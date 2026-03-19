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
        GeometryReader { geometry in
            HStack(spacing: geometry.size.width > 400 ? 12 : 4) {
                // Mode Switcher - Hide if very narrow
                if geometry.size.width > 220 {
                    Picker("", selection: Binding(
                        get: { workspaceManager.activeWorkspace.chromeState.browserMode },
                        set: { workspaceManager.activeWorkspace.chromeState.browserMode = $0; workspaceManager.saveWorkspace() }
                    )) {
                        Image(systemName: "square.grid.3x3.fill").tag(0)
                        Image(systemName: "rectangle.grid.1x2.fill").tag(1)
                        Image(systemName: "list.bullet").tag(2)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: geometry.size.width > 300 ? 100 : 80)
                    .scaleEffect(0.8)
                }
                
                // Search Field (WF-501) - Flexible width
                HStack {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                    if geometry.size.width > 200 {
                        TextField("Search", text: $searchManager.criteria.searchText)
                            .font(.system(size: 11))
                            .textFieldStyle(.plain)
                            .frame(maxWidth: 120)
                    }
                    
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
                
                Spacer(minLength: 0)
                
                // Zoom Slider (Only for Grid/Filmstrip) - Lower threshold to 150px
                if workspaceManager.activeWorkspace.chromeState.browserMode != 2 && geometry.size.width > 150 {
                    HStack(spacing: 4) {
                        Image(systemName: "photo").font(.system(size: 8))
                        Slider(value: $zoomStore.thumbnailSize, in: 80...400)
                            .frame(width: geometry.size.width > 250 ? 80 : 50)
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
                
                // Sort Menu
                Menu {
                    Button("Filename") { sortOrder = "filename" }
                    Button("Rating") { sortOrder = "rating" }
                    Button("Color Tag") { sortOrder = "colorTag" }
                    Button("Date") { sortOrder = "date" }
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                }
                .menuStyle(BorderlessButtonMenuStyle())
                .frame(width: 24)
                
                // Grouping Menu - Hide if narrow
                if geometry.size.width > 450 {
                    Menu {
                        Button("None") { groupingMode = "none" }
                        Button("By Date") { groupingMode = "date" }
                        Button("By Similarity") { groupingMode = "similarity" }
                    } label: {
                        Label("Group", systemImage: "rectangle.3.group")
                            .font(.system(size: 11))
                    }
                    .menuStyle(BorderlessButtonMenuStyle())
                }
            }
            .padding(.horizontal, 8)
            .frame(height: 32)
        }
        .frame(height: 32)
        .background(CaptureOneTheme.Colors.panelBackground)
    }

    private func modeIcon(_ mode: Int) -> String {
        switch mode {
        case 0: return "square.grid.3x3.fill"
        case 1: return "rectangle.grid.1x2.fill"
        default: return "list.bullet"
        }
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

// MARK: - Helpers
@ViewBuilder
func colorSquare(for tag: VariantBase.ColorTag, size: CGFloat = 8) -> some View {
    let color = colorForTag(tag)
    if tag == .none {
        RoundedRectangle(cornerRadius: 1.5)
            .stroke(Color.white.opacity(0.3), lineWidth: 0.8)
            .frame(width: size, height: size)
    } else {
        RoundedRectangle(cornerRadius: 1.5)
            .fill(color)
            .frame(width: size, height: size)
    }
}

func colorForTag(_ tag: VariantBase.ColorTag) -> Color {
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

// MARK: - Grid View
struct COBrowserGridView: View {
    let images: [ImageBase]
    @Binding var selectedVariant: VariantBase?
    @ObservedObject var interactor: ImageBrowserInteractor
    @ObservedObject var zoomStore: ImageBrowserZoomLevelStore
    @ObservedObject var workspaceManager = WorkspaceManager.shared
    
    private func columns(for width: CGFloat) -> [GridItem] {
        let spacing: CGFloat = 15
        let padding: CGFloat = width > 300 ? 20 : 10
        let availableWidth = width - (padding * 2)
        
        let itemSize = CGFloat(zoomStore.thumbnailSize)
        let columnCount = max(1, Int(floor((availableWidth + spacing) / (itemSize + spacing))))
        
        return Array(repeating: GridItem(.flexible(), spacing: spacing), count: columnCount)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVGrid(columns: columns(for: geometry.size.width), spacing: 25) {
                    ForEach(images, id: \.imageUUID) { image in
                        let isSelected = interactor.selectedVariants.contains(image.primaryVariant?.variantUUID ?? "")
                        let isPrimary = selectedVariant?.variantUUID == image.primaryVariant?.variantUUID
                        
                        COImageBrowserCell(
                            image: image,
                            interactor: interactor,
                            isSelected: isSelected,
                            isPrimary: isPrimary,
                            size: CGFloat(zoomStore.thumbnailSize),
                            showLabel: workspaceManager.activeWorkspace.chromeState.browserLabelsShown,
                            useFullWidth: true,
                            onTap: { handleTap(on: image) }
                        )
                    }
                }
                .padding(geometry.size.width > 300 ? 20 : 10)
            }
        }
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
                    let isSelected = interactor.selectedVariants.contains(image.primaryVariant?.variantUUID ?? "")
                    let isPrimary = selectedVariant?.variantUUID == image.primaryVariant?.variantUUID
                    
                    COImageBrowserCell(
                        image: image,
                        interactor: interactor,
                        isSelected: isSelected,
                        isPrimary: isPrimary,
                        size: CGFloat(zoomStore.thumbnailSize),
                        showLabel: workspaceManager.activeWorkspace.chromeState.browserLabelsShown,
                        onTap: {
                            guard let variant = image.primaryVariant else { return }
                            interactor.select(variant: variant, isMultiSelect: false, isRangeSelect: false)
                            selectedVariant = variant
                        }
                    )
                }
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
        }
        .frame(maxHeight: CGFloat(zoomStore.thumbnailSize) + 40)
    }
}

// MARK: - List View
struct COBrowserListView: View {
    let images: [ImageBase]
    @Binding var selectedVariant: VariantBase?
    @ObservedObject var interactor: ImageBrowserInteractor
    
    @State private var editingImageID: String? = nil
    @State private var editedName: String = ""
    @State private var pickingColorImageID: String? = nil

    var body: some View {
        Table(images, selection: Binding(
            get: { Set(interactor.selectedVariants) },
            set: { _ in } // Managed via interactor logic if needed
        )) {
            TableColumn("Name") { image in
                COBrowserListNameCell(
                    image: image,
                    isEditing: editingImageID == image.imageUUID,
                    editedName: $editedName,
                    pickingColorImageID: $pickingColorImageID,
                    onStartEditing: {
                        editedName = image.displayName
                        editingImageID = image.imageUUID
                    },
                    onCommitEditing: {
                        image.renameFile(to: editedName)
                        editingImageID = nil
                    }
                )
            }
            TableColumn("Rating") { image in
                COBrowserListRatingCell(variant: image.primaryVariant)
            }
            TableColumn("Color") { image in
                COBrowserListColorCell(
                    variant: image.primaryVariant,
                    isPicking: pickingColorImageID == image.imageUUID,
                    onTogglePicking: { pickingColorImageID = (pickingColorImageID == image.imageUUID ? nil : image.imageUUID) }
                )
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
}

// MARK: - List View Subviews (for observation)

struct COBrowserListNameCell: View {
    @ObservedObject var image: ImageBase
    let isEditing: Bool
    @Binding var editedName: String
    @Binding var pickingColorImageID: String?
    let onStartEditing: () -> Void
    let onCommitEditing: () -> Void
    
    var body: some View {
        HStack(spacing: 6) {
            if isEditing {
                TextField("", text: $editedName, onCommit: onCommitEditing)
                .textFieldStyle(.plain)
                .font(.system(size: 11))
            } else {
                Text(image.displayName)
                    .onTapGesture(count: 2) { onStartEditing() }
            }
            
            Spacer()
            
            if let variant = image.primaryVariant {
                COBrowserColorSquareButton(variant: variant, pickingColorImageID: $pickingColorImageID, imageUUID: image.imageUUID)
            }
        }
        .onDrag {
            if let variant = image.primaryVariant {
                return NSItemProvider(object: variant.variantUUID as NSString)
            }
            return NSItemProvider()
        }
    }
}

struct COBrowserListRatingCell: View {
    @ObservedObject var variant: VariantBase
    
    init?(variant: VariantBase?) {
        guard let variant = variant else { return nil }
        self.variant = variant
    }
    
    var body: some View {
        Text("\(variant.rating) ★")
            .foregroundColor(.yellow)
    }
}

struct COBrowserListColorCell: View {
    @ObservedObject var variant: VariantBase
    let isPicking: Bool
    let onTogglePicking: () -> Void
    
    init?(variant: VariantBase?) {
        guard let variant = variant else { return nil }
        self.variant = variant
        self.isPicking = false
        self.onTogglePicking = {}
    }

    init?(variant: VariantBase?, isPicking: Bool, onTogglePicking: @escaping () -> Void) {
        guard let variant = variant else { return nil }
        self.variant = variant
        self.isPicking = isPicking
        self.onTogglePicking = onTogglePicking
    }
    
    var body: some View {
        Button(action: onTogglePicking) {
            Circle().fill(colorForTag(variant.colorTag))
                .frame(width: 10, height: 10)
        }
        .buttonStyle(.plain)
        .popover(isPresented: Binding(
            get: { isPicking },
            set: { if !$0 { onTogglePicking() } }
        )) {
            POColorTagPicker(selectedTag: Binding(
                get: { variant.colorTag },
                set: { newValue in
                    withAnimation {
                        variant.colorTag = newValue
                    }
                    onTogglePicking() 
                }
            ))
            .padding(8)
        }
    }
}

struct COBrowserColorSquareButton: View {
    @ObservedObject var variant: VariantBase
    @Binding var pickingColorImageID: String?
    let imageUUID: String
    
    var body: some View {
        Button(action: { pickingColorImageID = imageUUID }) {
            colorSquare(for: variant.colorTag, size: 10)
                .padding(4)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .popover(isPresented: Binding(
            get: { pickingColorImageID == imageUUID },
            set: { if !$0 { pickingColorImageID = nil } }
        )) {
            POColorTagPicker(selectedTag: Binding(
                get: { variant.colorTag },
                set: { newValue in
                    withAnimation {
                        variant.colorTag = newValue
                    }
                    pickingColorImageID = nil 
                }
            ))
            .padding(8)
        }
    }
}

/// Reconstructed high-fidelity Browser Cell (UI-005).
public struct COImageBrowserCell: View {
    @ObservedObject var image: ImageBase
    @ObservedObject var interactor: ImageBrowserInteractor
    let isSelected: Bool
    let isPrimary: Bool
    let size: CGFloat
    let showLabel: Bool
    var useFullWidth: Bool = false
    var onTap: (() -> Void)? = nil
    
    @State private var thumbnail: NSImage?
    @State private var isEditingName = false
    @State private var editedName = ""
    @State private var showingColorPicker = false
    
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
                if let variant = image.primaryVariant {
                    BrowserOverlayView(variant: variant, image: image)
                } else {
                    BrowserOverlayView(variant: nil, image: image)
                }
                
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
            .frame(maxWidth: useFullWidth ? .infinity : size)
            .aspectRatio(1.0, contentMode: .fit)
            .onTapGesture { onTap?() } // Thumbnail area tap
            .onDrag {
                if let variant = image.primaryVariant {
                    return NSItemProvider(object: variant.variantUUID as NSString)
                }
                return NSItemProvider()
            }
            
            if showLabel {
                if let variant = image.primaryVariant {
                    COImageBrowserCellFooter(
                        image: image,
                        variant: variant,
                        isPrimary: isPrimary,
                        size: size,
                        useFullWidth: useFullWidth,
                        isEditingName: $isEditingName,
                        editedName: $editedName,
                        showingColorPicker: $showingColorPicker,
                        onTap: onTap
                    )
                } else {
                    Text(image.displayName)
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                }
            }
        }
        .onAppear { loadThumbnail() }
        .contextMenu {
            Button("Rename") {
                editedName = image.displayName
                isEditingName = true
            }
            Button("Batch Rename...") {
                let commands = AppCommandCenter.shared
                let selectedUUIDs = interactor.selectedVariants
                let allVariants = commands.browser.dataSource.flatMap { $0.variants }
                let selected = allVariants.filter { selectedUUIDs.contains($0.variantUUID) }
                
                // If nothing is selected (unlikely in context menu, but still), 
                // fallback to the current image's primary variant
                if selected.isEmpty, let primary = image.primaryVariant {
                    commands.updateSelectedVariantsForBatchRename([primary])
                } else {
                    commands.updateSelectedVariantsForBatchRename(selected)
                }
                
                commands.presentBatchRename()
            }
            Divider()
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

struct COImageBrowserCellFooter: View {
    @ObservedObject var image: ImageBase
    @ObservedObject var variant: VariantBase
    let isPrimary: Bool
    let size: CGFloat
    let useFullWidth: Bool
    @Binding var isEditingName: Bool
    @Binding var editedName: String
    @Binding var showingColorPicker: Bool
    var onTap: (() -> Void)?
    
    var body: some View {
        HStack(spacing: 4) {
            if isEditingName {
                TextField("", text: $editedName, onCommit: {
                    image.renameFile(to: editedName)
                    isEditingName = false
                })
                .textFieldStyle(.plain)
                .font(.system(size: 10))
                .multilineTextAlignment(.leading)
                .foregroundColor(.white)
                .background(Color.blue.opacity(0.3))
                .frame(maxWidth: useFullWidth ? .infinity : size)
            } else {
                Text(image.displayName)
                    .font(.system(size: 10, weight: isPrimary ? .bold : .regular))
                    .foregroundColor(isPrimary ? .white : CaptureOneTheme.Colors.textSecondary)
                    .lineLimit(1)
                    .frame(maxWidth: useFullWidth ? .infinity : size)
                    .onTapGesture(count: 2) {
                        editedName = image.displayName
                        isEditingName = true
                    }
                    .onTapGesture(count: 1) { onTap?() }
            }
            
            Spacer(minLength: 0)
            
            Button(action: { showingColorPicker = true }) {
                colorSquare(for: variant.colorTag)
                    .padding(4)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .popover(isPresented: $showingColorPicker) {
                POColorTagPicker(selectedTag: Binding(
                    get: { variant.colorTag },
                    set: { newValue in
                        withAnimation {
                            variant.colorTag = newValue
                        }
                        showingColorPicker = false 
                    }
                ))
                .padding(8)
            }
        }
        .frame(maxWidth: useFullWidth ? .infinity : size)
    }
}
