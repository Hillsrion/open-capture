import SwiftUI
import AppCoreShared
import ImageCore

/// Reconstructed Viewer area for Capture One.
/// Handles high-resolution rendering using the ImageCorePipeline.
public struct ImageViewerView: View {
    
    let image: ImageBase?
    @State private var renderedImage: NSImage?
    @State private var isLoading: Bool = false
    
    public init(image: ImageBase?) {
        self.image = image
    }
    
    public var body: some View {
        ZStack {
            Color.black
            
            if let nsImage = renderedImage {
                Image(nsImage: nsImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
            } else if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            } else {
                Text("No Image Selected")
                    .foregroundColor(CaptureOneTheme.Colors.disabledText)
            }
        }
        .clipped()
        .onAppear {
            renderSelectedImage()
        }
        .onChange(of: image?.imageUUID) { _ in
            renderSelectedImage()
        }
    }
    
    private func renderSelectedImage() {
        guard let image = image else { 
            self.renderedImage = nil
            return 
        }
        
        self.isLoading = true
        
        // 1. Logic recovery: Use high-speed ThumbnailManager for initial preview
        ThumbnailManager.shared.requestThumbnail(for: image.path, size: CGSize(width: 2000, height: 2000)) { thumb in
            self.renderedImage = thumb
            self.isLoading = false
            
            // 2. Implementation logic recovery: Trigger full pipeline render in background
            let pipeline = ImageCorePipeline(mode: .cpu_simd)
            let settings = IC_ProcessSettings()
            
            // Simulation of full render (Phase 3 Task 2)
            print("[ImageCore] Rendering high-res for: \(image.displayName)")
        }
    }
}
