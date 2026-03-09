import Foundation
import Accelerate

/// Reconstructed LCC Profile for ImageCore.
/// Stores light falloff and color cast data extracted from a calibration image.
/// Based on CLCCData patterns in ImageCore.
public struct IC_LCCProfile {
    public let cameraModel: String
    public let size: CGSize
    public let uniformityMap: [Float]
    
    public var hasUniformityData: Bool {
        return !uniformityMap.isEmpty
    }
    
    public init(cameraModel: String, size: CGSize, uniformityMap: [Float]) {
        self.cameraModel = cameraModel
        self.size = size
        self.uniformityMap = uniformityMap
    }
}

/// Reconstructed LCC Analysis and Application for ImageCore.
/// Based on disassembly of LccAnalysis::GenerateLensCastCorrection and CImgOpApplyLCC.
public class LCCManager {
    public static let shared = LCCManager()
    
    public init() {}
    
    /// Reconstructed logic for LccAnalysis::GenerateLensCastCorrection.
    public func generateLensCastCorrection(from buffer: UnsafePointer<Float>, size: CGSize, input: RawImageRep) -> IC_LCCProfile {
        let pixelCount = Int(size.width * size.height)
        
        // 1. Analyze the buffer (FillLCCData patterns)
        var maxBrightness: Float = 0.0
        vDSP_maxv(buffer, 1, &maxBrightness, vDSP_Length(pixelCount))
        
        // 2. Generate gain map
        var uniformityMap = [Float](repeating: 1.0, count: pixelCount)
        if maxBrightness > 0 {
            for i in 0..<pixelCount {
                // Avoid division by zero and handle clipped areas
                let val = max(1e-6, buffer[i])
                uniformityMap[i] = maxBrightness / val
            }
        }
        
        return IC_LCCProfile(cameraModel: input.cameraModel, size: size, uniformityMap: uniformityMap)
    }
    
    /// Reconstructed logic for CImgOpApplyLCC::SetParameters and Apply.
    public func apply(profile: IC_LCCProfile, to buffer: inout [Float], count: Int) {
        guard profile.hasUniformityData else { return }
        let minCount = min(count, profile.uniformityMap.count)
        vDSP_vmul(buffer, 1, profile.uniformityMap, 1, &buffer, 1, vDSP_Length(minCount))
    }
}
