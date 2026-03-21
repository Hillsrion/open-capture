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
        COWorkspaceManager.shared.activeWorkspace = COWorkspaceManager.createWorkspace(windowKind: .session, name: "Default")
        
        let context = ObjectContext()
        cullingCollection = MOFolderCollection(uuid: UUID().uuidString, context: context)
        
        // Start from an empty shell instead of pretending a session is already loaded.
        session = SessionBase(documentUUID: UUID().uuidString, type: 0, context: context)
        session?.name = "Untitled Session"
        
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.path ?? "/"
        session?.rootFolder = documentsPath
        
        // Ensure default folders exist in memory
        session?.captureFolder = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first?.appendingPathComponent("Capture").path
        
        // Add a default recipe
        recipeManager.addRecipe(OutputRecipe(name: "JPEG 80%", recipe: MCRecipe(dictionary: [:]), context: context))
        
        AppCommandCenter.shared.configure(session: session!, recipeManager: recipeManager, batchQueue: batchQueue)
        
        let contentView = CullingView(
            browser: AppCommandCenter.shared.browser,
            adjustmentController: adjustmentController,
            recipeManager: recipeManager,
            batchQueue: batchQueue,
            session: session!
        )
        window?.contentView = NSHostingView(rootView: contentView)
    }
}

/// High-Fidelity Reconstructed Culling View matching v16.5 aesthetic.
public struct CullingView: View {
    
    @ObservedObject var browser: CImageBrowser
    @ObservedObject var adjustmentController = AdjustmentToolController.shared
    @ObservedObject var recipeManager: OutputRecipeManager
    @ObservedObject var batchQueue: BatchQueue
    @ObservedObject var session: SessionBase
    @ObservedObject var workspaceManager = COWorkspaceManager.shared
    @ObservedObject var commands = AppCommandCenter.shared
    @StateObject private var keywordCache: DocumentKeywordCache
    
    public init(browser: CImageBrowser, adjustmentController: AdjustmentToolController, recipeManager: OutputRecipeManager, batchQueue: BatchQueue, session: SessionBase) {
        self.browser = browser
        self.adjustmentController = adjustmentController
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
            if recipeManager.recipes.isEmpty, let ctx = session.managedObjectContext {
                recipeManager.addRecipe(OutputRecipe(name: "JPEG 80%", recipe: MCRecipe(dictionary: [:]), context: ctx))
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
                DraggableDivider(
                    direction: .horizontal,
                    size: $workspaceManager.activeWorkspace.sidebarWidth,
                    range: 200...600,
                    isReversed: false,
                    onResizeEnd: { workspaceManager.saveWorkspace() }
                )
            }

            mainContentArea

            if workspaceManager.activeWorkspace.chromeState.toolsDisplayState != .hidden,
               workspaceManager.activeWorkspace.chromeState.toolsPosition == .right {
                DraggableDivider(
                    direction: .horizontal,
                    size: $workspaceManager.activeWorkspace.sidebarWidth,
                    range: 200...600,
                    isReversed: true,
                    onResizeEnd: { workspaceManager.saveWorkspace() }
                )
                toolsSidebar
            }
        }
        .animation(nil, value: workspaceManager.activeWorkspace.sidebarWidth)
    }

    private var toolsSidebar: some View {
        VStack(spacing: 0) {
            InspectorToolTabView(selectedTabID: selectedPaletteBinding, context: inspectorContext)

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
                DraggableDivider(
                    direction: .horizontal,
                    size: $workspaceManager.activeWorkspace.chromeState.browserWidth,
                    range: 150...800,
                    isReversed: true,
                    onResizeEnd: { workspaceManager.saveWorkspace() }
                )
                browserPanePortrait
            }
            .animation(nil, value: workspaceManager.activeWorkspace.chromeState.browserWidth)
        } else {
            VStack(spacing: 0) {
                viewerPane
                DraggableDivider(
                    direction: .vertical,
                    size: $workspaceManager.activeWorkspace.chromeState.browserHeight,
                    range: 100...600,
                    isReversed: true,
                    onResizeEnd: { workspaceManager.saveWorkspace() }
                )
                browserPaneLandscape
            }
            .animation(nil, value: workspaceManager.activeWorkspace.chromeState.browserHeight)
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
            browser: commands.browser,
            predicate: $adjustmentController.activePredicate,
            selectedVariant: $adjustmentController.currentVariant
        )
        .frame(width: workspaceManager.activeWorkspace.chromeState.browserWidth)
    }

    private var browserPaneLandscape: some View {
        COImageBrowserView(
            browser: commands.browser,
            predicate: $adjustmentController.activePredicate,
            selectedVariant: $adjustmentController.currentVariant
        )
        .frame(height: workspaceManager.activeWorkspace.chromeState.browserHeight)
    }
    @ViewBuilder
    private func sheetView(for route: AppSheetRoute) -> some View {
        switch route {
        case .preferences:
            AppPreferencesView()
        case .keyboardShortcuts:
            ShortcutEditorSheet()
        case .newCatalog:
            CONewCatalogView()
        case .newSession:
            NewSessionWindowView()
        case .sessionUpgrade:
            if let session = commands.session {
                SessionUpgradeDialog(
                    session: session,
                    onUpgrade: {
                        commands.performUpgrade()
                        commands.presentedSheet = nil
                    },
                    onCancel: {
                        commands.presentedSheet = nil
                    }
                )
            }
        case .batchRename:
            BatchRenameView(
                controller: commands.batchRenameController,
                selectedVariants: commands.selectedVariantsForBatchRename
            )
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
