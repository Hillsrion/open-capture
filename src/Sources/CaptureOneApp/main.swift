import Cocoa
import SwiftUI
import AppCoreShared
import DataCore
import ImageCore
import CaptureOneUI

class AppDelegate: NSObject, NSApplicationDelegate, NSMenuItemValidation {
    var window: NSWindow!

    func applicationDidFinishLaunching(_ notification: Notification) {
        print("[System] App launched. Initializing...")
        
        // 1. Initialize Reconstructed Core (with safety)
        let _ = B2CIdentityManager.shared
        let _ = LicenseInfo()
        
        // 1.5 Setup Plugins (INT-003)
        COPluginManager.shared.discoverPlugins()
        
        // 1.6 Setup Hardware Controllers (INT-005)
        HardwareControllerManager.shared.actionDelegate = AdjustmentToolController.shared
        
        // 2. Setup Context — context is now created per-document in newCatalog/newSession
        
        NSApp.mainMenu = buildMainMenu()

        // 3. Document Lifecycle parity (UI-211)
        if ProcessInfo.processInfo.environment["CAPTUREONE_BYPASS_START"] == "1" {
            print("[System] Bypassing Start Window, creating New Catalog...")
            Task { @MainActor in
                AppCommandCenter.shared.newCatalog()
            }
        } else {
            print("[System] Showing Start Window...")
            COWindowManager.shared.showStartWindow()
        }
        
        // Ensure app comes to front
        NSApp.activate(ignoringOtherApps: true)
        
        print("[System] Initialization complete. Window should be visible.")
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false // Return to start window on last document close
    }

    func application(_ sender: NSApplication, openFile filename: String) -> Bool {
        print("[System] Received request to open file: \(filename)")
        let url = URL(fileURLWithPath: filename)
        
        // Add to recent documents
        NSDocumentController.shared.noteNewRecentDocumentURL(url)
        
        let ext = url.pathExtension.lowercased()
        if ext == "cosessiondb" || ext == "cocatalogdb" {
            Task { @MainActor in
                print("[System] Loading database at: \(url.path)")
                // Load the session/catalog into the shared SessionManager
                SessionManager.shared.loadSession(at: url)
                
                // Ensure the main window is visible
                if let window = COWindowManager.shared.mainWindow {
                    window.makeKeyAndOrderFront(nil)
                }
            }
            return true
        }
        
        return false
    }

    func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        return true
    }

    // MARK: - Menu Actions

    @objc func importImages(_ sender: Any?) {
        Task { @MainActor in AppCommandCenter.shared.presentImport() }
    }

    @objc func exportImages(_ sender: Any?) {
        Task { @MainActor in AppCommandCenter.shared.presentExport() }
    }

    @objc func newCatalog(_ sender: Any?) {
        print("[Menu] New Catalog clicked")
        Task { @MainActor in 
            print("[Menu] Task: newCatalog")
            AppCommandCenter.shared.newCatalog() 
        }
    }

    @objc func newSession(_ sender: Any?) {
        print("[Menu] New Session clicked")
        Task { @MainActor in 
            print("[Menu] Task: newSession")
            AppCommandCenter.shared.newSession() 
        }
    }

    @objc func openDocument(_ sender: Any?) {
        print("[Menu] Open Document clicked")
        Task { @MainActor in AppCommandCenter.shared.openDocument() }
    }

    @objc func printImages(_ sender: Any?) {
        Task { @MainActor in AppCommandCenter.shared.presentPrint() }
    }

    @objc func openLivePreview(_ sender: Any?) {
        Task { @MainActor in AppCommandCenter.shared.openLivePreview() }
    }

    @objc func openViewerWindow(_ sender: Any?) {
        Task { @MainActor in AppCommandCenter.shared.openViewerWindow() }
    }

    @objc func openCullingWindow(_ sender: Any?) {
        Task { @MainActor in AppCommandCenter.shared.openCullingWindow() }
    }

    @objc func showPreferences(_ sender: Any?) {
        Task { @MainActor in AppCommandCenter.shared.presentPreferences() }
    }

    @objc func showKeyboardShortcuts(_ sender: Any?) {
        Task { @MainActor in AppCommandCenter.shared.presentKeyboardShortcuts() }
    }

    @objc func toggleBeforeAfter(_ sender: Any?) {
        Task { @MainActor in AppCommandCenter.shared.beforeAfterEnabled.toggle() }
    }

    @objc func toggleExposureWarning(_ sender: Any?) {
        Task { @MainActor in AppCommandCenter.shared.showExposureWarning.toggle() }
    }

    @objc func toggleFocusMask(_ sender: Any?) {
        Task { @MainActor in AppCommandCenter.shared.showFocusMask.toggle() }
    }

    @objc func toggleProofing(_ sender: Any?) {
        Task { @MainActor in AdjustmentToolController.shared.isSoftProofingEnabled.toggle() }
    }

    @objc func toggleGrid(_ sender: Any?) {
        Task { @MainActor in AppCommandCenter.shared.showGridOverlay.toggle() }
    }

    @objc func showTips(_ sender: Any?) {
        Task { @MainActor in AppCommandCenter.shared.showTips() }
    }

    @objc func undo(_ sender: Any?) {
        Task { @MainActor in AppCommandCenter.shared.undo() }
    }

    @objc func redo(_ sender: Any?) {
        Task { @MainActor in AppCommandCenter.shared.redo() }
    }

    // MARK: - Menu Builder

    private func buildMainMenu() -> NSMenu {
        let mainMenu = NSMenu()

        let appMenuItem = NSMenuItem()
        mainMenu.addItem(appMenuItem)
        let appMenu = NSMenu()
        appMenuItem.submenu = appMenu
        appMenu.addItem(withTitle: "Preferences...", action: #selector(showPreferences(_:)), keyEquivalent: ",").target = self
        appMenu.addItem(.separator())
        appMenu.addItem(withTitle: "Quit Capture One", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")

        let fileMenuItem = NSMenuItem()
        mainMenu.addItem(fileMenuItem)
        let fileMenu = NSMenu(title: "File")
        fileMenuItem.submenu = fileMenu
        
        fileMenu.addItem(withTitle: "New Catalog...", action: #selector(newCatalog(_:)), keyEquivalent: "n").target = self
        fileMenu.addItem(withTitle: "New Session...", action: #selector(newSession(_:)), keyEquivalent: "N").target = self
        fileMenu.addItem(withTitle: "Open...", action: #selector(openDocument(_:)), keyEquivalent: "o").target = self
        
        let openRecentItem = NSMenuItem(title: "Open Recent", action: nil, keyEquivalent: "")
        let openRecentMenu = NSMenu(title: "Open Recent")
        openRecentMenu.addItem(withTitle: "Clear Menu", action: #selector(NSDocumentController.clearRecentDocuments(_:)), keyEquivalent: "")
        openRecentItem.submenu = openRecentMenu
        fileMenu.addItem(openRecentItem)
        
        fileMenu.addItem(.separator())
        fileMenu.addItem(withTitle: "Import Images...", action: #selector(importImages(_:)), keyEquivalent: "i").target = self
        fileMenu.addItem(withTitle: "Export Images...", action: #selector(exportImages(_:)), keyEquivalent: "e").target = self
        fileMenu.addItem(withTitle: "Print...", action: #selector(printImages(_:)), keyEquivalent: "p").target = self
        fileMenu.addItem(.separator())
        fileMenu.addItem(withTitle: "Close Window", action: #selector(NSWindow.performClose(_:)), keyEquivalent: "w")

        let editMenuItem = NSMenuItem()
        mainMenu.addItem(editMenuItem)
        let editMenu = NSMenu(title: "Edit")
        editMenuItem.submenu = editMenu
        editMenu.addItem(withTitle: "Undo", action: #selector(undo(_:)), keyEquivalent: "z").target = self
        editMenu.addItem(withTitle: "Redo", action: #selector(redo(_:)), keyEquivalent: "Z").target = self
        editMenu.addItem(.separator())
        editMenu.addItem(withTitle: "Keyboard Shortcuts...", action: #selector(showKeyboardShortcuts(_:)), keyEquivalent: "k").target = self

        let viewMenuItem = NSMenuItem()
        mainMenu.addItem(viewMenuItem)
        let viewMenu = NSMenu(title: "View")
        viewMenuItem.submenu = viewMenu
        viewMenu.addItem(withTitle: "Before/After", action: #selector(toggleBeforeAfter(_:)), keyEquivalent: "y").target = self
        viewMenu.addItem(withTitle: "Exposure Warning", action: #selector(toggleExposureWarning(_:)), keyEquivalent: "j").target = self
        viewMenu.addItem(withTitle: "Focus Mask", action: #selector(toggleFocusMask(_:)), keyEquivalent: "m").target = self
        viewMenu.addItem(withTitle: "Recipe Proofing", action: #selector(toggleProofing(_:)), keyEquivalent: "r").target = self
        viewMenu.addItem(withTitle: "Grid Overlay", action: #selector(toggleGrid(_:)), keyEquivalent: "g").target = self

        let windowMenuItem = NSMenuItem()
        mainMenu.addItem(windowMenuItem)
        let windowMenu = NSMenu(title: "Window")
        windowMenuItem.submenu = windowMenu
        windowMenu.addItem(withTitle: "Minimize", action: #selector(NSWindow.performMiniaturize(_:)), keyEquivalent: "m")
        windowMenu.addItem(withTitle: "Zoom", action: #selector(NSWindow.performZoom(_:)), keyEquivalent: "")
        windowMenu.addItem(.separator())
        windowMenu.addItem(withTitle: "Live View", action: #selector(openLivePreview(_:)), keyEquivalent: "l").target = self
        windowMenu.addItem(withTitle: "New Viewer", action: #selector(openViewerWindow(_:)), keyEquivalent: "V").target = self
        windowMenu.addItem(withTitle: "Culling", action: #selector(openCullingWindow(_:)), keyEquivalent: "").target = self
        NSApp.windowsMenu = windowMenu

        let helpMenuItem = NSMenuItem()
        mainMenu.addItem(helpMenuItem)
        let helpMenu = NSMenu(title: "Help")
        helpMenuItem.submenu = helpMenu
        helpMenu.addItem(withTitle: "Capture One Tips", action: #selector(showTips(_:)), keyEquivalent: "?").target = self

        return mainMenu
    }
}

autoreleasepool {
    let app = NSApplication.shared
    let delegate = AppDelegate()
    app.delegate = delegate
    app.setActivationPolicy(.regular)
    app.run()
}
