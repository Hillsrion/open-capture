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
        
        let context = ObjectContext()
        cullingCollection = MOFolderCollection(uuid: UUID().uuidString, context: context)
        
        // Initialize a mock session for the UI
        session = SessionBase(documentUUID: UUID().uuidString, type: 0, context: context)
        session?.rootFolder = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first?.path
        
        // Add a default recipe
        recipeManager.addRecipe(OutputRecipe(name: "JPEG 80%", recipe: MCRecipe(dictionary: [:]), context: context))
        
        let picturesPath = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first?.path ?? "/"
        cullingCollection?.updateWithFolderPath(picturesPath, clear: true, synchronizeFS: true)
        
        if let images = cullingCollection?.images {
            browser.dataSource = images
        }
        
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
    @ObservedObject var adjustmentController: AdjustmentToolController
    @ObservedObject var recipeManager: OutputRecipeManager
    @ObservedObject var batchQueue: BatchQueue
    @ObservedObject var session: SessionBase
    @ObservedObject var workspaceManager = WorkspaceManager.shared
    
    @State private var selectedToolTab: String = "ADJUST"
    
    public init(browser: CImageBrowser, adjustmentController: AdjustmentToolController, recipeManager: OutputRecipeManager, batchQueue: BatchQueue, session: SessionBase) {
        self.browserWrapper = BrowserWrapper(browser: browser)
        self.adjustmentController = adjustmentController
        self.recipeManager = recipeManager
        self.batchQueue = batchQueue
        self.session = session
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // MARK: - 1. Top Toolbar (Grouped Icons)
            HStack(spacing: 20) {
                HStack(spacing: 12) {
                    ToolbarButton(icon: "arrow.down.doc", label: "Import")
                    ToolbarButton(icon: "arrow.up.doc", label: "Export")
                    ToolbarButton(icon: "square.grid.2x2", label: "Cull")
                }
                
                Spacer()
                
                HStack(spacing: 15) {
                    ToolbarActionIcon(systemName: "arrow.counterclockwise") // Reset
                    ToolbarActionIcon(systemName: "arrow.uturn.backward") // Undo
                    ToolbarActionIcon(systemName: "arrow.uturn.forward") // Redo
                    ToolbarActionIcon(systemName: "magicmouse") // Auto
                }
                
                Spacer()
                
                // Cursor Tools Group
                HStack(spacing: 8) {
                    ToolbarCursorIcon(systemName: "cursorarrow", isSelected: true)
                    ToolbarCursorIcon(systemName: "hand.raised", isSelected: false)
                    ToolbarCursorIcon(systemName: "loupe", isSelected: false)
                    ToolbarCursorIcon(systemName: "crop", isSelected: false)
                    ToolbarCursorIcon(systemName: "arrow.triangle.2.circlepath", isSelected: false)
                }
                .padding(4)
                .background(Color.white.opacity(0.05))
                .cornerRadius(6)
                
                Spacer()
                
                HStack(spacing: 12) {
                    ToolbarButton(icon: "sidebar.left", label: "Before")
                    ToolbarButton(icon: "grid", label: "Grid")
                    ToolbarButton(icon: "exclamationmark.triangle", label: "Exp. Warning")
                }
            }
            .padding(.horizontal, 15)
            .frame(height: 55)
            .background(CaptureOneTheme.Colors.toolbarBackground)
            
            Divider().background(Color.black)
            
            // MARK: - 2. Main Workspace
            HStack(spacing: 0) {
                
                // MARK: - Left Sidebar (Vertical Tool Tabs)
                VStack(spacing: 0) {
                    InspectorToolTabView(selectedTabID: $selectedToolTab)
                    
                    if let activeTab = workspaceManager.activeWorkspace.leftSidebarTabs.first(where: { $0.id == selectedToolTab }) {
                        InspectorToolLayout(tab: activeTab, adjustmentController: adjustmentController)
                    }
                }
                .frame(width: workspaceManager.activeWorkspace.sidebarWidth)
                .background(CaptureOneTheme.Colors.panelBackground)
                
                Divider().background(Color.black)
                
                // MARK: - Center Viewer
                COViewerView(image: adjustmentController.currentVariant?.image, adjustmentController: adjustmentController)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Divider().background(Color.black)
                
                // MARK: - Right Filmstrip (Vertical)
                COImageBrowserView(
                    images: $browserWrapper.browser.dataSource,
                    predicate: $adjustmentController.activePredicate,
                    selectedVariant: $adjustmentController.currentVariant
                )
                .frame(width: 250)
            }
        }
        .background(CaptureOneTheme.Colors.applicationBackground)
        .preferredColorScheme(.dark)
        .onAppear {
            NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
                if handleShortcut(event) { return nil }
                return event
            }
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
