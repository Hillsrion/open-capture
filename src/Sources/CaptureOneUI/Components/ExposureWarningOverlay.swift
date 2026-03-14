import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Exposure Warning Overlay (UI-204).
/// Simulates highlight and shadow clipping based on preference thresholds.
public struct ExposureWarningOverlay: View {
    let image: NSImage
    @ObservedObject var controller = AdjustmentToolController.shared
    
    public var body: some View {
        Canvas { context, size in
            // In a real app, this would use a Metal shader analyzing pixel values (0-255).
            // Here we simulate the effect by drawing patterns where clipping would occur.
            
            // Highlight clipping (Red)
            // Normalized threshold: 250/255 approx 0.98
            let hThreshold = controller.exposureHighlightThreshold / 255.0
            
            // Shadow clipping (Blue)
            let sThreshold = controller.exposureShadowThreshold / 255.0
            
            // Simulation: Draw a few "clipped" blobs if threshold is low/high enough
            if hThreshold < 1.0 {
                context.fill(Path(CGRect(x: size.width * 0.7, y: size.height * 0.2, width: 40, height: 30)), with: .color(controller.exposureHighlightColor.opacity(0.8)))
            }
            
            if sThreshold > 0.0 {
                context.fill(Path(CGRect(x: size.width * 0.1, y: size.height * 0.8, width: 25, height: 25)), with: .color(controller.exposureShadowColor.opacity(0.8)))
            }
        }
        .allowsHitTesting(false)
    }
}
