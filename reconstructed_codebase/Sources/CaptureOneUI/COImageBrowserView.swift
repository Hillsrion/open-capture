import SwiftUI
import AppCoreShared
import DataCore

/// Reconstructed high-performance Grid View Browser (UI-005).
/// Based on disassembly of _TtC10CaptureOne22ImageBrowserInteractor and Related Metadata.
public struct COImageBrowserView: View {

    @Binding var images: [ImageBase]
    @Binding var predicate: COFilterPredicate
    @Binding var selectedVariant: VariantBase?
    
    // Zoom state (based on ImageBrowserZoomLevelStore)
    @State private var thumbnailSize: CGFloat = 160
    @State private var sortOrder: String = "filename"

    public init(images: Binding<[ImageBase]>, predicate: Binding<COFilterPredicate>, selectedVariant: Binding<VariantBase?>) {
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
    
    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: thumbnailSize, maximum: thumbnailSize * 1.5), spacing: 15)]
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // MARK: - Browser Header / Toolbar
            HStack(spacing: 15) {
                Text("\(filteredImages.count) images").font(.system(size: 11)).foregroundColor(.gray)
                
                Spacer()
                
                // Zoom Slider
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
            .frame(height: 32)
            .background(CaptureOneTheme.Colors.panelBackground)
            
            Divider().background(Color.black)
            
            // MARK: - Main Grid
            ScrollView {
                LazyVGrid(columns: columns, spacing: 25) {
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
                .padding(20)
            }
        }
        .background(CaptureOneTheme.Colors.browserBackground)
    }
}

/// Reconstructed high-fidelity Browser Cell (UI-005).
/// Based on visual analysis of v16.5 cell and _TtC10CaptureOne30ImageBrowserImageContainerView.
public struct COImageBrowserCell: View {
    let image: ImageBase
    let isSelected: Bool
    let size: CGFloat
    
    @State private var thumbnail: NSImage?
    
    public var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .center) {
                // 1. Selection & Background
                Rectangle()
                    .fill(isSelected ? CaptureOneTheme.Colors.activeHighlight.opacity(0.1) : CaptureOneTheme.Colors.histogramBackground)
                    .aspectRatio(1.0, contentMode: .fit)
                    .overlay(
                        RoundedRectangle(cornerRadius: 3)
                            .stroke(isSelected ? CaptureOneTheme.Colors.activeHighlight : Color.white.opacity(0.1), 
                                    lineWidth: isSelected ? 2.5 : 0.5)
                    )
                
                // 2. High-Quality Thumbnail
                if let thumb = thumbnail {
                    Image(nsImage: thumb)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(isSelected ? 6 : 4)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                } else {
                    ProgressView().scaleEffect(0.6)
                }
                
                // 3. Overlays (Metadata & State)
                VStack {
                    HStack(alignment: .top) {
                        // Color Tag (v16.5 vertical bar style)
                        if let variant = image.primaryVariant, variant.colorTag != .none {
                            Rectangle()
                                .fill(colorForTag(variant.colorTag))
                                .frame(width: 5, height: 18)
                                .cornerRadius(1.5)
                        }
                        
                        Spacer()
                        
                        // Indicators
                        VStack(alignment: .trailing, spacing: 4) {
                            if image.isOffline {
                                Image(systemName: "bolt.horizontal.circle.fill")
                                    .foregroundColor(.orange)
                                    .font(.system(size: 11))
                            }
                            if image.isMovie {
                                Image(systemName: "play.circle.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 11))
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Rating Stars
                    if let variant = image.primaryVariant, variant.rating > 0 {
                        HStack(spacing: 1.5) {
                            ForEach(0..<variant.rating, id: \.self) { _ in
                                Image(systemName: "star.fill")
                                    .font(.system(size: 8))
                                    .foregroundColor(.yellow)
                            }
                        }
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(3)
                    }
                }
                .padding(8)
            }
            .frame(width: size, height: size)
            
            // 4. Label (Filename + Extension)
            VStack(spacing: 1) {
                Text(image.displayName)
                    .font(.system(size: 10, weight: isSelected ? .bold : .regular))
                    .foregroundColor(isSelected ? .white : CaptureOneTheme.Colors.textSecondary)
                    .lineLimit(1)
                
                // Optional index or small info
                Text("\(image.imageUUID.prefix(4))")
                    .font(.system(size: 8))
                    .foregroundColor(.gray.opacity(0.6))
            }
            .frame(width: size)
        }
        .contentShape(Rectangle())
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
        ThumbnailManager.shared.requestThumbnail(for: image.path, size: CGSize(width: 512, height: 512)) { thumb in
            self.thumbnail = thumb
        }
    }
}
