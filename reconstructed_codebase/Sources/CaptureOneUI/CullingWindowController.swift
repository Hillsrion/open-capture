import AppCoreShared
import ImageCore
import DataCore
import SwiftUI
import AppKit

/// Observable wrapper for CImageBrowser to trigger SwiftUI updates
public class BrowserWrapper: ObservableObject {
    @Published public var browser: CImageBrowser
    public init(browser: CImageBrowser) {
        self.browser = browser
    }
}

/// High-Fidelity Reconstructed Culling Window Controller.
public class CullingWindowController: NSWindowController {
    
    public var cullingCollection: MOFolderCollection?
    public var browser = CImageBrowser()
    public var adjustmentController = AdjustmentToolController()
    public var recipeManager = OutputRecipeManager.defaultManager()
    public var batchQueue = BatchQueue()
    public var session: SessionBase?
    
    public override init(window: NSWindow?) {
        super.init(window: window)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func windowDidLoad() {
        super.windowDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        window?.backgroundColor = NSColor(calibratedWhite: 0.12, alpha: 1.0)
        WorkspaceManager.shared.activeWorkspace = WorkspaceManager.createWorkspace(windowKind: .session, name: "Default")
        
        let context = ObjectContext()
        cullingCollection = MOFolderCollection(uuid: UUID().uuidString, context: context)
        
        // Start from an empty shell instead of pretending a session is already loaded.
        session = SessionBase(documentUUID: UUID().uuidString, type: 1, context: context)
        session?.name = "Untitled Catalog"
        
        // Add a default recipe
        recipeManager.addRecipe(OutputRecipe(name: "JPEG 80%", recipe: MCRecipe(dictionary: [:]), context: context))
        
        let contentView = CullingView(
            browser: browser,
            adjustmentController: adjustmentController,
            recipeManager: recipeManager,
            batchQueue: batchQueue,
            session: session ?? SessionBase(documentUUID: "mock", type: 0, context: context)
        )
        window?.contentView = NSHostingView(rootView: contentView)
    }
}

/// High-Fidelity Reconstructed Culling View matching v16.5 aesthetic.
public struct CullingView: View {
    
    @ObservedObject var browserWrapper: BrowserWrapper
    @ObservedObject var adjustmentController = AdjustmentToolController.shared
    @ObservedObject var recipeManager: OutputRecipeManager
    @ObservedObject var batchQueue: BatchQueue
    @ObservedObject var session: SessionBase
    @ObservedObject var workspaceManager = WorkspaceManager.shared
    @ObservedObject var commands = AppCommandCenter.shared
    @StateObject private var keywordCache: DocumentKeywordCache
    
    public init(browser: CImageBrowser, adjustmentController: AdjustmentToolController, recipeManager: OutputRecipeManager, batchQueue: BatchQueue, session: SessionBase) {
        self.browserWrapper = BrowserWrapper(browser: browser)
        self.recipeManager = recipeManager
        self.batchQueue = batchQueue
        self.session = session
        self._keywordCache = StateObject(wrappedValue: DocumentKeywordCache(session: session))
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            workspaceBody
        }
        .background(CaptureOneTheme.Colors.applicationBackground)
        .preferredColorScheme(.dark)
        .onAppear {
            commands.configure(session: session, recipeManager: recipeManager, batchQueue: batchQueue)
            if recipeManager.recipes.isEmpty {
                recipeManager.addRecipe(OutputRecipe(name: "JPEG 80%", recipe: MCRecipe(dictionary: [:]), context: ObjectContext()))
            }
            NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
                if handleShortcut(event) { return nil }
                return event
            }
        }
        .sheet(item: $commands.presentedSheet) { route in
            sheetView(for: route)
        }
        .alert(item: $commands.notice) { notice in
            Alert(
                title: Text(notice.title),
                message: Text(notice.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func handleShortcut(_ event: NSEvent) -> Bool {
        guard let variant = adjustmentController.currentVariant else { return false }
        
        switch event.charactersIgnoringModifiers {
        // Rating (1-5, 0 to reset)
        case "1": variant.rating = 1; return true
        case "2": variant.rating = 2; return true
        case "3": variant.rating = 3; return true
        case "4": variant.rating = 4; return true
        case "5": variant.rating = 5; return true
        case "0": variant.rating = 0; return true
            
        // Color Tags (6-9)
        case "6": variant.colorTag = VariantBase.ColorTag.red; return true
        case "7": variant.colorTag = VariantBase.ColorTag.yellow; return true
        case "8": variant.colorTag = VariantBase.ColorTag.green; return true
        case "9": variant.colorTag = VariantBase.ColorTag.blue; return true
            
        default:
            return false
        }
    }

    private var selectedPaletteBinding: Binding<String> {
        Binding(
            get: { workspaceManager.activeWorkspace.selectedPaletteID },
            set: { workspaceManager.setSelectedPaletteID($0, autosave: true) }
        )
    }

    private var inspectorContext: InspectorToolContext {
        InspectorToolContext(
            adjustmentController: adjustmentController,
            session: session,
            recipeManager: recipeManager,
            batchQueue: batchQueue,
            keywordCache: keywordCache
        )
    }

    @ViewBuilder
    private var workspaceBody: some View {
        HStack(spacing: 0) {
            if workspaceManager.activeWorkspace.chromeState.toolsDisplayState != .hidden,
               workspaceManager.activeWorkspace.chromeState.toolsPosition == .left {
                toolsSidebar
                Divider().background(Color.black)
            }

            mainContentArea

            if workspaceManager.activeWorkspace.chromeState.toolsDisplayState != .hidden,
               workspaceManager.activeWorkspace.chromeState.toolsPosition == .right {
                Divider().background(Color.black)
                toolsSidebar
            }
        }
    }

    private var toolsSidebar: some View {
        VStack(spacing: 0) {
            InspectorToolTabView(selectedTabID: selectedPaletteBinding)

            if let activePalette = workspaceManager.activeWorkspace.activePalette() {
                InspectorToolLayout(palette: activePalette, context: inspectorContext)
            } else {
                Spacer(minLength: 0)
            }
        }
        .frame(width: workspaceManager.activeWorkspace.sidebarWidth)
        .background(CaptureOneTheme.Colors.panelBackground)
    }

    @ViewBuilder
    private var mainContentArea: some View {
        if workspaceManager.activeWorkspace.chromeState.browserDisplayState == .hidden {
            viewerPane
        } else if workspaceManager.activeWorkspace.chromeState.browserPosition == .portrait {
            HStack(spacing: 0) {
                viewerPane
                Divider().background(Color.black)
                browserPanePortrait
            }
        } else {
            VStack(spacing: 0) {
                viewerPane
                Divider().background(Color.black)
                browserPaneLandscape
            }
        }
    }

    private var viewerPane: some View {
        Group {
            if workspaceManager.activeWorkspace.chromeState.viewerShown {
                COViewerView(image: adjustmentController.currentVariant?.image, adjustmentController: adjustmentController)
            } else {
                Color.clear
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var browserPanePortrait: some View {
        COImageBrowserView(
            images: $browserWrapper.browser.dataSource,
            predicate: $adjustmentController.activePredicate,
            selectedVariant: $adjustmentController.currentVariant
        )
        .frame(width: workspaceManager.activeWorkspace.chromeState.browserWidth)
    }

    private var browserPaneLandscape: some View {
        COImageBrowserView(
            images: $browserWrapper.browser.dataSource,
            predicate: $adjustmentController.activePredicate,
            selectedVariant: $adjustmentController.currentVariant
        )
        .frame(height: workspaceManager.activeWorkspace.chromeState.browserHeight)
    }

    @ViewBuilder
    private func sheetView(for route: AppSheetRoute) -> some View {
        switch route {
        case .importImages:
            ImportDialog(importer: commands.importer)
        case .exportImages:
            ExportView(
                recipeManager: recipeManager,
                batchQueue: batchQueue,
                selectedVariant: adjustmentController.currentVariant
            )
            .frame(minWidth: 720, minHeight: 480)
        case .preferences:
            AppPreferencesView()
        case .keyboardShortcuts:
            ShortcutEditorSheet()
        case .print:
            PrintSheetHost()
        }
    }
}

// MARK: - Helper Components

struct ToolbarButton: View {
    let icon: String
    let label: String
    var body: some View {
        VStack(spacing: 2) {
            Image(systemName: icon).font(.system(size: 16))
            Text(label).font(.system(size: 9))
        }
        .foregroundColor(CaptureOneTheme.Colors.textPrimary)
        .frame(width: 50)
    }
}

struct ToolbarActionIcon: View {
    let systemName: String
    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: 14))
            .foregroundColor(CaptureOneTheme.Colors.iconNormal)
    }
}

struct ToolbarCursorIcon: View {
    let systemName: String
    let isSelected: Bool
    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: 14))
            .foregroundColor(isSelected ? CaptureOneTheme.Colors.activeHighlight : .white)
            .frame(width: 24, height: 24)
            .background(isSelected ? Color.white.opacity(0.1) : Color.clear)
            .cornerRadius(4)
    }
}

struct VToolTab: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                Text(label)
                    .font(.system(size: 8, weight: .bold))
            }
            .foregroundColor(isSelected ? CaptureOneTheme.Colors.activeHighlight : .gray)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                Rectangle()
                    .fill(isSelected ? CaptureOneTheme.Colors.activeHighlight : Color.clear)
                    .frame(height: 2),
                alignment: .bottom
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

private struct ShortcutEditorSheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            ShortcutEditorView()
                .padding(16)

            Divider()

            HStack {
                Spacer()
                Button("Done") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(CaptureOneTheme.Colors.activeHighlight)
                .padding(16)
            }
        }
        .frame(minWidth: 720, minHeight: 420)
        .background(CaptureOneTheme.Colors.panelBackground)
        .foregroundColor(.white)
    }
}

private struct PrintSheetHost: View {
    @ObservedObject private var adjustmentController = AdjustmentToolController.shared
    @State private var selectedVariants: [VariantBase] = []

    var body: some View {
        PrintDialog(selectedVariants: $selectedVariants)
            .onAppear {
                selectedVariants = adjustmentController.currentVariant.map { [$0] } ?? []
            }
    }
}
