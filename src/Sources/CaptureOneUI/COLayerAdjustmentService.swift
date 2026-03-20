import SwiftUI
import AppCoreShared
import DataCore

/// Service for managing Layer-based adjustments (Reference: 2-HZ7HSYXUQ).
public class COLayerAdjustmentService {
    public static let shared = COLayerAdjustmentService()
    
    private init() {}
    
    /// Creates a new adjustment layer for the given variant.
    public func createAdjustmentLayer(for variant: VariantBase, name: String = "New Layer") -> LayerBase {
        let newLayer = LayerBase(
            uuid: UUID().uuidString,
            name: name,
            type: .adjustment,
            context: variant.managedObjectContext
        )
        variant.layers.append(newLayer)
        variant.activeLayerIndex = variant.layers.count - 1
        variant.isModified = true
        return newLayer
    }
    
    /// Applies a COStyle to a specific layer.
    public func applyStyle(_ style: COStyle, to layer: LayerBase) {
        if layer.mcLayer == nil {
            layer.mcLayer = MCAdjLayer(dictionary: [:])
        }
        
        for (key, val) in style.adjustments {
            layer.mcLayer?.setObject(val.value, forKey: key)
        }
        
        print("[LayerService] Style \(style.name) applied to layer \(layer.name)")
    }
}
