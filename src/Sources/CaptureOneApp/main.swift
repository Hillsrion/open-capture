import Cocoa
import SwiftUI
import AppCoreShared
import DataCore
import ImageCore
import CaptureOneUI

final class AppMenuTarget: NSObject {
    @objc func importImages(_ sender: Any?) {
        Task { @MainActor in
            AppCommandCenter.shared.presentImport()
        }
    }

    @objc func exportImages(_ sender: Any?) {
        Task { @MainActor in
            AppCommandCenter.shared.presentExport()
        }
    }

    @objc func newCatalog(_ sender: Any?) {
        Task { @MainActor in AppCommandCenter.shared.newCatalog() }
    }

    @objc func newSession(_ sender: Any?) {
        Task { @MainActor in AppCommandCenter.shared.newSession() }
    }

    @objc func openDocument(_ sender: Any?) {
        Task { @MainActor in AppCommandCenter.shared.openDocument() }
    }

    @objc func printImages(_ sender: Any?) {
        Task { @MainActor in
            AppCommandCenter.shared.presentPrint()
        }
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
        Task { @MainActor in
            AppCommandCenter.shared.presentPreferences()
        }
    }

    @objc func showKeyboardShortcuts(_ sender: Any?) {
        Task { @MainActor in
            AppCommandCenter.shared.presentKeyboardShortcuts()
        }
    }

    @objc func toggleBeforeAfter(_ sender: Any?) {
        Task { @MainActor in
            AppCommandCenter.shared.beforeAfterEnabled.toggle()
        }
    }

    @objc func toggleExposureWarning(_ sender: Any?) {
        Task { @MainActor in
            AppCommandCenter.shared.showExposureWarning.toggle()
        }
    }

    @objc func toggleFocusMask(_ sender: Any?) {
        Task { @MainActor in
            AppCommandCenter.shared.showFocusMask.toggle()
        }
    }

    @objc func toggleProofing(_ sender: Any?) {
        Task { @MainActor in
            AdjustmentToolController.shared.isSoftProofingEnabled.toggle()
        }
    }

    @objc func toggleGrid(_ sender: Any?) {
        Task { @MainActor in
            AppCommandCenter.shared.showGridOverlay.toggle()
        }
    }

    @objc func showTips(_ sender: Any?) {
        Task { @MainActor in
            AppCommandCenter.shared.showTips()
        }
    }

    @objc func undo(_ sender: Any?) {
        Task { @MainActor in
            AppCommandCenter.shared.undo()
        }
    }

    @objc func redo(_ sender: Any?) {
        Task { @MainActor in
            AppCommandCenter.shared.redo()
        }
    }
}

// MARK: - App Delegate
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    let menuTarget = AppMenuTarget()

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
            AppCommandCenter.shared.newCatalog()
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

    private func buildMainMenu() -> NSMenu {
        let mainMenu = NSMenu()

        let appMenuItem = NSMenuItem()
        mainMenu.addItem(appMenuItem)
        let appMenu = NSMenu()
        appMenuItem.submenu = appMenu
        appMenu.addItem(withTitle: "Preferences...", action: #selector(AppMenuTarget.showPreferences(_:)), keyEquivalent: ",").target = menuTarget
        appMenu.addItem(.separator())
        appMenu.addItem(withTitle: "Quit Capture One", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")

        let fileMenuItem = NSMenuItem()
        mainMenu.addItem(fileMenuItem)
        let fileMenu = NSMenu(title: "File")
        fileMenuItem.submenu = fileMenu
        
        fileMenu.addItem(withTitle: "New Catalog...", action: #selector(AppMenuTarget.newCatalog(_:)), keyEquivalent: "n").target = menuTarget
        fileMenu.addItem(withTitle: "New Session...", action: #selector(AppMenuTarget.newSession(_:)), keyEquivalent: "N").target = menuTarget
        fileMenu.addItem(withTitle: "Open...", action: #selector(AppMenuTarget.openDocument(_:)), keyEquivalent: "o").target = menuTarget
        
        // Open Recent is a standard macOS submenu
        let openRecentItem = NSMenuItem(title: "Open Recent", action: nil, keyEquivalent: "")
        let openRecentMenu = NSMenu(title: "Open Recent")
        openRecentMenu.addItem(withTitle: "Clear Menu", action: #selector(NSDocumentController.clearRecentDocuments(_:)), keyEquivalent: "")
        openRecentItem.submenu = openRecentMenu
        fileMenu.addItem(openRecentItem)
        
        fileMenu.addItem(.separator())
        fileMenu.addItem(withTitle: "Import Images...", action: #selector(AppMenuTarget.importImages(_:)), keyEquivalent: "i").target = menuTarget
        fileMenu.addItem(withTitle: "Export Images...", action: #selector(AppMenuTarget.exportImages(_:)), keyEquivalent: "e").target = menuTarget
        fileMenu.addItem(withTitle: "Print...", action: #selector(AppMenuTarget.printImages(_:)), keyEquivalent: "p").target = menuTarget
        fileMenu.addItem(.separator())
        fileMenu.addItem(withTitle: "Close Window", action: #selector(NSWindow.performClose(_:)), keyEquivalent: "w")

        let editMenuItem = NSMenuItem()
        mainMenu.addItem(editMenuItem)
        let editMenu = NSMenu(title: "Edit")
        editMenuItem.submenu = editMenu
        editMenu.addItem(withTitle: "Undo", action: #selector(AppMenuTarget.undo(_:)), keyEquivalent: "z").target = menuTarget
        editMenu.addItem(withTitle: "Redo", action: #selector(AppMenuTarget.redo(_:)), keyEquivalent: "Z").target = menuTarget
        editMenu.addItem(.separator())
        editMenu.addItem(withTitle: "Keyboard Shortcuts...", action: #selector(AppMenuTarget.showKeyboardShortcuts(_:)), keyEquivalent: "k").target = menuTarget

        let viewMenuItem = NSMenuItem()
        mainMenu.addItem(viewMenuItem)
        let viewMenu = NSMenu(title: "View")
        viewMenuItem.submenu = viewMenu
        viewMenu.addItem(withTitle: "Before/After", action: #selector(AppMenuTarget.toggleBeforeAfter(_:)), keyEquivalent: "y").target = menuTarget
        viewMenu.addItem(withTitle: "Exposure Warning", action: #selector(AppMenuTarget.toggleExposureWarning(_:)), keyEquivalent: "j").target = menuTarget
        viewMenu.addItem(withTitle: "Focus Mask", action: #selector(AppMenuTarget.toggleFocusMask(_:)), keyEquivalent: "m").target = menuTarget
        viewMenu.addItem(withTitle: "Recipe Proofing", action: #selector(AppMenuTarget.toggleProofing(_:)), keyEquivalent: "r").target = menuTarget
        viewMenu.addItem(withTitle: "Grid Overlay", action: #selector(AppMenuTarget.toggleGrid(_:)), keyEquivalent: "g").target = menuTarget

        let windowMenuItem = NSMenuItem()
        mainMenu.addItem(windowMenuItem)
        let windowMenu = NSMenu(title: "Window")
        windowMenuItem.submenu = windowMenu
        windowMenu.addItem(withTitle: "Minimize", action: #selector(NSWindow.performMiniaturize(_:)), keyEquivalent: "m")
        windowMenu.addItem(withTitle: "Zoom", action: #selector(NSWindow.performZoom(_:)), keyEquivalent: "")
        windowMenu.addItem(.separator())
        windowMenu.addItem(withTitle: "Live View", action: #selector(AppMenuTarget.openLivePreview(_:)), keyEquivalent: "l").target = menuTarget
        windowMenu.addItem(withTitle: "New Viewer", action: #selector(AppMenuTarget.openViewerWindow(_:)), keyEquivalent: "V").target = menuTarget
        windowMenu.addItem(withTitle: "Culling", action: #selector(AppMenuTarget.openCullingWindow(_:)), keyEquivalent: "").target = menuTarget
        NSApp.windowsMenu = windowMenu

        let helpMenuItem = NSMenuItem()
        mainMenu.addItem(helpMenuItem)
        let helpMenu = NSMenu(title: "Help")
        helpMenuItem.submenu = helpMenu
        helpMenu.addItem(withTitle: "Capture One Tips", action: #selector(AppMenuTarget.showTips(_:)), keyEquivalent: "?").target = menuTarget

        return mainMenu
    }
}

// MARK: - Main Entry Point
autoreleasepool {
    let app = NSApplication.shared
    app.setActivationPolicy(.regular)
    
    let delegate = AppDelegate()
    app.delegate = delegate
    
    print("[System] Booting...")
    withExtendedLifetime(delegate) {
        app.run()
    }
}
