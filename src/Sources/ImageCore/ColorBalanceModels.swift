import Foundation
import CoreGraphics

/// Reconstructed data model for a single color balance adjustment.
public struct ColorBalanceValue: Codable, Equatable {
    public var hue: Double
    public var saturation: Double
    public var brightness: Double

    public init(hue: Double = 0, saturation: Double = 0, brightness: Double = 0) {
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
    }

    public static let neutral = ColorBalanceValue()
}

/// Reconstructed data model for the full 3-way color balance settings.
public struct ColorBalanceSettings: Codable, Equatable {
    public var master: ColorBalanceValue
    public var shadow: ColorBalanceValue
    public var midtone: ColorBalanceValue
    public var highlight: ColorBalanceValue

    public init(
        master: ColorBalanceValue = .neutral,
        shadow: ColorBalanceValue = .neutral,
        midtone: ColorBalanceValue = .neutral,
        highlight: ColorBalanceValue = .neutral
    ) {
        self.master = master
        self.shadow = shadow
        self.midtone = midtone
        self.highlight = highlight
    }
}

/// Reconstructed math for color wheel coordinate transformations.
public enum ColorWheelMath {
    /// Converts hue/saturation to normalized cartesian coordinates.
    public static func polarToCartesian(hue: Double, saturation: Double) -> CGPoint {
        let radians = (hue - 90) * .pi / 180.0
        let radius = saturation / 100.0
        return CGPoint(x: radius * cos(radians), y: radius * sin(radians))
    }

    /// Converts normalized cartesian coordinates to hue/saturation.
    public static func cartesianToPolar(x: Double, y: Double) -> (hue: Double, saturation: Double) {
        let radius = min(1.0, sqrt(x * x + y * y))
        let saturation = radius * 100.0

        var hue = atan2(y, x) * 180.0 / .pi + 90.0
        if hue < 0 {
            hue += 360.0
        }

        return (hue, saturation)
    }
}
