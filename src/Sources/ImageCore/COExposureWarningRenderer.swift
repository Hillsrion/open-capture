import Foundation
import AppKit

/// Reconstructed high-fidelity Exposure Warning Renderer (IMG-008).
/// Responsible for analyzing pixel values and generating clipping masks.
public final class COExposureWarningRenderer {
    public static let shared = COExposureWarningRenderer()
    
    private init() {}
    
    /// Generates a clipping mask for highlights and shadows.
    /// This is a simplified CPU-based version of the original Metal kernel.
    public func generateClippingMask(for image: NSImage, highlightThreshold: Double, shadowThreshold: Double, highlightColor: NSColor, shadowColor: NSColor, showShadows: Bool = false) -> NSImage? {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return nil }
        
        let width = cgImage.width
        let height = cgImage.height
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo) else { return nil }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
        
        guard let pixelData = context.data else { return nil }
        let data = pixelData.bindMemory(to: UInt8.self, capacity: width * height * 4)
        
        // Output context for the mask
        guard let maskContext = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo) else { return nil }
        let maskData = maskContext.data!.bindMemory(to: UInt8.self, capacity: width * height * 4)
        
        // Highlight color components
        let hR = UInt8(highlightColor.redComponent * 255)
        let hG = UInt8(highlightColor.greenComponent * 255)
        let hB = UInt8(highlightColor.blueComponent * 255)
        let hA = UInt8(highlightColor.alphaComponent * 255)
        
        // Shadow color components
        let sR = UInt8(shadowColor.redComponent * 255)
        let sG = UInt8(shadowColor.greenComponent * 255)
        let sB = UInt8(shadowColor.blueComponent * 255)
        let sA = UInt8(shadowColor.alphaComponent * 255)

        for i in 0..<(width * height) {
            let offset = i * 4
            let b = data[offset]
            let g = data[offset + 1]
            let r = data[offset + 2]
            
            // Luma calculation (simplified Rec. 709)
            let luma = Double(r) * 0.2126 + Double(g) * 0.7152 + Double(b) * 0.0722
            
            if luma >= highlightThreshold {
                maskData[offset] = hB
                maskData[offset + 1] = hG
                maskData[offset + 2] = hR
                maskData[offset + 3] = hA
            } else if showShadows && luma <= shadowThreshold {
                maskData[offset] = sB
                maskData[offset + 1] = sG
                maskData[offset + 2] = sR
                maskData[offset + 3] = sA
            } else {
                maskData[offset] = 0
                maskData[offset + 1] = 0
                maskData[offset + 2] = 0
                maskData[offset + 3] = 0
            }
        }
        
        guard let maskCGImage = maskContext.makeImage() else { return nil }
        return NSImage(cgImage: maskCGImage, size: image.size)
    }
}
