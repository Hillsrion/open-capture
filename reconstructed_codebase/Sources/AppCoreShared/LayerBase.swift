import Foundation
import ImageCore

/// Reconstructed Base class for Layer entities in AppCoreShared.
/// Based on _TtC12AppCoreShared9LayerBase metadata.

public class LayerBase: BaseObject, ICMaskableLayer {
    
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
