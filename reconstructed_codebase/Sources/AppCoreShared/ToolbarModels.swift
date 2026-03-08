import Foundation

/// Reconstructed Data Model for a Toolbar Item (INT-001).
/// Represents a single icon or widget in the main application toolbar.
public struct ToolbarItem: Identifiable, Codable, Hashable {
    public let id: String
    public let name: String
    public let iconName: String
    public let type: ItemType
    
    public enum TokenType: String, Codable {
        case action = "Action"
        case tool = "Tool"
        case spacer = "Spacer"
        case flexibleSpacer = "FlexibleSpacer"
        case group = "Group"
    }
    
    // Using a different enum name to avoid confusion with SwiftUI or other types if needed
    public enum ItemType: String, Codable {
        case action
        case tool
        case spacer
        case flexibleSpacer
        case group
    }
    
    public init(id: String, name: String, iconName: String, type: ItemType = .action) {
        self.id = id
        self.name = name
        self.iconName = iconName
        self.type = type
    }
}

/// Reconstructed Data Model for a Toolbar Configuration.
/// Represents the ordered list of items visible in the toolbar.
public struct ToolbarConfiguration: Codable, Hashable {
    public var itemIDs: [String]
    
    public init(itemIDs: [String] = []) {
        self.itemIDs = itemIDs
    }
    
    public static var defaultConfiguration: ToolbarConfiguration {
        return ToolbarConfiguration(itemIDs: [
            "Select", "Pan", "Loupe", "FIXED_SPACER",
            "Crop", "Rotate", "Keystone", "FIXED_SPACER",
            "FLEXIBLE_SPACER",
            "AutoAdjust", "FIXED_SPACER",
            "CopyAdjustments", "ApplyAdjustments", "FIXED_SPACER",
            "Import", "Capture", "Export"
        ])
    }
}

/// Registry of all available toolbar items in Capture One.
public struct ToolbarItemRegistry {
    public static let availableItems: [ToolbarItem] = [
        // Tools
        ToolbarItem(id: "Select", name: "Select", iconName: "cursorarrow", type: .tool),
        ToolbarItem(id: "Pan", name: "Pan", iconName: "hand.raised", type: .tool),
        ToolbarItem(id: "Loupe", name: "Loupe", iconName: "magnifyingglass", type: .tool),
        ToolbarItem(id: "Crop", name: "Crop", iconName: "crop", type: .tool),
        ToolbarItem(id: "Straighten", name: "Straighten", iconName: "line.diagonal", type: .tool),
        ToolbarItem(id: "Rotate", name: "Rotate", iconName: "rotate.right", type: .tool),
        ToolbarItem(id: "Keystone", name: "Keystone", iconName: "rectangle.distorted", type: .tool),
        
        // Actions
        ToolbarItem(id: "AutoAdjust", name: "Auto Adjust", iconName: "wand.and.stars"),
        ToolbarItem(id: "CopyAdjustments", name: "Copy Adjustments", iconName: "arrow.up.doc"),
        ToolbarItem(id: "ApplyAdjustments", name: "Apply Adjustments", iconName: "arrow.down.doc"),
        ToolbarItem(id: "Reset", name: "Reset", iconName: "arrow.counterclockwise"),
        
        // Workflow
        ToolbarItem(id: "Import", name: "Import", iconName: "square.and.arrow.down"),
        ToolbarItem(id: "Capture", name: "Capture", iconName: "camera"),
        ToolbarItem(id: "Export", name: "Export", iconName: "square.and.arrow.up"),
        
        // Spacers (Special IDs)
        ToolbarItem(id: "FIXED_SPACER", name: "Space", iconName: "space", type: .spacer),
        ToolbarItem(id: "FLEXIBLE_SPACER", name: "Flexible Space", iconName: "arrow.left.and.right", type: .flexibleSpacer)
    ]
    
    public static func item(for id: String) -> ToolbarItem? {
        return availableItems.first { $0.id == id }
    }
}
