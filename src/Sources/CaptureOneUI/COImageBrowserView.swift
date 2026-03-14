import SwiftUI
import AppCoreShared
import DataCore

/// Compatibility class for managing browser data source.
public class CImageBrowser: ObservableObject {
    @Published public var dataSource: [ImageBase] = []
    public init() {}
}

/// Reconstructed high-performance Multi-Mode Browser (WF-501).
/// Matches Capture One 16.7.4 specifications for Grid, Filmstrip, and List modes.
public struct COImageBrowserView: View {

    @ObservedObject var browser: CImageBrowser
    @Binding var predicate: COFilterPredicate
    @Binding var selectedVariant: VariantBase?
    
    @ObservedObject var searchManager = SearchManager.shared
    @ObservedObject var workspaceManager = WorkspaceManager.shared
    @ObservedObject var zoomStore = ImageBrowserZoomLevelStore.shared
    @StateObject private var interactor = ImageBrowserInteractor()
    @State private var sortOrder: String = "filename"
    @State private var groupingMode: String = "none"

    public init(browser: CImageBrowser, predicate: Binding<COFilterPredicate>, selectedVariant: Binding<VariantBase?>) {
        self.browser = browser
        self._predicate = predicate
        self._selectedVariant = selectedVariant
    }

    private var filteredImages: [ImageBase] {
        // Collect all primary variants from the browser's data source
        let allVariants = browser.dataSource.compactMap { $0.primaryVariant }
        
        // Filter via SearchManager
        let filteredVariants = searchManager.filter(allVariants)
        
        // Map back to images
        let filteredVariantIDs = Set(filteredVariants.map { $0.variantUUID })
        return browser.dataSource.filter { image in
            guard let primary = image.primaryVariant else { return false }
            return filteredVariantIDs.contains(primary.variantUUID)
        }
    }
    public var body: some View {
        VStack(spacing: 0) {
            browserToolbar
            
            Divider().background(Color.black)
            
            // Mode Dispatcher
            Group {
                switch workspaceManager.activeWorkspace.chromeState.browserMode {
                case 1: // Filmstrip
                    COBrowserFilmstripView(
                        images: filteredImages,
                        selectedVariant: $selectedVariant,
                        interactor: interactor,
                        zoomStore: zoomStore
                    )
                case 2: // List
                    COBrowserListView(
                        images: filteredImages,
                        selectedVariant: $selectedVariant,
                        interactor: interactor
                    )
                default: // Grid
                    COBrowserGridView(
                        images: filteredImages,
                        selectedVariant: $selectedVariant,
                        interactor: interactor,
                        zoomStore: zoomStore
                    )
                }
            }
            
            Divider().background(Color.black)
            browserFooter
        }
        .background(CaptureOneTheme.Colors.browserBackground)
        .onAppear { interactor.updateDataSource(with: browser.dataSource) }
        .onChange(of: browser.dataSource) { newImages in interactor.updateDataSource(with: newImages) }
    }
    
    // MARK: - Toolbar
    private var browserToolbar: some View {
        HStack(spacing: 12) {
            // Mode Switcher
            Picker("", selection: Binding(
                get: { workspaceManager.activeWorkspace.chromeState.browserMode },
                set: { workspaceManager.activeWorkspace.chromeState.browserMode = $0; workspaceManager.saveWorkspace() }
            )) {
                Image(systemName: "square.grid.3x3.fill").tag(0)
                Image(systemName: "rectangle.grid.1x2.fill").tag(1)
                Image(systemName: "list.bullet").tag(2)
            }
            .pickerStyle(.segmented)
            .frame(width: 100)
            .scaleEffect(0.8)
            
            // Search Field (WF-501)
            HStack {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                TextField("Search", text: $searchManager.criteria.searchText)
                    .font(.system(size: 11))
                    .textFieldStyle(.plain)
                    .frame(width: 120)
                
                if !searchManager.criteria.searchText.isEmpty {
                    Button(action: { searchManager.criteria.searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(4)
            .background(Color.white.opacity(0.05))
            .cornerRadius(4)
            
            Spacer()
            
            // Zoom Slider (Only for Grid/Filmstrip)
            if workspaceManager.activeWorkspace.chromeState.browserMode != 2 {
                HStack(spacing: 6) {
                    Image(systemName: "photo").font(.system(size: 8))
                    Slider(value: $zoomStore.thumbnailSize, in: 80...400)
                        .frame(width: 80)
                        .accentColor(CaptureOneTheme.Colors.activeHighlight)
                    Image(systemName: "photo").font(.system(size: 12))
                }
            }
            
            // Labels Toggle
            Button(action: { 
                workspaceManager.activeWorkspace.chromeState.browserLabelsShown.toggle()
                workspaceManager.saveWorkspace()
            }) {
                Image(systemName: workspaceManager.activeWorkspace.chromeState.browserLabelsShown ? "text.bubble.fill" : "text.bubble")
                    .font(.system(size: 12))
                    .foregroundColor(workspaceManager.activeWorkspace.chromeState.browserLabelsShown ? CaptureOneTheme.Colors.activeHighlight : .gray)
            }
            .buttonStyle(.plain)
            .help("Show/Hide Labels")
            
            // Sort Menu
            Menu {
                Button("Filename") { sortOrder = "filename" }
                Button("Rating") { sortOrder = "rating" }
                Button("Color Tag") { sortOrder = "colorTag" }
                Button("Date") { sortOrder = "date" }
            } label: {
                Label(sortOrder.capitalized, systemImage: "arrow.up.arrow.down")
                    .font(.system(size: 11))
            }
            .menuStyle(BorderlessButtonMenuStyle())
            
            // Grouping Menu (Cull View Feature)
            Menu {
                Button("None") { groupingMode = "none" }
                Button("By Date") { groupingMode = "date" }
                Button("By Similarity") { groupingMode = "similarity" }
            } label: {
                Label("Group: \(groupingMode.capitalized)", systemImage: "rectangle.3.group")
                    .font(.system(size: 11))
            }
            .menuStyle(BorderlessButtonMenuStyle())
        }
        .padding(.horizontal, 10)
        .frame(height: 32)
        .background(CaptureOneTheme.Colors.panelBackground)
    }
    
    private var browserFooter: some View {
        HStack {
            if let selected = selectedVariant,
               let index = browser.dataSource.firstIndex(where: { $0.primaryVariant?.variantUUID == selected.variantUUID }) {
                Text("\(index + 1) of \(browser.dataSource.count)")
            } else {
                Text("\(browser.dataSource.count) images")
            }
            Spacer()
        }
        .font(.system(size: 10))
        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(CaptureOneTheme.Colors.browserBackground)
    }

}

// MARK: - Grid View
struct COBrowserGridView: View {
    let images: [ImageBase]
    @Binding var selectedVariant: VariantBase?
    @ObservedObject var interactor: ImageBrowserInteractor
    @ObservedObject var zoomStore: ImageBrowserZoomLevelStore
    @ObservedObject var workspaceManager = WorkspaceManager.shared
    
    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: CGFloat(zoomStore.thumbnailSize), maximum: CGFloat(zoomStore.thumbnailSize) * 1.5), spacing: 15)]
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 25) {
                ForEach(images, id: \.imageUUID) { image in
                    cell(for: image)
                }
            }
            .padding(20)
        }
    }
    
    private func cell(for image: ImageBase) -> some View {
        let isSelected = interactor.selectedVariants.contains(image.primaryVariant?.variantUUID ?? "")
        let isPrimary = selectedVariant?.variantUUID == image.primaryVariant?.variantUUID
        
        return COImageBrowserCell(
            image: image,
            isSelected: isSelected,
            isPrimary: isPrimary,
            size: CGFloat(zoomStore.thumbnailSize),
            showLabel: workspaceManager.activeWorkspace.chromeState.browserLabelsShown
        )
        .onTapGesture { handleTap(on: image) }
    }
    
    private func handleTap(on image: ImageBase) {
        guard let variant = image.primaryVariant else { return }
        let isCmdPressed = NSEvent.modifierFlags.contains(.command)
        let isShiftPressed = NSEvent.modifierFlags.contains(.shift)
        interactor.select(variant: variant, isMultiSelect: isCmdPressed, isRangeSelect: isShiftPressed)
        selectedVariant = variant
    }
}

// MARK: - Filmstrip View
struct COBrowserFilmstripView: View {
    let images: [ImageBase]
    @Binding var selectedVariant: VariantBase?
    @ObservedObject var interactor: ImageBrowserInteractor
    @ObservedObject var zoomStore: ImageBrowserZoomLevelStore
    @ObservedObject var workspaceManager = WorkspaceManager.shared
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack(spacing: 15) {
                ForEach(images, id: \.imageUUID) { image in
                    cell(for: image)
                }
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
        }
        .frame(maxHeight: CGFloat(zoomStore.thumbnailSize) + 40)
    }
    
    private func cell(for image: ImageBase) -> some View {
        let isSelected = interactor.selectedVariants.contains(image.primaryVariant?.variantUUID ?? "")
        let isPrimary = selectedVariant?.variantUUID == image.primaryVariant?.variantUUID
        
        return COImageBrowserCell(
            image: image,
            isSelected: isSelected,
            isPrimary: isPrimary,
            size: CGFloat(zoomStore.thumbnailSize),
            showLabel: workspaceManager.activeWorkspace.chromeState.browserLabelsShown
        )
        .onTapGesture {
            guard let variant = image.primaryVariant else { return }
            interactor.select(variant: variant, isMultiSelect: false, isRangeSelect: false)
            selectedVariant = variant
        }
    }
}

// MARK: - List View
struct COBrowserListView: View {
    let images: [ImageBase]
    @Binding var selectedVariant: VariantBase?
    @ObservedObject var interactor: ImageBrowserInteractor
    
    var body: some View {
        Table(images, selection: Binding(
            get: { Set(interactor.selectedVariants) },
            set: { _ in } // Managed via interactor logic if needed
        )) {
            TableColumn("Name", value: \.displayName)
            TableColumn("Rating") { image in
                Text("\(image.primaryVariant?.rating ?? 0) ★")
                    .foregroundColor(.yellow)
            }
            TableColumn("Color") { image in
                Circle().fill(colorForTag(image.primaryVariant?.colorTag ?? .none))
                    .frame(width: 10, height: 10)
            }
            TableColumn("Type") { image in
                Text(isRaw(image.path) ? "RAW" : "JPEG")
                    .font(.system(size: 10, design: .monospaced))
            }
        }
        .tableStyle(.inset)
        .font(.system(size: 11))
    }
    
    private func isRaw(_ path: String) -> Bool {
        let ext = path.lowercased()
        let rawExts = ["arw", "cr2", "cr3", "nef", "nrw", "orf", "raf", "rw2", "pef", "dng", "iiq"]
        return rawExts.contains { ext.hasSuffix($0) }
    }
    
    private func colorForTag(_ tag: VariantBase.ColorTag) -> Color {
        switch tag {
        case .none: return .clear
        case .red: return .red
        case .orange: return .orange
        case .yellow: return .yellow
        case .green: return .green
        case .blue: return .blue
        case .purple: return .purple
        case .pink: return .pink
        }
    }
}

/// Reconstructed high-fidelity Browser Cell (UI-005).
public struct COImageBrowserCell: View {
    let image: ImageBase
    let isSelected: Bool
    let isPrimary: Bool
    let size: CGFloat
    let showLabel: Bool
    
    @State private var thumbnail: NSImage?
    
    public var body: some View {
        VStack(spacing: 6) {
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
                BrowserOverlayView(variant: image.primaryVariant, image: image)
                
                // 4. Face Focus (Cull View AI)
                if AppCommandCenter.shared.showFocusMask {
                    ZStack {
                        Circle()
                            .stroke(Color.green, lineWidth: 1)
                            .frame(width: size * 0.3, height: size * 0.3)
                        Image(systemName: "person.fill.viewfinder")
                            .font(.system(size: 8))
                            .foregroundColor(.green)
                            .offset(y: -size * 0.15)
                    }
                    .background(Color.black.opacity(0.4))
                    .clipShape(Circle())
                    .position(x: size * 0.8, y: size * 0.2)
                }
            }
            .frame(width: size, height: size)
            
            if showLabel {
                Text(image.displayName)
                    .font(.system(size: 10, weight: isPrimary ? .bold : .regular))
                    .foregroundColor(isPrimary ? .white : CaptureOneTheme.Colors.textSecondary)
                    .lineLimit(1)
                    .frame(width: size)
            }
        }
        .contentShape(Rectangle())
        .onAppear { loadThumbnail() }
        .contextMenu {
            Button("Create LCC Profile") {
                AdjustmentToolController.shared.createLCCProfile()
            }
        }
    }
    
    private func loadThumbnail() {
        ThumbnailManager.shared.requestThumbnail(for: image.path, size: CGSize(width: 512, height: 512)) { thumb in
            self.thumbnail = thumb
        }
    }
}
