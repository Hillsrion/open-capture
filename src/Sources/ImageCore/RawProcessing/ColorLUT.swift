import Foundation
import CoreImage
import CoreGraphics
import Metal

internal struct ColorLUT {
    let dimension: Int
    let data: Data
    let texture: MTLTexture?
    
    init(dimension: Int, data: Data, texture: MTLTexture? = nil) {
        self.dimension = dimension
        self.data = data
        self.texture = texture
    }
}

internal struct ComputeLUTParams {
    struct ColorBalanceValue {
        var hue: Float
        var saturation: Float
        var brightness: Float
        
        init(_ val: ImageCore.ColorBalanceValue) {
            self.hue = Float(val.hue)
            self.saturation = Float(val.saturation)
            self.brightness = Float(val.brightness)
        }
    }
    
    var exposure: Float
    var contrast: Float
    var brightness: Float
    var saturation: Float
    
    var shadow: ColorBalanceValue
    var midtone: ColorBalanceValue
    var highlight: ColorBalanceValue
    var master: ColorBalanceValue
    
    init(settings: IC_ProcessSettings) {
        self.exposure = settings.exposure
        self.contrast = settings.contrast
        self.brightness = settings.brightness
        self.saturation = settings.saturation
        self.shadow = ColorBalanceValue(settings.colorBalance.shadow)
        self.midtone = ColorBalanceValue(settings.colorBalance.midtone)
        self.highlight = ColorBalanceValue(settings.colorBalance.highlight)
        self.master = ColorBalanceValue(settings.colorBalance.master)
    }
}

internal struct LUTKey: Hashable {
    let exposure: Float
    let contrast: Float
    let brightness: Float
    let saturation: Float
    let colorBalance: ColorBalanceSettings
    let curveX: ICCurve
    let curveR: ICCurve
    let curveG: ICCurve
    let curveB: ICCurve
    let curveL: ICCurve
    let colorCorrectionList: IC_ColorCorrectionList
    
    init(settings: IC_ProcessSettings) {
        self.exposure = settings.exposure
        self.contrast = settings.contrast
        self.brightness = settings.brightness
        self.saturation = settings.saturation
        self.colorBalance = settings.colorBalance
        self.curveX = settings.gradationCurves.curveX
        self.curveR = settings.gradationCurves.curveR
        self.curveG = settings.gradationCurves.curveG
        self.curveB = settings.gradationCurves.curveB
        self.curveL = settings.gradationCurves.curveL
        self.colorCorrectionList = settings.colorCorrectionList
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(exposure)
        hasher.combine(contrast)
        hasher.combine(brightness)
        hasher.combine(saturation)
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
    
    func execute(input: CIImage, settings: IC_ProcessSettings, parameters: SImageOperationAllParameters) -> CIImage {
        let lut = ComputeLUTCache.shared.lut(for: settings, parameters: parameters)
        filter.setValue(input, forKey: kCIInputImageKey)
        filter.setValue(lut.dimension, forKey: "inputCubeDimension")
        filter.setValue(lut.data, forKey: "inputCubeData")
        return filter.outputImage ?? input
    }
}

/// Cache for ComputeLUT results keyed by settings + quality + viewport.
internal final class ComputeLUTCache {
    struct Key: Hashable {
        let lutKey: LUTKey
        let quality: IC_ProcessQuality
        let viewportBucket: Int
    }
    
    private struct Entry {
        let lut: ColorLUT
        let timestamp: Date
        var lastAccess: Date
        var accessCount: Int
    }

    static let shared = ComputeLUTCache()
    
    private let builder = ColorLUTBuilder()
    private let metalBuilder = MetalColorLUTBuilder()
    private let queue = DispatchQueue(label: "ImageCore.ComputeLUTCache")
    private var entries: [Key: Entry] = [:]
    private var lru: [Key] = []
    private let maxItems: Int
    private let ttl: TimeInterval = 600 // 10 minutes
    
    init(maxItems: Int = 32) {
        self.maxItems = maxItems
    }
    
    func lut(for settings: IC_ProcessSettings, parameters: SImageOperationAllParameters) -> ColorLUT {
        let key = Key(lutKey: LUTKey(settings: settings),
                      quality: parameters.quality,
                      viewportBucket: viewportBucket(for: parameters.viewport, settings: settings))
        if let cached = queue.sync(execute: { () -> ColorLUT? in
            if let entry = entries[key] {
                if Date().timeIntervalSince(entry.timestamp) > ttl {
                    entries.removeValue(forKey: key)
                    if let index = lru.firstIndex(of: key) {
                        lru.remove(at: index)
                    }
                    return nil
                }
                touch(key)
                return entry.lut
            }
            return nil
        }) {
            return cached
        }
        
        let lut: ColorLUT
        if let metalLUT = metalBuilder?.build(settings: settings) {
            lut = metalLUT
        } else {
            lut = builder.build(settings: settings)
        }
        
        queue.sync {
            let now = Date()
            entries[key] = Entry(lut: lut, timestamp: now, lastAccess: now, accessCount: 1)
            touch(key)
            enforceLimits()
        }
        return lut
    }
    
    private func viewportBucket(for rect: CGRect?, settings: IC_ProcessSettings) -> Int {
        guard let rect = rect, !isGlobalOnly(settings: settings) else { return 0 }
        
        // Round to 5% increments
        let rx = Int((rect.origin.x * 20).rounded())
        let ry = Int((rect.origin.y * 20).rounded())
        let rw = Int((rect.size.width * 20).rounded())
        let rh = Int((rect.size.height * 20).rounded())
        
        var hasher = Hasher()
        hasher.combine(rx)
        hasher.combine(ry)
        hasher.combine(rw)
        hasher.combine(rh)
        return hasher.finalize()
    }

    private func isGlobalOnly(settings: IC_ProcessSettings) -> Bool {
        // A LUT is viewport-dependent if it contains local color corrections
        // or if there are visible local adjustment layers
        let hasLocalCorrections = settings.colorCorrectionList.corrections.prefix(Int(settings.colorCorrectionList.count)).contains { $0.isLocal }
        let hasVisibleLayers = settings.localAdjustments.contains { $0.isVisible && $0.opacity > 0 }
        return !hasLocalCorrections && !hasVisibleLayers
    }
    
    private func touch(_ key: Key) {
        if let index = lru.firstIndex(of: key) {
            lru.remove(at: index)
        }
        lru.append(key)
        entries[key]?.lastAccess = Date()
        entries[key]?.accessCount += 1
    }
    
    private func enforceLimits() {
        let now = Date()
        // TTL Check
        let expiredKeys = entries.filter { now.timeIntervalSince($0.value.timestamp) > ttl }.map { $0.key }
        for key in expiredKeys {
            entries.removeValue(forKey: key)
            if let index = lru.firstIndex(of: key) {
                lru.remove(at: index)
            }
        }

        // LRU check
        while entries.count > maxItems, let oldest = lru.first {
            lru.removeFirst()
            entries.removeValue(forKey: oldest)
        }
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

internal final class MetalColorLUTBuilder {
    private let device: MTLDevice
    private let commandQueue: MTLCommandQueue
    private let pipelineState: MTLComputePipelineState
    private let dimension = 33
    
    init?() {
        guard let device = ImageCoreGPU.shared.device,
              let commandQueue = ImageCoreGPU.shared.commandQueue else { return nil }
        self.device = device
        self.commandQueue = commandQueue
        
        // Load default library for our custom kernel
        let library = device.makeDefaultLibrary()
        guard let function = library?.makeFunction(name: "compute_3d_lut") else {
            print("[MetalColorLUTBuilder] Failed to find kernel compute_3d_lut")
            return nil
        }
        do {
            self.pipelineState = try device.makeComputePipelineState(function: function)
        } catch {
            print("[MetalColorLUTBuilder] Pipeline setup failed: \(error)")
            return nil
        }
    }
    
    func build(settings: IC_ProcessSettings) -> ColorLUT? {
        let params = ComputeLUTParams(settings: settings)
        
        guard let outTexture = create3DTexture(),
              let curveX = createCurveTexture(CurvesKernels.generateLUT(from: settings.gradationCurves.curveX.points, count: Int(settings.gradationCurves.curveX.count))),
              let curveL = createCurveTexture(CurvesKernels.generateLUT(from: settings.gradationCurves.curveL.points, count: Int(settings.gradationCurves.curveL.count))),
              let curveR = createCurveTexture(CurvesKernels.generateLUT(from: settings.gradationCurves.curveR.points, count: Int(settings.gradationCurves.curveR.count))),
              let curveG = createCurveTexture(CurvesKernels.generateLUT(from: settings.gradationCurves.curveG.points, count: Int(settings.gradationCurves.curveG.count))),
              let curveB = createCurveTexture(CurvesKernels.generateLUT(from: settings.gradationCurves.curveB.points, count: Int(settings.gradationCurves.curveB.count))),
              let commandBuffer = commandQueue.makeCommandBuffer(),
              let encoder = commandBuffer.makeComputeCommandEncoder() else {
            return nil
        }
        
        encoder.setComputePipelineState(pipelineState)
        encoder.setTexture(outTexture, index: 0)
        
        var paramsCopy = params
        encoder.setBytes(&paramsCopy, length: MemoryLayout<ComputeLUTParams>.size, index: 0)
        
        encoder.setTexture(curveX, index: 1)
        encoder.setTexture(curveL, index: 2)
        encoder.setTexture(curveR, index: 3)
        encoder.setTexture(curveG, index: 4)
        encoder.setTexture(curveB, index: 5)
        
        let threadgroupSize = MTLSize(width: 8, height: 8, depth: 8)
        let threadgroups = MTLSize(width: (dimension + threadgroupSize.width - 1) / threadgroupSize.width,
                                   height: (dimension + threadgroupSize.height - 1) / threadgroupSize.height,
                                   depth: (dimension + threadgroupSize.depth - 1) / threadgroupSize.depth)
        
        encoder.dispatchThreadgroups(threadgroups, threadsPerThreadgroup: threadgroupSize)
        encoder.endEncoding()
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
        
        return readBack(texture: outTexture)
    }
    
    private func create3DTexture() -> MTLTexture? {
        let desc = MTLTextureDescriptor()
        desc.textureType = .type3D
        desc.pixelFormat = .rgba32Float
        desc.width = dimension
        desc.height = dimension
        desc.depth = dimension
        desc.usage = [.shaderWrite, .shaderRead]
        return device.makeTexture(descriptor: desc)
    }
    
    private func createCurveTexture(_ data: [Float]) -> MTLTexture? {
        guard !data.isEmpty else { return nil }
        let desc = MTLTextureDescriptor()
        desc.textureType = .type1D
        desc.pixelFormat = .r32Float
        desc.width = data.count
        desc.height = 1
        desc.depth = 1
        desc.usage = [.shaderRead]
        guard let texture = device.makeTexture(descriptor: desc) else { return nil }
        texture.replace(region: MTLRegionMake1D(0, data.count), mipmapLevel: 0, withBytes: data, bytesPerRow: data.count * 4)
        return texture
    }
    
    private func readBack(texture: MTLTexture) -> ColorLUT? {
        var cubeData = [Float](repeating: 0, count: dimension * dimension * dimension * 4)
        
        texture.getBytes(&cubeData,
                         bytesPerRow: dimension * 4 * MemoryLayout<Float>.size,
                         bytesPerImage: dimension * dimension * 4 * MemoryLayout<Float>.size,
                         from: MTLRegionMake3D(0, 0, 0, dimension, dimension, dimension),
                         mipmapLevel: 0,
                         slice: 0)
        
        let data = cubeData.withUnsafeBufferPointer { buffer in
            Data(buffer: buffer)
        }
        
        return ColorLUT(dimension: dimension, data: data, texture: texture)
    }
}
