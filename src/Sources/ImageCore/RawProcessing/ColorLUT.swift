import Foundation
import CoreImage

internal struct ColorLUT {
    let dimension: Int
    let data: Data
}

internal struct LUTKey: Hashable {
    let colorBalance: ColorBalanceSettings
    let curveX: ICCurve
    let curveR: ICCurve
    let curveG: ICCurve
    let curveB: ICCurve
    let curveL: ICCurve
    let colorCorrectionList: IC_ColorCorrectionList
    
    init(settings: IC_ProcessSettings) {
        self.colorBalance = settings.colorBalance
        self.curveX = settings.gradationCurves.curveX
        self.curveR = settings.gradationCurves.curveR
        self.curveG = settings.gradationCurves.curveG
        self.curveB = settings.gradationCurves.curveB
        self.curveL = settings.gradationCurves.curveL
        self.colorCorrectionList = settings.colorCorrectionList
    }
    
    func hash(into hasher: inout Hasher) {
        hashColorBalance(colorBalance, into: &hasher)
        hashCurve(curveX, into: &hasher)
        hashCurve(curveR, into: &hasher)
        hashCurve(curveG, into: &hasher)
        hashCurve(curveB, into: &hasher)
        hashCurve(curveL, into: &hasher)
        hashColorCorrectionList(colorCorrectionList, into: &hasher)
    }
    
    static func == (lhs: LUTKey, rhs: LUTKey) -> Bool {
        var lh = Hasher()
        lhs.hash(into: &lh)
        var rh = Hasher()
        rhs.hash(into: &rh)
        return lh.finalize() == rh.finalize()
    }
    
    private func hashColorBalance(_ balance: ColorBalanceSettings, into hasher: inout Hasher) {
        hashColorBalanceValue(balance.shadow, into: &hasher)
        hashColorBalanceValue(balance.midtone, into: &hasher)
        hashColorBalanceValue(balance.highlight, into: &hasher)
        hashColorBalanceValue(balance.master, into: &hasher)
    }
    
    private func hashColorBalanceValue(_ value: ColorBalanceValue, into hasher: inout Hasher) {
        hasher.combine(value.hue)
        hasher.combine(value.saturation)
        hasher.combine(value.brightness)
    }
    
    private func hashCurve(_ curve: ICCurve, into hasher: inout Hasher) {
        hasher.combine(curve.count)
        for index in 0..<Int(curve.count) {
            let point = curve.points[index]
            hasher.combine(point.x.bitPattern)
            hasher.combine(point.y.bitPattern)
        }
    }
    
    private func hashColorCorrectionList(_ list: IC_ColorCorrectionList, into hasher: inout Hasher) {
        hasher.combine(list.count)
        let count = Int(list.count)
        guard count > 0 else { return }
        for index in 0..<count {
            let corr = list.corrections[index]
            hasher.combine(corr.hueRotation.bitPattern)
            hasher.combine(corr.saturationChange.bitPattern)
            hasher.combine(corr.lightnessChange.bitPattern)
            hasher.combine(corr.red.bitPattern)
            hasher.combine(corr.green.bitPattern)
            hasher.combine(corr.blue.bitPattern)
            hasher.combine(corr.lowHue.bitPattern)
            hasher.combine(corr.highHue.bitPattern)
            hasher.combine(corr.lowSaturation.bitPattern)
            hasher.combine(corr.highSaturation.bitPattern)
            hasher.combine(corr.smoothness.bitPattern)
            hasher.combine(corr.homogeneityHue.bitPattern)
            hasher.combine(corr.homogeneitySaturation.bitPattern)
            hasher.combine(corr.homogeneityLightness.bitPattern)
            hasher.combine(corr.pieType)
            hasher.combine(corr.isLocal)
            hasher.combine(corr.isInverted)
        }
    }
}

internal final class ColorLUTOperation: ImageOperation {
    private let filter = CIFilter(name: "CIColorCube")!
    private let builder = ColorLUTBuilder()
    private var cachedKey: LUTKey?
    private var cachedLUT: ColorLUT?
    
    func execute(input: CIImage, settings: IC_ProcessSettings) -> CIImage {
        let key = LUTKey(settings: settings)
        if cachedKey != key || cachedLUT == nil {
            cachedLUT = builder.build(settings: settings)
            cachedKey = key
        }
        
        guard let lut = cachedLUT else { return input }
        filter.setValue(input, forKey: kCIInputImageKey)
        filter.setValue(lut.dimension, forKey: "inputCubeDimension")
        filter.setValue(lut.data, forKey: "inputCubeData")
        return filter.outputImage ?? input
    }
}

internal final class ColorLUTBuilder {
    private let dimension = 33
    
    func build(settings: IC_ProcessSettings) -> ColorLUT {
        let size = dimension * dimension * dimension * 4
        var cubeData = [Float](repeating: 0, count: size)
        
        let curveX = CurvesKernels.generateLUT(from: settings.gradationCurves.curveX.points,
                                               count: Int(settings.gradationCurves.curveX.count))
        let curveL = CurvesKernels.generateLUT(from: settings.gradationCurves.curveL.points,
                                               count: Int(settings.gradationCurves.curveL.count))
        let curveR = CurvesKernels.generateLUT(from: settings.gradationCurves.curveR.points,
                                               count: Int(settings.gradationCurves.curveR.count))
        let curveG = CurvesKernels.generateLUT(from: settings.gradationCurves.curveG.points,
                                               count: Int(settings.gradationCurves.curveG.count))
        let curveB = CurvesKernels.generateLUT(from: settings.gradationCurves.curveB.points,
                                               count: Int(settings.gradationCurves.curveB.count))
        
        var index = 0
        for b in 0..<dimension {
            for g in 0..<dimension {
                for r in 0..<dimension {
                    var rf = Float(r) / Float(dimension - 1)
                    var gf = Float(g) / Float(dimension - 1)
                    var bf = Float(b) / Float(dimension - 1)
                    
                    applyColorBalance(settings.colorBalance, r: &rf, g: &gf, b: &bf)
                    applyCurves(curveX: curveX, curveL: curveL, curveR: curveR, curveG: curveG, curveB: curveB, r: &rf, g: &gf, b: &bf)
                    applyColorCorrections(settings.colorCorrectionList, r: &rf, g: &gf, b: &bf)
                    
                    cubeData[index] = clamp(rf)
                    cubeData[index + 1] = clamp(gf)
                    cubeData[index + 2] = clamp(bf)
                    cubeData[index + 3] = 1.0
                    index += 4
                }
            }
        }
        
        let data = cubeData.withUnsafeBufferPointer { buffer in
            Data(buffer: buffer)
        }
        
        return ColorLUT(dimension: dimension, data: data)
    }
    
    private func applyColorBalance(_ settings: ColorBalanceSettings, r: inout Float, g: inout Float, b: inout Float) {
        var rr = r
        var gg = g
        var bb = b
        AdjustmentKernels.applyColorBalance(r: &rr, g: &gg, b: &bb, count: 1, settings: settings)
        r = rr; g = gg; b = bb
    }
    
    private func applyCurves(curveX: [Float], curveL: [Float], curveR: [Float], curveG: [Float], curveB: [Float], r: inout Float, g: inout Float, b: inout Float) {
        r = sampleCurve(curveX, value: r)
        g = sampleCurve(curveX, value: g)
        b = sampleCurve(curveX, value: b)

        let luma = 0.299 * r + 0.587 * g + 0.114 * b
        let mappedLuma = sampleCurve(curveL, value: luma)
        if luma > 0.0001 {
            let scale = mappedLuma / luma
            r *= scale; g *= scale; b *= scale
        } else {
            r = mappedLuma; g = mappedLuma; b = mappedLuma
        }
        
        r = sampleCurve(curveR, value: r)
        g = sampleCurve(curveG, value: g)
        b = sampleCurve(curveB, value: b)
    }
    
    private func applyColorCorrections(_ list: IC_ColorCorrectionList, r: inout Float, g: inout Float, b: inout Float) {
        guard list.count > 0 else { return }
        var rr = [r]
        var gg = [g]
        var bb = [b]
        rr.withUnsafeMutableBufferPointer { rPtr in
            gg.withUnsafeMutableBufferPointer { gPtr in
                bb.withUnsafeMutableBufferPointer { bPtr in
                    guard let rBase = rPtr.baseAddress,
                          let gBase = gPtr.baseAddress,
                          let bBase = bPtr.baseAddress else { return }
                    ColorCorrectionKernels.applyCorrections(list, toR: rBase, toG: gBase, toB: bBase, count: 1)
                }
            }
        }
        r = rr[0]; g = gg[0]; b = bb[0]
    }
    
    private func sampleCurve(_ lut: [Float], value: Float) -> Float {
        guard !lut.isEmpty else { return clamp(value) }
        let clamped = clamp(value)
        let maxIndex = Float(lut.count - 1)
        let pos = clamped * maxIndex
        let lower = Int(floor(pos))
        let upper = min(lower + 1, lut.count - 1)
        let t = pos - Float(lower)
        return lut[lower] + (lut[upper] - lut[lower]) * t
    }
    
    private func clamp(_ value: Float) -> Float {
        max(0.0, min(1.0, value))
    }
}
