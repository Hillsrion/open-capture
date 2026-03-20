import SwiftUI
import AppCoreShared
import ImageCore
import Combine

/// Specialized controller for Clarity & Structure parameters.
/// Manages Clarity amount, method and fine-scale structure.
public class COClarityToolController: ObservableObject {
    public static let shared = COClarityToolController()
    
    @ObservedObject var adjustmentController: AdjustmentToolController
    
    private var cancellables = Set<AnyCancellable>()
    
    public init(adjustmentController: AdjustmentToolController = .shared) {
        self.adjustmentController = adjustmentController
        
        // Link with AdjustmentController's @Published properties
        adjustmentController.objectWillChange
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }
    
    public var amount: Float {
        get { adjustmentController.clarityAmount }
        set { adjustmentController.clarityAmount = newValue }
    }
    
    public var structure: Float {
        get { adjustmentController.structureAmount }
        set { adjustmentController.structureAmount = newValue }
    }
    
    public var method: Int {
        get { adjustmentController.clarityMethod }
        set { adjustmentController.clarityMethod = newValue }
    }
    
    public func resetToDefaults() {
        adjustmentController.clarityAmount = 0
        adjustmentController.structureAmount = 0
        adjustmentController.clarityMethod = 3 // Default usually Natural (3) in modern C1
    }
}
