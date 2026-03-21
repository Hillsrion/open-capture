import Foundation
import Combine

/// Reconstructed manager for workspace presets and persistence (WS-101).
@MainActor
public class COWorkspaceManager: ObservableObject, Codable {
    public static let shared = COWorkspaceManager()
    public static var persistenceDirectoryOverride: URL?

    @Published public var activeWorkspace: Workspace
    @Published public var allWorkspaces: [Workspace] = []
    
    public var systemWorkspacesAsMenu: [Workspace] {
        return allWorkspaces.filter { $0.isBundleWorkspace }
    }

    public var allWorkspacesAsMenu: [Workspace] {
        return allWorkspaces
    }

    private init() {
        self.activeWorkspace = COWorkspaceManager.createDefaultWorkspace()
        self.allWorkspaces = [self.activeWorkspace]
    }
    
    enum CodingKeys: CodingKey {
        case activeWorkspace
        case allWorkspaces
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        activeWorkspace = try container.decode(Workspace.self, forKey: .activeWorkspace)
        allWorkspaces = try container.decode([Workspace].self, forKey: .allWorkspaces)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(activeWorkspace, forKey: .activeWorkspace)
        try container.encode(allWorkspaces, forKey: .allWorkspaces)
    }

    public func saveWorkspace() {
        do {
            let data = try JSONEncoder().encode(activeWorkspace)
            let url = getPersistenceURL(for: activeWorkspace.name)
            try data.write(to: url)
            print("[Workspace] Saved workspace: \(activeWorkspace.name)")
        } catch {
            print("[Workspace] Failed to save workspace: \(error)")
        }
    }

    private func getPersistenceURL(for name: String) -> URL {
        let dir: URL
        if let override = COWorkspaceManager.persistenceDirectoryOverride {
            dir = override
        } else {
            let paths = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
            dir = paths[0].appendingPathComponent("CaptureOne/Workspaces", isDirectory: true)
        }
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent("\(name).coworkspace")
    }

    public func loadWorkspace(named name: String) {
        let url = getPersistenceURL(for: name)
        guard let data = try? Data(contentsOf: url) else {
            activeWorkspace = COWorkspaceManager.createDefaultWorkspace()
            activeWorkspace.name = name
            return
        }

        guard let decoded = try? JSONDecoder().decode(Workspace.self, from: data) else {
            activeWorkspace = COWorkspaceManager.createDefaultWorkspace()
            activeWorkspace.name = name
            return
        }

        activeWorkspace = decoded
    }

    public func toolStateValue(toolID: String, key: String) -> String? {
        let compositeKey = "\(toolID).\(key)"
        if let override = activeWorkspace.toolState[compositeKey] {
            return override.stringValue
        }

        return activeWorkspace.defaultToolStateValue(toolID: toolID, key: key)?.stringValue
    }

    public func setToolStateValue(_ value: String?, toolID: String, key: String, autosave: Bool = true) {
        let compositeKey = "\(toolID).\(key)"
        if let value {
            activeWorkspace.toolState[compositeKey] = .string(value)
        } else {
            activeWorkspace.toolState.removeValue(forKey: compositeKey)
        }

        if autosave {
            saveWorkspace()
        }
    }

    public func setSelectedPaletteID(_ paletteID: String, autosave: Bool = true) {
        objectWillChange.send()
        var updatedWorkspace = activeWorkspace
        updatedWorkspace.chromeState.selectedToolPaletteID = paletteID
        activeWorkspace = updatedWorkspace
        
        if autosave {
            saveWorkspace()
        }
    }

    public func moveTool(_ toolID: String, toPinnedArea pinned: Bool, autosave: Bool = true) {
        guard let paletteIndex = activeWorkspace.palettes.firstIndex(where: { $0.id == activeWorkspace.selectedPaletteID }) else {
            return
        }

        var palette = activeWorkspace.palettes[paletteIndex]
        let fixedIndex = palette.fixedTools.firstIndex(where: { $0.id == toolID })
        let scrolledIndex = palette.scrolledTools.firstIndex(where: { $0.id == toolID })

        if pinned {
            // Target is pinned area
            if let scrolledIndex {
                let tool = palette.scrolledTools.remove(at: scrolledIndex)
                palette.fixedTools.append(tool)
            }
        } else {
            // Target is scrollable area
            if let fixedIndex {
                let tool = palette.fixedTools.remove(at: fixedIndex)
                palette.scrolledTools.insert(tool, at: 0)
            }
        }

        activeWorkspace.palettes[paletteIndex] = palette
        if autosave {
            saveWorkspace()
        }
    }

    public func removeTool(_ toolID: String, autosave: Bool = true) {
        guard let paletteIndex = activeWorkspace.palettes.firstIndex(where: { $0.id == activeWorkspace.selectedPaletteID }) else {
            return
        }

        var palette = activeWorkspace.palettes[paletteIndex]
        palette.fixedTools.removeAll { $0.id == toolID }
        palette.scrolledTools.removeAll { $0.id == toolID }
        activeWorkspace.palettes[paletteIndex] = palette

        if autosave {
            saveWorkspace()
        }
    }

    public func removePalette(_ paletteID: String, autosave: Bool = true) {
        activeWorkspace.palettes.removeAll { $0.id == paletteID }
        if activeWorkspace.chromeState.selectedToolPaletteID == paletteID {
            activeWorkspace.chromeState.selectedToolPaletteID = activeWorkspace.palettes.first?.id
        }
        if autosave {
            saveWorkspace()
        }
    }

    public func setToolSizeOption(_ sizeOption: Int?, for toolID: String, autosave: Bool = true) {
        guard let paletteIndex = activeWorkspace.palettes.firstIndex(where: { $0.id == activeWorkspace.selectedPaletteID }) else {
            return
        }

        var palette = activeWorkspace.palettes[paletteIndex]
        if let fixedIndex = palette.fixedTools.firstIndex(where: { $0.id == toolID }) {
            palette.fixedTools[fixedIndex].sizeOption = sizeOption
        }
        if let scrolledIndex = palette.scrolledTools.firstIndex(where: { $0.id == toolID }) {
            palette.scrolledTools[scrolledIndex].sizeOption = sizeOption
        }
        activeWorkspace.palettes[paletteIndex] = palette
        setToolStateValue(sizeOption.map(String.init), toolID: toolID, key: "sizeOption", autosave: autosave)
    }

    public func hasToolConfiguration(_ toolID: String) -> Bool {
        // 1. Check override in toolState
        if toolStateValue(toolID: toolID, key: "isCollapsed") != nil {
            return true
        }
        
        // 2. Check layout definition
        for palette in activeWorkspace.palettes {
            if palette.allTools.contains(where: { $0.id == toolID }) {
                return true
            }
        }
        
        return false
    }

    public func isToolCollapsed(_ toolID: String) -> Bool {
        // 1. Check override in toolState
        if let value = toolStateValue(toolID: toolID, key: "isCollapsed") {
            return value == "true"
        }
        
        // 2. Check layout definition
        for palette in activeWorkspace.palettes {
            if let tool = palette.allTools.first(where: { $0.id == toolID }) {
                return tool.isCollapsed
            }
        }
        
        return false
    }

    public func setToolCollapsed(_ collapsed: Bool, for toolID: String, autosave: Bool = true) {
        // Update all occurrences in all palettes
        for (pIdx, palette) in activeWorkspace.palettes.enumerated() {
            var updatedPalette = palette
            var modified = false
            
            for (tIdx, tool) in palette.fixedTools.enumerated() {
                if tool.id == toolID {
                    updatedPalette.fixedTools[tIdx].isCollapsed = collapsed
                    modified = true
                }
            }
            for (tIdx, tool) in palette.scrolledTools.enumerated() {
                if tool.id == toolID {
                    updatedPalette.scrolledTools[tIdx].isCollapsed = collapsed
                    modified = true
                }
            }
            
            if modified {
                activeWorkspace.palettes[pIdx] = updatedPalette
            }
        }
        
        setToolStateValue(collapsed ? "true" : "false", toolID: toolID, key: "isCollapsed", autosave: autosave)
    }

    public func expandAllTools(in paletteID: String) {
        guard let paletteIndex = activeWorkspace.palettes.firstIndex(where: { $0.id == paletteID }) else { return }
        let palette = activeWorkspace.palettes[paletteIndex]
        for tool in palette.allTools {
            setToolCollapsed(false, for: tool.id, autosave: false)
        }
        saveWorkspace()
    }

    public func collapseAllTools(in paletteID: String) {
        guard let paletteIndex = activeWorkspace.palettes.firstIndex(where: { $0.id == paletteID }) else { return }
        let palette = activeWorkspace.palettes[paletteIndex]
        for tool in palette.allTools {
            setToolCollapsed(true, for: tool.id, autosave: false)
        }
        saveWorkspace()
    }

    public static func createDefaultWorkspace() -> Workspace {
        createWorkspace(windowKind: .session, name: "Default")
    }

    public static func createWorkspace(windowKind: WorkspaceWindowKind, name: String? = nil) -> Workspace {
        return fallbackWorkspace(windowKind: windowKind, name: name ?? "Default")
    }

    public static func createSimplifiedWorkspace() -> Workspace {
        let mainPalette = WorkspacePaletteDefinition(
            id: "QuickToolTab",
            name: "Quick",
            iconName: "bolt.fill",
            fixedTools: [ToolConfiguration(id: "Histogram")],
            scrolledTools: [ToolConfiguration(id: "Exposure")]
        )
        var chrome = WorkspaceChromeState()
        chrome.selectedToolPaletteID = mainPalette.id
        return Workspace(name: "Simplified", windowKind: .viewer, palettes: [mainPalette], chromeState: chrome)
    }

    private static func fallbackWorkspace(windowKind: WorkspaceWindowKind, name: String) -> Workspace {
        let libraryPalette = WorkspacePaletteDefinition(
            id: "LibraryToolTab", name: "Library", iconName: "folder.fill",
            fixedTools: [ToolConfiguration(id: "Library")],
            scrolledTools: [ToolConfiguration(id: "CloudTransfer"), ToolConfiguration(id: "MetadataFilters"), ToolConfiguration(id: "Keywords"), ToolConfiguration(id: "KeywordLibrary"), ToolConfiguration(id: "Metadata"), ToolConfiguration(id: "BatchRename")]
        )
        
        let capturePalette = WorkspacePaletteDefinition(
            id: "CaptureToolTab", name: "Capture", iconName: "camera.fill",
            fixedTools: [ToolConfiguration(id: "Camera"), ToolConfiguration(id: "CameraFocus")],
            scrolledTools: [ToolConfiguration(id: "CameraSettings"), ToolConfiguration(id: "NextCaptureNaming"), ToolConfiguration(id: "NextCaptureLocation"), ToolConfiguration(id: "NextCaptureAdjustments"), ToolConfiguration(id: "Overlay"), ToolConfiguration(id: "LiveForStudio"), ToolConfiguration(id: "NextCaptureMetadata"), ToolConfiguration(id: "NextCaptureKeywords"), ToolConfiguration(id: "NextCaptureBackup")]
        )
        
        let colorPalette = WorkspacePaletteDefinition(
            id: "ColorToolTab", name: "Color", iconName: "paintpalette.fill",
            fixedTools: [ToolConfiguration(id: "Histogram"), ToolConfiguration(id: "LocalAdjustments")],
            scrolledTools: [ToolConfiguration(id: "BaseCharacteristics"), ToolConfiguration(id: "WhiteBalance"), ToolConfiguration(id: "SelectiveColorControl"), ToolConfiguration(id: "ColorBalance"), ToolConfiguration(id: "NegativeFilm"), ToolConfiguration(id: "BlackAndWhite"), ToolConfiguration(id: "Normalize")]
        )
        
        let exposurePalette = WorkspacePaletteDefinition(
            id: "ExposureToolTab", name: "Exposure", iconName: "sun.max.fill",
            fixedTools: [ToolConfiguration(id: "Histogram"), ToolConfiguration(id: "LocalAdjustments")],
            scrolledTools: [ToolConfiguration(id: "AdjustmentsClipboard"), ToolConfiguration(id: "SmartAdjustments"), ToolConfiguration(id: "StyleBrushes"), ToolConfiguration(id: "MatchLook"), ToolConfiguration(id: "Exposure"), ToolConfiguration(id: "ShadowHighlight"), ToolConfiguration(id: "Levels"), ToolConfiguration(id: "Curves"), ToolConfiguration(id: "Clarity"), ToolConfiguration(id: "Dehaze")]
        )
        
        let lensPalette = WorkspacePaletteDefinition(
            id: "LensToolTab", name: "Lens", iconName: "scope",
            fixedTools: [ToolConfiguration(id: "LensCorrection")],
            scrolledTools: [ToolConfiguration(id: "Crop"), ToolConfiguration(id: "AICrop"), ToolConfiguration(id: "Rotation"), ToolConfiguration(id: "Perspective"), ToolConfiguration(id: "Vignetting"), ToolConfiguration(id: "Grid"), ToolConfiguration(id: "Guides")]
        )
        
        let detailsPalette = WorkspacePaletteDefinition(
            id: "DetailsToolTab", name: "Details", iconName: "magnifyingglass",
            fixedTools: [ToolConfiguration(id: "Navigator"), ToolConfiguration(id: "Focus")],
            scrolledTools: [ToolConfiguration(id: "Sharpening"), ToolConfiguration(id: "Noise"), ToolConfiguration(id: "Film Grain"), ToolConfiguration(id: "SpotRemoval"), ToolConfiguration(id: "LensColorCorrections"), ToolConfiguration(id: "Moire")]
        )
        
        let exportPalette = WorkspacePaletteDefinition(
            id: "ExportToolTab", name: "Export", iconName: "arrow.up.doc.fill",
            fixedTools: [ToolConfiguration(id: "ExportDialogRecipeList")],
            scrolledTools: [ToolConfiguration(id: "ExportLocation"), ToolConfiguration(id: "ExportNaming"), ToolConfiguration(id: "FormatAndSize"), ToolConfiguration(id: "OutputAdjustments"), ToolConfiguration(id: "Watermark"), ToolConfiguration(id: "OutputMetadata"), ToolConfiguration(id: "ExportProcess"), ToolConfiguration(id: "OutputContentCredentials"), ToolConfiguration(id: "ExportQueue")]
        )

        let retouchPalette = WorkspacePaletteDefinition(
            id: "RetouchToolTab", name: "Retouch", iconName: "face.smiling.fill",
            fixedTools: [ToolConfiguration(id: "RetouchFaceSkin")],
            scrolledTools: [ToolConfiguration(id: "BlemishRemoval"), ToolConfiguration(id: "EvenSkin"), ToolConfiguration(id: "RetouchTeeth"), ToolConfiguration(id: "RetouchEyes")]
        )

        var chrome = WorkspaceChromeState()
        chrome.selectedToolPaletteID = exposurePalette.id
        chrome.toolsWidth = 362.0
        let ws = Workspace(name: name, windowKind: windowKind, palettes: [libraryPalette, capturePalette, colorPalette, exposurePalette, lensPalette, detailsPalette, exportPalette, retouchPalette], chromeState: chrome)
        return ws
    }
}

/// Reconstructed model for window and palette coordination (v16.5+).
public class COWorkspaceLayout: Codable {
    public weak var manager: COWorkspaceManager?

    public init(manager: COWorkspaceManager?) {
        self.manager = manager
    }
}
