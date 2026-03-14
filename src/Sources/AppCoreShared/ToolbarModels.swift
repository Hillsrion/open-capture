import Foundation

/// Reconstructed Data Model for a Toolbar Item (INT-001).
/// Represents a single icon or widget in the main application toolbar.
public struct COToolbarItem: Identifiable, Codable, Hashable {
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
            "Import", "Export", "Capture", "FIXED_SPACER",
            "Reset", "UndoRedo", "AutoAdjust", "ConvertNegative", "FIXED_SPACER",
            "CursorTools", "FLEXIBLE_SPACER",
            "BeforeAfter", "Grid", "ExposureWarning", "Proofing", "FocusMask", "FIXED_SPACER",
            "CopyAdjustments", "ApplyAdjustments", "EditSelected", "Print"
        ])
    }
}

/// Registry of all available toolbar items in Capture One.
public struct COToolbarItemRegistry {
    public static let availableItems: [COToolbarItem] = [
        // Tools
        COToolbarItem(id: "Select", name: "Select", iconName: "cursorarrow", type: .tool),
        COToolbarItem(id: "Pan", name: "Pan", iconName: "hand.raised", type: .tool),
        COToolbarItem(id: "Loupe", name: "Loupe", iconName: "magnifyingglass", type: .tool),
        COToolbarItem(id: "Crop", name: "Crop", iconName: "crop", type: .tool),
        COToolbarItem(id: "Straighten", name: "Straighten", iconName: "line.diagonal", type: .tool),
        COToolbarItem(id: "Rotate", name: "Rotate", iconName: "rotate.right", type: .tool),
        COToolbarItem(id: "Keystone", name: "Keystone", iconName: "rectangle.distorted", type: .tool),
        COToolbarItem(id: "Heal", name: "Heal", iconName: "bandage", type: .tool),
        COToolbarItem(id: "Clone", name: "Clone", iconName: "person.2.fill", type: .tool),
        COToolbarItem(id: "DrawLinearGradient", name: "Linear Gradient", iconName: "line.diagonal", type: .tool),
        COToolbarItem(id: "DrawRadialGradient", name: "Radial Gradient", iconName: "circle.circle", type: .tool),
        
        // Actions
        COToolbarItem(id: "AutoAdjust", name: "Auto Adjust", iconName: "wand.and.stars"),
        COToolbarItem(id: "ConvertNegative", name: "Convert Negative", iconName: "film.stack"),
        COToolbarItem(id: "CopyAdjustments", name: "Copy Adjustments", iconName: "arrow.up.doc"),
        COToolbarItem(id: "ApplyAdjustments", name: "Apply Adjustments", iconName: "arrow.down.doc"),
        COToolbarItem(id: "Reset", name: "Reset", iconName: "arrow.counterclockwise"),
        COToolbarItem(id: "UndoRedo", name: "Undo / Redo", iconName: "arrow.uturn.backward.circle", type: .group),
        COToolbarItem(id: "CursorTools", name: "Cursor Tools", iconName: "cursorarrow", type: .group),
        COToolbarItem(id: "Activity", name: "Activity", iconName: "clock.arrow.circlepath", type: .group),
        COToolbarItem(id: "BeforeAfter", name: "Before / After", iconName: "square.on.square"),
        COToolbarItem(id: "Grid", name: "Grid", iconName: "square.grid.3x3"),
        COToolbarItem(id: "ExposureWarning", name: "Exposure Warning", iconName: "exclamationmark.triangle"),
        COToolbarItem(id: "FocusMask", name: "Focus Mask", iconName: "scope"),
        COToolbarItem(id: "Proofing", name: "Proofing", iconName: "eyeglasses"),
        COToolbarItem(id: "EditSelected", name: "Edit Selected", iconName: "square.stack.3d.up"),
        COToolbarItem(id: "Culling", name: "Culling", iconName: "rectangle.grid.1x2"),
        COToolbarItem(id: "Live", name: "Live", iconName: "dot.radiowaves.left.and.right"),
        COToolbarItem(id: "SelfServe", name: "Self Serve", iconName: "person.crop.circle.badge.questionmark"),
        COToolbarItem(id: "Tips", name: "Tips", iconName: "lightbulb"),
        
        // Workflow
        COToolbarItem(id: "Import", name: "Import", iconName: "square.and.arrow.down"),
        COToolbarItem(id: "Capture", name: "Capture", iconName: "camera"),
        COToolbarItem(id: "Export", name: "Export", iconName: "square.and.arrow.up"),
        COToolbarItem(id: "Print", name: "Print", iconName: "printer", type: .action),
        
        // Spacers (Special IDs)
        COToolbarItem(id: "FIXED_SPACER", name: "Space", iconName: "space", type: .spacer),
        COToolbarItem(id: "FLEXIBLE_SPACER", name: "Flexible Space", iconName: "arrow.left.and.right", type: .flexibleSpacer)
    ]
    
    public static func item(for id: String) -> COToolbarItem? {
        return availableItems.first { $0.id == id }
    }
}
