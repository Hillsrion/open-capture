import SwiftUI
import AppCoreShared

/// Controller to manage crop interactions and constraints.
public class COCropController: ObservableObject {
    public static let shared = COCropController()
    
    public func handleDrag(_ gesture: DragGesture.Value, size: CGSize, controller: AdjustmentToolController, activeZone: inout CropRectHitboxCalculator.InteractionZone, startRect: inout CGRect) {
        if activeZone == .none {
            let denormalized = CGRect(x: controller.cropRect.minX * size.width,
                                      y: controller.cropRect.minY * size.height,
                                      width: controller.cropRect.width * size.width,
                                      height: controller.cropRect.height * size.height)
            activeZone = CropRectHitboxCalculator.sharedInstance.interactionZone(at: gesture.startLocation, for: denormalized)
            startRect = controller.cropRect
            if controller.cropRect == .zero {
                activeZone = .resizeBottomRight
                startRect = CGRect(x: gesture.startLocation.x / size.width, y: gesture.startLocation.y / size.height, width: 0, height: 0)
            }
        }
        
        let dx = gesture.translation.width / size.width
        let dy = gesture.translation.height / size.height
        var newRect = startRect
        
        switch activeZone {
        case .move:
            newRect.origin.x += dx
            newRect.origin.y += dy
        case .resizeTopLeft:
            newRect.origin.x += dx
            newRect.origin.y += dy
            newRect.size.width -= dx
            newRect.size.height -= dy
        case .resizeTop:
            newRect.origin.y += dy
            newRect.size.height -= dy
        case .resizeTopRight:
            newRect.origin.y += dy
            newRect.size.width += dx
            newRect.size.height -= dy
        case .resizeLeft:
            newRect.origin.x += dx
            newRect.size.width -= dx
        case .resizeRight:
            newRect.size.width += dx
        case .resizeBottomLeft:
            newRect.origin.x += dx
            newRect.size.width -= dx
            newRect.size.height += dy
        case .resizeBottom:
            newRect.size.height += dy
        case .resizeBottomRight:
            newRect.size.width += dx
            newRect.size.height += dy
        default:
            if controller.cropRect == .zero { 
                newRect.size.width = dx
                newRect.size.height = dy 
            }
        }
        
        // Normalize coordinates and bounds check
        newRect.origin.x = max(0, min(1.0, newRect.origin.x))
        newRect.origin.y = max(0, min(1.0, newRect.origin.y))
        newRect.size.width = max(0, min(1.0 - newRect.origin.x, newRect.size.width))
        newRect.size.height = max(0, min(1.0 - newRect.origin.y, newRect.size.height))
        
        // Apply constraints if any
        let constraintManager = COAspectConstraintManager.shared
        // Let's assume original aspect is 1.5 as fallback, normally from image
        if let aspect = constraintManager.aspect(for: controller.cropRatioIndex, originalAspect: 1.5, isSwapped: controller.isCropOrientationSwapped) {
            newRect = constraintManager.constrainRect(newRect, aspect: aspect)
            // Need to re-clamp after constraint
            newRect.origin.x = max(0, min(1.0, newRect.origin.x))
            newRect.origin.y = max(0, min(1.0, newRect.origin.y))
            newRect.size.width = max(0, min(1.0 - newRect.origin.x, newRect.size.width))
            newRect.size.height = max(0, min(1.0 - newRect.origin.y, newRect.size.height))
        }
        
        controller.cropRect = newRect
    }
}
