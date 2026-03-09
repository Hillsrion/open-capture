import Cocoa
import SwiftUI
import AppCoreShared

/// Standalone Window Controller for a floating tool (WS-105).
public class FloatingToolWindowController: NSWindowController {
    
    private let toolID: String
    private let toolName: String
    private let session: SessionBase
    
    public init(toolID: String, toolName: String, session: SessionBase) {
        self.toolID = toolID
        self.toolName = toolName
        self.session = session
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 200),
            styleMask: [.titled, .closable, .resizable, .fullSizeContentView, .utilityWindow],
            backing: .buffered,
            defer: false
        )
        window.title = toolName
        window.center()
        window.titlebarAppearsTransparent = true
        window.backgroundColor = NSColor(calibratedWhite: 0.12, alpha: 1.0)
        window.level = .floating // Stay on top
        
        super.init(window: window)
        
        let contentView = FloatingToolRootView(toolID: toolID, session: session)
        window.contentView = NSHostingView(rootView: contentView)
        
        // Auto-resize based on content if possible, or just set a sensible default
        window.setContentSize(NSSize(width: 305, height: 250))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate struct FloatingToolRootView: View {
    let toolID: String
    let session: SessionBase
    @StateObject private var adjustmentController = AdjustmentToolController.shared
    
    var body: some View {
        VStack(spacing: 0) {
            ToolRegistry.view(for: toolID, context: ToolRegistryContext(
                config: ToolConfiguration(id: toolID),
                adjustmentController: adjustmentController,
                session: session,
                recipeManager: OutputRecipeManager.shared,
                batchQueue: BatchQueue(),
                keywordCache: DocumentKeywordCache(session: session)
            ))
            Spacer(minLength: 0)
        }
        .background(CaptureOneTheme.Colors.applicationBackground)
        .preferredColorScheme(.dark)
    }
}
