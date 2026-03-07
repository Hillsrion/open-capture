import SwiftUI
import AppCoreShared
import ImageCore

/// Reconstructed high-fidelity Viewer for Capture One.
/// Based on _TtC10CaptureOne25ViewerDisplayModeSettings and related metadata.
public struct COViewerView: View {
    
    public init(image: ImageBase?) {
        self.image = image
    }
    
    let image: ImageBase?
    @State private var renderedImage: NSImage?
    @State private var zoomLevel: Double = 1.0 // Inferred from ViewerZoomViewController
    
    public var body: some View {
        VStack(spacing: 0) {
            // MARK: - Main Rendering Area
            ZStack {
                CaptureOneTheme.Colors.applicationBackground
                
                if let nsImage = renderedImage {
                    Image(nsImage: nsImage)
                        .resizable()
                        .scaleEffect(zoomLevel)
                        .aspectRatio(contentMode: .fit)
                } else {
                    ProgressView().tint(.white)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // MARK: - COViewerBarView (Reconstructed from metadata)
            COViewerBarView(zoomLevel: $zoomLevel)
        }
        .onAppear {
            render()
        }
        .onChange(of: image?.imageUUID) { _ in
            render()
        }
    }
    
    private func render() {
        guard let image = image else { return }
        ThumbnailManager.shared.requestThumbnail(for: image.path, size: CGSize(width: 2000, height: 2000)) { thumb in
            self.renderedImage = thumb
        }
    }
}

/// Reconstructed Bottom Bar for the Viewer.
/// Based on 'viewerBarView' and 'viewerZoomControl' properties.
struct COViewerBarView: View {
    @Binding var zoomLevel: Double
    
    var body: some View {
        HStack {
            // Zoom Control
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                Slider(value: $zoomLevel, in: 0.1...4.0)
                    .frame(width: 150)
                Text("\(Int(zoomLevel * 100))%")
                    .font(.system(size: 10, design: .monospaced))
            }
            
            Spacer()
            
            // Display Mode Toggle (Inferred from viewerDisplayMode)
            HStack(spacing: 15) {
                Button(action: {}) {
                    Image(systemName: "square.grid.2x2")
                }
                Button(action: {}) {
                    Image(systemName: "rectangle.split.3x1")
                }
            }
        }
        .padding(.horizontal, 15)
        .frame(height: 35)
        .background(CaptureOneTheme.Colors.mainWindowTitleAndToolbar)
        .foregroundColor(.white)
    }
}
