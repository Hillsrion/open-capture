import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Linear Gradient Mask Overlay (UI-204).
/// Displays the 3-line interactive handle system.
public struct LinearGradientMaskOverlay: View {
    let gradient: LinearGradientMask
    let viewerSize: CGSize
    
    public var body: some View {
        let p1 = denormalize(gradient.start, in: viewerSize)
        let p2 = denormalize(gradient.end, in: viewerSize)
        let mid = denormalize(gradient.middle, in: viewerSize)
        
        // Calculate angle and distance
        let dx = p2.x - p1.x
        let dy = p2.y - p1.y
        let angle = atan2(dy, dx)
        let distance = sqrt(dx*dx + dy*dy)
        
        ZStack {
            // Main Axis Line
            Path { path in
                path.move(to: p1)
                path.addLine(to: p2)
            }
            .stroke(Color.white.opacity(0.5), style: StrokeStyle(lineWidth: 1, dash: [4]))
            
            // Primary Line (Start - 100%)
            gradientLine(center: p1, angle: angle + .pi/2, length: viewerSize.width * 2)
                .stroke(Color.white, lineWidth: 2)
            
            // Middle Line (50% transition)
            gradientLine(center: mid, angle: angle + .pi/2, length: viewerSize.width * 2)
                .stroke(Color.white.opacity(0.8), lineWidth: 1)
            
            // End Line (0%)
            gradientLine(center: p2, angle: angle + .pi/2, length: viewerSize.width * 2)
                .stroke(Color.white.opacity(0.6), lineWidth: 1)
            
            // Rotation/Origin Handle
            Circle()
                .fill(Color.white)
                .frame(width: 8, height: 8)
                .position(mid)
                .shadow(radius: 2)
        }
        .allowsHitTesting(false)
    }
    
    private func gradientLine(center: CGPoint, angle: CGFloat, length: CGFloat) -> Path {
        var path = Path()
        let x1 = center.x + cos(angle) * length / 2
        let y1 = center.y + sin(angle) * length / 2
        let x2 = center.x - cos(angle) * length / 2
        let y2 = center.y - sin(angle) * length / 2
        
        path.move(to: CGPoint(x: x1, y: y1))
        path.addLine(to: CGPoint(x: x2, y: y2))
        return path
    }
    
    private func denormalize(_ point: CGPoint, in size: CGSize) -> CGPoint {
        return CGPoint(x: point.x * size.width, y: point.y * size.height)
    }
}
