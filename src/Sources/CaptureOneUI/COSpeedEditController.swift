import SwiftUI
import AppCoreShared

/// Reconstructed Speed Edit Controller (UI-202).
/// Manages HUD state and parameter updates during Speed Edit interaction.
public class COSpeedEditController: ObservableObject {
    public static let shared = COSpeedEditController()
    
    public enum SpeedEditAction: String {
        case exposure = "Exposure"
        case contrast = "Contrast"
        case brightness = "Brightness"
        case saturation = "Saturation"
        case highlights = "Highlights"
        case shadows = "Shadows"
        case whites = "Whites"
        case blacks = "Blacks"
    }
    
    @Published public var activeAction: SpeedEditAction? = nil
    @Published public var currentValue: Float = 0.0
    @Published public var isInteracting: Bool = false
    
    private let adjustmentController = AdjustmentToolController.shared
    
    public init() {}
    
    public func handleKeyDown(action: SpeedEditAction) {
        activeAction = action
        updateCurrentValue()
        isInteracting = true
    }
    
    public func handleKeyUp() {
        activeAction = nil
        isInteracting = false
    }
    
    public func updateCurrentValue() {
        guard let action = activeAction else { return }
        switch action {
        case .exposure: currentValue = adjustmentController.exposure
        case .contrast: currentValue = adjustmentController.contrast
        case .brightness: currentValue = adjustmentController.brightness
        case .saturation: currentValue = adjustmentController.saturation
        case .highlights: currentValue = adjustmentController.highlights
        case .shadows: currentValue = adjustmentController.shadows
        case .whites: currentValue = adjustmentController.whites
        case .blacks: currentValue = adjustmentController.blacks
        }
    }
    
    public func handleDrag(deltaX: Float) {
        guard let action = activeAction else { return }
        
        let sensitivity: Float = 0.5
        
        switch action {
        case .exposure:
            adjustmentController.exposure = max(-4.0, min(4.0, adjustmentController.exposure + (deltaX * sensitivity * 0.01)))
        case .contrast:
            adjustmentController.contrast = max(-50, min(50, adjustmentController.contrast + (deltaX * sensitivity)))
        case .brightness:
            adjustmentController.brightness = max(-50, min(50, adjustmentController.brightness + (deltaX * sensitivity)))
        case .saturation:
            adjustmentController.saturation = max(-100, min(100, adjustmentController.saturation + (deltaX * sensitivity)))
        case .highlights:
            adjustmentController.highlights = max(-100, min(100, adjustmentController.highlights + (deltaX * sensitivity)))
        case .shadows:
            adjustmentController.shadows = max(-100, min(100, adjustmentController.shadows + (deltaX * sensitivity)))
        case .whites:
            adjustmentController.whites = max(-100, min(100, adjustmentController.whites + (deltaX * sensitivity)))
        case .blacks:
            adjustmentController.blacks = max(-100, min(100, adjustmentController.blacks + (deltaX * sensitivity)))
        }
        
        updateCurrentValue()
        adjustmentController.objectWillChange.send()
    }
}
