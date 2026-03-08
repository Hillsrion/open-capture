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
    
    // Auxiliary windows
    private var livePreviewWindowController: NSWindowController?
    private var viewerWindowController: NSWindowController?
    private var cullingWindowController: NSWindowController?
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
        
        // Needs a real viewer creation here
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1200, height: 800),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.center()
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
        }
    }
}
