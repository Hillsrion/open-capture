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
    public var browserWidth: Double = 300.0
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
        let palette = palettes.first(where: { $0.id == selectedPaletteID }) ?? palettes.first
        return palette
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
