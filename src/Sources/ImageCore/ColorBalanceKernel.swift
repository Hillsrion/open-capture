import Foundation

public enum ColorBalanceKernel {
    public static func isNeutral(_ settings: ColorBalanceSettings) -> Bool {
        settings == ColorBalanceSettings()
    }

    public static func apply(to red: inout [Float], green: inout [Float], blue: inout [Float], settings: ColorBalanceSettings) {
        guard red.count == green.count, green.count == blue.count else {
            return
        }

        for index in red.indices {
            apply(value: settings.master, weight: 1.0, red: &red[index], green: &green[index], blue: &blue[index])

            let luminance = ((red[index] + green[index] + blue[index]) / 3.0).clamped(to: 0...1)
            let weights = tonalWeights(for: luminance)
            apply(value: settings.shadow, weight: weights.shadow, red: &red[index], green: &green[index], blue: &blue[index])
            apply(value: settings.midtone, weight: weights.midtone, red: &red[index], green: &green[index], blue: &blue[index])
            apply(value: settings.highlight, weight: weights.highlight, red: &red[index], green: &green[index], blue: &blue[index])
        }
    }

    public static func tonalWeights(for luminance: Float) -> (shadow: Float, midtone: Float, highlight: Float) {
        let shadow = max(0, min(1, (0.55 - luminance) / 0.55))
        let highlight = max(0, min(1, (luminance - 0.45) / 0.55))
        let midtone = max(0, 1 - abs(luminance - 0.5) * 2.2)
        return (shadow, midtone, highlight)
    }

    private static func apply(value: ColorBalanceValue, weight: Float, red: inout Float, green: inout Float, blue: inout Float) {
        guard weight > 0 else {
            return
        }

        let sat = Float(value.saturation / 100.0)
        let lightness = Float(value.brightness / 100.0)
        let vector = hueVector(for: Float(value.hue))
        let chromaScale: Float = 0.18 * sat * weight
        let lightnessScale: Float = 0.14 * lightness * weight

        red = (red + vector.r * chromaScale + lightnessScale).clamped(to: 0...1)
        green = (green + vector.g * chromaScale + lightnessScale).clamped(to: 0...1)
        blue = (blue + vector.b * chromaScale + lightnessScale).clamped(to: 0...1)
    }

    private static func hueVector(for hue: Float) -> (r: Float, g: Float, b: Float) {
        let normalized = ((hue.truncatingRemainder(dividingBy: 360)) + 360).truncatingRemainder(dividingBy: 360) / 60
        let sector = Int(normalized)
        let fraction = normalized - Float(sector)

        let p: Float = 0
        let q: Float = 1 - fraction
        let t: Float = fraction

        let rgb: (Float, Float, Float)
        switch sector {
        case 0: rgb = (1, t, p)
        case 1: rgb = (q, 1, p)
        case 2: rgb = (p, 1, t)
        case 3: rgb = (p, q, 1)
        case 4: rgb = (t, p, 1)
        default: rgb = (1, p, q)
        }

        return (
            (rgb.0 - 0.5) * 2,
            (rgb.1 - 0.5) * 2,
            (rgb.2 - 0.5) * 2
        )
    }
}

private extension Float {
    func clamped(to range: ClosedRange<Float>) -> Float {
        min(range.upperBound, max(range.lowerBound, self))
    }
}
