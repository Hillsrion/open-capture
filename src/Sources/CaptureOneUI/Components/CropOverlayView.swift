import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Crop Overlay (UI-204).
/// Based on CropRectHitboxCalculator and AdjustmentToolController properties.
public struct CropOverlayView: View {
    @ObservedObject var controller: AdjustmentToolController
    let viewerSize: CGSize
    
    private let hitbox = CropRectHitboxCalculator.sharedInstance
    
    public var body: some View {
        ZStack {
            // 1. Darkened Mask (Out-of-crop area)
            if controller.cropShowMask && controller.cropRect != .zero {
                CropMaskShape(cropRect: denormalize(controller.cropRect, in: viewerSize))
                    .fill(Color.black.opacity(controller.cropMaskOpacity / 100.0))
                    .brightness(controller.cropMaskBrightness / 100.0)
            }
            
            // 2. The Crop Box
            if controller.cropRect != .zero {
                let rect = denormalize(controller.cropRect, in: viewerSize)
                
                // Border
                Rectangle()
                    .stroke(Color.white, lineWidth: 1)
                    .frame(width: rect.width, height: rect.height)
                    .position(x: rect.midX, y: rect.midY)
                
                // 3. Grid
                CropGridSelectorView(controller: controller, rect: rect)
                
                // 4. Handles (8 handles)
                Group {
                    // Corners
                    handle(at: hitbox.topLeftResizeRectForCropRect(rect))
                    handle(at: hitbox.topRightResizeRectForCropRect(rect))
                    handle(at: hitbox.bottomLeftResizeRectForCropRect(rect))
                    handle(at: hitbox.bottomRightResizeRectForCropRect(rect))
                    
                    // Sides
                    handle(at: hitbox.topResizeRectForCropRect(rect))
                    handle(at: hitbox.bottomResizeRectForCropRect(rect))
                    handle(at: hitbox.leftResizeRectForCropRect(rect))
                    handle(at: hitbox.rightResizeRectForCropRect(rect))
                }
            }
        }
    }
    
    private func handle(at rect: CGRect) -> some View {
        Rectangle()
            .fill(Color.white)
            .frame(width: rect.width, height: rect.height)
            .position(x: rect.midX, y: rect.midY)
            .shadow(color: .black.opacity(0.5), radius: 1)
    }
    
    private func denormalize(_ rect: CGRect, in size: CGSize) -> CGRect {
        return CGRect(
            x: rect.origin.x * size.width,
            y: rect.origin.y * size.height,
            width: rect.width * size.width,
            height: rect.height * size.height
        )
    }
}

/// Shape that fills the entire area EXCEPT the crop rectangle.
struct CropMaskShape: Shape {
    let cropRect: CGRect
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRect(rect)
        path.addRect(cropRect)
        return path
    }
}

struct CropGridSelectorView: View {
    @ObservedObject var controller: AdjustmentToolController
    let rect: CGRect
    
    var body: some View {
        ZStack {
            switch controller.cropGridIndex {
            case 0: // 3x3
                StandardGridView(rect: rect, rows: 3, cols: 3)
            case 1: // Golden Ratio
                GoldenRatioGridView(rect: rect)
            case 2: // Center Cross
                StandardGridView(rect: rect, rows: 2, cols: 2)
            default:
                EmptyView()
            }
        }
    }
}

struct StandardGridView: View {
    let rect: CGRect
    let rows: Int
    let cols: Int
    
    var body: some View {
        Path { path in
            for i in 1..<rows {
                let y = rect.minY + CGFloat(i) * rect.height / CGFloat(rows)
                path.move(to: CGPoint(x: rect.minX, y: y))
                path.addLine(to: CGPoint(x: rect.maxX, y: y))
            }
            for i in 1..<cols {
                let x = rect.minX + CGFloat(i) * rect.width / CGFloat(cols)
                path.move(to: CGPoint(x: x, y: rect.minY))
                path.addLine(to: CGPoint(x: x, y: rect.maxY))
            }
        }
        .stroke(Color.white.opacity(0.4), lineWidth: 0.5)
    }
}

struct GoldenRatioGridView: View {
    let rect: CGRect
    private let phi: CGFloat = 0.61803398875
    
    var body: some View {
        Path { path in
            // Horizontal lines
            let y1 = rect.minY + rect.height * (1.0 - phi)
            let y2 = rect.maxY - rect.height * (1.0 - phi)
            path.move(to: CGPoint(x: rect.minX, y: y1))
            path.addLine(to: CGPoint(x: rect.maxX, y: y1))
            path.move(to: CGPoint(x: rect.minX, y: y2))
            path.addLine(to: CGPoint(x: rect.maxX, y: y2))
            
            // Vertical lines
            let x1 = rect.minX + rect.width * (1.0 - phi)
            let x2 = rect.maxX - rect.width * (1.0 - phi)
            path.move(to: CGPoint(x: x1, y: rect.minY))
            path.addLine(to: CGPoint(x: x1, y: rect.maxY))
            path.move(to: CGPoint(x: x2, y: rect.minY))
            path.addLine(to: CGPoint(x: x2, y: rect.maxY))
        }
        .stroke(Color.white.opacity(0.4), lineWidth: 0.5)
    }
}
