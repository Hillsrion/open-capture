import Foundation
import CoreImage

internal final class ICCInputOperation: ImageOperation {
    func execute(input: CIImage, settings: IC_ProcessSettings, parameters: SImageOperationAllParameters) -> CIImage {
        guard let profileID = settings.inputProfileID,
              let colorSpace = ICCManager.shared.profile(for: profileID)?.colorSpace else { return input }
        return input.matchedToColorSpace(colorSpace) ?? input
    }
}

internal final class ICCOutputOperation: ImageOperation {
    func execute(input: CIImage, settings: IC_ProcessSettings, parameters: SImageOperationAllParameters) -> CIImage {
        guard let profileID = settings.outputProfileID,
              let colorSpace = ICCManager.shared.profile(for: profileID)?.colorSpace else { return input }
        return input.matchedToColorSpace(colorSpace) ?? input
    }
}

internal struct ToneCurvePreset {
    let p0: CGPoint
    let p1: CGPoint
    let p2: CGPoint
    let p3: CGPoint
    let p4: CGPoint
}

internal enum FilmCurvePresets {
    static func preset(for id: String) -> ToneCurvePreset {
        switch id.lowercased() {
        case "linear":
            return ToneCurvePreset(p0: CGPoint(x: 0.0, y: 0.0),
                                   p1: CGPoint(x: 0.25, y: 0.25),
                                   p2: CGPoint(x: 0.5, y: 0.5),
                                   p3: CGPoint(x: 0.75, y: 0.75),
                                   p4: CGPoint(x: 1.0, y: 1.0))
        case "filmstandard", "film":
            return ToneCurvePreset(p0: CGPoint(x: 0.0, y: 0.0),
                                   p1: CGPoint(x: 0.22, y: 0.18),
                                   p2: CGPoint(x: 0.5, y: 0.52),
                                   p3: CGPoint(x: 0.78, y: 0.86),
                                   p4: CGPoint(x: 1.0, y: 1.0))
        case "filmc-contrast", "highcontrast":
            return ToneCurvePreset(p0: CGPoint(x: 0.0, y: 0.0),
                                   p1: CGPoint(x: 0.2, y: 0.12),
                                   p2: CGPoint(x: 0.5, y: 0.55),
                                   p3: CGPoint(x: 0.8, y: 0.9),
                                   p4: CGPoint(x: 1.0, y: 1.0))
        default:
            return ToneCurvePreset(p0: CGPoint(x: 0.0, y: 0.0),
                                   p1: CGPoint(x: 0.2, y: 0.18),
                                   p2: CGPoint(x: 0.5, y: 0.5),
                                   p3: CGPoint(x: 0.8, y: 0.84),
                                   p4: CGPoint(x: 1.0, y: 1.0))
        }
    }
}

internal final class FilmCurveOperation: ImageOperation {
    private let filter = CIFilter(name: "CIToneCurve")!
    
    func execute(input: CIImage, settings: IC_ProcessSettings, parameters: SImageOperationAllParameters) -> CIImage {
        let preset = FilmCurvePresets.preset(for: settings.toneCurveID)
        filter.setValue(input, forKey: kCIInputImageKey)
        filter.setValue(CIVector(x: preset.p0.x, y: preset.p0.y), forKey: "inputPoint0")
        filter.setValue(CIVector(x: preset.p1.x, y: preset.p1.y), forKey: "inputPoint1")
        filter.setValue(CIVector(x: preset.p2.x, y: preset.p2.y), forKey: "inputPoint2")
        filter.setValue(CIVector(x: preset.p3.x, y: preset.p3.y), forKey: "inputPoint3")
        filter.setValue(CIVector(x: preset.p4.x, y: preset.p4.y), forKey: "inputPoint4")
        return filter.outputImage ?? input
    }
}

internal final class HDROperation: ImageOperation {
    private let filter = CIFilter(name: "CIHighlightShadowAdjust")!

    func execute(input: CIImage, settings: IC_ProcessSettings, parameters: SImageOperationAllParameters) -> CIImage {
        filter.setValue(input, forKey: kCIInputImageKey)
        let shadow = clamp01(settings.hdr.shadows / 100.0)
        let highlight = clamp01(1.0 - settings.hdr.highlights / 100.0)
        filter.setValue(shadow, forKey: "inputShadowAmount")
        filter.setValue(highlight, forKey: "inputHighlightAmount")
        return filter.outputImage ?? input
    }

    private func clamp01(_ value: Float) -> Float {
        max(0.0, min(1.0, value))
    }
}
internal final class NoiseReductionOperation: ImageOperation {
    private let filter = CIFilter(name: "CINoiseReduction")!
    
    func execute(input: CIImage, settings: IC_ProcessSettings, parameters: SImageOperationAllParameters) -> CIImage {
        filter.setValue(input, forKey: kCIInputImageKey)
        let luminance = max(0.0, min(1.0, settings.noiseReduction.luminance / 100.0))
        let detail = max(0.0, min(1.0, settings.noiseReduction.details / 100.0))
        filter.setValue(luminance, forKey: "inputNoiseLevel")
        filter.setValue(detail, forKey: "inputSharpness")
        return filter.outputImage ?? input
    }
}

internal final class SharpenOperation: ImageOperation {
    private let filter = CIFilter(name: "CISharpenLuminance")!
    
    func execute(input: CIImage, settings: IC_ProcessSettings, parameters: SImageOperationAllParameters) -> CIImage {
        filter.setValue(input, forKey: kCIInputImageKey)
        let amount = max(0.0, min(2.0, settings.sharpening.amount / 100.0))
        filter.setValue(amount, forKey: "inputSharpness")
        return filter.outputImage ?? input
    }
}
