import Foundation

/// Reconstructed White Balance mapping logic for ImageCore.
/// Based on disassembly of IC_KelvinTintToRGB and CRawImageRep patterns.

public struct WhiteBalanceKernels {
    
    /// Reconstructed Kelvin to RGB conversion.
    /// Uses a standard black-body radiation approximation (simplified for restoration).
    /// Formula: T -> (R, G, B)
    public static func kelvinToRGB(kelvin: Double, tint: Double) -> (r: Double, g: Double, b: Double) {
        // 1. Calculate base RGB from Kelvin (approximate Planckian locus)
        let temp = kelvin / 100.0
        var r, g, b: Double
        
        if temp <= 66 {
            r = 255
            g = 99.4708025861 * log(temp) - 161.1195681661
            if temp <= 19 {
                b = 0
            } else {
                b = 138.5177312231 * log(temp - 10) - 305.0447927307
            }
        } else {
            r = 329.698727446 * pow(temp - 60, -0.1332047592)
            g = 288.1221695283 * pow(temp - 60, -0.0755148492)
            b = 255
        }
        
        // 2. Apply Tint (Magenta/Green balance)
        // Inferred: Tint adds/removes Green relative to R and B
        let tintFactor = 1.0 + (tint / 100.0)
        g = g / tintFactor
        
        // Normalize to 0.0 - 1.0
        return (
            r: max(0, min(255, r)) / 255.0,
            g: max(0, min(255, g)) / 255.0,
            b: max(0, min(255, b)) / 255.0
        )
    }
}
