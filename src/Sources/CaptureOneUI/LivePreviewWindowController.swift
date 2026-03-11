import Cocoa
import SwiftUI
import AppCoreShared
import ImageCore
import DataCore

/// Standalone Window Controller for Live View Engine Restoration (GAP-401).
/// Hosts a live video stream area and a Workspace-driven sidebar for Live Preview tools.
public class LivePreviewWindowController: NSWindowController {
    
    private var session: SessionBase
    private var workspace: Workspace
    
    public init(session: SessionBase) {
        self.session = session
        // Request the specific live preview workspace preset
        self.workspace = WorkspaceManager.createWorkspace(windowKind: .livePreview, name: "Live Preview")
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1000, height: 750),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.title = "Live View - \(session.name ?? "Untitled")"
        window.center()
        window.titlebarAppearsTransparent = true
        window.backgroundColor = NSColor(calibratedWhite: 0.12, alpha: 1.0)
        
        super.init(window: window)
        
        let contentView = LivePreviewRootView(session: session, workspace: workspace)
        window.contentView = NSHostingView(rootView: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Root View

fileprivate struct LivePreviewRootView: View {
    let session: SessionBase
    @State var workspace: Workspace
    @StateObject private var adjustmentController = AdjustmentToolController.shared
    
    var body: some View {
        HStack(spacing: 0) {
            // Main Live Stream Area
            VStack(spacing: 0) {
                // Mock Toolbar
                HStack {
                    Button(action: {}) { Image(systemName: "hand.draw") }
                    Button(action: {}) { Image(systemName: "eyedropper") }
                    Button(action: {}) { Image(systemName: "video") }
                    
                    Divider().frame(height: 16)
                    
                    // Live View Interactive Controls
                    Button(action: {}) { Image(systemName: "playpause.fill") }.help("Pause/Play Live View")
                    Button(action: {}) { Image(systemName: "square.grid.3x3") }.help("Overlay Toggle")
                    
                    Divider().frame(height: 16)
                    
                    // Focus Meter
                    ProgressView(value: 0.7)
                        .progressViewStyle(LinearProgressViewStyle(tint: .green))
                        .frame(width: 100)
                        .help("Focus Meter")
                        
                    Spacer()
                    Button("Capture") {
                        // Trigger capture action
                    }.buttonStyle(.borderedProminent)
                }
                .padding(8)
                .background(Color.black.opacity(0.8))
                
                // Stream Container
                ZStack {
                    Color.black
                    Text("Live View Stream Pending...")
                        .font(.title2)
                        .foregroundColor(.gray)
                    Image(systemName: "camera.viewfinder")
                        .font(.system(size: 64))
                        .foregroundColor(Color.white.opacity(0.1))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Divider().background(Color.black)
            
            // Reconstructed Tool Sidebar based on workspace preset
            VStack(spacing: 0) {
                // Tab Selection
                HStack(spacing: 0) {
                    ForEach(workspace.palettes) { palette in
                        Button(action: {
                            WorkspaceManager.shared.setSelectedPaletteID(palette.id, autosave: false)
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
                
                // Active Toolkit
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
                                    keywordCache: DocumentKeywordCache(session: session)
                                ))
                            }
                        }
                    }
                } else {
                    Spacer()
                }
            }
            .frame(width: workspace.sidebarWidth)
            .background(CaptureOneTheme.Colors.applicationBackground)
        }
        .edgesIgnoringSafeArea(.top)
    }
}
