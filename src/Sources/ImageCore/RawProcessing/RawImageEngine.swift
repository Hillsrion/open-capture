import Foundation
import CoreGraphics
import CoreImage
import Metal

/// Reconstructed RAW Rendering Engine (IMG-002).
/// Bridges IC_ProcessSettings to the actual GPU rendering pipeline.
public class RawImageEngine {
    
    public static let shared = RawImageEngine()
    private let context: CIContext
    
    // Proxy Cache: Stores the active RenderPipelines per URL to simulate C1's VRAM proxy architecture
    // Implemented as an LRU Cache to prevent VRAM/RAM leaks.
    private let maxCacheSize = 5
    private var activePipelines: [URL: RenderPipeline] = [:]
    private var lruList: [URL] = []
    
    private init() {
        // In original C1, this would be a Metal-backed context shared with the viewer
        if let device = MTLCreateSystemDefaultDevice() {
            self.context = CIContext(mtlDevice: device)
        } else {
            self.context = CIContext()
        }
    }
    
    /// Main entry point for developing a RAW image.
    /// Mimics the behavior of ImageProcessing.framework's development methods.
    public func developImage(at url: URL, with settings: IC_ProcessSettings, isLiveDrag: Bool = false) -> CIImage? {
        let pipeline: RenderPipeline
        
        if let existing = activePipelines[url] {
            pipeline = existing
            
            // Update LRU position
            if let index = lruList.firstIndex(of: url) {
                lruList.remove(at: index)
                lruList.append(url)
            }
        } else {
            print("[Engine] Loading RAW into Proxy Cache: \(url.lastPathComponent)")
            
            // 1. RAW Loading (Improved for CR3/Modern formats)
            guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else {
                print("[Engine] Failed to create ImageSource for \(url.path)")
                return createPlaceholderImage()
            }
            
            guard let extracted = extractSourceImage(from: source) else {
                print("[Engine] Failed to extract source image from \(url.lastPathComponent)")
                return createPlaceholderImage()
            }
            
            pipeline = RenderPipeline(sourceImage: extracted)
            
            // Evict oldest if cache is full
            if lruList.count >= maxCacheSize {
                let oldestUrl = lruList.removeFirst()
                activePipelines.removeValue(forKey: oldestUrl)
                print("[Engine] Evicted \(oldestUrl.lastPathComponent) from Proxy Cache (LRU)")
            }
            
            // Store in proxy cache to guarantee 30fps/60fps playback during slider drag
            activePipelines[url] = pipeline
            lruList.append(url)
        }
        
        let output = pipeline.process(settings: settings, isLiveDrag: isLiveDrag)
        
        // 3. Return CIImage directly to avoid CPU Readback
        return output
    }
    
    /// Encapsulates a persistent CoreImage graph to avoid rebuilding CIFilters during 60fps drag events
    private class RenderPipeline {
        let sourceImage: CIImage
        
        private let exposureFilter = CIFilter(name: "CIExposureAdjust")!
        private let wbFilter = CIFilter(name: "CITemperatureAndTint")!
        private let colorFilter = CIFilter(name: "CIColorControls")!
        private let midtoneTintFilter = CIFilter(name: "CIColorMonochrome")!
        private let layerBlendFilter = CIFilter(name: "CIBlendWithAlphaMask")!
        private let layerExposureFilter = CIFilter(name: "CIExposureAdjust")!
        private let layerOpacityFilter = CIFilter(name: "CIColorControls")!
        
        init(sourceImage: CIImage) {
            self.sourceImage = sourceImage
        }
        
        func process(settings: IC_ProcessSettings, isLiveDrag: Bool) -> CIImage {
            var output = sourceImage
            
            // --- Display Pipeline (Temps réel - 60fps) ---
            
            // A. Exposure & Contrast
            exposureFilter.setValue(output, forKey: kCIInputImageKey)
            exposureFilter.setValue(settings.exposure, forKey: kCIInputEVKey)
            output = exposureFilter.outputImage ?? output
            
            // B. White Balance (Kelvin/Tint simulation)
            wbFilter.setValue(output, forKey: kCIInputImageKey)
            let neutral = CIVector(x: 6500, y: 0)
            let target = CIVector(x: CGFloat(settings.kelvin), y: CGFloat(settings.tint))
            wbFilter.setValue(neutral, forKey: "inputNeutral")
            wbFilter.setValue(target, forKey: "inputTargetNeutral")
            output = wbFilter.outputImage ?? output
            
            // B.5 Flip & Rotation (UI-204 Parity)
            if settings.flipHorizontal {
                output = output.transformed(by: CGAffineTransform(scaleX: -1, y: 1).translatedBy(x: -output.extent.width, y: 0))
            }
            if settings.flipVertical {
                output = output.transformed(by: CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -output.extent.height))
            }
            
            // C. Saturation
            colorFilter.setValue(output, forKey: kCIInputImageKey)
            colorFilter.setValue(1.0 + settings.saturation, forKey: kCIInputSaturationKey)
            colorFilter.setValue(1.0 + settings.contrast, forKey: kCIInputContrastKey)
            output = colorFilter.outputImage ?? output
            
            // D. Color Balance (3-Way Grading simulation)
            if settings.colorBalance != ColorBalanceSettings() && settings.colorBalance.midtone.saturation > 0 {
                let radians = CGFloat(settings.colorBalance.midtone.hue - 90) * .pi / 180.0
                let strength = CGFloat(settings.colorBalance.midtone.saturation / 500.0) // Scaled for simulation
                let color = CIColor(red: 0.5 + cos(radians) * strength, 
                                    green: 0.5 + sin(radians) * strength, 
                                    blue: 0.5 - 0.5 * strength)
                
                midtoneTintFilter.setValue(output, forKey: kCIInputImageKey)
                midtoneTintFilter.setValue(color, forKey: kCIInputColorKey)
                midtoneTintFilter.setValue(strength, forKey: kCIInputIntensityKey)
                output = midtoneTintFilter.outputImage?.composited(over: output) ?? output
            }
            
            // --- Render Pipeline (Haute Fidélité) ---
            // Bypass heavy operations during live drag to guarantee 60fps
            if !isLiveDrag {
                // 2.5 Local Adjustments Pipeline (LAY-001)
                for layerCfg in settings.localAdjustments where layerCfg.isVisible && layerCfg.opacity > 0 {
                    output = applyLayer(layerCfg, to: output, baseImage: sourceImage)
                }
            }
            
            return output
        }
        
        /// Applies a local adjustment layer using masking and alpha blending.
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
            let width = Int(size.width)
            let height = Int(size.height)
            guard maskData.count >= width * height else { return CIImage.empty() }
            let data = Data(bytes: maskData, count: maskData.count * MemoryLayout<Float>.size)
            return CIImage(bitmapData: data,
                           bytesPerRow: width * MemoryLayout<Float>.size,
                           size: size,
                           format: .RGBAf,
                           colorSpace: nil)
        }
        
        private func createSimulationMask(for layerId: UInt32, extent: CGRect) -> CIImage {
            if layerId % 2 == 0 {
                return CIFilter(name: "CIRadialGradient", parameters: [
                    "inputCenter": CIVector(x: extent.midX, y: extent.midY),
                    "inputRadius0": extent.width * 0.1,
                    "inputRadius1": extent.width * 0.3,
                    "inputColor0": CIColor.white,
                    "inputColor1": CIColor.clear
                ])?.outputImage?.cropped(to: extent) ?? CIImage.empty()
            } else {
                return CIFilter(name: "CILinearGradient", parameters: [
                    "inputPoint0": CIVector(x: 0, y: extent.height),
                    "inputPoint1": CIVector(x: 0, y: extent.height * 0.6),
                    "inputColor0": CIColor.white,
                    "inputColor1": CIColor.clear
                ])?.outputImage?.cropped(to: extent) ?? CIImage.empty()
            }
        }
    }
    
    /// Placeholder for high-performance Metal rendering (C1 Parity).
    public func renderToMetal(texture: MTLTexture, settings: IC_ProcessSettings, commandBuffer: MTLCommandBuffer) {
        print("[Engine] High-speed Metal render pass requested.")
    }
    
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
    
    private func createPlaceholderImage() -> CIImage? {
        let color = CIColor(red: 0.2, green: 0.2, blue: 0.2)
        return CIImage(color: color).cropped(to: CGRect(x: 0, y: 0, width: 1024, height: 1024))
    }
}

