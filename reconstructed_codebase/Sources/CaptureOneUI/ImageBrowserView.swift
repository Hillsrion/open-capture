import SwiftUI
import AppCoreShared

/// Reconstructed Image Browser view for Capture One.
/// Displays a performant grid of thumbnails using SwiftUI LazyVGrid.
public struct ImageBrowserView: View {
    
    @State var images: [ImageBase] = []
    @State private var thumbnailSize: CGFloat = 150
    
    let columns = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    public init(images: [ImageBase] = []) {
        self._images = State(initialValue: images)
    }
    
    public var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(images, id: \.imageUUID) { image in
                    ThumbnailCell(image: image)
                }
            }
            .padding()
        }
        .background(CaptureOneTheme.Colors.applicationBackground)
    }
}

/// Individual Thumbnail Cell with metadata overlays.
struct ThumbnailCell: View {
    let image: ImageBase
    @State private var thumbnail: NSImage?
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                // MARK: - Thumbnail Image
                if let thumb = thumbnail {
                    Image(nsImage: thumb)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .aspectRatio(3/2, contentMode: .fit)
                        .overlay(ProgressView().scaleEffect(0.5))
                }
                
                // MARK: - Metadata Overlay (Rating/Tag)
                HStack(spacing: 2) {
                    if image.isOffline {
                        Image(systemName: "bolt.horizontal.circle.fill")
                            .foregroundColor(.orange)
                            .font(.system(size: 10))
                    }
                }
                .padding(2)
            }
            .cornerRadius(2)
            
            // MARK: - Filename
            Text(image.displayName)
                .font(.system(size: 9))
                .foregroundColor(.white)
                .lineLimit(1)
        }
        .onAppear {
            loadThumbnail()
        }
    }
    
    private func loadThumbnail() {
        ThumbnailManager.shared.requestThumbnail(for: image.path, size: CGSize(width: 200, height: 200)) { thumb in
            self.thumbnail = thumb
        }
    }
}
