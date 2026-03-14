import Foundation
import CoreGraphics
import CoreImage
import Metal

/// Reconstructed RAW Rendering Engine (IMG-002).
/// Bridges IC_ProcessSettings to the actual GPU rendering pipeline.
public class RawImageEngine {
    
    public static let shared = RawImageEngine()
    private let context: CIContext
    
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
    public func developImage(at url: URL, with settings: IC_ProcessSettings) -> CGImage? {
        print("[Engine] Developing RAW: \(url.lastPathComponent)")
        
        // 1. RAW Loading (Simulation)
        // In original, this would use CRawImageRep to extract Bayer data
        guard let sourceImage = CIImage(contentsOf: url) ?? createPlaceholderImage() else {
            return nil
        }
        
        // 2. Apply Pipeline (Simplified parity with C1 pipeline)
        var output = sourceImage
        
        // A. Exposure & Contrast
        if let exposureFilter = CIFilter(name: "CIExposureAdjust") {
            exposureFilter.setValue(output, forKey: kCIInputImageKey)
            exposureFilter.setValue(settings.exposure, forKey: kCIInputEVKey)
            output = exposureFilter.outputImage ?? output
        }
        
        // B. White Balance (Kelvin/Tint simulation)
        if let wbFilter = CIFilter(name: "CITemperatureAndTint") {
            wbFilter.setValue(output, forKey: kCIInputImageKey)
            // C1 uses a complex matrix for Kelvin, here we approximate
            let neutral = CIVector(x: 6500, y: 0)
            let target = CIVector(x: CGFloat(settings.kelvin), y: CGFloat(settings.tint))
            wbFilter.setValue(neutral, forKey: "inputNeutral")
            wbFilter.setValue(target, forKey: "inputTargetNeutral")
            output = wbFilter.outputImage ?? output
        }
        
        // C. Saturation
        if let colorFilter = CIFilter(name: "CIColorControls") {
            colorFilter.setValue(output, forKey: kCIInputImageKey)
            colorFilter.setValue(1.0 + settings.saturation, forKey: kCIInputSaturationKey)
            colorFilter.setValue(1.0 + settings.contrast, forKey: kCIInputContrastKey)
            output = colorFilter.outputImage ?? output
        }
        
        // D. Color Balance (3-Way Grading simulation)
        // In high-fidelity mode, this calls AdjustmentKernels.applyColorBalance
        if settings.colorBalance != ColorBalanceSettings() {
            output = applyColorGradePass(to: output, settings: settings.colorBalance)
        }
        
        // 2.5 Local Adjustments Pipeline (LAY-001)
        // Mimics Capture One's layer stack (up to 16 layers)
        for layerCfg in settings.localAdjustments where layerCfg.isVisible && layerCfg.opacity > 0 {
            output = applyLayer(layerCfg, to: output, baseImage: sourceImage)
        }
        
        // 3. Render to Final Buffer
        return context.createCGImage(output, from: output.extent)
    }
    
    private func applyColorGradePass(to image: CIImage, settings: ColorBalanceSettings) -> CIImage {
        // Simulation: Apply tinting based on shadow/midtone/highlight teintes
        // In original, this is a per-pixel weighted calculation in Metal.
        var output = image
        
        if settings.midtone.saturation > 0 {
            // Apply a global tint simulation for midtones
            let radians = CGFloat(settings.midtone.hue - 90) * .pi / 180.0
            let strength = CGFloat(settings.midtone.saturation / 500.0) // Scaled for simulation
            
            let color = CIColor(red: 0.5 + cos(radians) * strength, 
                                green: 0.5 + sin(radians) * strength, 
                                blue: 0.5 - 0.5 * strength)
            
            if let filter = CIFilter(name: "CIColorMonochrome") {
                filter.setValue(output, forKey: kCIInputImageKey)
                filter.setValue(color, forKey: kCIInputColorKey)
                filter.setValue(strength, forKey: kCIInputIntensityKey)
                output = filter.outputImage?.composited(over: output) ?? output
            }
        }
        
        return output
    }
    
    /// Applies a local adjustment layer using masking and alpha blending.
    private func applyLayer(_ layer: IC_LocalAdjustCfg, to currentImage: CIImage, baseImage: CIImage) -> CIImage {
        // 1. Create the adjusted version of the image for this layer
        var layerAdjusted = currentImage
        let s = layer.settings
        
        // Apply local exposure
        if s.exposure != 0, let filter = CIFilter(name: "CIExposureAdjust") {
            filter.setValue(layerAdjusted, forKey: kCIInputImageKey)
            filter.setValue(s.exposure, forKey: kCIInputEVKey)
            layerAdjusted = filter.outputImage ?? layerAdjusted
        }
        
        // 2. Generate/Retrieve the Mask (Simulation)
        // In original, this would be a high-res grayscale buffer from IC_LocalAdjustCfg
        let mask: CIImage
        if let realData = layer.maskData {
            // NEW: Use real AI-generated mask data
            mask = createCIImage(from: realData, size: currentImage.extent.size)
        } else {
            // Fallback to simulated masks
            mask = createSimulationMask(for: layer.layerId, extent: currentImage.extent)
        }
        
        // 3. Blend using the mask and layer opacity
        if let blendFilter = CIFilter(name: "CIBlendWithAlphaMask") {
            blendFilter.setValue(layerAdjusted, forKey: kCIInputImageKey) // Foreground (Adjusted)
            blendFilter.setValue(currentImage, forKey: kCIInputBackgroundImageKey) // Background (Current)
            
            // Adjust mask intensity by layer opacity
            var alphaMask = mask
            if layer.opacity < 1.0, let opacityFilter = CIFilter(name: "CIColorControls") {
                opacityFilter.setValue(alphaMask, forKey: kCIInputImageKey)
                opacityFilter.setValue(layer.opacity, forKey: "inputBrightness") // Simplified opacity mapping
                alphaMask = opacityFilter.outputImage ?? alphaMask
            }
            
            blendFilter.setValue(alphaMask, forKey: kCIInputMaskImageKey)
            return blendFilter.outputImage ?? currentImage
        }
        
        return currentImage
    }
    
    private func createCIImage(from maskData: [Float], size: CGSize) -> CIImage {
        let width = Int(size.width)
        let height = Int(size.height)
        
        // Ensure data size matches expected extent (simplified check)
        guard maskData.count >= width * height else {
            return CIImage.empty()
        }
        
        let data = Data(bytes: maskData, count: maskData.count * MemoryLayout<Float>.size)
        return CIImage(bitmapData: data,
                       bytesPerRow: width * MemoryLayout<Float>.size,
                       size: size,
                       format: .f, // Float format for grayscale
                       colorSpace: nil)
    }
    
    private func createSimulationMask(for layerId: UInt32, extent: CGRect) -> CIImage {
        // Generates different dummy masks based on layer ID for visual testing
        if layerId % 2 == 0 {
            // Radial Gradient (Center)
            return CIFilter(name: "CIRadialGradient", parameters: [
                "inputCenter": CIVector(x: extent.midX, y: extent.midY),
                "inputRadius0": extent.width * 0.1,
                "inputRadius1": extent.width * 0.3,
                "inputColor0": CIColor.white,
                "inputColor1": CIColor.clear
            ])?.outputImage?.cropped(to: extent) ?? CIImage.empty()
        } else {
            // Linear Gradient (Top to Bottom)
            return CIFilter(name: "CILinearGradient", parameters: [
                "inputPoint0": CIVector(x: 0, y: extent.height),
                "inputPoint1": CIVector(x: 0, y: extent.height * 0.6),
                "inputColor0": CIColor.white,
                "inputColor1": CIColor.clear
            ])?.outputImage?.cropped(to: extent) ?? CIImage.empty()
        }
    }
    
    /// Placeholder for high-performance Metal rendering (C1 Parity).
    /// Used for real-time viewer updates.
    public func renderToMetal(texture: MTLTexture, settings: IC_ProcessSettings, commandBuffer: MTLCommandBuffer) {
        // This is where the custom Metal kernels from ImageProcessing.framework would be executed.
        // Logic: Apply Demosaic -> Lens Correction -> Color Match -> Curves -> Sharpen
        print("[Engine] High-speed Metal render pass requested.")
    }
    
    private func createPlaceholderImage() -> CIImage? {
        // Returns a neutral gray image if the RAW file can't be read in simulation
        let color = CIColor(red: 0.5, green: 0.5, blue: 0.5)
        return CIImage(color: color).cropped(to: CGRect(x: 0, y: 0, width: 1024, height: 1024))
    }
}
