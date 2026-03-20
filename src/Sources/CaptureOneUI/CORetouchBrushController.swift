import Foundation
import Combine
import AppCoreShared
import ImageCore

/// Manages Heal and Clone brush interactions (UI-203).
public class CORetouchBrushController: ObservableObject {
    public static let shared = CORetouchBrushController()
    
    @Published public var isHealActive: Bool = false
    @Published public var isCloneActive: Bool = false
    
    private let layerManager = COLayerManager.shared
    
    private init() {}
    
    public func handleMouseDown(at point: CGPoint, mode: RetouchMode) {
        guard let variant = AdjustmentToolController.shared.currentVariant else { return }
        
        // 1. Ensure appropriate layer exists or create one
        let layerName = mode == .heal ? "Heal Layer" : "Clone Layer"
        let layerType: LayerBase.LayerType = mode == .heal ? .heal : .clone
        
        var targetLayer = variant.layers.first { $0.name == layerName && $0.type == layerType }
        if targetLayer == nil {
            layerManager.createLayer(for: variant, name: layerName, type: layerType)
            targetLayer = variant.layers.last
        }
        
        // 2. Add retouch point (simulated)
        print("[Retouch] Adding \(mode) point at \(point) on \(layerName)")
    }
    
    public enum RetouchMode {
        case heal
        case clone
    }
}
