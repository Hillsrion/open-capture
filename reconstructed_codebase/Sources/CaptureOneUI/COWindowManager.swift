import Cocoa
import SwiftUI
import AppCoreShared
import DataCore
import ImageCore

/// Reconstructed Document Manager for handling multiple Session workspaces.
/// Coordinates between AppKit window lifecycle and the restored SwiftUI shell.
@MainActor
public final class COWindowManager {
    public static let shared = COWindowManager()
    
    private var documentWindows: [String: NSWindow] = [:]
    private var windowDelegates: [String: DocumentWindowDelegate] = [:]
    private var livePreviewWindowDelegate: LivePreviewWindowDelegate?
    private var viewerWindowDelegate: AuxiliaryWindowDelegate?
    private var cullingWindowDelegate: AuxiliaryWindowDelegate?
    private var importerWindowDelegate: AuxiliaryWindowDelegate?
    private var exporterWindowDelegate: AuxiliaryWindowDelegate?
    private var printWindowDelegate: AuxiliaryWindowDelegate?
    
    // Auxiliary windows
    private var livePreviewWindowController: NSWindowController?
    private var viewerWindowController: NSWindowController?
    private var cullingWindowController: NSWindowController?
    private var importerWindowController: NSWindowController?
    private var exporterWindowController: NSWindowController?
    private var printWindowController: NSWindowController?
    private var floatingToolControllers: [String: FloatingToolWindowController] = [:]
    private var floatingToolDelegates: [String: FloatingToolWindowDelegate] = [:]
    private var floatingPaletteControllers: [String: FloatingPaletteWindowController] = [:]
    private var floatingPaletteDelegates: [String: FloatingPaletteWindowDelegate] = [:]
    private var startWindow: NSWindow?
    
    private init() {}
    
    public func showStartWindow() {
        if let window = startWindow {
            window.makeKeyAndOrderFront(nil)
            return
        }
        
        // A minimal "Recent Documents" / Start window matching UI-211 requirements
        let view = VStack(spacing: 32) {
            Image(systemName: "camera.aperture")
                .font(.system(size: 64))
                .foregroundColor(.gray)
                
            Text("Capture One Reconstructed")
                .font(.system(size: 24, weight: .light))
                
            VStack(spacing: 8) {
                Button("New Catalog...") {
                    AppCommandCenter.shared.newCatalog()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                
                Button("New Session...") {
                    AppCommandCenter.shared.newSession()
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                
                Button("Open Document...") {
                    AppCommandCenter.shared.openDocument()
                }
                .buttonStyle(.plain)
                .foregroundColor(.accentColor)
                .padding(.top, 8)
            }
        }
        .frame(width: 600, height: 450)
        .background(CaptureOneTheme.Colors.applicationBackground)
        .preferredColorScheme(.dark)
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 600, height: 450),
            styleMask: [.titled, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.center()
        window.title = "Welcome to Capture One"
        window.titlebarAppearsTransparent = true
        window.isMovableByWindowBackground = true
        window.contentView = NSHostingView(rootView: view)
        window.delegate = NSApp.delegate as? NSWindowDelegate
        window.identifier = NSUserInterfaceItemIdentifier("StartWindow")
        
        self.startWindow = window
        window.makeKeyAndOrderFront(nil)
    }
    
    public func openDocumentWindow(for session: SessionBase) {
        if let existing = documentWindows[session.documentUUID] {
            existing.makeKeyAndOrderFront(nil)
            return
        }
        
        // Hide start window if open
        startWindow?.close()
        startWindow = nil
        
        let workspace = WorkspaceManager.shared.activeWorkspace
        let frame = workspace.chromeState.windowFrame ?? NSRect(x: 0, y: 0, width: 1200, height: 800)
        
        // Needs a real viewer creation here
        let window = NSWindow(
            contentRect: frame,
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        if workspace.chromeState.windowFrame == nil {
            window.center()
        }
        window.title = session.name ?? "Untitled \(session.documentType == 0 ? "Session" : "Catalog")"
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.toolbarStyle = .unifiedCompact
        window.backgroundColor = NSColor(calibratedWhite: 0.12, alpha: 1.0)
        
        // In a real flow, these would be bound to the document
        let browser = CImageBrowser()
        let adjustmentController = AdjustmentToolController.shared
        let recipeManager = OutputRecipeManager.shared
        let batchQueue = BatchQueue()
        
        let contentView = CullingView(
            browser: browser,
            adjustmentController: adjustmentController,
            recipeManager: recipeManager,
            batchQueue: batchQueue,
            session: session
        )
        
        window.contentView = NSHostingView(rootView: contentView)
        
        // Attach native NSToolbar (UI-207)
        let config = WorkspaceManager.shared.activeWorkspace.toolbarConfiguration
        let nativeToolbar = CONativeToolbar(configuration: config, commands: AppCommandCenter.shared)
        window.toolbar = nativeToolbar
        window.titleVisibility = .visible
        window.titlebarAppearsTransparent = false
        
        let delegate = DocumentWindowDelegate(manager: self, sessionID: session.documentUUID)
        windowDelegates[session.documentUUID] = delegate
        window.delegate = delegate
        
        documentWindows[session.documentUUID] = window
        window.makeKeyAndOrderFront(nil)
    }
    
    public func removeDocumentWindow(id: String) {
        documentWindows.removeValue(forKey: id)
        windowDelegates.removeValue(forKey: id)
        if documentWindows.isEmpty {
            showStartWindow()
        }
    }
    
    public func openLivePreview(for session: SessionBase) {
        if let existingController = livePreviewWindowController {
            existingController.window?.makeKeyAndOrderFront(nil)
            return
        }
        
        let controller = LivePreviewWindowController(session: session)
        self.livePreviewWindowController = controller
        
        guard let window = controller.window else { return }
        let delegate = LivePreviewWindowDelegate(manager: self)
        self.livePreviewWindowDelegate = delegate
        window.delegate = delegate
        window.makeKeyAndOrderFront(nil)
    }
    
    public func removeLivePreviewWindow() {
        livePreviewWindowController = nil
        livePreviewWindowDelegate = nil
    }
    
    // MARK: - Viewer Window (WS-101)
    
    public func openViewerWindow(for session: SessionBase) {
        if let existingController = viewerWindowController {
            existingController.window?.makeKeyAndOrderFront(nil)
            return
        }
        
        let controller = ViewerWindowController(session: session)
        self.viewerWindowController = controller
        
        guard let window = controller.window else { return }
        let delegate = AuxiliaryWindowDelegate(manager: self, kind: .viewer)
        self.viewerWindowDelegate = delegate
        window.delegate = delegate
        window.makeKeyAndOrderFront(nil)
    }
    
    public func removeViewerWindow() {
        viewerWindowController = nil
        viewerWindowDelegate = nil
    }
    
    // MARK: - Culling Window (WS-103)
    
    public func openCullingWindow(for session: SessionBase) {
        if let existingController = cullingWindowController {
            existingController.window?.makeKeyAndOrderFront(nil)
            return
        }
        
        let controller = CullingShellController(session: session)
        self.cullingWindowController = controller
        
        guard let window = controller.window else { return }
        let delegate = AuxiliaryWindowDelegate(manager: self, kind: .culling)
        self.cullingWindowDelegate = delegate
        window.delegate = delegate
        window.makeKeyAndOrderFront(nil)
    }
    
    public func removeCullingWindow() {
        cullingWindowController = nil
        cullingWindowDelegate = nil
    }

    public func openImporterWindow(importer: POImporter) {
        if let existingController = importerWindowController {
            existingController.window?.makeKeyAndOrderFront(nil)
            return
        }

        let controller = ImporterWindowController(importer: importer)
        self.importerWindowController = controller

        guard let window = controller.window else { return }
        let delegate = AuxiliaryWindowDelegate(manager: self, kind: .importer)
        self.importerWindowDelegate = delegate
        window.delegate = delegate
        window.makeKeyAndOrderFront(nil)
    }

    public func removeImporterWindow() {
        importerWindowController = nil
        importerWindowDelegate = nil
    }

    // MARK: - Exporter Window (WS-104)

    public func openExporterWindow(recipeManager: OutputRecipeManager, batchQueue: BatchQueue, selectedVariant: VariantBase?) {
        if let existingController = exporterWindowController {
            existingController.window?.makeKeyAndOrderFront(nil)
            return
        }

        let controller = ExporterWindowController(recipeManager: recipeManager, batchQueue: batchQueue, selectedVariant: selectedVariant)
        self.exporterWindowController = controller

        guard let window = controller.window else { return }
        let delegate = AuxiliaryWindowDelegate(manager: self, kind: .exporter)
        self.exporterWindowDelegate = delegate
        window.delegate = delegate
        window.makeKeyAndOrderFront(nil)
    }

    public func removeExporterWindow() {
        exporterWindowController = nil
        exporterWindowDelegate = nil
    }

    // MARK: - Print Window (WS-104)

    public func openPrintWindow() {
        if let existingController = printWindowController {
            existingController.window?.makeKeyAndOrderFront(nil)
            return
        }

        let controller = PrintWindowController()
        self.printWindowController = controller

        guard let window = controller.window else { return }
        let delegate = AuxiliaryWindowDelegate(manager: self, kind: .print)
        self.printWindowDelegate = delegate
        window.delegate = delegate
        window.makeKeyAndOrderFront(nil)
    }

    public func removePrintWindow() {
        printWindowController = nil
        printWindowDelegate = nil
    }

    // MARK: - Floating Tools (WS-105)

    public func openFloatingToolWindow(toolID: String, toolName: String, session: SessionBase) {
        if let existingController = floatingToolControllers[toolID] {
            existingController.window?.makeKeyAndOrderFront(nil)
            return
        }

        let controller = FloatingToolWindowController(toolID: toolID, toolName: toolName, session: session)
        self.floatingToolControllers[toolID] = controller

        guard let window = controller.window else { return }
        let delegate = FloatingToolWindowDelegate(manager: self, toolID: toolID)
        self.floatingToolDelegates[toolID] = delegate
        window.delegate = delegate
        window.makeKeyAndOrderFront(nil)
    }

    public func removeFloatingToolWindow(id: String) {
        floatingToolControllers.removeValue(forKey: id)
        floatingToolDelegates.removeValue(forKey: id)
    }

    public func openFloatingPaletteWindow(palette: WorkspacePaletteDefinition, context: InspectorToolContext) {
        if let existingController = floatingPaletteControllers[palette.id] {
            existingController.window?.makeKeyAndOrderFront(nil)
            return
        }

        let controller = FloatingPaletteWindowController(palette: palette, context: context)
        self.floatingPaletteControllers[palette.id] = controller

        guard let window = controller.window else { return }
        let delegate = FloatingPaletteWindowDelegate(manager: self, paletteID: palette.id)
        self.floatingPaletteDelegates[palette.id] = delegate
        window.delegate = delegate
        window.makeKeyAndOrderFront(nil)
    }

    public func removeFloatingPaletteWindow(id: String) {
        floatingPaletteControllers.removeValue(forKey: id)
        floatingPaletteDelegates.removeValue(forKey: id)
    }
}

fileprivate class DocumentWindowDelegate: NSObject, NSWindowDelegate {
    let manager: COWindowManager
    let sessionID: String
    
    init(manager: COWindowManager, sessionID: String) {
        self.manager = manager
        self.sessionID = sessionID
    }
    
    func windowWillClose(_ notification: Notification) {
        manager.removeDocumentWindow(id: sessionID)
    }

    func windowDidMove(_ notification: Notification) {
        if let window = notification.object as? NSWindow {
            WorkspaceManager.shared.activeWorkspace.chromeState.windowFrame = window.frame
            WorkspaceManager.shared.saveWorkspace()
        }
    }

    func windowDidResize(_ notification: Notification) {
        if let window = notification.object as? NSWindow {
            WorkspaceManager.shared.activeWorkspace.chromeState.windowFrame = window.frame
            WorkspaceManager.shared.saveWorkspace()
        }
    }
}

fileprivate class LivePreviewWindowDelegate: NSObject, NSWindowDelegate {
    let manager: COWindowManager
    
    init(manager: COWindowManager) {
        self.manager = manager
    }
    
    func windowWillClose(_ notification: Notification) {
        manager.removeLivePreviewWindow()
    }
}

enum AuxiliaryWindowKind {
    case viewer
    case culling
    case importer
    case exporter
    case print
}

fileprivate class AuxiliaryWindowDelegate: NSObject, NSWindowDelegate {
    let manager: COWindowManager
    let kind: AuxiliaryWindowKind
    
    init(manager: COWindowManager, kind: AuxiliaryWindowKind) {
        self.manager = manager
        self.kind = kind
    }
    
    func windowWillClose(_ notification: Notification) {
        switch kind {
        case .viewer:
            manager.removeViewerWindow()
        case .culling:
            manager.removeCullingWindow()
        case .importer:
            manager.removeImporterWindow()
        case .exporter:
            manager.removeExporterWindow()
        case .print:
            manager.removePrintWindow()
        }
    }

    func windowDidMove(_ notification: Notification) {
        saveFrame(notification)
    }

    func windowDidResize(_ notification: Notification) {
        saveFrame(notification)
    }

    private func saveFrame(_ notification: Notification) {
        if let window = notification.object as? NSWindow {
            // This is a simplification: in reality, each window kind would have its own workspace
            // persistence key in the plist. For now, we save it globally for the active workspace
            // if it's the main window, but for auxiliary windows we'd need a multi-workspace manager.
            // For now, just allow them to move without global workspace persistence to avoid conflicts.
            print("[Window] \(kind) moved to \(window.frame)")
        }
    }
}

fileprivate class FloatingToolWindowDelegate: NSObject, NSWindowDelegate {
    let manager: COWindowManager
    let toolID: String
    
    init(manager: COWindowManager, toolID: String) {
        self.manager = manager
        self.toolID = toolID
    }
    
    func windowWillClose(_ notification: Notification) {
        manager.removeFloatingToolWindow(id: toolID)
    }
}

fileprivate class FloatingPaletteWindowDelegate: NSObject, NSWindowDelegate {
    let manager: COWindowManager
    let paletteID: String
    
    init(manager: COWindowManager, paletteID: String) {
        self.manager = manager
        self.paletteID = paletteID
    }
    
    func windowWillClose(_ notification: Notification) {
        manager.removeFloatingPaletteWindow(id: paletteID)
    }
}
