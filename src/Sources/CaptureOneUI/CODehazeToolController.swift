import SwiftUI
import AppCoreShared
import ImageCore
import Combine

/// Specialized controller for Dehaze parameters.
/// Manages Dehaze amount and shadow tone color.
public class CODehazeToolController: ObservableObject {
    public static let shared = CODehazeToolController()
    
    @ObservedObject var adjustmentController: AdjustmentToolController
    
    private var cancellables = Set<AnyCancellable>()
    
    public init(adjustmentController: AdjustmentToolController = .shared) {
        self.adjustmentController = adjustmentController
        
        // Link with AdjustmentController's @Published properties
        adjustmentController.objectWillChange
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }
    
    public var amount: Double {
        get { adjustmentController.dehazeAmount }
        set { adjustmentController.dehazeAmount = newValue }
    }
    
    public var shadowToneHue: Double {
        get { adjustmentController.dehazeShadowToneHue }
        set { adjustmentController.dehazeShadowToneHue = newValue }
    }
    
    public var shadowToneColor: Color {
        get { adjustmentController.dehazeColor }
        set {
            adjustmentController.dehazeColor = newValue
            
            // Sync hue when color changes manually
            // We use NSColor to extract the hue component
            #if os(macOS)
            let nsColor = NSColor(newValue)
            if let converted = nsColor.usingColorSpace(.deviceRGB) {
                adjustmentController.dehazeShadowToneHue = Double(converted.hueComponent) * 360.0
            }
            #else
            let uiColor = UIColor(newValue)
            var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
            if uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
                adjustmentController.dehazeShadowToneHue = Double(h) * 360.0
            }
            #endif
        }
    }
    
    public func resetToDefaults() {
        adjustmentController.resetDehaze()
    }
}
