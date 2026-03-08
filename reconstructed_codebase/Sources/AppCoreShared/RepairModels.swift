import Foundation
import CoreGraphics

/// Reconstructed Data Model for Heal/Clone repair arrows (UI-006).
/// Based on disassembly of RepairArrow.
public class RepairArrow: Identifiable, Codable {
    public let id: String
    public var sourcePoint: CGPoint
    public var destinationPoint: CGPoint
    public var type: ArrowType
    
    public enum ArrowType: Int, Codable {
        case heal = 0
        case clone = 1
    }
    
    public init(id: String = UUID().uuidString, source: CGPoint, destination: CGPoint, type: ArrowType) {
        self.id = id
        self.sourcePoint = source
        self.destinationPoint = destination
        self.type = type
    }
}
