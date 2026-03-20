import SwiftUI
import Combine
import AppKit
import ImageCore
import AppCoreShared

/// Bridges the COExposureWarningRenderer to the Viewer UI (UI-204).
/// Manages real-time generation of highlight/shadow clipping masks.
@MainActor
public final class COClippingOverlayManager: ObservableObject {
    public static let shared = COClippingOverlayManager()
    
    @Published public var clippingMask: NSImage?
    private var cancellables = Set<AnyCancellable>()
    private let controller = AdjustmentToolController.shared
    private let commands = AppCommandCenter.shared
    
    private init() {
        setupObservers()
    }
    
    private func setupObservers() {
        // Observe both the toggle state and adjustment changes
        Publishers.CombineLatest(
            commands.$showExposureWarning,
            controller.objectWillChange
        )
        .debounce(for: .milliseconds(16), scheduler: RunLoop.main)
        .sink { [weak self] show, _ in
            guard let self = self else { return }
            if show {
                self.updateMask()
            } else {
                self.clippingMask = nil
            }
        }
        .store(in: &cancellables)
        
        // Also observe current variant changes
        controller.$currentVariant
            .sink { [weak self] _ in
                guard let self = self, self.commands.showExposureWarning else { return }
                self.updateMask()
            }
            .store(in: &cancellables)
    }
    
    public func updateMask() {
        guard let variant = controller.currentVariant,
              let image = variant.image?.previewImage ?? variant.image?.fullImage else {
            self.clippingMask = nil
            return
        }
        
        // Generate the mask using the high-fidelity renderer
        let mask = COExposureWarningRenderer.shared.generateClippingMask(
            for: image,
            highlightThreshold: controller.exposureHighlightThreshold,
            shadowThreshold: controller.exposureShadowThreshold,
            highlightColor: NSColor(controller.exposureHighlightColor),
            shadowColor: NSColor(controller.exposureShadowColor),
            showShadows: true // Assuming we want to show both if enabled
        )
        
        self.clippingMask = mask
    }
}
