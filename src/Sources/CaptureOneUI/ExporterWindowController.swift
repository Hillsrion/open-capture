import Cocoa
import SwiftUI
import AppCoreShared

/// Standalone Window Controller for the Exporter (WS-104).
/// Reconstructs the dedicated window shell instead of using a sheet.
public class ExporterWindowController: NSWindowController {
    
    private var recipeManager: OutputRecipeManager
    private var batchQueue: BatchQueue
    private var selectedVariant: VariantBase?
    private var workspace: Workspace
    
    public init(recipeManager: OutputRecipeManager, batchQueue: BatchQueue, selectedVariant: VariantBase?) {
        self.recipeManager = recipeManager
        self.batchQueue = batchQueue
        self.selectedVariant = selectedVariant
        
        // Request the specific exporter window workspace preset
        self.workspace = COWorkspaceManager.createWorkspace(windowKind: .exporter, name: "Export")
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 900, height: 650),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.title = "Export"
        window.center()
        window.titlebarAppearsTransparent = true
        window.backgroundColor = NSColor(calibratedWhite: 0.12, alpha: 1.0)
        
        super.init(window: window)
        
        let contentView = ExporterRootView(
            recipeManager: recipeManager,
            batchQueue: batchQueue,
            selectedVariant: selectedVariant,
            workspace: workspace
        )
        window.contentView = NSHostingView(rootView: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate struct ExporterRootView: View {
    @ObservedObject var recipeManager: OutputRecipeManager
    @ObservedObject var batchQueue: BatchQueue
    var selectedVariant: VariantBase?
    let workspace: Workspace
    
    var body: some View {
        ExportView(
            recipeManager: recipeManager,
            batchQueue: batchQueue,
            selectedVariant: selectedVariant
        )
        .background(CaptureOneTheme.Colors.applicationBackground)
        .preferredColorScheme(ColorScheme.dark)
        .edgesIgnoringSafeArea(Edge.Set.top)
    }
}
