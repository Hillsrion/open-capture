import Foundation
import AppKit
import AppCoreShared

/// Reconstructed global keyboard event listener (INT-002).
/// Based on disassembly of keyboardShortcutsMonitor.
public class ShortcutInputHandler {
    public static let shared = ShortcutInputHandler()
    private var monitor: Any?
    
    private init() {}
    
    /// Starts monitoring local key events for the application.
    public func startMonitoring() {
        monitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            if self?.handleKeyEvent(event) == true {
                return nil // Event handled, swallow it
            }
            return event
        }
    }
    
    /// Reconstructed logic for resolving an NSEvent to a KeyboardShortcut.
    private func handleKeyEvent(_ event: NSEvent) -> Bool {
        guard let chars = event.charactersIgnoringModifiers?.lowercased() else { return false }
        
        let shortcut = KeyboardShortcut(
            key: chars,
            modifiers: event.modifierFlags,
            actionID: "" // Not needed for lookup
        )
        
        return ShortcutManager.shared.handleShortcut(shortcut)
    }
    
    public func stopMonitoring() {
        if let monitor = monitor {
            NSEvent.removeMonitor(monitor)
        }
    }
}
