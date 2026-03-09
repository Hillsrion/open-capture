import Foundation
import Accelerate

/// Reconstructed mathematical kernels for image adjustments in ImageCore.
/// Based on disassembly of CImgOpApplyExposure and CImgOpBrightness.

public struct AdjustmentKernels {
    
    // MARK: - Exposure
    
    /// Reconstructed Exposure adjustment logic.
    /// Formula inferred: Output = Input * 2^EV
    public static func applyExposure(to buffer: UnsafeMutablePointer<Float>, count: Int, ev: Float) {
        let gain = pow(2.0, ev)
        var multiplier = gain
        vDSP_vsmul(buffer, 1, &multiplier, buffer, 1, vDSP_Length(count))
    }
    
    // MARK: - Contrast
    
    /// Reconstructed Contrast adjustment logic.
    /// Based on ApplyContrast_SIMD patterns.
    /// Formula inferred: Output = (Input - 0.5) * Contrast + 0.5 + Brightness
    public static func applyContrast(to buffer: UnsafeMutablePointer<Float>, count: Int, contrast: Float, brightness: Float) {
        var pivot: Float = -0.5
        var contrastVal = contrast
        var offset: Float = 0.5 + brightness
        
        // 1. Input - 0.5
        vDSP_vsadd(buffer, 1, &pivot, buffer, 1, vDSP_Length(count))
        // 2. Multiply by Contrast
        vDSP_vsmul(buffer, 1, &contrastVal, buffer, 1, vDSP_Length(count))
        // 3. Add offset (0.5 + brightness)
        vDSP_vsadd(buffer, 1, &offset, buffer, 1, vDSP_Length(count))
    }
    
    // MARK: - Saturation
    
    /// Reconstructed Saturation adjustment logic.
    /// Uses luminance preservation (Luma = 0.299R + 0.587G + 0.114B)
    public static func applySaturation(r: UnsafeMutablePointer<Float>, g: UnsafeMutablePointer<Float>, b: UnsafeMutablePointer<Float>, count: Int, saturation: Float) {
        for i in 0..<count {
            let luma = 0.299 * r[i] + 0.587 * g[i] + 0.114 * b[i]
            r[i] = luma + (r[i] - luma) * saturation
            g[i] = luma + (g[i] - luma) * saturation
            b[i] = luma + (b[i] - luma) * saturation
        }
    }
}
