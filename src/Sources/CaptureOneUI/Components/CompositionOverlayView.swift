import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Composition Overlay (GAP-406).
/// Supports image-based ghosting for alignment.
public struct CompositionOverlayView: View {
    @ObservedObject var model: COOverlayModel = .shared
    
    public var body: some View {
        ZStack {
            if model.showOverlay && !model.imagePath.isEmpty {
                if let nsImage = model.overlayImage {
                    Image(nsImage: nsImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(model.scale / 100.0)
                        .offset(x: model.offset.x, y: model.offset.y)
                        .opacity(model.opacity / 100.0)
                        .allowsHitTesting(false)
                }
            }
        }
    }
}
