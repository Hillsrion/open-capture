import Foundation
import Accelerate

/// Reconstructed High Dynamic Range (HDR) recovery kernels for ImageCore.
/// Based on disassembly of HighDynamicRangeAdjustments and CImgOpDesaturateShadows.

public struct HDRKernels {
    
    // MARK: - Highlight Recovery
    
    /// Reconstructed Highlight recovery logic.
    /// Inferred formula: Reduces intensity of pixels near peak (1.0) while preserving color.
    public static func applyHighlightRecovery(to buffer: UnsafeMutablePointer<Float>, count: Int, amount: Float) {
        // amount: 0.0 to 1.0 (Capture One slider 0-100)
        let threshold: Float = 0.7
        let strength = amount * 0.5 // Scale strength for natural look
        
        for i in 0..<count {
            if buffer[i] > threshold {
                let over = buffer[i] - threshold
                buffer[i] -= over * strength
            }
        }
    }
    
    // MARK: - Shadow Recovery
    
    /// Reconstructed Shadow recovery logic.
    /// Inferred formula: Lifts low-intensity pixels without affecting highlights.
    public static func applyShadowRecovery(to buffer: UnsafeMutablePointer<Float>, count: Int, amount: Float) {
        // amount: 0.0 to 1.0
        let threshold: Float = 0.3
        let lift = amount * 0.4
        
        for i in 0..<count {
            if buffer[i] < threshold {
                let darkness = (threshold - buffer[i]) / threshold
                buffer[i] += darkness * lift
            }
        }
    }
}
