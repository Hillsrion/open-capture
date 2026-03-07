import SwiftUI
import AppCoreShared

/// Reconstructed Image Browser for Capture One.
/// Based on _TtC10CaptureOne32ImageBrowserSettingsWithGrouping and related metadata.
public struct COImageBrowserView: View {
    
    @State var images: [ImageBase] = []
    public var onSelect: ((ImageBase) -> Void)?
    
    // MARK: - Browser Settings (Reconstructed from metadata)
    @State private var thumbnailSize: CGFloat = 120
    @State private var sortOrder: String = "filename" // ZSORTORDER
    
    let columns = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    public init(images: [ImageBase] = [], onSelect: ((ImageBase) -> Void)? = nil) {
        self._images = State(initialValue: images)
        self.onSelect = onSelect
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // MARK: - Browser Toolbar (Inferred)
            HStack {
                Text("Browser").font(.caption).bold()
                Spacer()
                // Sort Menu (based on ZSORTORDER)
                Menu {
                    Button("Filename") { sortOrder = "filename" }
                    Button("Rating") { sortOrder = "rating" }
                    Button("Date") { sortOrder = "date" }
                } label: {
                    Label(sortOrder.capitalized, systemImage: "arrow.up.arrow.down")
                        .font(.caption)
                }
            }
            .padding(.horizontal, 10)
            .frame(height: 25)
            .background(CaptureOneTheme.Colors.mainWindowTitleAndToolbar.opacity(0.5))
            
            // MARK: - thumbnailCollectionView
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(images, id: \.imageUUID) { image in
                        COThumbnailCell(image: image)
                            .onTapGesture {
                                onSelect?(image)
                            }
                    }
                }
                .padding(10)
            }
        }
        .background(CaptureOneTheme.Colors.applicationBackground)
    }
}

/// Reconstructed Thumbnail Cell.
/// Based on _TtC10CaptureOne30ImageBrowserImageContainerView.
struct COThumbnailCell: View {
    let image: ImageBase
    @State private var thumbnail: NSImage?
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack(alignment: .bottomTrailing) {
                // Image Container
                ZStack {
                    CaptureOneTheme.Colors.histogramBackground
                    
                    if let thumb = thumbnail {
                        Image(nsImage: thumb)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        ProgressView().scaleEffect(0.5)
                    }
                }
                .aspectRatio(3/2, contentMode: .fit)
                .cornerRadius(2)
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(Color.white.opacity(0.15), lineWidth: 0.5)
                )
                
                // Status Icons (Inferred)
                if image.isOffline {
                    Image(systemName: "bolt.horizontal.circle.fill")
                        .foregroundColor(.orange)
                        .font(.system(size: 10))
                        .padding(4)
                }
            }
            
            // Info Label (Based on BrowserInformationTextFormatter)
            Text(image.displayName)
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.9))
                .lineLimit(1)
        }
    }
    
    private func loadThumbnail() {
        ThumbnailManager.shared.requestThumbnail(for: image.path, size: CGSize(width: 250, height: 250)) { thumb in
            self.thumbnail = thumb
        }
    }
    
    init(image: ImageBase) {
        self.image = image
    }
}
extension COThumbnailCell {
    // Ensuring onAppear is called
    var bodyWithOnAppear: some View {
        self.onAppear { loadThumbnail() }
    }
}
