import Foundation
import Accelerate

/// Reconstructed Levels adjustment logic.
/// Maps [BlackPoint, WhitePoint] to [TargetBlack, TargetWhite] with a gamma (midtone) correction.

public struct LevelsKernels {
    
    /// Applies levels mapping to a single channel buffer
    /// 
    /// - Parameters:
    ///   - buffer: The floating point pixel buffer (e.g. 0.0 to 1.0)
    ///   - count: Number of pixels
    ///   - blackPoint: Input black level (usually 0.0 to 1.0)
    ///   - whitePoint: Input white level (usually 0.0 to 1.0)
    ///   - midtone: Gamma correction factor (usually around 1.0, < 1 brightens shadows, > 1 darkens shadows)
    ///   - targetBlack: Output black level
    ///   - targetWhite: Output white level
    public static func applyLevels(to buffer: UnsafeMutablePointer<Float>, count: Int, blackPoint: Float, whitePoint: Float, midtone: Float, targetBlack: Float, targetWhite: Float) {
        // Levels equation:
        // 1. Normalize: norm = (val - blackPoint) / (whitePoint - blackPoint)
        // 2. Gamma correction: gammaC = pow(norm, 1.0 / midtone)
        // 3. Output map: out = gammaC * (targetWhite - targetBlack) + targetBlack
        
        let range = whitePoint - blackPoint
        let outRange = targetWhite - targetBlack
        
        // Ensure range > 0
        guard range > 0.0001 else { return }
        
        for i in 0..<count {
            // 1. Normalize and clamp to 0..1
            var norm = (buffer[i] - blackPoint) / range
            norm = max(0.0, min(1.0, norm))
            
            // 2. Midtone correction (Gamma)
            let gammaC = midtone == 1.0 ? norm : pow(norm, 1.0 / midtone)
            
            // 3. Map to Target
            buffer[i] = gammaC * outRange + targetBlack
        }
    }
}
