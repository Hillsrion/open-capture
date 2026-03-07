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
        print("[System] Application Did Finish Launching.")
        
        // Setup Window
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1000, height: 700),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        
        window.center()
        window.title = "Capture One Reconstructed"
        
        // Important: Ensure window is visible
        window.setIsVisible(true)
        window.makeKeyAndOrderFront(nil)
        
        // Setup Content
        let contentView = CullingView()
        window.contentView = NSHostingView(rootView: contentView)
        
        // Force Activation
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
        
        print("[System] UI should be visible now.")
    }
}

// MARK: - Main Entry Point
autoreleasepool {
    let app = NSApplication.shared
    let delegate = AppDelegate()
    app.delegate = delegate
    app.run()
}
