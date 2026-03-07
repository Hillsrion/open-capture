import SwiftUI
import AppCoreShared
import DataCore

/// Reconstructed Image Browser for Capture One.
/// Based on _TtC10CaptureOne32ImageBrowserSettingsWithGrouping and related metadata.
public struct COImageBrowserView: View {

    @State var images: [ImageBase] = []
    @Binding var predicate: COFilterPredicate
    public var onSelect: ((ImageBase) -> Void)?

    // MARK: - Browser Settings (Reconstructed from metadata)
    @State private var thumbnailSize: CGFloat = 120
    @State private var sortOrder: String = "filename" // ZSORTORDER

    let columns = [
        GridItem(.adaptive(minimum: 100))
    ]

    public init(images: [ImageBase] = [], predicate: Binding<COFilterPredicate>, onSelect: ((ImageBase) -> Void)? = nil) {
        self._images = State(initialValue: images)
        self._predicate = predicate
        self.onSelect = onSelect
    }
    
    private var filteredImages: [ImageBase] {
        return images.filter { image in
            guard let variant = image.primaryVariant else { return true }
            
            // Rating Filter
            if let min = predicate.minRating, variant.rating < min { return false }
            if let max = predicate.maxRating, variant.rating > max { return false }
            
            // Color Tag Filter
            if let tags = predicate.colorTags, !tags.isEmpty {
                if !tags.contains(variant.colorTag.rawValue) { return false }
            }
            
            // Text Search
            if let text = predicate.searchText, !text.isEmpty {
                if !image.displayName.localizedCaseInsensitiveContains(text) { return false }
            }
            
            return true
        }
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
                    ForEach(filteredImages, id: \.imageUUID) { image in
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
                VStack(alignment: .trailing, spacing: 2) {
                    if image.isOffline {
                        Image(systemName: "bolt.horizontal.circle.fill")
                            .foregroundColor(.orange)
                            .font(.system(size: 10))
                    }
                    
                    // Rating stars on thumbnail (Reconstructed)
                    if let variant = image.primaryVariant, variant.rating > 0 {
                        HStack(spacing: 1) {
                            ForEach(0..<variant.rating, id: \.self) { _ in
                                Image(systemName: "star.fill")
                                    .font(.system(size: 8))
                                    .foregroundColor(.yellow)
                            }
                        }
                        .padding(2)
                        .background(Color.black.opacity(0.4))
                        .cornerRadius(2)
                    }
                }
                .padding(4)
                
                // Color Tag Overlay (Reconstructed)
                if let variant = image.primaryVariant, variant.colorTag != .none {
                    Rectangle()
                        .fill(colorForTag(variant.colorTag))
                        .frame(width: 4, height: 16)
                        .cornerRadius(1)
                        .position(x: 4, y: 12)
                }
            }
            
            // Info Label (Based on BrowserInformationTextFormatter)
            Text(image.displayName)
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.9))
                .lineLimit(1)
        }
        .onAppear { loadThumbnail() }
    }
    
    private func colorForTag(_ tag: VariantBase.ColorTag) -> Color {
        switch tag {
        case .none: return Color.clear
        case .red: return Color.red
        case .orange: return Color.orange
        case .yellow: return Color.yellow
        case .green: return Color.green
        case .blue: return Color.blue
        case .purple: return Color.purple
        case .pink: return Color.pink
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
