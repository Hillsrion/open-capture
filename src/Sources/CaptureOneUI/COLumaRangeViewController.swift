import SwiftUI
import AppCoreShared
import Combine

/// Controller for the Luma Range dialog state and live preview.
/// Ported from UI-204 specifications.
public class COLumaRangeViewController: ObservableObject {
    @Published public var rangeMin: Double = 64.0
    @Published public var rangeMax: Double = 192.0
    @Published public var falloffMin: Double = 0.0
    @Published public var falloffMax: Double = 255.0
    
    @Published public var radius: Double = 5.0
    @Published public var sensitivity: Double = 50.0
    @Published public var isDisplayingMask: Bool = true
    
    private var cancellables = Set<AnyCancellable>()
    private weak var adjustmentController: AdjustmentToolController?
    
    public init(adjustmentController: AdjustmentToolController) {
        self.adjustmentController = adjustmentController
        
        // Setup live preview updates
        Publishers.CombineLatest4($rangeMin, $rangeMax, $falloffMin, $falloffMax)
            .debounce(for: .milliseconds(16), scheduler: RunLoop.main)
            .sink { [weak self] _ in self?.updateLivePreview() }
            .store(in: &cancellables)
            
        Publishers.CombineLatest($radius, $sensitivity)
            .debounce(for: .milliseconds(16), scheduler: RunLoop.main)
            .sink { [weak self] _ in self?.updateLivePreview() }
            .store(in: &cancellables)
    }
    
    public func updateLivePreview() {
        guard let controller = adjustmentController, let variant = controller.currentVariant else { return }
        
        // 1. Get luminance data (Simulated)
        let luminance: [Float] = variant.luminanceData ?? []
        guard !luminance.isEmpty else { return }
        
        // 2. Generate mask
        let settings = COLuminosityMaskService.LumaRangeSettings(
            rangeMin: rangeMin,
            rangeMax: rangeMax,
            falloffMin: falloffMin,
            falloffMax: falloffMax,
            radius: radius,
            sensitivity: sensitivity
        )
        let mask = COLuminosityMaskService.generateMask(fromLuminance: luminance, settings: settings)
        
        // 3. Generate preview overlay
        if isDisplayingMask {
            let preview = COMaskPreviewGenerator.generatePreview(fromMask: mask, mode: .grayscale)
            // In a real implementation, we would pass this preview data to the Viewer for rendering.
            print("[LumaRange] Live Preview Updated with range: \(rangeMin)-\(rangeMax)")
        }
    }
    
    public func apply() {
        guard let controller = adjustmentController else { return }
        controller.computeLumaRange(
            start: rangeMin,
            end: rangeMax,
            falloffStart: falloffMin,
            falloffEnd: falloffMax
        )
    }
}
