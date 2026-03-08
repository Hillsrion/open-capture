import SwiftUI
import AppCoreShared
import DataCore

/// Reconstructed high-performance Image Browser for Capture One (UI-005).
/// Based on disassembly of _TtC10CaptureOne32ImageBrowserSettingsWithGrouping and BrowserInteractor.
public struct COImageBrowserView: View {

    @Binding var images: [ImageBase]
    @Binding var predicate: COFilterPredicate
    @Binding var selectedVariant: VariantBase?
    
    @State private var thumbnailSize: CGFloat = 160
    @State private var sortOrder: String = "filename"

    public init(images: Binding<[ImageBase]>, predicate: Binding<COFilterPredicate>, selectedVariant: Binding<VariantBase?>, onSelect: ((ImageBase) -> Void)? = nil) {
        self._images = images
        self._predicate = predicate
        self._selectedVariant = selectedVariant
    }
    
    private var filteredImages: [ImageBase] {
        return images.filter { image in
            guard let variant = image.primaryVariant else { return true }
            if let min = predicate.minRating, variant.rating < min { return false }
            if let max = predicate.maxRating, variant.rating > max { return false }
            if let tags = predicate.colorTags, !tags.isEmpty {
                if !tags.contains(variant.colorTag.rawValue) { return false }
            }
            if let text = predicate.searchText, !text.isEmpty {
                if !image.displayName.localizedCaseInsensitiveContains(text) { return false }
            }
            return true
        }
    }
    
    // Dynamic column calculation based on thumbnail size
    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: thumbnailSize, maximum: thumbnailSize * 1.5), spacing: 15)]
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // MARK: - Browser Toolbar
            HStack(spacing: 15) {
                Text("Images").font(.caption).bold()
                
                Spacer()
                
                // Zoom Slider (based on ImageBrowserZoomLevelStore)
                HStack(spacing: 6) {
                    Image(systemName: "photo").font(.system(size: 8))
                    Slider(value: $thumbnailSize, in: 80...400)
                        .frame(width: 100)
                        .accentColor(CaptureOneTheme.Colors.activeHighlight)
                    Image(systemName: "photo").font(.system(size: 12))
                }
                
                // Sort Menu
                Menu {
                    Button("Filename") { sortOrder = "filename" }
                    Button("Rating") { sortOrder = "rating" }
                    Button("Date") { sortOrder = "date" }
                } label: {
                    Label(sortOrder.capitalized, systemImage: "arrow.up.arrow.down")
                        .font(.system(size: 11))
                }
                .menuStyle(BorderlessButtonMenuStyle())
            }
            .padding(.horizontal, 12)
            .frame(height: 30)
            .background(CaptureOneTheme.Colors.panelBackground)
            
            Divider().background(Color.black)
            
            // MARK: - Grid
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(filteredImages, id: \.imageUUID) { image in
                        COImageBrowserCell(
                            image: image,
                            isSelected: selectedVariant?.variantUUID == image.primaryVariant?.variantUUID,
                            size: thumbnailSize
                        )
                        .onTapGesture {
                            selectedVariant = image.primaryVariant
                        }
                    }
                }
                .padding(15)
            }
        }
        .background(CaptureOneTheme.Colors.browserBackground)
    }
}

/// Reconstructed high-fidelity Browser Cell (CORE-005).
/// Based on disassembly of _TtC10CaptureOne30ImageBrowserImageContainerView.
public struct COImageBrowserCell: View {
    let image: ImageBase
    let isSelected: Bool
    let size: CGFloat
    
    @State private var thumbnail: NSImage?
    
    public var body: some View {
        VStack(spacing: 6) {
            ZStack(alignment: .center) {
                // Background/Border Container
                Rectangle()
                    .fill(CaptureOneTheme.Colors.histogramBackground)
                    .aspectRatio(1.0, contentMode: .fit)
                    .overlay(
                        RoundedRectangle(cornerRadius: 2)
                            .stroke(isSelected ? CaptureOneTheme.Colors.activeHighlight : Color.white.opacity(0.1), 
                                    lineWidth: isSelected ? 2 : 0.5)
                    )
                
                // Thumbnail
                if let thumb = thumbnail {
                    Image(nsImage: thumb)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(isSelected ? 4 : 2)
                } else {
                    ProgressView().scaleEffect(0.5)
                }
                
                // Overlays
                VStack {
                    HStack {
                        // Color Tag
                        if let variant = image.primaryVariant, variant.colorTag != .none {
                            Rectangle()
                                .fill(colorForTag(variant.colorTag))
                                .frame(width: 4, height: 12)
                                .cornerRadius(1)
                        }
                        Spacer()
                        // Offline indicator
                        if image.isOffline {
                            Image(systemName: "bolt.horizontal.circle.fill")
                                .foregroundColor(.orange)
                                .font(.system(size: 10))
                        }
                    }
                    Spacer()
                    // Rating
                    if let variant = image.primaryVariant, variant.rating > 0 {
                        HStack(spacing: 1) {
                            ForEach(0..<variant.rating, id: \.self) { _ in
                                Image(systemName: "star.fill")
                                    .font(.system(size: 7))
                                    .foregroundColor(.yellow)
                            }
                        }
                        .padding(2)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(2)
                    }
                }
                .padding(6)
            }
            .frame(width: size, height: size)
            
            // Label
            Text(image.displayName)
                .font(.system(size: 10))
                .foregroundColor(isSelected ? .white : .gray)
                .lineLimit(1)
                .frame(width: size)
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
        ThumbnailManager.shared.requestThumbnail(for: image.path, size: CGSize(width: 400, height: 400)) { thumb in
            self.thumbnail = thumb
        }
    }
}
