import Foundation
import Accelerate

/// Reconstructed Luma Range Engine.
public class LumaRangeEngine {
    public static let shared = LumaRangeEngine()
    
    private init() {}
    
    public func generateMask(from lumaBuffer: UnsafePointer<Float>, 
                             into mask: inout [Float], 
                             size: CGSize, 
                             rangeStart: Float, 
                             rangeEnd: Float, 
                             falloffStart: Float, 
                             falloffEnd: Float) {
        
        let pixelCount = Int(size.width * size.height)
        
        for i in 0..<pixelCount {
            // Assume luma values are 0.0 to 1.0, and ranges are 0 to 100
            let luma = lumaBuffer[i] * 100.0
            
            if luma >= rangeStart && luma <= rangeEnd {
                mask[i] = 1.0
            } else if luma >= (rangeStart - falloffStart) && luma < rangeStart {
                let diff = luma - (rangeStart - falloffStart)
                mask[i] = diff / max(falloffStart, 0.001)
            } else if luma > rangeEnd && luma <= (rangeEnd + falloffEnd) {
                let diff = (rangeEnd + falloffEnd) - luma
                mask[i] = diff / max(falloffEnd, 0.001)
            } else {
                mask[i] = 0.0
            }
        }
    }
}
