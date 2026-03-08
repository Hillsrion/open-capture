import Foundation

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
        if let bundled = Bundle.main.url(forResource: "Default", withExtension: "plist", subdirectory: "Contents/Resources/Workspaces") {
            return bundled
        }

        let sourceURL = URL(fileURLWithPath: #filePath)
        let repositoryRoot = sourceURL
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
        let fallback = repositoryRoot
            .appendingPathComponent("Contents/Resources/Workspaces/Default.plist", isDirectory: false)
        if FileManager.default.fileExists(atPath: fallback.path) {
            return fallback
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
            let metadata = paletteMetadata(for: paletteID)

            return WorkspacePaletteDefinition(
                id: paletteID,
                name: metadata.name,
                iconName: metadata.icon,
                fixedTools: fixedTools,
                scrolledTools: scrolledTools
            )
        }
    }

    private func parseToolConfigurations(rawPalette: Any?) -> [ToolConfiguration] {
        guard let palette = rawPalette as? [Any], palette.count >= 3 else {
            return []
        }

        let ids = palette[0] as? [String] ?? []
        let collapsedIndices = Set((palette[1] as? [Int]) ?? [])
        let states = palette[2] as? [[String: Any]] ?? []

        return ids.enumerated().map { index, toolID in
            let rawState = index < states.count ? states[index] : [:]
            let sizeOption = intValue(rawState["sizeOption"])
            let height = numberValue(for: "height", in: rawState)
            let state = rawState.reduce(into: [String: WorkspaceStoredValue]()) { result, pair in
                guard pair.key != "sizeOption", pair.key != "height", let stored = WorkspaceStoredValue(any: pair.value) else {
                    return
                }
                result[pair.key] = stored
            }

            return ToolConfiguration(
                id: toolID,
                isCollapsed: collapsedIndices.contains(index),
                height: height,
                sizeOption: sizeOption,
                state: state
            )
        }
    }

    private func paletteMetadata(for paletteID: String) -> (name: String, icon: String) {
        switch paletteID {
        case "OrganizeToolTab": return ("Library", "books.vertical.fill")
        case "CaptureToolTab": return ("Capture", "camera.fill")
        case "LensToolTab": return ("Lens", "camera.metering.matrix")
        case "SettingsToolTab": return ("Settings", "gearshape.fill")
        case "ExposureToolTab": return ("Exposure", "dial.medium.fill")
        case "DetailsToolTab": return ("Details", "slider.horizontal.3")
        case "QuickToolTab": return ("Quick", "bolt.fill")
        case "ColorToolTab": return ("Color", "paintpalette.fill")
        case "CompositionToolTab": return ("Composition", "crop")
        case "MetaDataToolTab": return ("Metadata", "info.circle.fill")
        case "ExportToolTab": return ("Export", "square.and.arrow.up.fill")
        case "LocalAdjustmentsToolTab": return ("Layers", "square.stack.3d.up.fill")
        case "BlackWhiteToolTab": return ("B&W", "circle.lefthalf.filled")
        case "LivePreviewToolTab": return ("Live", "video.fill")
        case "CullingWindowToolTab": return ("Culling", "rectangle.grid.1x2.fill")
        default: return (paletteID, "square.grid.2x2")
        }
    }

    private func normalizedToolbarIdentifier(_ itemID: String) -> String? {
        switch itemID {
        case "NSToolbarSpaceItem":
            return "FIXED_SPACER"
        case "NSToolbarFlexibleSpaceItem":
            return "FLEXIBLE_SPACER"
        case "ImportItem":
            return "Import"
        case "CaptureItem":
            return "Capture"
        case "ExportVariantsItem":
            return "Export"
        case "CullingItem":
            return "Culling"
        case "CaptureOneLiveToolbarItem":
            return "Live"
        case "RotateItem":
            return "Rotate"
        case "AutoAdjustItem":
            return "AutoAdjust"
        case "PrintItem":
            return "Print"
        case "ResetAdjustmentsItem":
            return "Reset"
        case "UndoRedoItem":
            return "UndoRedo"
        case "EditPrimaryOnlyItem":
            return "EditSelected"
        case "CursorToolItem":
            return "CursorTools"
        case "ActivitiesProgressItem":
            return "Activity"
        case "BeforeAfterItem":
            return "BeforeAfter"
        case "AlignmentItem":
            return "Grid"
        case "ExposureWarningItem":
            return "ExposureWarning"
        case "RecipeProofingItem":
            return "Proofing"
        case "FocusMaskItem":
            return "FocusMask"
        case "AdjustmentsItem":
            return "ApplyAdjustments"
        case "SelfServeItem":
            return "SelfServe"
        case "TipsItem":
            return "Tips"
        default:
            return nil
        }
    }

    private func numberValue(for key: String, in dict: [String: Any]) -> Double? {
        if let value = dict[key] as? Double {
            return value
        }
        if let value = dict[key] as? Int {
            return Double(value)
        }
        if let value = dict[key] as? Float {
            return Double(value)
        }
        return nil
    }

    private func intValue(_ raw: Any?) -> Int? {
        if let raw = raw as? Int {
            return raw
        }
        if let raw = raw as? Double {
            return Int(raw)
        }
        return nil
    }
}

public enum WorkspacePresetError: Error {
    case missingPlist
    case invalidPlist
}
