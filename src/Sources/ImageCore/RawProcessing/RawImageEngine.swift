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
    public func developImage(at url: URL, with settings: IC_ProcessSettings, isLiveDrag: Bool = false) -> CIImage? {
        guard let resolvedPipeline = proxyCache.pipeline(for: url, context: context) { [weak self] in
            guard let self = self else { return nil }
            return self.loadSourceImage(from: url)
        } else {
            return createPlaceholderImage()
        }
        let output = resolvedPipeline.process(settings: settings, isLiveDrag: isLiveDrag)
        
        // 3. Return CIImage directly to avoid CPU Readback
        return output
    }
    
    /// Encapsulates a persistent CoreImage graph to avoid rebuilding CIFilters during 60fps drag events.
    /// Reconstructed to use a modular OperationChain architecture (C1 Secret Sauce parity).
    final class RenderPipeline {
        let sourceImage: CIImage
        private let context: CIContext
        private let processQueue = DispatchQueue(label: "ImageCore.RenderPipeline.process")
        private let chainBuilder = OperationChainBuilder()
        
        init(sourceImage: CIImage, context: CIContext) {
            self.sourceImage = sourceImage
            self.context = context
        }
        
        func process(settings: IC_ProcessSettings, isLiveDrag: Bool) -> CIImage {
            processQueue.sync {
                let quality: IC_ProcessQuality = isLiveDrag ? .display : .render
                let parameters = SImageOperationAllParameters(settings: settings,
                                                              quality: quality,
                                                              isInteractive: isLiveDrag)
                let chain = chainBuilder.buildChain(parameters)
                var output = sourceImage
                
                for operation in chain {
                    output = operation.execute(input: output, settings: settings)
                }
                
                return output
            }
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
    func execute(input: CIImage, settings: IC_ProcessSettings) -> CIImage
}

internal class ExposureOperation: ImageOperation {
    private let filter = CIFilter(name: "CIExposureAdjust")!
    func execute(input: CIImage, settings: IC_ProcessSettings) -> CIImage {
        filter.setValue(input, forKey: kCIInputImageKey)
        filter.setValue(settings.exposure, forKey: kCIInputEVKey)
        return filter.outputImage ?? input
    }
}

internal class WhiteBalanceOperation: ImageOperation {
    private let filter = CIFilter(name: "CITemperatureAndTint")!
    func execute(input: CIImage, settings: IC_ProcessSettings) -> CIImage {
        filter.setValue(input, forKey: kCIInputImageKey)
        let neutral = CIVector(x: 6500, y: 0)
        let target = CIVector(x: CGFloat(settings.kelvin), y: CGFloat(settings.tint))
        filter.setValue(neutral, forKey: "inputNeutral")
        filter.setValue(target, forKey: "inputTargetNeutral")
        return filter.outputImage ?? input
    }
}

internal class GeometryOperation: ImageOperation {
    func execute(input: CIImage, settings: IC_ProcessSettings) -> CIImage {
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
    func execute(input: CIImage, settings: IC_ProcessSettings) -> CIImage {
        filter.setValue(input, forKey: kCIInputImageKey)
        filter.setValue(1.0 + settings.saturation, forKey: kCIInputSaturationKey)
        filter.setValue(1.0 + settings.contrast, forKey: kCIInputContrastKey)
        return filter.outputImage ?? input
    }
}

internal class ColorGradingOperation: ImageOperation {
    private let filter = CIFilter(name: "CIColorMonochrome")!
    func execute(input: CIImage, settings: IC_ProcessSettings) -> CIImage {
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
    
    func execute(input: CIImage, settings: IC_ProcessSettings) -> CIImage {
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
    private let colorControls = ColorControlsOperation()
    private let colorGrading = ColorGradingOperation()
    private let colorLUT = ColorLUTOperation()
    private let localAdjustments = LocalAdjustmentsOperation()
    
    func buildChain(_ parameters: SImageOperationAllParameters) -> [ImageOperation] {
        let settings = parameters.settings
        var chain: [ImageOperation] = []
        
        if shouldApplyExposure(settings) { chain.append(exposure) }
        if shouldApplyWhiteBalance(settings) { chain.append(whiteBalance) }
        if shouldApplyGeometry(settings) { chain.append(geometry) }
        if shouldApplyColorControls(settings) { chain.append(colorControls) }
        
        if parameters.quality != .display {
            if shouldApplyColorLUT(settings) {
                chain.append(colorLUT)
            } else if shouldApplyColorGrading(settings) {
                chain.append(colorGrading)
            }
            if shouldApplyLocalAdjustments(settings) { chain.append(localAdjustments) }
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
