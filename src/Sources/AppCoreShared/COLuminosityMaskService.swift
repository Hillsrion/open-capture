import Foundation
import ImageCore

/// Service for calculating luminosity-based masks (Luma Range).
/// Ported from UI-204/GAP-401 specifications.
public class COLuminosityMaskService {
    
    public struct LumaRangeSettings {
        public var rangeMin: Double
        public var rangeMax: Double
        public var falloffMin: Double
        public var falloffMax: Double
        public var radius: Double
        public var sensitivity: Double
        
        public init(rangeMin: Double = 0, rangeMax: Double = 255, falloffMin: Double = 0, falloffMax: Double = 255, radius: Double = 5, sensitivity: Double = 50) {
            self.rangeMin = rangeMin
            self.rangeMax = rangeMax
            self.falloffMin = falloffMin
            self.falloffMax = falloffMax
            self.radius = radius
            self.sensitivity = sensitivity
        }
    }
    
    /// Generates a grayscale mask from luminance data.
    /// Luminance data is expected to be in 0.0...1.0 range.
    /// Settings are in 0...255 range.
    public static func generateMask(fromLuminance luminance: [Float], settings: LumaRangeSettings) -> [Float] {
        let count = luminance.count
        var mask = [Float](repeating: 0.0, count: count)
        
        let fMin = Float(settings.falloffMin / 255.0)
        let rMin = Float(settings.rangeMin / 255.0)
        let rMax = Float(settings.rangeMax / 255.0)
        let fMax = Float(settings.falloffMax / 255.0)
        
        for i in 0..<count {
            let luma = luminance[i]
            
            if luma < fMin || luma > fMax {
                mask[i] = 0.0
            } else if luma >= rMin && luma <= rMax {
                mask[i] = 1.0
            } else if luma < rMin {
                // Fade in from fMin to rMin
                let denominator = rMin - fMin
                if denominator > 0 {
                    mask[i] = (luma - fMin) / denominator
                } else {
                    mask[i] = 1.0
                }
            } else if luma > rMax {
                // Fade out from rMax to fMax
                let denominator = fMax - rMax
                if denominator > 0 {
                    mask[i] = 1.0 - (luma - rMax) / denominator
                } else {
                    mask[i] = 1.0
                }
            }
        }
        
        // In a full implementation, we would apply radius/sensitivity refinement here.
        // For now, we apply a simple box blur or stub it as per instruction.
        if settings.radius > 0 {
            // ApplyRadiusSmoothing(&mask, radius: settings.radius)
        }
        
        return mask
    }
}
