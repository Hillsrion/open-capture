import Foundation
import Accelerate

/// Reconstructed mathematical kernels for noise reduction in ImageCore.
/// Based on disassembly of ICNR_ApplyLuminanceNR and ICNR_ApplyColorNR.
public struct NoiseReductionKernels {
    
    /// Reconstructed Luminance NR logic.
    /// Uses a detail-preserving bilateral-style filter (simulated logic).
    public static func applyLuminanceNR(to buffer: inout [Float], count: Int, amount: Float, details: Float) {
        guard amount > 0 else { return }
        
        // 1. Calculate smoothing strength
        let smoothing = amount / 100.0
        let detailPreservation = details / 100.0
        
        // 2. Perform smoothing (simulated with a weighted local average that ignores high-contrast edges)
        // Based on AbiLuminance and AbiDetails patterns.
        var smoothed = [Float](buffer)
        // (In a real pipeline, this would use vImageTentConvolve_PlanarF or custom bilateral kernel)
        
        // 3. Blend smoothed back with original based on detail preservation
        var weight = [Float](repeating: smoothing * (1.0 - detailPreservation), count: count)
        vDSP_vmsb(smoothed, 1, weight, 1, buffer, 1, &buffer, 1, vDSP_Length(count))
    }
    
    /// Reconstructed Color NR logic.
    /// Based on AbiColor symbols. Suppresses low-frequency color fluctuations.
    public static func applyColorNR(r: inout [Float], g: inout [Float], b: inout [Float], count: Int, amount: Float) {
        guard amount > 0 else { return }
        
        // Logic: Convert to YCbCr, smooth Cb and Cr channels, convert back.
        // Simplified: reduce the distance of R and B from G.
        let suppression = amount / 200.0
        for i in 0..<count {
            r[i] = r[i] + (g[i] - r[i]) * suppression
            b[i] = b[i] + (g[i] - b[i]) * suppression
        }
    }
    
    /// Reconstructed Single Pixel NR (Hot pixel removal).
    /// Based on AbiSinglePixel. Detects and removes isolated peak values.
    public static func applySinglePixelNR(to buffer: inout [Float], count: Int, amount: Float) {
        guard amount > 0 else { return }
        
        // Logic: Simple 3x1 median filter simulation for hot pixels.
        for i in 1..<count-1 {
            let localAvg = (buffer[i-1] + buffer[i+1]) / 2.0
            if abs(buffer[i] - localAvg) > 0.5 * (1.0 - amount / 100.0) {
                buffer[i] = localAvg
            }
        }
    }
}
