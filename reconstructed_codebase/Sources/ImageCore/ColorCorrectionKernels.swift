import Foundation
import Accelerate

/// Reconstructed Color Correction Kernels for ImageCore.
/// Simulates the Advanced Color Editor (Hue, Saturation, Lightness targeting).

public struct ColorCorrectionKernels {
    
    /// Reconstructed logic for converting RGB to HSL.
    public static func rgbToHsl(r: Float, g: Float, b: Float) -> (h: Float, s: Float, l: Float) {
        let maxV = max(r, max(g, b))
        let minV = min(r, min(g, b))
        let delta = maxV - minV
        
        var h: Float = 0.0
        var s: Float = 0.0
        let l: Float = (maxV + minV) / 2.0
        
        if delta > 0.0001 {
            s = l > 0.5 ? delta / (2.0 - maxV - minV) : delta / (maxV + minV)
            
            if maxV == r {
                h = (g - b) / delta + (g < b ? 6.0 : 0.0)
            } else if maxV == g {
                h = (b - r) / delta + 2.0
            } else {
                h = (r - g) / delta + 4.0
            }
            h /= 6.0
        }
        
        return (h, s, l)
    }
    
    /// Reconstructed logic for converting HSL to RGB.
    public static func hslToRgb(h: Float, s: Float, l: Float) -> (r: Float, g: Float, b: Float) {
        if s == 0 {
            return (l, l, l)
        }
        
        let q = l < 0.5 ? l * (1.0 + s) : l + s - l * s
        let p = 2.0 * l - q
        
        func hueToRgb(t1: Float, t2: Float, t3: Float) -> Float {
            var t = t3
            if t < 0 { t += 1.0 }
            if t > 1 { t -= 1.0 }
            if t < 1.0/6.0 { return t1 + (t2 - t1) * 6.0 * t }
            if t < 1.0/2.0 { return t2 }
            if t < 2.0/3.0 { return t1 + (t2 - t1) * (2.0/3.0 - t) * 6.0 }
            return t1
        }
        
        let r = hueToRgb(t1: p, t2: q, t3: h + 1.0/3.0)
        let g = hueToRgb(t1: p, t2: q, t3: h)
        let b = hueToRgb(t1: p, t2: q, t3: h - 1.0/3.0)
        
        return (r, g, b)
    }
    
    /// Reconstructed logic for applying a list of color corrections to an RGB buffer.
    public static func applyCorrections(_ list: IC_ColorCorrectionList, toR: UnsafeMutablePointer<Float>, toG: UnsafeMutablePointer<Float>, toB: UnsafeMutablePointer<Float>, count: Int) {
        guard list.count > 0 else { return }
        let numCorrections = Int(list.count)
        
        for i in 0..<count {
            var r = toR[i]
            var g = toG[i]
            var b = toB[i]
            
            for j in 0..<numCorrections {
                let corr = list.corrections[j]
                
                // 1. Convert to HSL
                var (h, s, l) = rgbToHsl(r: r, g: g, b: b)
                
                // 2. Check if color falls within wedge (simplified hue check)
                // In reality, this requires checking hue wrapping and saturation bounds
                var inRange = false
                let hueWrapped = h
                if corr.lowHue < corr.highHue {
                    inRange = (hueWrapped >= corr.lowHue && hueWrapped <= corr.highHue)
                } else {
                    // Spans across 0/1 boundary
                    inRange = (hueWrapped >= corr.lowHue || hueWrapped <= corr.highHue)
                }
                
                if inRange && s >= corr.lowSaturation && s <= corr.highSaturation {
                    // Apply smoothness falloff (simulated as linear here)
                    let weight: Float = 1.0 
                    
                    // 3. Apply shifts
                    h += (corr.hueRotation / 360.0) * weight
                    if h > 1.0 { h -= 1.0 }
                    if h < 0.0 { h += 1.0 }
                    
                    s += (corr.saturationChange / 100.0) * weight
                    s = max(0.0, min(1.0, s))
                    
                    l += (corr.lightnessChange / 100.0) * weight
                    l = max(0.0, min(1.0, l))
                    
                    // Note: Homogeneity (Skin Tone) logic goes here in a full implementation.
                    // It pulls the current HSL towards the target deviceRGB HSL based on homogeneity sliders.
                }
                
                // 4. Convert back
                (r, g, b) = hslToRgb(h: h, s: s, l: l)
            }
            
            toR[i] = r
            toG[i] = g
            toB[i] = b
        }
    }
}
