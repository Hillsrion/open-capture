import Cocoa
import SwiftUI
import AppCoreShared
import ImageCore
import DataCore

/// Standalone Window Controller for the Culling window (WS-103).
/// Loads the cullingwindow.tools workspace preset for its sidebar.
public class CullingShellController: NSWindowController {
    
    private var session: SessionBase
    private var workspace: Workspace
    
    public init(session: SessionBase) {
        self.session = session
        self.workspace = WorkspaceManager.createWorkspace(windowKind: .culling, name: "Culling")
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1100, height: 750),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.title = "Culling - \(session.name ?? "Untitled")"
        window.center()
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        window.backgroundColor = NSColor(calibratedWhite: 0.12, alpha: 1.0)
        
        super.init(window: window)
        
        let contentView = CullingShellRootView(session: session, workspace: workspace)
        window.contentView = NSHostingView(rootView: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Root View

fileprivate struct CullingShellRootView: View {
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
            // Sidebar
            if workspace.chromeState.toolsDisplayState != .hidden {
                toolsSidebar
                Divider().background(Color.black)
            }
            
            // Main Culling Grid
            VStack(spacing: 0) {
                cullingToolbar
                Divider().background(Color.black)
                
                // Culling Grid Content
                ZStack {
                    Color.black
                    VStack(spacing: 16) {
                        Image(systemName: "rectangle.grid.2x2")
                            .font(.system(size: 48))
                            .foregroundColor(.gray.opacity(0.4))
                        Text("Culling View")
                            .font(.title3)
                            .foregroundColor(.gray)
                        Text("Import images to start culling")
                            .font(.system(size: 12))
                            .foregroundColor(.gray.opacity(0.6))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(CaptureOneTheme.Colors.applicationBackground)
        .preferredColorScheme(.dark)
    }
    
    private var cullingToolbar: some View {
        HStack(spacing: 12) {
            Text("Culling")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white)
            
            Divider().frame(height: 20)
            
            // Rating shortcuts
            HStack(spacing: 4) {
                ForEach(1...5, id: \.self) { star in
                    Button(action: {
                        adjustmentController.currentVariant?.rating = star
                    }) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.yellow.opacity(0.6))
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Divider().frame(height: 20)
            
            // Color tags
            HStack(spacing: 4) {
                ForEach([("Red", Color.red), ("Yellow", Color.yellow), ("Green", Color.green), ("Blue", Color.blue)], id: \.0) { tag in
                    Button(action: {}) {
                        Circle()
                            .fill(tag.1)
                            .frame(width: 10, height: 10)
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Spacer()
            
            Text("0 images")
                .font(.system(size: 11))
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 12)
        .frame(height: 32)
        .background(CaptureOneTheme.Colors.panelBackground)
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
            
            // Active Tools
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
