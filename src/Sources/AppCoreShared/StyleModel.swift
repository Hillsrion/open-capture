import Foundation

/// Reconstructed Style model (STY-001).
/// Based on .costyle XML structure discovered in AppCoreShared.
public struct COStyle: Identifiable, Codable {
    public var id: String { name }
    public var name: String
    public var category: String
    
    /// The map of adjustments stored in the style.
    /// Key: The property name (e.g., "Exposure", "Contrast")
    /// Value: The value as a string (as stored in XML)
    public var adjustments: [String: String]
    
    public init(name: String, category: String = "User Styles", adjustments: [String: String] = [:]) {
        self.name = name
        self.category = category
        self.adjustments = adjustments
    }
}

/// A collection of styles (Folder).
public struct StylePack: Identifiable {
    public var id: String { name }
    public var name: String
    public var styles: [COStyle]
}
