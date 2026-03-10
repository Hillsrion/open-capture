import Cocoa
import SwiftUI
import AppCoreShared
import ImageCore
import DataCore

/// Standalone Window Controller for the Viewer window (WS-101).
/// Hosts a full-screen viewer with an optional workspace-driven sidebar.
public class ViewerWindowController: NSWindowController {
    
    private var session: SessionBase
    private var workspace: Workspace
    
    public init(session: SessionBase) {
        self.session = session
        self.workspace = WorkspaceManager.createWorkspace(windowKind: .viewer, name: "Viewer")
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1200, height: 850),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.title = "Viewer - \(session.name ?? "Untitled")"
        window.center()
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        window.toolbarStyle = .unifiedCompact
        window.backgroundColor = NSColor(calibratedWhite: 0.12, alpha: 1.0)
        
        super.init(window: window)
        
        let contentView = ViewerRootView(session: session, workspace: workspace)
        window.contentView = NSHostingView(rootView: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Root View

fileprivate struct ViewerRootView: View {
    let session: SessionBase
    @State var workspace: Workspace
    @StateObject private var adjustmentController = AdjustmentToolController.shared
    @StateObject private var keywordCache: DocumentKeywordCache
    
    init(session: SessionBase, workspace: Workspace) {
        self.session = session
        self.workspace = workspace
        self._keywordCache = StateObject(wrappedValue: DocumentKeywordCache(session: session))
    }
    
    var body: some View {
        HStack(spacing: 0) {
            // Sidebar (optional, driven by workspace chrome)
            if workspace.chromeState.toolsDisplayState != .hidden,
               workspace.chromeState.toolsPosition == .left {
                toolsSidebar
                Divider().background(Color.black)
            }
            
            // Main Viewer Area
            VStack(spacing: 0) {
                // Viewer Toolbar Strip
                if workspace.chromeState.viewerToolbarShown {
                    viewerToolbar
                    Divider().background(Color.black)
                }
                
                // Viewer Content
                COViewerView(
                    image: adjustmentController.currentVariant?.image,
                    adjustmentController: adjustmentController
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            // Right sidebar
            if workspace.chromeState.toolsDisplayState != .hidden,
               workspace.chromeState.toolsPosition == .right {
                Divider().background(Color.black)
                toolsSidebar
            }
        }
        .background(CaptureOneTheme.Colors.applicationBackground)
        .preferredColorScheme(.dark)
    }
    
    private var viewerToolbar: some View {
        HStack(spacing: 12) {
            // Cursor tools
            HStack(spacing: 4) {
                viewerToolbarIcon("hand.draw", label: "Pan")
                viewerToolbarIcon("magnifyingglass", label: "Loupe")
            }
            
            Divider().frame(height: 20)
            
            // View toggles
            HStack(spacing: 4) {
                viewerToolbarIcon("rectangle.on.rectangle.square", label: "Before/After")
                viewerToolbarIcon("eyeglasses", label: "Recipe Proofing")
                viewerToolbarIcon("exclamationmark.triangle", label: "Exposure Warning")
                viewerToolbarIcon("triangle.fill", label: "Gamut Warning") // Inverted triangle often used for gamut
                viewerToolbarIcon("camera.metering.spot", label: "Focus Mask")
            }
            
            Spacer()
            
            // Image info
            if let variant = adjustmentController.currentVariant {
                Text(variant.image?.displayName ?? "No Selection")
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
            } else {
                Text("No Image Selected")
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 12)
        .frame(height: 32)
        .background(CaptureOneTheme.Colors.panelBackground)
    }
    
    private func viewerToolbarIcon(_ systemName: String, label: String) -> some View {
        Button(action: {}) {
            Image(systemName: systemName)
                .font(.system(size: 13))
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
        }
        .buttonStyle(.plain)
        .help(label)
    }
    
    private var toolsSidebar: some View {
        VStack(spacing: 0) {
            // Tab bar
            HStack(spacing: 0) {
                ForEach(workspace.palettes) { palette in
                    Button(action: {
                        workspace.chromeState.selectedToolPaletteID = palette.id
                    }) {
                        Image(systemName: palette.iconName)
                            .font(.system(size: 14))
                            .foregroundColor(workspace.selectedPaletteID == palette.id ? CaptureOneTheme.Colors.activeHighlight : .gray)
                            .frame(height: 36)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                    .background(workspace.selectedPaletteID == palette.id ? Color.black.opacity(0.4) : Color.clear)
                }
            }
            .background(Color(NSColor.windowBackgroundColor))
            
            Divider().background(Color.black)
            
            // Active tools
            if let activePalette = workspace.activePalette() {
                ScrollView {
                    VStack(spacing: 1) {
                        ForEach(activePalette.allTools) { toolConfig in
                            ToolRegistry.view(for: toolConfig.id, context: ToolRegistryContext(
                                config: toolConfig,
                                adjustmentController: adjustmentController,
                                session: session,
                                recipeManager: OutputRecipeManager.shared,
                                batchQueue: BatchQueue(),
                                keywordCache: keywordCache
                            ))
                        }
                    }
                }
            } else {
                Spacer()
            }
        }
        .frame(width: workspace.sidebarWidth)
        .background(CaptureOneTheme.Colors.panelBackground)
    }
}
