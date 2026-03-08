import Foundation

/// Reconstructed Data Model for a Style (UI-010).
/// A Style is a collection of adjustments that can be applied to a variant.
public struct Style: Identifiable, Codable {
    public let id: UUID
    public let name: String
    public let adjustments: [String: AnyCodable] // Reconstructed as AnyCodable for flexibility
    
    public init(id: UUID = UUID(), name: String, adjustments: [String: AnyCodable]) {
        self.id = id
        self.name = name
        self.adjustments = adjustments
    }
}

/// Reconstructed Data Model for a Style Pack.
/// Represents a folder or collection of styles.
public class StylePack: Identifiable {
    public let id: UUID
    public let name: String
    public var styles: [Style]
    public var childPacks: [StylePack]
    
    public init(id: UUID = UUID(), name: String, styles: [Style] = [], childPacks: [StylePack] = []) {
        self.id = id
        self.name = name
        self.styles = styles
        self.childPacks = childPacks
    }
}

/// Helper for Codable dictionary with mixed types.
public struct AnyCodable: Codable {
    public let value: Any
    
    public init(_ value: Any) {
        self.value = value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Double.self) { value = x }
        else if let x = try? container.decode(String.self) { value = x }
        else if let x = try? container.decode(Bool.self) { value = x }
        else { throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported type") }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let x = value as? Double { try container.encode(x) }
        else if let x = value as? String { try container.encode(x) }
        else if let x = value as? Bool { try container.encode(x) }
    }
}
