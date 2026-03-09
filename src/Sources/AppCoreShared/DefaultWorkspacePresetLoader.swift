import Foundation

#if !SWIFT_PACKAGE
extension Bundle {
    static var module: Bundle {
        return Bundle(for: DefaultWorkspacePresetLoader.self)
    }
}
#endif

public final class DefaultWorkspacePresetLoader {
    public init() {}

    public func makeWorkspace(windowKind: WorkspaceWindowKind, name: String = "Default") throws -> Workspace {
        let root = try loadRootDictionary()
        let chrome = parseChromeState(for: windowKind, root: root)
        let toolbarConfiguration = parseToolbarConfiguration(for: windowKind, root: root)
        let palettes = parsePalettes(for: windowKind, root: root)

        return Workspace(
            name: name,
            windowKind: windowKind,
            palettes: palettes,
            chromeState: chrome,
            toolbarConfiguration: toolbarConfiguration
        )
    }

    private func loadRootDictionary() throws -> [String: Any] {
        let data = try Data(contentsOf: try plistURL())
        guard let plist = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] else {
            throw WorkspacePresetError.invalidPlist
        }
        return plist
    }

    private func plistURL() throws -> URL {
        // Now using proper SPM module bundle
        if let bundled = Bundle.module.url(forResource: "Default", withExtension: "plist", subdirectory: "Resources/Workspaces") {
            return bundled
        }

        throw WorkspacePresetError.missingPlist
    }

    private func parseChromeState(for windowKind: WorkspaceWindowKind, root: [String: Any]) -> WorkspaceChromeState {
        let chromeDict = root[windowKind.chromeKey] as? [String: Any] ?? [:]
        var chrome = WorkspaceChromeState()
        chrome.selectedToolPaletteID = chromeDict["selected-tool-palette-id"] as? String
        chrome.toolsPosition = WorkspaceToolsPosition(rawValue: chromeDict["tools-position"] as? String ?? "") ?? .left
        chrome.toolsDisplayState = WorkspaceDisplayState(rawValue: chromeDict["tools-display-state"] as? String ?? "") ?? .shown
        chrome.toolsWidth = numberValue(for: "tools-width", in: chromeDict) ?? chrome.toolsWidth
        chrome.browserDisplayState = WorkspaceDisplayState(rawValue: chromeDict["browser-display-state"] as? String ?? "") ?? chrome.browserDisplayState
        chrome.browserPosition = WorkspaceBrowserPosition(rawValue: chromeDict["browser-position"] as? String ?? "") ?? chrome.browserPosition
        chrome.browserWidth = numberValue(for: "browser-width", in: chromeDict) ?? chrome.browserWidth
        chrome.browserHeight = numberValue(for: "browser-height", in: chromeDict) ?? chrome.browserHeight
        chrome.viewerShown = chromeDict["viewer-shown"] as? Bool ?? chrome.viewerShown
        chrome.viewerToolbarShown = chromeDict["viewer-toolbar-shown"] as? Bool ?? chrome.viewerToolbarShown
        chrome.fullScreen = chromeDict["full-screen"] as? Bool ?? chrome.fullScreen
        chrome.maximizeViewer = chromeDict["maximize-viewer"] as? Bool ?? chrome.maximizeViewer
        return chrome
    }

    private func parseToolbarConfiguration(for windowKind: WorkspaceWindowKind, root: [String: Any]) -> ToolbarConfiguration {
        let toolbarKey = "\(windowKind.chromeKey).toolbar"
        guard
            let toolbarRoot = root[toolbarKey] as? [String: Any],
            let toolbarConfiguration = toolbarRoot["toolbarConfiguration"] as? [String: Any],
            let itemIDs = toolbarConfiguration["TB Item Identifiers"] as? [String]
        else {
            return .defaultConfiguration
        }

        let mapped = itemIDs.compactMap(normalizedToolbarIdentifier)
        return mapped.count >= 4 ? ToolbarConfiguration(itemIDs: mapped) : .defaultConfiguration
    }

    private func parsePalettes(for windowKind: WorkspaceWindowKind, root: [String: Any]) -> [WorkspacePaletteDefinition] {
        let fixedRoot = (windowKind.toolsKey.flatMap { root[$0] as? [String: Any] }) ?? [:]
        let scrolledRoot = (windowKind.scrolledToolsKey.flatMap { root[$0] as? [String: Any] }) ?? [:]

        let paletteIDs =
            (fixedRoot["tabConfiguration"] as? [String]) ??
            (scrolledRoot["tabConfiguration"] as? [String]) ??
            fixedRoot.keys.filter { !$0.hasPrefix("tool-") && $0 != "tabConfiguration" }.sorted()

        return paletteIDs.map { paletteID in
            let fixedTools = parseToolConfigurations(rawPalette: fixedRoot[paletteID])
            let scrolledTools = parseToolConfigurations(rawPalette: scrolledRoot[paletteID])

            let name: String
            let icon: String
            (name, icon) = paletteInfo(for: paletteID)

            return WorkspacePaletteDefinition(
                id: paletteID,
                name: name,
                iconName: icon,
                fixedTools: fixedTools,
                scrolledTools: scrolledTools
            )
        }
    }

    private func parseToolConfigurations(rawPalette: Any?) -> [ToolConfiguration] {
        guard let toolIDs = rawPalette as? [String] else { return [] }
        return toolIDs.map { id in
            ToolConfiguration(id: id)
        }
    }

    private func paletteInfo(for id: String) -> (String, String) {
        switch id {
        case "LibraryToolTab": return ("Library", "folder.fill")
        case "CaptureToolTab": return ("Capture", "camera.fill")
        case "ExposureToolTab": return ("Exposure", "sun.max.fill")
        case "ColorToolTab": return ("Color", "paintpalette.fill")
        case "DetailsToolTab": return ("Details", "magnifyingglass")
        case "LensToolTab": return ("Lens", "scope")
        case "LocalAdjustmentsToolTab": return ("Layers", "square.stack.3d.up.fill")
        case "MetadataToolTab": return ("Metadata", "info.circle.fill")
        case "OutputToolTab": return ("Output", "arrow.up.doc.fill")
        case "QuickToolTab": return ("Quick", "bolt.fill")
        default: return (id, "wrench.fill")
        }
    }

    private func normalizedToolbarIdentifier(_ id: String) -> String? {
        if id.contains("NSToolbarFlexibleSpaceItem") { return "FlexibleSpace" }
        if id.contains("NSToolbarSpaceItem") { return "Space" }
        
        let components = id.components(separatedBy: ".")
        return components.last
    }

    private func numberValue(for key: String, in dict: [String: Any]) -> Double? {
        if let val = dict[key] as? Double { return val }
        if let val = dict[key] as? Float { return Double(val) }
        if let val = dict[key] as? Int { return Double(val) }
        return nil
    }
}

public enum WorkspacePresetError: Error {
    case missingPlist
    case invalidPlist
}
