import Cocoa
import SwiftUI
import AppCoreShared
import DataCore
import ImageCore
import CaptureOneUI

// MARK: - App Delegate
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!

    func applicationDidFinishLaunching(_ notification: Notification) {
        print("[System] App launched. Initializing...")
        
        // 1. Initialize Reconstructed Core (with safety)
        let _ = B2CIdentityManager.shared
        let _ = LicenseInfo()
        
        // 2. Setup Context
        let context = ObjectContext()

        // 3. Create the Window
        print("[System] Creating Window...")
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1200, height: 800),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, 
            defer: false)
        
        window.center()
        window.title = "Capture One Reconstructed"
        window.backgroundColor = NSColor(calibratedWhite: 0.12, alpha: 1.0)
        
        // 4. Setup Browser Data Source
        let browser = CImageBrowser()
        // Note: For testing, the CullingWindowController logic will trigger the scan.
        // We initialize the view with the browser.
        
        let contentView = CullingView(browser: browser)
        window.contentView = NSHostingView(rootView: contentView)
        
        window.makeKeyAndOrderFront(nil)
        
        // Ensure app comes to front
        NSApp.activate(ignoringOtherApps: true)
        
        print("[System] Initialization complete. Window should be visible.")
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
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
