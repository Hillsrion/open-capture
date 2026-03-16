import Foundation
import CoreGraphics
import CoreImage
import Metal

/// Reconstructed RAW Rendering Engine (IMG-002).
/// Bridges IC_ProcessSettings to the actual GPU rendering pipeline.
public class RawImageEngine {
    
    public static let shared = RawImageEngine()
    private let context: CIContext
    private let proxyCache = ProxyCache()
    
    private init() {
        // In original C1, this would be a Metal-backed context shared with the viewer
        // Setting workingFormat to .RGBAh (16-bit float) to match C1's high-precision pipeline (IMG-002)
        let options: [CIContextOption: Any] = [
            .workingFormat: CIFormat.RGBAh,
            .workingColorSpace: CGColorSpaceCreateDeviceRGB(),
            .cacheIntermediates: false,
            .useSoftwareRenderer: false
        ]
        
        if let device = MTLCreateSystemDefaultDevice() {
            self.context = CIContext(mtlDevice: device, options: options)
        } else {
            self.context = CIContext(options: options)
        }
    }
    
    /// Main entry point for developing a RAW image.
    /// Mimics the behavior of ImageProcessing.framework's development methods.
    public func developImage(at url: URL,
                             with settings: IC_ProcessSettings,
                             isLiveDrag: Bool = false,
                             viewport: CGRect? = nil) -> CIImage? {
        guard let resolvedPipeline = proxyCache.pipeline(for: url, context: context, loader: { [weak self] in
            guard let self = self else { return nil }
            return self.loadSourceImage(from: url)
        }) else {
            return createPlaceholderImage()
        }
        let output = resolvedPipeline.process(settings: settings, isLiveDrag: isLiveDrag, viewport: viewport)
        
        // 3. Return CIImage directly to avoid CPU Readback
        return output
    }
    
    /// Encapsulates a persistent CoreImage graph to avoid rebuilding CIFilters during 60fps drag events.
    /// Reconstructed to use a modular OperationChain architecture (C1 Secret Sauce parity).
    final class RenderPipeline {
        let sourceImage: CIImage
        private let context: CIContext
        private let processQueue = DispatchQueue(label: "ImageCore.RenderPipeline.process")
        private let displayChainBuilder = OperationChainBuilder()
        private let renderChainBuilder = OperationChainBuilder()
        private let displayExecutor: TileGPUExecutor
        private let renderExecutor: TileGPUExecutor
        private var lastRenderImage: CIImage?
        private var displayBaseCache: (scale: CGFloat, sourceID: ObjectIdentifier, image: CIImage)?
        
        init(sourceImage: CIImage, context: CIContext) {
            self.sourceImage = sourceImage
            self.context = context
            self.displayExecutor = TileGPUExecutor(context: context)
            self.renderExecutor = TileGPUExecutor(context: context)
        }
        
        func process(settings: IC_ProcessSettings, isLiveDrag: Bool, viewport: CGRect?) -> CIImage {
            processQueue.sync {
                let quality: IC_ProcessQuality = isLiveDrag ? .display : .render
                let displayScale = isLiveDrag ? displayScaleFactor(for: viewport) : 1
                let canTile = canTileProcess(settings: settings, quality: quality)
                let chainBuilder = isLiveDrag ? displayChainBuilder : renderChainBuilder
                let parameters = SImageOperationAllParameters(settings: settings,
                                                              quality: quality,
                                                              isInteractive: isLiveDrag,
                                                              viewport: viewport)
                let chain = chainBuilder.buildChain(parameters)
                let operationKey = operationSignature(for: chain)
                
                // Input for the tiling pipeline (already scaled for display if needed)
                let sourceForTiles = displayScale < 1
                    ? sourceImage.transformed(by: CGAffineTransform(scaleX: displayScale, y: displayScale))
                    : sourceImage
                
                let applyChain: (CIImage) -> CIImage = { input in
                    var current = input
                    for operation in chain {
                        current = operation.execute(input: current, settings: settings, parameters: parameters)
                    }
                    return current
                }
                
                let extent = sourceForTiles.extent
                guard !extent.isEmpty, !extent.isNull else { return sourceForTiles }
                let overlap = Int(round(CGFloat(overlapPixels(for: settings)) * displayScale))
                let settingsKey = settingsCacheKey(for: settings, quality: quality, scale: displayScale, operationKey: operationKey)

                if isLiveDrag, let viewport,
                   let viewportPixels = pixelViewport(from: viewport, extent: extent) {
                    let base = displayBaseImage(scale: displayScale)
                    if canTile {
                        return displayExecutor.renderTiles(baseImage: base,
                                                           viewport: viewportPixels,
                                                           fullSize: extent.size,
                                                           overlap: overlap,
                                                           waitForCompletion: false,
                                                           cacheKey: settingsKey,
                                                           quality: quality,
                                                           scale: displayScale,
                                                           operationKey: operationKey,
                                                           tileProvider: { rect in
                            let tileInput = sourceForTiles.cropped(to: rect)
                            return applyChain(tileInput)
                        })
                    } else {
                        let fullProcessed = applyChain(sourceForTiles)
                        return displayExecutor.render(image: fullProcessed,
                                                      baseImage: base,
                                                      viewport: viewportPixels,
                                                      fullSize: extent.size,
                                                      overlap: overlap,
                                                      waitForCompletion: false,
                                                      cacheKey: settingsKey,
                                                      quality: quality,
                                                      scale: displayScale,
                                                      operationKey: operationKey)
                    }
                }

                // Non-interactive Render
                let finalImage: CIImage
                if canTile {
                    finalImage = renderExecutor.renderTiles(baseImage: nil,
                                                           viewport: nil,
                                                           fullSize: extent.size,
                                                           overlap: overlap,
                                                           cacheKey: settingsKey,
                                                           quality: quality,
                                                           scale: displayScale,
                                                           operationKey: operationKey,
                                                           tileProvider: { rect in
                        let tileInput = sourceForTiles.cropped(to: rect)
                        return applyChain(tileInput)
                    })
                } else {
                    let fullProcessed = applyChain(sourceForTiles)
                    finalImage = renderExecutor.render(image: fullProcessed,
                                                       baseImage: nil,
                                                       viewport: nil,
                                                       fullSize: extent.size,
                                                       overlap: overlap,
                                                       cacheKey: settingsKey,
                                                       quality: quality,
                                                       scale: displayScale,
                                                       operationKey: operationKey)
                }
                
                if !isLiveDrag {
                    lastRenderImage = finalImage
                    displayBaseCache = nil
                }
                return finalImage
            }
        }

        private func canTileProcess(settings: IC_ProcessSettings, quality: IC_ProcessQuality) -> Bool {
            // Supported for both .display and .render if no incompatible global transformations are active.
            if settings.flipHorizontal || settings.flipVertical {
                return false
            }
            return quality == .display || quality == .render
        }

        private func pixelViewport(from normalized: CGRect, extent: CGRect) -> CGRect? {
            let clampRect = CGRect(x: 0, y: 0, width: 1, height: 1)
            let clamped = normalized.intersection(clampRect)
            guard !clamped.isNull, clamped.width > 0, clamped.height > 0 else { return nil }
            let x = clamped.origin.x * extent.width
            let y = (CGFloat(1) - clamped.origin.y - clamped.height) * extent.height
            let width = clamped.width * extent.width
            let height = clamped.height * extent.height
            return CGRect(x: x, y: y, width: width, height: height)
        }

        private func overlapPixels(for settings: IC_ProcessSettings) -> Int {
            if settings.sharpening.amount > 0 { return 16 }
            if settings.noiseReduction.luminance > 0 || settings.noiseReduction.color > 0 { return 16 }
            if settings.noiseReduction.singlePixel > 0 || settings.noiseReduction.details > 0 { return 16 }
            if settings.clarity.amount != 0 { return 16 }
            if settings.filmGrain.amount != 0 { return 16 }
            if settings.localAdjustments.contains(where: { $0.settings.clarity.amount != 0 || $0.settings.moire.amount != 0 }) {
                return 16
            }
            return 0
        }
        
        private func operationSignature(for chain: [ImageOperation]) -> Int {
            var hasher = Hasher()
            for operation in chain {
                hasher.combine(ObjectIdentifier(type(of: operation)))
            }
            return hasher.finalize()
        }
        
        private func settingsCacheKey(for settings: IC_ProcessSettings,
                                      quality: IC_ProcessQuality,
                                      scale: CGFloat,
                                      operationKey: Int) -> Int {
            var hasher = Hasher()
            hasher.combine(Int(quality.rawValue))
            hasher.combine(Double(scale).bitPattern)
            hasher.combine(operationKey)
            hasher.combine(settings.exposure.bitPattern)
            hasher.combine(settings.contrast.bitPattern)
            hasher.combine(settings.brightness.bitPattern)
            hasher.combine(settings.saturation.bitPattern)
            hasher.combine(settings.kelvin.bitPattern)
            hasher.combine(settings.tint.bitPattern)
            hasher.combine(settings.flipHorizontal)
            hasher.combine(settings.flipVertical)
            hasher.combine(settings.hdr.highlights.bitPattern)
            hasher.combine(settings.hdr.shadows.bitPattern)
            hasher.combine(settings.hdr.whites.bitPattern)
            hasher.combine(settings.hdr.blacks.bitPattern)
            hasher.combine(settings.sharpening.amount.bitPattern)
            hasher.combine(settings.sharpening.radius.bitPattern)
            hasher.combine(settings.sharpening.threshold.bitPattern)
            hasher.combine(settings.noiseReduction.luminance.bitPattern)
            hasher.combine(settings.noiseReduction.color.bitPattern)
            hasher.combine(settings.noiseReduction.singlePixel.bitPattern)
            hasher.combine(settings.noiseReduction.details.bitPattern)
            hasher.combine(settings.clarity.amount.bitPattern)
            hasher.combine(settings.filmGrain.amount.bitPattern)
            hasher.combine(settings.filmGrain.size.bitPattern)
            hasher.combine(settings.colorBalance.shadow.hue.bitPattern)
            hasher.combine(settings.colorBalance.shadow.saturation.bitPattern)
            hasher.combine(settings.colorBalance.midtone.hue.bitPattern)
            hasher.combine(settings.colorBalance.midtone.saturation.bitPattern)
            hasher.combine(settings.colorBalance.highlight.hue.bitPattern)
            hasher.combine(settings.colorBalance.highlight.saturation.bitPattern)
            hasher.combine(settings.gradationCurves.curveX.points.count)
            hasher.combine(settings.gradationCurves.curveR.points.count)
            hasher.combine(settings.gradationCurves.curveG.points.count)
            hasher.combine(settings.gradationCurves.curveB.points.count)
            hasher.combine(settings.gradationCurves.curveL.points.count)
            hasher.combine(settings.colorCorrectionList.count)
            hasher.combine(settings.localAdjustments.count)
            for layer in settings.localAdjustments where layer.isVisible && layer.opacity > 0 {
                hasher.combine(layer.opacity.bitPattern)
                hasher.combine(layer.settings.exposure.bitPattern)
                hasher.combine(layer.settings.contrast.bitPattern)
                hasher.combine(layer.settings.brightness.bitPattern)
                hasher.combine(layer.settings.saturation.bitPattern)
                hasher.combine(layer.settings.kelvin.bitPattern)
                hasher.combine(layer.settings.clarity.amount.bitPattern)
                hasher.combine(layer.settings.moire.amount.bitPattern)
                if let mask = layer.maskData {
                    hasher.combine(mask.count)
                }
            }
            return hasher.finalize()
        }

        private func displayScaleFactor(for viewport: CGRect?) -> CGFloat {
            guard let viewport else { return 1 }
            let clamped = viewport.intersection(CGRect(x: 0, y: 0, width: 1, height: 1))
            guard !clamped.isNull, clamped.width > 0, clamped.height > 0 else { return 1 }
            let area = clamped.width * clamped.height
            if area >= CGFloat(0.64) { return 0.5 }
            if area >= CGFloat(0.36) { return 0.66 }
            if area >= CGFloat(0.16) { return 0.75 }
            return 1
        }

        private func displayBaseImage(scale: CGFloat) -> CIImage? {
            guard let base = lastRenderImage else { return nil }
            if scale >= 1 { return base }
            let sourceID = ObjectIdentifier(base)
            if let cached = displayBaseCache,
               cached.scale == scale,
               cached.sourceID == sourceID {
                return cached.image
            }
            let scaled = base.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
            displayBaseCache = (scale: scale, sourceID: sourceID, image: scaled)
            return scaled
        }
    }
    
    // MARK: - Internal Helpers
    
    private func extractSourceImage(from source: CGImageSource) -> CIImage? {
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: 4096,
            kCGImageSourceShouldCache: true
        ]
        for index in 0...1 {
            if let cgImage = CGImageSourceCreateThumbnailAtIndex(source, index, options as CFDictionary) {
                print("[Engine] Successfully extracted image at index \(index)")
                return CIImage(cgImage: cgImage)
            }
        }
        return nil
    }
    
    private func loadSourceImage(from url: URL) -> CIImage? {
        print("[Engine] Loading RAW into Proxy Cache: \(url.lastPathComponent)")
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else {
            print("[Engine] Failed to create ImageSource for \(url.path)")
            return nil
        }
        guard let extracted = extractSourceImage(from: source) else {
            print("[Engine] Failed to extract source image from \(url.lastPathComponent)")
            return nil
        }
        return extracted
    }
    
    private func createPlaceholderImage() -> CIImage? {
        let color = CIColor(red: 0.2, green: 0.2, blue: 0.2)
        return CIImage(color: color).cropped(to: CGRect(x: 0, y: 0, width: 1024, height: 1024))
    }
}

// MARK: - Operation Chain Infrastructure

internal protocol ImageOperation {
    func execute(input: CIImage, settings: IC_ProcessSettings, parameters: SImageOperationAllParameters) -> CIImage
}

internal class ExposureOperation: ImageOperation {
    private let filter = CIFilter(name: "CIExposureAdjust")!
    func execute(input: CIImage, settings: IC_ProcessSettings, parameters: SImageOperationAllParameters) -> CIImage {
        filter.setValue(input, forKey: kCIInputImageKey)
        filter.setValue(settings.exposure, forKey: kCIInputEVKey)
        return filter.outputImage ?? input
    }
}

internal class WhiteBalanceOperation: ImageOperation {
    private let filter = CIFilter(name: "CITemperatureAndTint")!
    func execute(input: CIImage, settings: IC_ProcessSettings, parameters: SImageOperationAllParameters) -> CIImage {
        filter.setValue(input, forKey: kCIInputImageKey)
        let neutral = CIVector(x: 6500, y: 0)
        let target = CIVector(x: CGFloat(settings.kelvin), y: CGFloat(settings.tint))
        filter.setValue(neutral, forKey: "inputNeutral")
        filter.setValue(target, forKey: "inputTargetNeutral")
        return filter.outputImage ?? input
    }
}

internal class GeometryOperation: ImageOperation {
    func execute(input: CIImage, settings: IC_ProcessSettings, parameters: SImageOperationAllParameters) -> CIImage {
        var output = input
        if settings.flipHorizontal {
            output = output.transformed(by: CGAffineTransform(scaleX: -1, y: 1).translatedBy(x: -output.extent.width, y: 0))
        }
        if settings.flipVertical {
            output = output.transformed(by: CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -output.extent.height))
        }
        return output
    }
}

internal class ColorControlsOperation: ImageOperation {
    private let filter = CIFilter(name: "CIColorControls")!
    func execute(input: CIImage, settings: IC_ProcessSettings, parameters: SImageOperationAllParameters) -> CIImage {
        filter.setValue(input, forKey: kCIInputImageKey)
        filter.setValue(1.0 + settings.saturation, forKey: kCIInputSaturationKey)
        filter.setValue(1.0 + settings.contrast, forKey: kCIInputContrastKey)
        return filter.outputImage ?? input
    }
}

internal class ColorGradingOperation: ImageOperation {
    private let filter = CIFilter(name: "CIColorMonochrome")!
    func execute(input: CIImage, settings: IC_ProcessSettings, parameters: SImageOperationAllParameters) -> CIImage {
        guard settings.colorBalance != ColorBalanceSettings() && settings.colorBalance.midtone.saturation > 0 else { return input }
        
        let radians = CGFloat(settings.colorBalance.midtone.hue - 90) * .pi / 180.0
        let strength = CGFloat(settings.colorBalance.midtone.saturation / 500.0)
        let color = CIColor(red: 0.5 + cos(radians) * strength, 
                            green: 0.5 + sin(radians) * strength, 
                            blue: 0.5 - 0.5 * strength)
        
        filter.setValue(input, forKey: kCIInputImageKey)
        filter.setValue(color, forKey: kCIInputColorKey)
        filter.setValue(strength, forKey: kCIInputIntensityKey)
        return filter.outputImage?.composited(over: input) ?? input
    }
}

internal class LocalAdjustmentsOperation: ImageOperation {
    private let layerBlendFilter = CIFilter(name: "CIBlendWithAlphaMask")!
    private let layerExposureFilter = CIFilter(name: "CIExposureAdjust")!
    private let layerOpacityFilter = CIFilter(name: "CIColorControls")!
    
    func execute(input: CIImage, settings: IC_ProcessSettings, parameters: SImageOperationAllParameters) -> CIImage {
        var output = input
        for layerCfg in settings.localAdjustments where layerCfg.isVisible && layerCfg.opacity > 0 {
            output = applyLayer(layerCfg, to: output, baseImage: input)
        }
        return output
    }
    
    private func applyLayer(_ layer: IC_LocalAdjustCfg, to currentImage: CIImage, baseImage: CIImage) -> CIImage {
        var layerAdjusted = currentImage
        let s = layer.settings
        
        if s.exposure != 0 {
            layerExposureFilter.setValue(layerAdjusted, forKey: kCIInputImageKey)
            layerExposureFilter.setValue(s.exposure, forKey: kCIInputEVKey)
            layerAdjusted = layerExposureFilter.outputImage ?? layerAdjusted
        }
        
        let mask: CIImage
        if let realData = layer.maskData {
            mask = createCIImage(from: realData, size: currentImage.extent.size)
        } else {
            mask = createSimulationMask(for: layer.layerId, extent: currentImage.extent)
        }
        
        layerBlendFilter.setValue(layerAdjusted, forKey: kCIInputImageKey)
        layerBlendFilter.setValue(currentImage, forKey: kCIInputBackgroundImageKey)
        
        var alphaMask = mask
        if layer.opacity < 1.0 {
            layerOpacityFilter.setValue(alphaMask, forKey: kCIInputImageKey)
            layerOpacityFilter.setValue(layer.opacity, forKey: "inputBrightness")
            alphaMask = layerOpacityFilter.outputImage ?? alphaMask
        }
        
        layerBlendFilter.setValue(alphaMask, forKey: kCIInputMaskImageKey)
        return layerBlendFilter.outputImage ?? currentImage
    }
    
    private func createCIImage(from maskData: [Float], size: CGSize) -> CIImage {
        let width = Int(size.width); let height = Int(size.height)
        guard maskData.count >= width * height else { return CIImage.empty() }
        let data = Data(bytes: maskData, count: maskData.count * MemoryLayout<Float>.size)
        return CIImage(bitmapData: data, bytesPerRow: width * MemoryLayout<Float>.size, size: size, format: .RGBAf, colorSpace: nil)
    }
    
    private func createSimulationMask(for layerId: UInt32, extent: CGRect) -> CIImage {
        if layerId % 2 == 0 {
            return CIFilter(name: "CIRadialGradient", parameters: [
                "inputCenter": CIVector(x: extent.midX, y: extent.midY),
                "inputRadius0": extent.width * 0.1, "inputRadius1": extent.width * 0.3,
                "inputColor0": CIColor.white, "inputColor1": CIColor.clear
            ])?.outputImage?.cropped(to: extent) ?? CIImage.empty()
        } else {
            return CIFilter(name: "CILinearGradient", parameters: [
                "inputPoint0": CIVector(x: 0, y: extent.height), "inputPoint1": CIVector(x: 0, y: extent.height * 0.6),
                "inputColor0": CIColor.white, "inputColor1": CIColor.clear
            ])?.outputImage?.cropped(to: extent) ?? CIImage.empty()
        }
    }
}

// MARK: - Dynamic OperationChain Builder

internal final class OperationChainBuilder {
    private let exposure = ExposureOperation()
    private let whiteBalance = WhiteBalanceOperation()
    private let geometry = GeometryOperation()
    private let iccInput = ICCInputOperation()
    private let filmCurve = FilmCurveOperation()
    private let colorControls = ColorControlsOperation()
    private let colorGrading = ColorGradingOperation()
    private let colorLUT = ColorLUTOperation()
    private let hdrOperation = HDROperation()
    private let noiseReduction = NoiseReductionOperation()
    private let sharpen = SharpenOperation()
    private let localAdjustments = LocalAdjustmentsOperation()
    private let iccOutput = ICCOutputOperation()
    
    func buildChain(_ parameters: SImageOperationAllParameters) -> [ImageOperation] {
        let settings = parameters.settings
        var chain: [ImageOperation] = []
        
        if shouldApplyExposure(settings) { chain.append(exposure) }
        if shouldApplyWhiteBalance(settings) { chain.append(whiteBalance) }
        if shouldApplyICCInput(settings) { chain.append(iccInput) }
        if shouldApplyFilmCurve(settings) { chain.append(filmCurve) }
        if shouldApplyGeometry(settings) { chain.append(geometry) }
        if shouldApplyColorControls(settings) { chain.append(colorControls) }
        
        if parameters.quality != .display {
            if shouldApplyColorLUT(settings) {
                chain.append(colorLUT)
            } else if shouldApplyColorGrading(settings) {
                chain.append(colorGrading)
            }
            if shouldApplyHDR(settings) { chain.append(hdrOperation) }
            if shouldApplyNoiseReduction(settings) { chain.append(noiseReduction) }
            if shouldApplySharpen(settings) { chain.append(sharpen) }
            if shouldApplyLocalAdjustments(settings) { chain.append(localAdjustments) }
            if shouldApplyICCOutput(settings) { chain.append(iccOutput) }
        }
        
        return chain
    }
    
    private func shouldApplyExposure(_ settings: IC_ProcessSettings) -> Bool {
        settings.exposure != 0
    }
    
    private func shouldApplyWhiteBalance(_ settings: IC_ProcessSettings) -> Bool {
        settings.kelvin != 5000.0 || settings.tint != 0.0
    }
    
    private func shouldApplyGeometry(_ settings: IC_ProcessSettings) -> Bool {
        settings.flipHorizontal || settings.flipVertical
    }
    
    private func shouldApplyColorControls(_ settings: IC_ProcessSettings) -> Bool {
        settings.saturation != 0 || settings.contrast != 0
    }
    
    private func shouldApplyColorGrading(_ settings: IC_ProcessSettings) -> Bool {
        settings.colorBalance != ColorBalanceSettings()
    }
    
    private func shouldApplyColorLUT(_ settings: IC_ProcessSettings) -> Bool {
        if settings.colorBalance != ColorBalanceSettings() { return true }
        if settings.colorCorrectionList.count > 0 { return true }
        if settings.gradationCurves.curveX.count > 1 { return true }
        if settings.gradationCurves.curveL.count > 1 { return true }
        if settings.gradationCurves.curveR.count > 1 { return true }
        if settings.gradationCurves.curveG.count > 1 { return true }
        if settings.gradationCurves.curveB.count > 1 { return true }
        return false
    }
    
    private func shouldApplyICCInput(_ settings: IC_ProcessSettings) -> Bool {
        settings.inputProfileID != nil
    }
    
    private func shouldApplyICCOutput(_ settings: IC_ProcessSettings) -> Bool {
        settings.outputProfileID != nil
    }
    
    private func shouldApplyFilmCurve(_ settings: IC_ProcessSettings) -> Bool {
        settings.toneCurveID.lowercased() != "linear"
    }
    
    private func shouldApplyHDR(_ settings: IC_ProcessSettings) -> Bool {
        settings.hdr.highlights != 0 || settings.hdr.shadows != 0 || settings.hdr.whites != 0 || settings.hdr.blacks != 0
    }
    
    private func shouldApplyNoiseReduction(_ settings: IC_ProcessSettings) -> Bool {
        settings.noiseReduction.luminance > 0 || settings.noiseReduction.color > 0 || settings.noiseReduction.singlePixel > 0
    }
    
    private func shouldApplySharpen(_ settings: IC_ProcessSettings) -> Bool {
        settings.sharpening.amount > 0
    }
    
    private func shouldApplyLocalAdjustments(_ settings: IC_ProcessSettings) -> Bool {
        settings.localAdjustments.contains { layer in
            guard layer.isVisible, layer.opacity > 0 else { return false }
            if layer.maskData != nil { return true }
            if layer.settings.exposure != 0 { return true }
            if layer.settings.contrast != 0 { return true }
            if layer.settings.brightness != 0 { return true }
            if layer.settings.saturation != 0 { return true }
            if layer.settings.kelvin != 0 { return true }
            if layer.settings.clarity.amount != 0 { return true }
            if layer.settings.moire.amount != 0 { return true }
            return false
        }
    }
}
