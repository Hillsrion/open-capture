import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Composition Overlay (GAP-406).
/// Supports image-based ghosting for alignment.
public struct CompositionOverlayView: View {
    @ObservedObject var controller: AdjustmentToolController
    
    public var body: some View {
        ZStack {
            if controller.showOverlay && !controller.overlayPath.isEmpty {
                if let nsImage = NSImage(contentsOfFile: controller.overlayPath) {
                    Image(nsImage: nsImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(controller.overlayScale / 100.0)
                        .offset(x: controller.overlayOffset.x, y: controller.overlayOffset.y)
                        .opacity(controller.overlayOpacity / 100.0)
                        .allowsHitTesting(false) // Overlay should not block interactions unless using Move tool
                }
            }
        }
    }
}
