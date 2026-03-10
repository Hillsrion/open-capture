import Foundation
import CoreGraphics

/// Reconstructed logic for crop rectangle manipulation (UI-204).
/// Ported from ApplicationBusinessRules symbols.
public final class CropRectHitboxCalculator {
    public static let sharedInstance = CropRectHitboxCalculator()
    
    private let handleSize: CGFloat = 8.0
    private let rotateHandleOffset: CGFloat = 20.0
    
    private init() {}
    
    // MARK: - Hitbox Rects
    
    public func moveRectForCropRect(_ cropRect: CGRect) -> CGRect {
        // The entire area minus the edge handles
        return cropRect.insetBy(dx: handleSize, dy: handleSize)
    }
    
    public func resizeRectForCropRect(_ cropRect: CGRect) -> CGRect {
        return cropRect
    }
    
    // Corner Resize Rects
    
    public func topLeftResizeRectForCropRect(_ cropRect: CGRect) -> CGRect {
        return CGRect(x: cropRect.minX - handleSize/2, y: cropRect.minY - handleSize/2, width: handleSize, height: handleSize)
    }
    
    public func topRightResizeRectForCropRect(_ cropRect: CGRect) -> CGRect {
        return CGRect(x: cropRect.maxX - handleSize/2, y: cropRect.minY - handleSize/2, width: handleSize, height: handleSize)
    }
    
    public func bottomLeftResizeRectForCropRect(_ cropRect: CGRect) -> CGRect {
        return CGRect(x: cropRect.minX - handleSize/2, y: cropRect.maxY - handleSize/2, width: handleSize, height: handleSize)
    }
    
    public func bottomRightResizeRectForCropRect(_ cropRect: CGRect) -> CGRect {
        return CGRect(x: cropRect.maxX - handleSize/2, y: cropRect.maxY - handleSize/2, width: handleSize, height: handleSize)
    }
    
    // Edge Resize Rects
    
    public func leftResizeRectForCropRect(_ cropRect: CGRect) -> CGRect {
        return CGRect(x: cropRect.minX - handleSize/2, y: cropRect.midY - handleSize/2, width: handleSize, height: handleSize)
    }
    
    public func rightResizeRectForCropRect(_ cropRect: CGRect) -> CGRect {
        return CGRect(x: cropRect.maxX - handleSize/2, y: cropRect.midY - handleSize/2, width: handleSize, height: handleSize)
    }
    
    public func topResizeRectForCropRect(_ cropRect: CGRect) -> CGRect {
        return CGRect(x: cropRect.midX - handleSize/2, y: cropRect.minY - handleSize/2, width: handleSize, height: handleSize)
    }
    
    public func bottomResizeRectForCropRect(_ cropRect: CGRect) -> CGRect {
        return CGRect(x: cropRect.midX - handleSize/2, y: cropRect.maxY - handleSize/2, width: handleSize, height: handleSize)
    }
    
    // Rotation Handle Rects (Outside the corners)
    
    public func topLeftRotateRectForCropRect(_ cropRect: CGRect) -> CGRect {
        return CGRect(x: cropRect.minX - rotateHandleOffset, y: cropRect.minY - rotateHandleOffset, width: handleSize * 2, height: handleSize * 2)
    }
    
    public func topRightRotateRectForCropRect(_ cropRect: CGRect) -> CGRect {
        return CGRect(x: cropRect.maxX + rotateHandleOffset - handleSize * 2, y: cropRect.minY - rotateHandleOffset, width: handleSize * 2, height: handleSize * 2)
    }
    
    public func bottomLeftRotateRectForCropRect(_ cropRect: CGRect) -> CGRect {
        return CGRect(x: cropRect.minX - rotateHandleOffset, y: cropRect.maxY + rotateHandleOffset - handleSize * 2, width: handleSize * 2, height: handleSize * 2)
    }
    
    public func bottomRightRotateRectForCropRect(_ cropRect: CGRect) -> CGRect {
        return CGRect(x: cropRect.maxX + rotateHandleOffset - handleSize * 2, y: cropRect.maxY + rotateHandleOffset - handleSize * 2, width: handleSize * 2, height: handleSize * 2)
    }
    
    // MARK: - Interaction Detection
    
    public enum InteractionZone {
        case none
        case move
        case resizeTopLeft, resizeTopRight, resizeBottomLeft, resizeBottomRight
        case resizeTop, resizeBottom, resizeLeft, resizeRight
        case rotateTopLeft, rotateTopRight, rotateBottomLeft, rotateBottomRight
    }
    
    public func interactionZone(at point: CGPoint, for cropRect: CGRect) -> InteractionZone {
        if topLeftResizeRectForCropRect(cropRect).contains(point) { return .resizeTopLeft }
        if topRightResizeRectForCropRect(cropRect).contains(point) { return .resizeTopRight }
        if bottomLeftResizeRectForCropRect(cropRect).contains(point) { return .resizeBottomLeft }
        if bottomRightResizeRectForCropRect(cropRect).contains(point) { return .resizeBottomRight }
        
        if topResizeRectForCropRect(cropRect).contains(point) { return .resizeTop }
        if bottomResizeRectForCropRect(cropRect).contains(point) { return .resizeBottom }
        if leftResizeRectForCropRect(cropRect).contains(point) { return .resizeLeft }
        if rightResizeRectForCropRect(cropRect).contains(point) { return .resizeRight }
        
        if topLeftRotateRectForCropRect(cropRect).contains(point) { return .rotateTopLeft }
        if topRightRotateRectForCropRect(cropRect).contains(point) { return .rotateTopRight }
        if bottomLeftRotateRectForCropRect(cropRect).contains(point) { return .rotateBottomLeft }
        if bottomRightRotateRectForCropRect(cropRect).contains(point) { return .rotateBottomRight }
        
        if moveRectForCropRect(cropRect).contains(point) { return .move }
        
        return .none
    }
}
