import Foundation

/// Reconstructed model for a tool's UI state (UI-013).
public struct ToolConfiguration: Codable, Identifiable {
    public let id: String
    public var isCollapsed: Bool = false
    public var height: Double? = nil // Optional fixed height
    
    public init(id: String, isCollapsed: Bool = false) {
        self.id = id
        self.isCollapsed = isCollapsed
    }
}

/// Reconstructed model for a tab within a workspace.
public struct WorkspaceTab: Codable, Identifiable {
    public let id: String
    public var name: String
    public var iconName: String
    public var tools: [ToolConfiguration]
    
    public init(id: String, name: String, iconName: String, tools: [ToolConfiguration] = []) {
        self.id = id
        self.name = name
        self.iconName = iconName
        self.tools = tools
    }
}

/// Reconstructed model for a full UI workspace state.
public struct Workspace: Codable, Identifiable {
    public let id: String
    public var name: String
    public var leftSidebarTabs: [WorkspaceTab]
    public var rightSidebarTabs: [WorkspaceTab]
    public var sidebarWidth: Double = 300.0
    
    public init(id: String = UUID().uuidString, name: String, left: [WorkspaceTab] = [], right: [WorkspaceTab] = []) {
        self.id = id
        self.name = name
        self.leftSidebarTabs = left
        self.rightSidebarTabs = right
    }
}

/// Reconstructed manager for workspace presets and persistence.
public class WorkspaceManager: ObservableObject {
    public static let shared = WorkspaceManager()
    
    @Published public var activeWorkspace: Workspace
    
    private init() {
        self.activeWorkspace = WorkspaceManager.createDefaultWorkspace()
    }
    
    /// Reconstructed logic for persisting workspace configuration.
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
        let paths = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        let dir = paths[0].appendingPathComponent("CaptureOne/Workspaces", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent("\(name).coworkspace")
    }
    
    public static func createDefaultWorkspace() -> Workspace {
        let adjustTab = WorkspaceTab(id: "ADJUST", name: "Adjust", iconName: "slider.horizontal.3", tools: [
            ToolConfiguration(id: "Histogram"),
            ToolConfiguration(id: "Exposure"),
            ToolConfiguration(id: "SmartAdjustments"),
            ToolConfiguration(id: "HDR"),
            ToolConfiguration(id: "Levels")
        ])
        
        let colorTab = WorkspaceTab(id: "COLOR", name: "Color", iconName: "paintpalette", tools: [
            ToolConfiguration(id: "ColorBalance"),
            ToolConfiguration(id: "WhiteBalance"),
            ToolConfiguration(id: "AdvancedColorEditor")
        ])
        
        return Workspace(name: "Default", left: [adjustTab, colorTab])
    }
    
    public static func createSimplifiedWorkspace() -> Workspace {
        let mainTab = WorkspaceTab(id: "MAIN", name: "Main", iconName: "house", tools: [
            ToolConfiguration(id: "Exposure"),
            ToolConfiguration(id: "Histogram")
        ])
        return Workspace(name: "Simplified", left: [mainTab])
    }
}
