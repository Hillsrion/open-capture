import Foundation
import CoreGraphics

/// Reconstructed Data Model for a single color balance adjustment (UI-003).
public struct ColorBalanceValue: Codable {
    public var hue: Double        // 0-360 degrees
    public var saturation: Double // 0-100%
    public var brightness: Double // -100 to 100
    
    public init(hue: Double = 0, saturation: Double = 0, brightness: Double = 0) {
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
    }
    
    public static let neutral = ColorBalanceValue()
}

/// Reconstructed Data Model for the full 3-Way Color Balance settings.
public struct ColorBalanceSettings: Codable {
    public var master: ColorBalanceValue
    public var shadow: ColorBalanceValue
    public var midtone: ColorBalanceValue
    public var highlight: ColorBalanceValue
    
    public init() {
        self.master = .neutral
        self.shadow = .neutral
        self.midtone = .neutral
        self.highlight = .neutral
    }
}

/// Reconstructed math for Color Wheel coordinate transformations.
public struct ColorWheelMath {
    
    /// Converts (Hue, Saturation) to (X, Y) normalized to a circle of radius 1.0.
    public static func polarToCartesian(hue: Double, saturation: Double) -> CGPoint {
        let radians = (hue - 90) * .pi / 180.0 // Offset by 90 to match UI (Red at top)
        let r = saturation / 100.0
        return CGPoint(x: r * cos(radians), y: r * sin(radians))
    }
    
    /// Converts (X, Y) relative to circle center to (Hue, Saturation).
    public static func cartesianToPolar(x: Double, y: Double) -> (hue: Double, saturation: Double) {
        let r = sqrt(x*x + y*y)
        let saturation = min(100.0, r * 100.0)
        
        var hue = atan2(y, x) * 180.0 / .pi + 90.0
        if hue < 0 { hue += 360.0 }
        
        return (hue, saturation)
    }
}
