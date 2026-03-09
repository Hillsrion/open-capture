import Cocoa
import SwiftUI
import AppCoreShared

/// Standalone Window Controller for a floating tool palette (WS-105).
public class FloatingPaletteWindowController: NSWindowController {
    
    private let palette: WorkspacePaletteDefinition
    private let context: InspectorToolContext
    
    public init(palette: WorkspacePaletteDefinition, context: InspectorToolContext) {
        self.palette = palette
        self.context = context
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 305, height: 600),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView, .utilityWindow],
            backing: .buffered,
            defer: false
        )
        window.title = palette.name
        window.center()
        window.titlebarAppearsTransparent = true
        window.backgroundColor = NSColor(calibratedWhite: 0.12, alpha: 1.0)
        window.level = .floating
        
        super.init(window: window)
        
        let contentView = FloatingPaletteRootView(palette: palette, context: context)
        window.contentView = NSHostingView(rootView: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate struct FloatingPaletteRootView: View {
    let palette: WorkspacePaletteDefinition
    let context: InspectorToolContext
    
    var body: some View {
        InspectorToolLayout(palette: palette, context: context)
            .background(CaptureOneTheme.Colors.applicationBackground)
            .preferredColorScheme(.dark)
    }
}
