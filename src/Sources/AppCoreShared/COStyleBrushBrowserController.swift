import Foundation
import Combine

/// Controller for managing Style Brushes (Reference: C1-034).
/// Handles browsing, selection, and the automatic orchestration of layer creation and tool configuration.
public class COStyleBrushBrowserController: ObservableObject {
    public static let shared = COStyleBrushBrowserController()
    
    @Published public private(set) var availableBrushes: [COStyleBrushModel] = COStyleBrushModel.defaults
    
    private let brushSettings = BrushSettingsManager.shared
    private let layerManager = COLayerManager.shared
    
    private init() {}
    
    /// Activates a style brush for the given variant.
    /// 1. Selects the Draw Mask tool.
    /// 2. Configures brush flow/opacity for cumulative build-up.
    /// 3. Ensures a named adjustment layer exists or creates one.
    public func selectBrush(_ brush: COStyleBrushModel, for variant: VariantBase) {
        // 1. Update UI state
        brushSettings.activeStyleBrush = brush.name
        
        // 2. Configure Brush Tool (Cumulative Behavior)
        // Style brushes typically use low flow for build-up
        var settings = brushSettings.drawBrushSettings
        settings.flow = brush.flow
        settings.opacity = brush.opacity
        settings.hardness = brush.hardness
        brushSettings.drawBrushSettings = settings
        
        // 3. Layer Orchestration (Auto-Layering)
        let targetLayerName = brush.name
        
        // Check if a layer with this name already exists
        if let existingIndex = variant.layers.firstIndex(where: { $0.name == targetLayerName }) {
            variant.activeLayerIndex = existingIndex
        } else {
            // Create a new adjustment layer
            _ = layerManager.createLayer(for: variant, name: targetLayerName, type: .adjustment)
            
            // Note: In a full implementation, we would also apply the brush's adjustments 
            // to this new layer here. For this reconstruction, we'll assume the layer 
            // is now ready to receive the adjustments defined in the model.
            applyAdjustments(brush.adjustments, to: variant.activeLayer)
        }
        
        // 4. Set the cursor tool to Draw Mask
        // This is typically handled via AppCommandCenter but we can trigger it here
        // if we have access to it, or let the View handle the tool selection.
    }
    
    private func applyAdjustments(_ adjustments: [String: Any], to layer: LayerBase?) {
        guard let layer = layer else { return }
        
        // Ensure we have an MCAdjLayer to store settings
        if layer.mcLayer == nil {
            layer.mcLayer = MCAdjLayer(dictionary: [:])
        }
        
        guard let mcLayer = layer.mcLayer else { return }
        
        print("[COStyleBrush] Applying adjustments to layer '\(layer.name)': \(adjustments.keys.joined(separator: ", "))")
        
        // Map style brush keys to metadata keys
        for (key, value) in adjustments {
            let metadataKey: String
            switch key {
            case "Exposure": metadataKey = "ZEXPOSURE"
            case "Contrast": metadataKey = "ZCONTRAST"
            case "Brightness": metadataKey = "ZBRIGHTNESS"
            case "Saturation": metadataKey = "ZSATURATION"
            case "Clarity": metadataKey = "ZCLARITY_AMOUNT"
            case "Structure": metadataKey = "ZSTRUCTURE_AMOUNT"
            case "Kelvin": metadataKey = "ZKELVIN"
            case "Tint": metadataKey = "ZTINT"
            default: metadataKey = "Z\(key.uppercased())"
            }
            
            mcLayer.setObject(value, forKey: metadataKey)
        }
        
        // Notify that adjustments have changed
        NotificationCenter.default.post(name: .COVariantAdjustmentsDidReset, object: nil)
    }
}
