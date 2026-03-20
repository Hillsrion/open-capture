import Foundation
import ImageCore

/// Service for generating live preview images of masks.
/// Used during Luma Range, Refine Mask, and other masking operations.
public class COMaskPreviewGenerator {
    
    public enum PreviewMode {
        case grayscale
        case overlay(color: [Float]) // RGB
    }
    
    /// Generates a preview image (simulated as data) from mask values.
    public static func generatePreview(fromMask mask: [Float], mode: PreviewMode = .grayscale) -> [Float] {
        let count = mask.count
        var result = [Float](repeating: 0.0, count: count * 4) // RGBA
        
        for i in 0..<count {
            let alpha = mask[i]
            let idx = i * 4
            
            switch mode {
            case .grayscale:
                result[idx] = alpha     // R
                result[idx + 1] = alpha // G
                result[idx + 2] = alpha // B
                result[idx + 3] = 1.0   // A
            case .overlay(let color):
                result[idx] = color[0]   // R
                result[idx + 1] = color[1] // G
                result[idx + 2] = color[2] // B
                result[idx + 3] = alpha   // A (Mask controls transparency of overlay)
            }
        }
        
        return result
    }
}
