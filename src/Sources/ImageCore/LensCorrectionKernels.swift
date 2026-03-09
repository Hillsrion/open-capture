import Foundation
import Accelerate

/// Reconstructed mathematical kernels for lens correction in ImageCore.
/// Based on disassembly of ICL_DistortionCorrection and ICL_LightFalloff.

public struct LensCorrectionKernels {
    
    // MARK: - Distortion
    
    /// Reconstructed Distortion correction logic (Brown-Conrady model).
    /// Formula: x' = x * (1 + k1*r^2 + k2*r^4 + ...)
    public static func applyDistortion(x: inout [Float], y: inout [Float], count: Int, k1: Float, k2: Float = 0.0) {
        for i in 0..<count {
            let r2 = x[i]*x[i] + y[i]*y[i]
            let distortion = 1.0 + k1*r2 + k2*r2*r2
            x[i] *= distortion
            y[i] *= distortion
        }
    }
    
    // MARK: - Light Falloff
    
    /// Reconstructed Light Falloff (vignetting) compensation logic.
    /// Formula: Output = Input * (1 + amount * r^2)
    /// Amount represents the inverse of the falloff curve.
    public static func applyLightFalloff(to buffer: inout [Float], distances: [Float], count: Int, amount: Float) {
        for i in 0..<count {
            let r2 = distances[i]*distances[i]
            let compensation = 1.0 + amount * r2
            buffer[i] *= compensation
        }
    }
    
    // MARK: - Chromatic Aberration
    
    /// Reconstructed Chromatic Aberration analysis and correction logic.
    /// Based on ApplyCA_SIMD patterns.
    /// Analyzes the color fringe near high-contrast edges and scales the R/B channels.
    public static func applyCA(r: inout [Float], g: inout [Float], b: inout [Float], count: Int, rScale: Float, bScale: Float) {
        // Simplified version: scaling the R and B channels relative to G (the anchor)
        // based on the analyzed CA shift.
        vDSP_vsmul(r, 1, [rScale], &r, 1, vDSP_Length(count))
        vDSP_vsmul(b, 1, [bScale], &b, 1, vDSP_Length(count))
    }
}
