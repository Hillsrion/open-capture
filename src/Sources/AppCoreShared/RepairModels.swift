import Foundation
import CoreGraphics

/// Reconstructed Data Model for Heal/Clone repair arrows (UI-006).
/// Based on disassembly of RepairArrow.
public class RepairArrow: Identifiable, Codable, ObservableObject {
    public let id: String
    @Published public var sourcePoint: CGPoint
    @Published public var destinationPoint: CGPoint
    public var type: ArrowType
    
    public enum ArrowType: Int, Codable {
        case heal = 0
        case clone = 1
    }
    
    enum CodingKeys: String, CodingKey {
        case id, sourcePoint, destinationPoint, type
    }
    
    public init(id: String = UUID().uuidString, source: CGPoint, destination: CGPoint, type: ArrowType) {
        self.id = id
        self.sourcePoint = source
        self.destinationPoint = destination
        self.type = type
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        sourcePoint = try container.decode(CGPoint.self, forKey: .sourcePoint)
        destinationPoint = try container.decode(CGPoint.self, forKey: .destinationPoint)
        type = try container.decode(ArrowType.self, forKey: .type)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(sourcePoint, forKey: .sourcePoint)
        try container.encode(destinationPoint, forKey: .destinationPoint)
        try container.encode(type, forKey: .type)
    }
}
