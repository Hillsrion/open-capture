import SwiftUI
import AppCoreShared
import ImageCore
import Combine

/// Specialized controller for Vignetting parameters.
/// Manages Vignetting amount and method.
public class COVignettingToolController: ObservableObject {
    public static let shared = COVignettingToolController()
    
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
        get { adjustmentController.vignettingAmount }
        set { adjustmentController.vignettingAmount = newValue }
    }
    
    public var method: Int {
        get { adjustmentController.vignettingMethod }
        set { adjustmentController.vignettingMethod = newValue }
    }
    
    public func resetToDefaults() {
        adjustmentController.resetVignetting()
    }
}
