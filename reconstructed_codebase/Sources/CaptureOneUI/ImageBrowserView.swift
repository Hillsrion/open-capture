import SwiftUI
import AppCoreShared

/// Reconstructed Image Browser view for Capture One.
/// Displays a performant grid of thumbnails using SwiftUI LazyVGrid.
public struct ImageBrowserView: View {
    
    @State var images: [ImageBase] = []
    public var onSelect: ((ImageBase) -> Void)?
    
    let columns = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    public init(images: [ImageBase] = [], onSelect: ((ImageBase) -> Void)? = nil) {
        self._images = State(initialValue: images)
        self.onSelect = onSelect
    }
    
    public var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(images, id: \.imageUUID) { image in
                    ThumbnailCell(image: image)
                        .onTapGesture {
                            onSelect?(image)
                        }
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
            .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
            )
            
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
