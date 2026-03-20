import CoreGraphics

/// Reconstructed constraint manager for crop logic.
public class COAspectConstraintManager {
    public static let shared = COAspectConstraintManager()
    
    /// Returns the constrained aspect ratio based on the index.
    /// 0: Unconstrained, 1: Original, 2: 1x1, 3: 4x5, 4: 2x3, 5: 16x9
    public func aspect(for index: Int, originalAspect: CGFloat, isSwapped: Bool = false) -> CGFloat? {
        var aspect: CGFloat?
        switch index {
        case 0: aspect = nil // Unconstrained
        case 1: aspect = originalAspect
        case 2: aspect = 1.0
        case 3: aspect = 4.0 / 5.0
        case 4: aspect = 2.0 / 3.0
        case 5: aspect = 16.0 / 9.0
        default: aspect = nil
        }
        
        if let a = aspect, isSwapped, a != 1.0 {
            return 1.0 / a
        }
        return aspect
    }
    
    public func constrainRect(_ rect: CGRect, aspect: CGFloat) -> CGRect {
        // Simple center-based constraint
        let center = CGPoint(x: rect.midX, y: rect.midY)
        var newWidth = rect.width
        var newHeight = rect.height
        
        let currentAspect = newWidth / newHeight
        if currentAspect > aspect {
            newWidth = newHeight * aspect
        } else {
            newHeight = newWidth / aspect
        }
        
        return CGRect(
            x: center.x - newWidth / 2,
            y: center.y - newHeight / 2,
            width: newWidth,
            height: newHeight
        )
    }
    
    public func swapOrientation(for index: Int) -> Int {
        // Swap orientations logic (stub, usually involves UI swapping, but here we can define aspect rules)
        // If we want to physically swap width and height, we can add a boolean state for `isLandscape`.
        // Let's rely on the controller to invert the crop rect directly.
        return index
    }
}
