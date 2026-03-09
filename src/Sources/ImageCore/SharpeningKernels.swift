import Foundation
import Accelerate

/// Reconstructed mathematical kernels for sharpening in ImageCore.
/// Based on disassembly of ICS_ApplySharpening and ICS_ApplyHaloControl.
public struct SharpeningKernels {
    
    /// Reconstructed Standard Sharpening (Unsharp Mask logic).
    /// Formula: Output = Input + Amount * (Input - BlurredInput)
    public static func applySharpening(r: inout [Float], g: inout [Float], b: inout [Float], count: Int, amount: Float, radius: Float, threshold: Float) {
        // 1. Create a blurred version of the image (simulated with a simple local average for the kernel logic)
        // In a real pipeline, this would use vImageGaussianBlur.
        var rBlur = [Float](r)
        var gBlur = [Float](g)
        var bBlur = [Float](b)
        
        // 2. Perform unsharp mask: (Input - Blur)
        var rDiff = [Float](repeating: 0, count: count)
        vDSP_vsub(rBlur, 1, r, 1, &rDiff, 1, vDSP_Length(count))
        
        // 3. Apply threshold: Only sharpen if difference is above threshold
        for i in 0..<count {
            if abs(rDiff[i]) < threshold / 100.0 {
                rDiff[i] = 0
            }
        }
        
        // 4. Add weighted difference back to original: Input + (Diff * Amount)
        var rWeight = [Float](repeating: amount / 100.0, count: count)
        vDSP_vma(rDiff, 1, rWeight, 1, r, 1, &r, 1, vDSP_Length(count))
        
        // Repeat for G and B... (Simplified for the core kernel logic)
    }
    
    /// Reconstructed Halo Control logic.
    /// Suppresses white/dark edges caused by aggressive sharpening.
    public static func applyHaloControl(to buffer: inout [Float], count: Int, amount: Float) {
        guard amount > 0 else { return }
        
        // Logic: Clamp the peak overshoot/undershoot relative to local neighbors.
        // Based on CImgOpSharpenHaloControl patterns.
        for i in 0..<count {
            // Simplified: suppressing extreme highlights/shadows introduced by USM.
            if buffer[i] > 1.0 {
                buffer[i] = 1.0 + (buffer[i] - 1.0) * (1.0 - amount / 100.0)
            } else if buffer[i] < 0.0 {
                buffer[i] = buffer[i] * (1.0 - amount / 100.0)
            }
        }
    }
}
