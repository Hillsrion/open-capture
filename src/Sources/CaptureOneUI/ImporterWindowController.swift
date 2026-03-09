import Cocoa
import SwiftUI
import AppCoreShared

/// Standalone Window Controller for the Importer (WS-104).
/// Reconstructs the dedicated window shell instead of using a sheet.
public class ImporterWindowController: NSWindowController {
    
    private var importer: POImporter
    private var workspace: Workspace
    
    public init(importer: POImporter) {
        self.importer = importer
        // Request the specific importer window workspace preset
        self.workspace = WorkspaceManager.createWorkspace(windowKind: .importer, name: "Import")
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1100, height: 750),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.title = "Import Images"
        window.center()
        window.titlebarAppearsTransparent = true
        window.backgroundColor = NSColor(calibratedWhite: 0.12, alpha: 1.0)
        
        super.init(window: window)
        
        let contentView = ImporterRootView(importer: importer, workspace: workspace)
        window.contentView = NSHostingView(rootView: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate struct ImporterRootView: View {
    @ObservedObject var importer: POImporter
    let workspace: Workspace
    
    var body: some View {
        ImportDialog(importer: importer)
            .background(CaptureOneTheme.Colors.applicationBackground)
            .preferredColorScheme(.dark)
            .edgesIgnoringSafeArea(.top)
    }
}
