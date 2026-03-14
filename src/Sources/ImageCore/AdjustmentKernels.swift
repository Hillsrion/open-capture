import Foundation
import Accelerate

/// Reconstructed mathematical kernels for image adjustments in ImageCore.
/// Based on disassembly of CImgOpApplyExposure and CImgOpBrightness.

public struct AdjustmentKernels {
    
    // MARK: - Exposure
    
    /// Reconstructed Exposure adjustment logic.
    /// Formula inferred: Output = Input * 2^EV
    public static func applyExposure(to buffer: UnsafeMutablePointer<Float>, count: Int, ev: Float) {
        let gain = pow(2.0, ev)
        var multiplier = gain
        vDSP_vsmul(buffer, 1, &multiplier, buffer, 1, vDSP_Length(count))
    }
    
    // MARK: - Contrast
    
    /// Reconstructed Contrast adjustment logic.
    /// Based on ApplyContrast_SIMD patterns.
    /// Formula inferred: Output = (Input - 0.5) * Contrast + 0.5 + Brightness
    public static func applyContrast(to buffer: UnsafeMutablePointer<Float>, count: Int, contrast: Float, brightness: Float) {
        var pivot: Float = -0.5
        var contrastVal = contrast
        var offset: Float = 0.5 + brightness
        
        // 1. Input - 0.5
        vDSP_vsadd(buffer, 1, &pivot, buffer, 1, vDSP_Length(count))
        // 2. Multiply by Contrast
        vDSP_vsmul(buffer, 1, &contrastVal, buffer, 1, vDSP_Length(count))
        // 3. Add offset (0.5 + brightness)
        vDSP_vsadd(buffer, 1, &offset, buffer, 1, vDSP_Length(count))
    }
    
    // MARK: - Saturation
    
    /// Reconstructed Saturation adjustment logic.
    /// Uses luminance preservation (Luma = 0.299R + 0.587G + 0.114B)
    public static func applySaturation(r: UnsafeMutablePointer<Float>, g: UnsafeMutablePointer<Float>, b: UnsafeMutablePointer<Float>, count: Int, saturation: Float) {
        for i in 0..<count {
            let luma = 0.299 * r[i] + 0.587 * g[i] + 0.114 * b[i]
            r[i] = luma + (r[i] - luma) * saturation
            g[i] = luma + (g[i] - luma) * saturation
            b[i] = luma + (b[i] - luma) * saturation
        }
    }
    
    // MARK: - Color Balance (3-Way Grading)
    
    /// Applies 3-way color balance (Shadows, Midtones, Highlights).
    /// Mimics C1's high-fidelity color grading algorithm.
    public static func applyColorBalance(r: UnsafeMutablePointer<Float>, g: UnsafeMutablePointer<Float>, b: UnsafeMutablePointer<Float>, count: Int, settings: ColorBalanceSettings) {
        for i in 0..<count {
            let luma = 0.299 * r[i] + 0.587 * g[i] + 0.114 * b[i]
            
            // 1. Calculate weights for each region
            let shadowWeight = pow(max(0, 1.0 - luma), 2.0)
            let highlightWeight = pow(max(0, luma), 2.0)
            let midtoneWeight = 1.0 - shadowWeight - highlightWeight
            
            // 2. Apply adjustments per region
            applyRegionAdjustment(r: &r[i], g: &g[i], b: &b[i], weight: shadowWeight, val: settings.shadow)
            applyRegionAdjustment(r: &r[i], g: &g[i], b: &b[i], weight: midtoneWeight, val: settings.midtone)
            applyRegionAdjustment(r: &r[i], g: &g[i], b: &b[i], weight: highlightWeight, val: settings.highlight)
        }
    }
    
    private static func applyRegionAdjustment(r: inout Float, g: inout Float, b: inout Float, weight: Float, val: ColorBalanceValue) {
        guard weight > 0 else { return }
        
        // Convert polar (Hue/Sat) to RGB offset
        let radians = Float(val.hue - 90) * .pi / 180.0
        let strength = Float(val.saturation / 100.0) * weight
        
        let dr = cos(radians) * strength
        let dg = sin(radians) * strength
        let db = -0.5 * strength // Simplified luminance-preserving blue offset
        
        r += dr
        g += dg
        b += db
        
        // Apply brightness/luminance
        let brightShift = Float(val.brightness / 100.0) * weight
        r += brightShift
        g += brightShift
        b += brightShift
    }
}

/// Bridge to original Capture One Metal Compute Kernels (IMG-GPU-001).
public struct NativeAdjustmentKernels {
    
    /// Applies original Capture One Film Grain.
    /// Uses one of the 10 passes discovered in captureone.metallib.
    public static func applyFilmGrain(input: MTLBuffer, output: MTLBuffer, size: CGSize, type: Int) {
        let kernelName = "Grains_PASS_ID\(min(max(type, 0), 9))"
        let threads = MTLSize(width: Int(size.width), height: Int(size.height), depth: 1)
        
        ImageCoreGPU.shared.dispatchKernel(name: kernelName, inputs: [input], output: output, threads: threads)
    }
    
    /// Applies high-quality resampling using EWA Tensor kernel.
    public static func resample(input: MTLBuffer, output: MTLBuffer, targetSize: CGSize) {
        let kernelName = "Resample_EWA_TENSOR0_RADIUS5"
        let threads = MTLSize(width: Int(targetSize.width), height: Int(targetSize.height), depth: 1)
        
        ImageCoreGPU.shared.dispatchKernel(name: kernelName, inputs: [input], output: output, threads: threads)
    }
}
