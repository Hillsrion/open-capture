import SwiftUI
import AppCoreShared
import DataCore

/// Reconstructed high-performance Grid View Browser (UI-005).
/// Based on disassembly of _TtC10CaptureOne22ImageBrowserInteractor and Related Metadata.
public struct COImageBrowserView: View {

    @Binding var images: [ImageBase]
    @Binding var predicate: COFilterPredicate
    @Binding var selectedVariant: VariantBase?
    
    // Zoom state
    @ObservedObject var zoomStore = ImageBrowserZoomLevelStore.shared
    
    // Interaction state (based on ImageBrowserInteractor)
    @StateObject private var interactor = ImageBrowserInteractor()
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
        [GridItem(.adaptive(minimum: CGFloat(zoomStore.thumbnailSize), maximum: CGFloat(zoomStore.thumbnailSize) * 1.5), spacing: 15)]
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
                    Slider(value: $zoomStore.thumbnailSize, in: 80...400)
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
                        let isSelected = interactor.selectedVariants.contains(image.primaryVariant?.variantUUID ?? "")
                        let isPrimary = selectedVariant?.variantUUID == image.primaryVariant?.variantUUID
                        
                        COImageBrowserCell(
                            image: image,
                            isSelected: isSelected,
                            isPrimary: isPrimary,
                            size: CGFloat(zoomStore.thumbnailSize)
                        )
                        .onTapGesture {
                            handleTap(on: image)
                        }
                        .contextMenu {
                            Button("Move to Selects") { /* Logic */ }
                            Button("Move to Trash") { /* Logic */ }
                            Divider()
                            Button("Copy Adjustments") { /* Logic */ }
                            Button("Apply Adjustments") { /* Logic */ }
                        }
                    }
                }
                .padding(20)
            }
        }
        .background(CaptureOneTheme.Colors.browserBackground)
        .onAppear {
            interactor.updateDataSource(with: images)
        }
        .onChange(of: images) { newImages in
            interactor.updateDataSource(with: newImages)
        }
    }
    
    private func handleTap(on image: ImageBase) {
        guard let variant = image.primaryVariant else { return }
        
        // Detect modifiers (simulated for SwiftUI macOS)
        let isCmdPressed = NSEvent.modifierFlags.contains(.command)
        let isShiftPressed = NSEvent.modifierFlags.contains(.shift)
        
        interactor.select(variant: variant, isMultiSelect: isCmdPressed, isRangeSelect: isShiftPressed)
        
        // Update the primary selected variant for the rest of the app
        selectedVariant = variant
    }
}

/// Reconstructed high-fidelity Browser Cell (UI-005).
public struct COImageBrowserCell: View {
    let image: ImageBase
    let isSelected: Bool
    let isPrimary: Bool
    let size: CGFloat
    
    @State private var thumbnail: NSImage?
    
    public var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .center) {
                // 1. Selection & Background
                Rectangle()
                    .fill(isPrimary ? CaptureOneTheme.Colors.activeHighlight.opacity(0.1) : (isSelected ? Color.white.opacity(0.05) : CaptureOneTheme.Colors.histogramBackground))
                    .aspectRatio(1.0, contentMode: .fit)
                    .overlay(
                        RoundedRectangle(cornerRadius: 3)
                            .stroke(isPrimary ? CaptureOneTheme.Colors.activeHighlight : (isSelected ? Color.white.opacity(0.4) : Color.white.opacity(0.1)), 
                                    lineWidth: isPrimary ? 2.5 : (isSelected ? 1.5 : 0.5))
                    )
                
                // 2. High-Quality Thumbnail
                if let thumb = thumbnail {
                    Image(nsImage: thumb)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(isPrimary ? 6 : 4)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                } else {
                    ProgressView().scaleEffect(0.6)
                }
                
                // 3. Overlays
                VStack {
                    HStack(alignment: .top) {
                        if let variant = image.primaryVariant, variant.colorTag != .none {
                            Rectangle()
                                .fill(colorForTag(variant.colorTag))
                                .frame(width: 5, height: 18)
                                .cornerRadius(1.5)
                        }
                        Spacer()
                        if image.isOffline {
                            Image(systemName: "bolt.horizontal.circle.fill")
                                .foregroundColor(.orange)
                                .font(.system(size: 11))
                        }
                    }
                    Spacer()
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
            
            Text(image.displayName)
                .font(.system(size: 10, weight: isPrimary ? .bold : .regular))
                .foregroundColor(isPrimary ? .white : CaptureOneTheme.Colors.textSecondary)
                .lineLimit(1)
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
