import SwiftUI
import Combine
import AppCoreShared
import ImageCore

/// Reconstructed Keystone Controller (UI-204).
/// Manages the 4-point interactive guides and the perspective warp state.
public class COKeystoneController: ObservableObject {
    public static let shared = COKeystoneController()
    
    @Published public var points: KeystonePoints {
        didSet {
            syncWithAdjustmentController()
        }
    }
    @Published public var mode: KeystoneMode = .verticalAndHorizontal
    @Published public var amount: Double = 100.0 {
        didSet {
            syncWithAdjustmentController()
        }
    }
    @Published public var isVisible: Bool = false
    
    public enum KeystoneMode: Int, CaseIterable {
        case vertical = 0
        case horizontal = 1
        case verticalAndHorizontal = 2
    }
    
    private init() {
        // Initialize with default 4 points in a normalized quad
        self.points = KeystonePoints(
            p0: CGPoint(x: 0.2, y: 0.2), // Top Left
            p1: CGPoint(x: 0.8, y: 0.2), // Top Right
            p2: CGPoint(x: 0.2, y: 0.8), // Bottom Left
            p3: CGPoint(x: 0.8, y: 0.8)  // Bottom Right
        )
    }
    
    public func updatePoint(_ index: Int, to location: CGPoint) {
        switch index {
        case 0: points.p0 = location
        case 1: points.p1 = location
        case 2: points.p2 = location
        case 3: points.p3 = location
        default: break
        }
    }
    
    public func resetPoints() {
        self.points = KeystonePoints(
            p0: CGPoint(x: 0.2, y: 0.2),
            p1: CGPoint(x: 0.8, y: 0.2),
            p2: CGPoint(x: 0.2, y: 0.8),
            p3: CGPoint(x: 0.8, y: 0.8)
        )
    }
    
    public func apply() {
        print("[COKeystoneController] Applying keystone correction based on points: \(points), Amount: \(amount)")
        // In a real implementation, this would trigger the actual image warp.
        AdjustmentToolController.shared.applyKeystone()
    }
    
    private func syncWithAdjustmentController() {
        // Map the quad points to tilt/skew values for the engine if needed,
        // or just store the points if the engine supports quad-based warping.
        AdjustmentToolController.shared.keystonePoints = self.points
        AdjustmentToolController.shared.keystoneAmount = self.amount
        
        // Simulating how points affect sliders
        let dy = points.p1.y - points.p0.y
        AdjustmentToolController.shared.keystoneTiltX = Double(dy * 100)
    }
}
