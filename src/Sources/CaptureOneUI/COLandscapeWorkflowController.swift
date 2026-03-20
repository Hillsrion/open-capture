import SwiftUI
import AppCoreShared
import Combine

/// Reconstructed Landscape Editing Workflow Controller.
/// Coordinates specialized tools for landscape photography.
public class COLandscapeWorkflowController: ObservableObject {
    public static let shared = COLandscapeWorkflowController()
    
    private let adjustmentController = AdjustmentToolController.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published public var isAsymmetricalModeEnabled: Bool = false
    
    public init() {
    }
    
    /// Optimized HDR settings for landscape (prioritizing highlights for skies)
    public func applyLandscapeHDRPreset() {
        adjustmentController.highlights = 40.0
        adjustmentController.shadows = 20.0
        adjustmentController.whites = 10.0
        adjustmentController.blacks = -5.0
    }
    
    /// Apply Dehaze with landscape-specific color bias
    public func applyAtmosphericDehaze() {
        adjustmentController.dehazeAmount = 30.0
        adjustmentController.dehazeColor = Color(hue: 0.6, saturation: 0.2, brightness: 0.8) // Slight blue bias
    }
    
    /// Coordination for Linear Gradient creation with asymmetrical feathering
    public func prepareLinearGradient(asymmetrical: Bool) {
        self.isAsymmetricalModeEnabled = asymmetrical
    }
}
