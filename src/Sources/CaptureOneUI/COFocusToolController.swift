import SwiftUI
import AppCoreShared
import ImageCore
import Combine

/// Dedicated controller for the Focus Tool sharpness verification (UI-203).
/// Decompiled: _TtC10CaptureOne21COFocusToolController
public class COFocusToolController: ObservableObject {
    public static let shared = COFocusToolController()
    
    @Published public var focusPoint: CGPoint = CGPoint(x: 0.5, y: 0.5)
    @Published public var zoomIndex: Int = 0 // 0: 100%, 1: 200%, 2: 400%
    @Published public var aiMode: Int = 0 // 0: Manual, 1: Eye, 2: Face
    @Published public var isDetecting: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        // Sync with AdjustmentToolController if needed
        AdjustmentToolController.shared.$focusPoint
            .assign(to: &$focusPoint)
        
        AdjustmentToolController.shared.$focusZoomIndex
            .assign(to: &$zoomIndex)
            
        AdjustmentToolController.shared.$focusAIMode
            .assign(to: &$aiMode)
            
        // When our properties change, update the shared controller
        $focusPoint
            .dropFirst()
            .sink { AdjustmentToolController.shared.focusPoint = $0 }
            .store(in: &cancellables)
            
        $zoomIndex
            .dropFirst()
            .sink { AdjustmentToolController.shared.focusZoomIndex = $0 }
            .store(in: &cancellables)
            
        $aiMode
            .dropFirst()
            .sink { AdjustmentToolController.shared.focusAIMode = $0 }
            .store(in: &cancellables)
    }
    
    public func syncFocusPoint() {
        AdjustmentToolController.shared.syncFocusPoint()
    }
    
    public func centerToEye() {
        guard let variant = AdjustmentToolController.shared.currentVariant,
              let image = variant.image?.previewImage else { return } // Using previewImage for speed
        
        isDetecting = true
        COEyeDetector.shared.detectEyes(in: image) { [weak self] points in
            DispatchQueue.main.async {
                self?.isDetecting = false
                if let firstEye = points.first {
                    self?.focusPoint = firstEye
                }
            }
        }
    }
}
