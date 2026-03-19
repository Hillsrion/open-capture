import SwiftUI
import AppCoreShared
import Combine

/// Specialized controller for Black & White conversion parameters.
/// Manages desaturation sensitivity (6-channels) and Split Toning.
public class COBlackAndWhiteToolController: ObservableObject {
    public static let shared = COBlackAndWhiteToolController()
    
    @ObservedObject var adjustmentController: AdjustmentToolController
    
    private var cancellables = Set<AnyCancellable>()
    
    // Split Toning helper bindings
    @Published public var highlightValue: ColorBalanceValue = .neutral
    @Published public var shadowValue: ColorBalanceValue = .neutral
    
    public init(adjustmentController: AdjustmentToolController = .shared) {
        self.adjustmentController = adjustmentController
        
        // Sync Split Toning values
        setupSplitToningSync()
    }
    
    private func setupSplitToningSync() {
        // From AdjustmentController to local ColorBalanceValue
        adjustmentController.$bwSplitToneHighlightHue
            .sink { [weak self] hue in self?.highlightValue.hue = hue }
            .store(in: &cancellables)
            
        adjustmentController.$bwSplitToneHighlightSaturation
            .sink { [weak self] sat in self?.highlightValue.saturation = sat }
            .store(in: &cancellables)
            
        adjustmentController.$bwSplitToneShadowHue
            .sink { [weak self] hue in self?.shadowValue.hue = hue }
            .store(in: &cancellables)
            
        adjustmentController.$bwSplitToneShadowSaturation
            .sink { [weak self] sat in self?.shadowValue.saturation = sat }
            .store(in: &cancellables)
            
        // From local ColorBalanceValue to AdjustmentController
        $highlightValue
            .dropFirst()
            .sink { [weak self] val in
                self?.adjustmentController.bwSplitToneHighlightHue = val.hue
                self?.adjustmentController.bwSplitToneHighlightSaturation = val.saturation
            }
            .store(in: &cancellables)
            
        $shadowValue
            .dropFirst()
            .sink { [weak self] val in
                self?.adjustmentController.bwSplitToneShadowHue = val.hue
                self?.adjustmentController.bwSplitToneShadowSaturation = val.saturation
            }
            .store(in: &cancellables)
    }
    
    public func resetToDefaults() {
        adjustmentController.bwRed = 0
        adjustmentController.bwOrange = 0
        adjustmentController.bwYellow = 0
        adjustmentController.bwGreen = 0
        adjustmentController.bwBlue = 0
        adjustmentController.bwMagenta = 0
        
        highlightValue = .neutral
        shadowValue = .neutral
    }
}
