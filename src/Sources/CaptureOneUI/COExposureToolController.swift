import SwiftUI
import AppCoreShared

/// Controller for the Exposure Tool (UI-202).
/// Binds to AdjustmentToolController for central state management.
public class COExposureToolController: ObservableObject {
    public static let shared = COExposureToolController()
    
    @ObservedObject var adjustmentController: AdjustmentToolController
    
    public init(adjustmentController: AdjustmentToolController = .shared) {
        self.adjustmentController = adjustmentController
    }
    
    public func resetExposure() { adjustmentController.exposure = 0.0 }
    public func resetContrast() { adjustmentController.contrast = 0.0 }
    public func resetBrightness() { adjustmentController.brightness = 0.0 }
    public func resetSaturation() { adjustmentController.saturation = 0.0 }
    
    public func autoAdjust() {
        // Simulation of auto-adjustment logic
        print("[Exposure] Running Auto-Adjustment")
        adjustmentController.exposure = 0.25 // Example result
    }
}
