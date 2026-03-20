import SwiftUI
import AppCoreShared

/// Reconstructed Direct Color Editor Controller (UI-202).
/// Handles on-image color editing (Hue, Saturation, Lightness).
public class CODirectColorEditorController: ObservableObject {
    public static let shared = CODirectColorEditorController()
    
    @Published public var isEnabled: Bool = false
    @Published public var activeSamplePoint: CGPoint? = nil
    
    private let adjustmentController = AdjustmentToolController.shared
    
    public init() {}
    
    /// Translates x/y deltas to Hue/Sat/Lum changes.
    /// Horizontal (Hue), Vertical (Saturation), Alt+Horizontal (Lightness).
    public func handleDrag(delta: CGSize, isAltPressed: Bool) {
        let sensitivity: Double = 0.5
        
        if isAltPressed {
            // Horizontal (Alt) -> Lightness/Luminance (ZBASIC_COLOR_LUM)
            // Simplified: apply to the "Basic Red" slice for demo purposes
            let lumDelta = Double(delta.width) * sensitivity
            let currentLum = adjustmentController.basicColorLum[0]
            adjustmentController.basicColorLum[0] = max(-100, min(100, currentLum + lumDelta))
            print("[ColorEditor] Adjusting Luminance: \(lumDelta)")
        } else {
            // Horizontal -> Hue (ZBASIC_COLOR_HUE)
            let hueDelta = Double(delta.width) * sensitivity
            let currentHue = adjustmentController.basicColorHue[0]
            adjustmentController.basicColorHue[0] = max(-100, min(100, currentHue + hueDelta))
            
            // Vertical -> Saturation (ZBASIC_COLOR_SAT)
            let satDelta = Double(-delta.height) * sensitivity
            let currentSat = adjustmentController.basicColorSat[0]
            adjustmentController.basicColorSat[0] = max(-100, min(100, currentSat + satDelta))
            
            print("[ColorEditor] Adjusting Hue: \(hueDelta), Sat: \(satDelta)")
        }
        
        // Trigger render
        adjustmentController.objectWillChange.send()
    }
}
