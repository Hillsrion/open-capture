import Foundation
import ImageCore

/// Reconstructed Manager for high-level layer operations (AI-001).
/// Coordinates AI engines and LayerBase to provide semantic masking.
public class COLayerManager {
    public static let shared = COLayerManager()
    
    private init() {}
    
    /// Creates and adds a new layer of the specified type to the variant.
    public func createLayer(for variant: VariantBase, name: String, type: LayerBase.LayerType) -> LayerBase {
        let layer = LayerBase(
            uuid: UUID().uuidString,
            name: name,
            type: type,
            context: variant.managedObjectContext
        )
        variant.layers.append(layer)
        variant.activeLayerIndex = variant.layers.count - 1
        variant.isModified = true
        return layer
    }
    
    /// Creates a new adjustment layer with a mask of the primary subject.
    public func createSubjectLayer(for variant: VariantBase, completion: @escaping (LayerBase?) -> Void) {
        guard let image = variant.image else {
            completion(nil)
            return
        }
        
        print("[COLayerManager] Creating AI Subject Layer for \(variant.variantUUID)")
        
        SubjectMaskingEngine.shared.selectSubject(for: image) { [weak variant] mask in
            guard let variant = variant, variant.isAlive, let mask = mask else {
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                let layer = COLayerManager.shared.createLayer(for: variant, name: "Subject", type: .adjustment)
                layer.mask = mask
                completion(layer)
            }
        }
    }
    
    /// Creates a new adjustment layer with a mask of the background.
    public func createBackgroundLayer(for variant: VariantBase, completion: @escaping (LayerBase?) -> Void) {
        guard let image = variant.image else {
            completion(nil)
            return
        }
        
        print("[COLayerManager] Creating AI Background Layer for \(variant.variantUUID)")
        
        SubjectMaskingEngine.shared.selectBackground(for: image) { [weak variant] mask in
            guard let variant = variant, variant.isAlive, let mask = mask else {
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                let layer = COLayerManager.shared.createLayer(for: variant, name: "Background", type: .adjustment)
                layer.mask = mask
                completion(layer)
            }
        }
    }
    
    /// Creates a new adjustment layer with a mask of detected skin regions.
    public func createSkinLayer(for variant: VariantBase, completion: @escaping (LayerBase?) -> Void) {
        guard let image = variant.image else {
            completion(nil)
            return
        }
        
        print("[COLayerManager] Creating AI Skin Layer for \(variant.variantUUID)")
        
        SkinSegmentationEngine.shared.generateSkinMask(for: image) { [weak variant] mask in
            guard let variant = variant, variant.isAlive, let mask = mask else {
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                let layer = COLayerManager.shared.createLayer(for: variant, name: "Skin", type: .adjustment)
                layer.mask = mask
                completion(layer)
            }
        }
    }
}
