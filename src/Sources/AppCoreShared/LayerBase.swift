import Foundation
import ImageCore

/// Reconstructed Base class for Layer entities in AppCoreShared.
/// Based on _TtC12AppCoreShared9LayerBase metadata.

public class LayerBase: BaseObject, ICMaskableLayer, Identifiable {
    
    public var id: String { uuid }
    
    public enum LayerType: Int {
        case background = 0
        case adjustment = 1
        case clone = 2
        case heal = 3
    }
    
    // MARK: - Properties
    public let uuid: String
    public var name: String
    public var opacity: Float // 0.0 to 1.0
    public var isVisible: Bool
    public var type: LayerType
    
    // MARK: - Mask Data (AI-001)
    /// The grayscale mask data for this layer.
    /// In original C1, this is an ICMask object pointing to a GPU texture.
    public var mask: [Float]?
    
    // MARK: - Repair Arrows (UI-006)
    public var repairArrows: [RepairArrow] = []
    
    // MARK: - Gradient Masks (UI-204)
    public var linearGradient: LinearGradientMask?
    public var radialGradient: RadialGradientMask?
    
    public var isMagicBrush: Bool {
        return self is VariantMagicBrushLayer
    }
    
    // MARK: - Internal Row State
    public var mcLayer: MCAdjLayer?
    
    public init(uuid: String, name: String, type: LayerType = .adjustment, context: ObjectContext?) {
        self.uuid = uuid
        self.name = name
        self.opacity = 1.0
        self.isVisible = true
        self.type = type
        super.init(managedObjectContext: context)
    }
}

public struct LinearGradientMask: Codable {
    public var start: CGPoint // Normalized
    public var end: CGPoint   // Normalized
    public var middle: CGPoint // Normalized
    public var isAsymmetrical: Bool = false

    public init(start: CGPoint, end: CGPoint, middle: CGPoint? = nil) {
        self.start = start
        self.end = end
        self.middle = middle ?? CGPoint(x: (start.x + end.x) / 2, y: (start.y + end.y) / 2)
    }
}
public struct RadialGradientMask: Codable {
    public var center: CGPoint // Normalized
    public var radius: CGSize  // Normalized
    public var rotation: Double // Degrees
    public var feather: Double  // 0.0 to 1.0
    
    public init(center: CGPoint, radius: CGSize, rotation: Double, feather: Double) {
        self.center = center
        self.radius = radius
        self.rotation = rotation
        self.feather = feather
    }
}
