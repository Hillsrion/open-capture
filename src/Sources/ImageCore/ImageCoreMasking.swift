import Foundation
import Accelerate

/// Reconstructed Mask representation for ImageCore.
/// Based on disassembly of CImgOpApplyMask.

public class ICMask {
    public let uuid: String
    public let size: CGSize
    public var buffer: UnsafeMutablePointer<UInt8>
    
    public init(uuid: String, size: CGSize) {
        self.uuid = uuid
        self.size = size
        let count = Int(size.width * size.height)
        self.buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: count)
        self.buffer.initialize(repeating: 0, count: count)
    }
    
    deinit {
        buffer.deallocate()
    }
    
    /// Reconstructed logic for clearing a mask.
    public func clear() {
        let count = Int(size.width * size.height)
        memset(buffer, 0, count)
    }
    
    /// Reconstructed logic for filling a mask (100% opacity).
    public func fill() {
        let count = Int(size.width * size.height)
        memset(buffer, 255, count)
    }
}

public struct MaskingKernels {
    
    /// Reconstructed alpha-blending kernel.
    /// Blends source into destination using mask and layer opacity.
    public static func blend(source: UnsafePointer<Float>, 
                             destination: UnsafeMutablePointer<Float>, 
                             mask: UnsafePointer<UInt8>, 
                             opacity: Float, 
                             count: Int) {
        for i in 0..<count {
            let alpha = (Float(mask[i]) / 255.0) * opacity
            destination[i] = source[i] * alpha + destination[i] * (1.0 - alpha)
        }
    }
}
