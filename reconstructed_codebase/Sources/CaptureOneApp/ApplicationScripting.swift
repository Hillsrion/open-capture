import AppKit
import AppCoreShared
import CaptureOneUI

/// Reconstructed AppleScript support for NSApplication (INT-004).
extension NSApplication {
    
    /// Scriptable: Return the name of the application.
    @objc public var name: String {
        return "Capture One Reconstructed"
    }
    
    /// Scriptable: Return the version of the application.
    @objc public var version: String {
        return "16.5.9.7" // Reconstructed version
    }
    
    /// Scriptable: Return the open documents (Sessions/Catalogs).
    @objc public var orderedDocuments: [SessionBase] {
        // Mock: In the real app, this would iterate through the DocumentController
        // For the reconstructed app, we fetch the mock session attached to the main window
        if let window = NSApp.windows.first,
           let cullingController = window.windowController as? CullingWindowController,
           let session = cullingController.session {
            return [session]
        }
        return []
    }
}
