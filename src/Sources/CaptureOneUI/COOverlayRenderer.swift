import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Composition Overlay Renderer (GAP-406).
/// Supports image-based ghosting with transparency support for PNG/PDF.
public struct COOverlayRenderer: View {
    @ObservedObject var model: COOverlayModel = .shared
    
    public var body: some View {
        ZStack {
            if model.showOverlay, let nsImage = model.overlayImage {
                Image(nsImage: nsImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(model.scale / 100.0)
                    .offset(x: model.offset.x, y: model.offset.y)
                    .opacity(model.opacity / 100.0)
                    .allowsHitTesting(false) // Interaction handled by COViewerView's Move tool
            }
        }
    }
}
