import Foundation

/// Reconstructed Style model (STY-001).
/// Based on .costyle XML structure discovered in AppCoreShared.
public struct COStyle: Identifiable, Codable {
    public var id: String { name }
    public var name: String
    public var category: String
    
    /// The map of adjustments stored in the style.
    public var adjustments: [String: AnyCodable]
    
    public init(name: String, category: String = "User Styles", adjustments: [String: AnyCodable] = [:]) {
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
