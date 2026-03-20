import Foundation
import Combine
import ImageCore
import AppCoreShared

/// High-fidelity Match Look Controller (AI-204).
/// Coordinates AI color grading transfer from reference images.
public class COMatchLookController: ObservableObject {
    public static let shared = COMatchLookController()
    
    @Published public var referenceVariant: VariantBase?
    @Published public var impact: Float = 100.0
    @Published public var isProcessing: Bool = false
    
    private let gradingEngine = COColorGradingEngine.shared
    
    private init() {}
    
    /// Sets the current selection as the reference for Match Look.
    public func setSelectionAsReference() {
        if let current = AdjustmentToolController.shared.currentVariant {
            self.referenceVariant = current
            print("[MatchLook] Reference set to: \(current.variantUUID)")
        }
    }
    
    /// Clears the reference.
    public func clearReference() {
        self.referenceVariant = nil
    }
    
    /// Applies the look from the reference to the target variants.
    public func applyToSelection(targets: [VariantBase]) {
        guard let reference = referenceVariant else { return }
        
        self.isProcessing = true
        
        // AI Logic: Transfer grading
        gradingEngine.transferGrade(from: reference, to: targets, impact: impact / 100.0) {
            DispatchQueue.main.async {
                self.isProcessing = false
                print("[MatchLook] Applied look to \(targets.count) images.")
            }
        }
    }
}
