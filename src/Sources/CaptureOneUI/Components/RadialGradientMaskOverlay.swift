import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Radial Gradient Mask Overlay (UI-204).
/// Displays the 2-circle interactive handle system.
public struct RadialGradientMaskOverlay: View {
    let gradient: RadialGradientMask
    let viewerSize: CGSize
    
    public var body: some View {
        let center = denormalize(gradient.center, in: viewerSize)
        let width = gradient.radius.width * viewerSize.width
        let height = gradient.radius.height * viewerSize.height
        
        let featherFactor = max(0.01, gradient.feather)
        
        ZStack {
            // Inner Circle (100%)
            Ellipse()
                .stroke(Color.white, lineWidth: 2)
                .frame(width: width * (1.0 - featherFactor), height: height * (1.0 - featherFactor))
                .rotationEffect(.degrees(gradient.rotation))
                .position(center)
            
            // Outer Circle (0%)
            Ellipse()
                .stroke(Color.white.opacity(0.6), lineWidth: 1)
                .frame(width: width, height: height)
                .rotationEffect(.degrees(gradient.rotation))
                .position(center)
            
            // Handles (Center and edges)
            Circle()
                .fill(Color.white)
                .frame(width: 8, height: 8)
                .position(center)
                .shadow(radius: 2)
                
            // Could add 4 edge handles here based on rotation and radius
        }
        .allowsHitTesting(false)
    }
    
    private func denormalize(_ point: CGPoint, in size: CGSize) -> CGPoint {
        return CGPoint(x: point.x * size.width, y: point.y * size.height)
    }
}
