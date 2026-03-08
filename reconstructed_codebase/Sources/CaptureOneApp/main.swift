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

    @objc func printImages(_ sender: Any?) {
        Task { @MainActor in
            AppCommandCenter.shared.presentPrint()
        }
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
        
        // 2. Setup Context
        let _ = ObjectContext()

        // 3. Create the Window
        print("[System] Creating Window...")
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1200, height: 800),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, 
            defer: false)
        
        window.center()
        window.title = "Untitled Catalog"
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.toolbarStyle = .unifiedCompact
        window.backgroundColor = NSColor(calibratedWhite: 0.12, alpha: 1.0)
        NSApp.mainMenu = buildMainMenu()
        
        // 4. Setup Browser Data Source and Adjustment Controller
        let browser = CImageBrowser()
        let adjustmentController = AdjustmentToolController.shared
        let recipeManager = OutputRecipeManager.shared
        let batchQueue = BatchQueue()
        let mockSession = SessionBase(documentUUID: "system-session", type: 1, context: nil)
        mockSession.name = "Untitled Catalog"
        if recipeManager.recipes.isEmpty {
            recipeManager.addRecipe(OutputRecipe(name: "JPEG 80%", recipe: MCRecipe(dictionary: [:]), context: ObjectContext()))
        }
        
        let contentView = CullingView(
            browser: browser,
            adjustmentController: adjustmentController,
            recipeManager: recipeManager,
            batchQueue: batchQueue,
            session: mockSession
        )
        window.contentView = NSHostingView(rootView: contentView)
        
        window.makeKeyAndOrderFront(nil)
        
        // Ensure app comes to front
        NSApp.activate(ignoringOtherApps: true)
        
        print("[System] Initialization complete. Window should be visible.")
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
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
    app.run()
}
