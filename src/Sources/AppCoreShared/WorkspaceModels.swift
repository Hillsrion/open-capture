import Foundation

public enum WorkspaceStoredValue: Codable, Equatable, Hashable {
    case string(String)
    case int(Int)
    case double(Double)
    case bool(Bool)
    case stringArray([String])

    public init?(any value: Any) {
        switch value {
        case let value as String:
            self = .string(value)
        case let value as Int:
            self = .int(value)
        case let value as Double:
            self = .double(value)
        case let value as Float:
            self = .double(Double(value))
        case let value as Bool:
            self = .bool(value)
        case let value as [String]:
            self = .stringArray(value)
        default:
            return nil
        }
    }

    public var stringValue: String {
        switch self {
        case let .string(value):
            return value
        case let .int(value):
            return String(value)
        case let .double(value):
            return String(value)
        case let .bool(value):
            return String(value)
        case let .stringArray(value):
            return value.joined(separator: ",")
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(String.self) {
            self = .string(value)
        } else if let value = try? container.decode(Int.self) {
            self = .int(value)
        } else if let value = try? container.decode(Double.self) {
            self = .double(value)
        } else if let value = try? container.decode(Bool.self) {
            self = .bool(value)
        } else if let value = try? container.decode([String].self) {
            self = .stringArray(value)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported workspace stored value")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .string(value):
            try container.encode(value)
        case let .int(value):
            try container.encode(value)
        case let .double(value):
            try container.encode(value)
        case let .bool(value):
            try container.encode(value)
        case let .stringArray(value):
            try container.encode(value)
        }
    }
}

/// Reconstructed model for a tool's UI state (UI-013).
public struct ToolConfiguration: Codable, Identifiable, Hashable {
    public let id: String
    public var isCollapsed: Bool = false
    public var height: Double? = nil
    public var sizeOption: Int? = nil
    public var state: [String: WorkspaceStoredValue] = [:]

    public init(
        id: String,
        isCollapsed: Bool = false,
        height: Double? = nil,
        sizeOption: Int? = nil,
        state: [String: WorkspaceStoredValue] = [:]
    ) {
        self.id = id
        self.isCollapsed = isCollapsed
        self.height = height
        self.sizeOption = sizeOption
        self.state = state
    }
}

public enum WorkspaceWindowKind: String, Codable, CaseIterable {
    case session
    case viewer
    case livePreview
    case culling
    case exporter
    case print
    case importer

    public var chromeKey: String {
        switch self {
        case .session: return "com.phaseone.captureone.sessionwindow"
        case .viewer: return "com.phaseone.captureone.viewerwindow"
        case .livePreview: return "com.phaseone.captureone.livepreviewwindow"
        case .culling: return "com.captureone.captureone.cullingwindow.tools"
        case .exporter: return "com.phaseone.captureone.exporterwindow"
        case .print: return "com.phaseone.captureone.printwindow"
        case .importer: return "com.phaseone.captureone.importerwindow"
        }
    }

    public var toolsKey: String? {
        switch self {
        case .session: return "com.phaseone.captureone.sessionwindow.tools"
        case .viewer: return "com.phaseone.captureone.viewerwindow.tools"
        case .livePreview: return "com.phaseone.captureone.livepreviewwindow.tools"
        case .culling: return "com.captureone.captureone.cullingwindow.tools"
        case .exporter, .print, .importer: return nil
        }
    }

    public var scrolledToolsKey: String? {
        switch self {
        case .session: return "com.phaseone.captureone.sessionwindow.tools.scrolled"
        case .viewer: return "com.phaseone.captureone.viewerwindow.tools.scrolled"
        case .livePreview: return "com.phaseone.captureone.livepreviewwindow.tools.scrolled"
        case .culling: return "com.captureone.captureone.cullingwindow.tools.scrolled"
        case .exporter, .print, .importer: return nil
        }
    }
}

public enum WorkspaceToolsPosition: String, Codable {
    case left = "Left"
    case right = "Right"
}

public enum WorkspaceDisplayState: String, Codable {
    case shown = "Shown"
    case hidden = "Hidden"
    case auto = "Auto"
}

public enum WorkspaceBrowserPosition: String, Codable {
    case portrait = "Portrait"
    case landscape = "Landscape"
}

public struct WorkspaceChromeState: Codable, Hashable {
    public var windowFrame: CGRect?
    public var selectedToolPaletteID: String?
    public var toolsPosition: WorkspaceToolsPosition = .left
    public var toolsDisplayState: WorkspaceDisplayState = .shown
    public var toolsWidth: Double = 305.0
    public var browserDisplayState: WorkspaceDisplayState = .shown
    public var browserPosition: WorkspaceBrowserPosition = .portrait
    public var browserWidth: Double = 200.0
    public var browserHeight: Double = 184.0
    public var browserMode: Int = 0 // 0: Grid, 1: Filmstrip, 2: List
    public var browserLabelsShown: Bool = true
    public var browserThumbnailAspectRatio: Int = 0 // 0: Square, 1: Original
    public var viewerShown: Bool = true
    public var viewerToolbarShown: Bool = true
    public var fullScreen: Bool = false
    public var maximizeViewer: Bool = false

    public init() {}
}

public struct WorkspacePaletteDefinition: Codable, Identifiable, Hashable {
    public let id: String
    public var name: String
    public var iconName: String
    public var fixedTools: [ToolConfiguration]
    public var scrolledTools: [ToolConfiguration]

    public init(
        id: String,
        name: String,
        iconName: String,
        fixedTools: [ToolConfiguration] = [],
        scrolledTools: [ToolConfiguration] = []
    ) {
        self.id = id
        self.name = name
        self.iconName = iconName
        self.fixedTools = fixedTools
        self.scrolledTools = scrolledTools
    }

    public var allTools: [ToolConfiguration] {
        fixedTools + scrolledTools
    }
}

/// Reconstructed model for a full UI workspace state.
public struct Workspace: Codable, Identifiable {
    public let id: String
    public var name: String
    public var windowKind: WorkspaceWindowKind
    public var palettes: [WorkspacePaletteDefinition]
    public var chromeState: WorkspaceChromeState
    public var toolbarConfiguration: ToolbarConfiguration = .defaultConfiguration
    public var toolState: [String: WorkspaceStoredValue] = [:]
    public var isBundleWorkspace: Bool = false

    public init(
        id: String = UUID().uuidString,
        name: String,
        windowKind: WorkspaceWindowKind,
        palettes: [WorkspacePaletteDefinition] = [],
        chromeState: WorkspaceChromeState = WorkspaceChromeState(),
        toolbarConfiguration: ToolbarConfiguration = .defaultConfiguration,
        isBundleWorkspace: Bool = false
    ) {
        self.id = id
        self.name = name
        self.windowKind = windowKind
        self.palettes = palettes
        self.chromeState = chromeState
        self.toolbarConfiguration = toolbarConfiguration
        self.isBundleWorkspace = isBundleWorkspace
    }

    public var selectedPaletteID: String {
        chromeState.selectedToolPaletteID ?? palettes.first?.id ?? ""
    }

    public var sidebarWidth: Double {
        get { chromeState.toolsWidth }
        set { chromeState.toolsWidth = newValue }
    }

    public func activePalette() -> WorkspacePaletteDefinition? {
        palettes.first(where: { $0.id == selectedPaletteID }) ?? palettes.first
    }

    public func defaultToolStateValue(toolID: String, key: String) -> WorkspaceStoredValue? {
        palettes
            .flatMap(\.allTools)
            .first(where: { $0.id == toolID })?
            .state[key]
    }

    private enum CodingKeys: String, CodingKey {
        case id, name, windowKind, palettes, chromeState, toolbarConfiguration, toolState, isBundleWorkspace
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? "Default"
        windowKind = try container.decodeIfPresent(WorkspaceWindowKind.self, forKey: .windowKind) ?? .session
        toolbarConfiguration = try container.decodeIfPresent(ToolbarConfiguration.self, forKey: .toolbarConfiguration) ?? .defaultConfiguration
        isBundleWorkspace = try container.decodeIfPresent(Bool.self, forKey: .isBundleWorkspace) ?? false
        palettes = try container.decodeIfPresent([WorkspacePaletteDefinition].self, forKey: .palettes) ?? []
        chromeState = try container.decodeIfPresent(WorkspaceChromeState.self, forKey: .chromeState) ?? WorkspaceChromeState()
        toolState = try container.decodeIfPresent([String: WorkspaceStoredValue].self, forKey: .toolState) ?? [:]

        if chromeState.selectedToolPaletteID == nil {
            chromeState.selectedToolPaletteID = palettes.first?.id
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(windowKind, forKey: .windowKind)
        try container.encode(palettes, forKey: .palettes)
        try container.encode(chromeState, forKey: .chromeState)
        try container.encode(toolbarConfiguration, forKey: .toolbarConfiguration)
        try container.encode(toolState, forKey: .toolState)
        try container.encode(isBundleWorkspace, forKey: .isBundleWorkspace)
    }
}

/// Reconstructed model for window and palette coordination (v16.5+).
public class WorkspaceLayout: Codable {
    public weak var workspaceManager: WorkspaceManager?
    
    public init(manager: WorkspaceManager?) {
        self.workspaceManager = manager
    }
}

/// Reconstructed manager for workspace presets and persistence.
public class WorkspaceManager: ObservableObject, Codable {
    public static let shared = WorkspaceManager()
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
        self.activeWorkspace = WorkspaceManager.createDefaultWorkspace()
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
        if let override = WorkspaceManager.persistenceDirectoryOverride {
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
            activeWorkspace = WorkspaceManager.createDefaultWorkspace()
            activeWorkspace.name = name
            return
        }

        guard let decoded = try? JSONDecoder().decode(Workspace.self, from: data) else {
            activeWorkspace = WorkspaceManager.createDefaultWorkspace()
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
        activeWorkspace.chromeState.selectedToolPaletteID = paletteID
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
            guard let scrolledIndex else { return }
            let tool = palette.scrolledTools.remove(at: scrolledIndex)
            palette.fixedTools.append(tool)
        } else {
            guard let fixedIndex else { return }
            let tool = palette.fixedTools.remove(at: fixedIndex)
            palette.scrolledTools.insert(tool, at: 0)
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
            scrolledTools: [ToolConfiguration(id: "MetadataFilters"), ToolConfiguration(id: "Keywords"), ToolConfiguration(id: "KeywordLibrary"), ToolConfiguration(id: "Metadata")]
        )
        
        let capturePalette = WorkspacePaletteDefinition(
            id: "CaptureToolTab", name: "Capture", iconName: "camera.fill",
            fixedTools: [ToolConfiguration(id: "Camera"), ToolConfiguration(id: "CameraFocus")],
            scrolledTools: [ToolConfiguration(id: "CameraSettings"), ToolConfiguration(id: "NextCaptureNaming"), ToolConfiguration(id: "NextCaptureLocation"), ToolConfiguration(id: "NextCaptureAdjustments"), ToolConfiguration(id: "Overlay"), ToolConfiguration(id: "LiveForStudio"), ToolConfiguration(id: "NextCaptureMetadata"), ToolConfiguration(id: "NextCaptureKeywords"), ToolConfiguration(id: "NextCaptureBackup")]
        )
        
        let colorPalette = WorkspacePaletteDefinition(
            id: "ColorToolTab", name: "Color", iconName: "paintpalette.fill",
            fixedTools: [ToolConfiguration(id: "Histogram"), ToolConfiguration(id: "LocalAdjustments")],
            scrolledTools: [ToolConfiguration(id: "BaseCharacteristics"), ToolConfiguration(id: "WhiteBalance"), ToolConfiguration(id: "SelectiveColorControl"), ToolConfiguration(id: "ColorBalance"), ToolConfiguration(id: "BlackAndWhite"), ToolConfiguration(id: "Normalize")]
        )
        
        let exposurePalette = WorkspacePaletteDefinition(
            id: "ExposureToolTab", name: "Exposure", iconName: "sun.max.fill",
            fixedTools: [ToolConfiguration(id: "Histogram"), ToolConfiguration(id: "LocalAdjustments")],
            scrolledTools: [ToolConfiguration(id: "SmartAdjustments"), ToolConfiguration(id: "StyleBrushes"), ToolConfiguration(id: "MatchLook"), ToolConfiguration(id: "Exposure"), ToolConfiguration(id: "ShadowHighlight"), ToolConfiguration(id: "Levels"), ToolConfiguration(id: "Curves"), ToolConfiguration(id: "Clarity"), ToolConfiguration(id: "Dehaze")]
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

        var chrome = WorkspaceChromeState()
        chrome.selectedToolPaletteID = exposurePalette.id
        chrome.toolsWidth = 362.0
        let ws = Workspace(name: name, windowKind: windowKind, palettes: [libraryPalette, capturePalette, colorPalette, exposurePalette, lensPalette, detailsPalette, exportPalette], chromeState: chrome)
        print("[WorkspaceManager] Created hardcoded precise workspace with \(ws.palettes.count) palettes")
        return ws
    }
}
