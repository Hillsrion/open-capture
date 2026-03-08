import Foundation
import AppKit

/// Reconstructed singleton for managing all keyboard shortcuts (INT-002).
public class ShortcutManager: ObservableObject {
    public static let shared = ShortcutManager()
    
    @Published public var activeSet: ShortcutSet
    private var actionRegistry: [String: () -> Void] = [:]
    
    private init() {
        self.activeSet = ShortcutManager.createDefaultSet()
    }
    
    /// Registers an action closure for a specific ID.
    public func registerAction(id: String, action: @escaping () -> Void) {
        actionRegistry[id] = action
    }
    
    /// Triggers the action associated with a shortcut if it exists.
    public func handleShortcut(_ shortcut: KeyboardShortcut) -> Bool {
        if let match = activeSet.shortcuts.first(where: { $0.key == shortcut.key && $0.modifiers == shortcut.modifiers }) {
            if let action = actionRegistry[match.actionID] {
                action()
                return true
            }
        }
        return false
    }
    
    /// Returns the display string for a shortcut mapped to an action.
    public func shortcutString(forActionID id: String) -> String? {
        activeSet.shortcuts.first { $0.actionID == id }?.displayString
    }
    
    /// Checks for overlapping shortcuts.
    public func hasConflict(for shortcut: KeyboardShortcut) -> String? {
        activeSet.shortcuts.first { $0.key == shortcut.key && $0.modifiers == shortcut.modifiers }?.actionID
    }
    
    // MARK: - Predefined Sets
    
    public static func createDefaultSet() -> ShortcutSet {
        let shortcuts = [
            KeyboardShortcut(key: "e", modifiers: .command, actionID: "com.captureone.export"),
            KeyboardShortcut(key: "r", modifiers: .command, actionID: "com.captureone.reset"),
            KeyboardShortcut(key: "1", modifiers: [], actionID: "com.captureone.rate.1"),
            KeyboardShortcut(key: "2", modifiers: [], actionID: "com.captureone.rate.2"),
            KeyboardShortcut(key: "3", modifiers: [], actionID: "com.captureone.rate.3"),
            KeyboardShortcut(key: "4", modifiers: [], actionID: "com.captureone.rate.4"),
            KeyboardShortcut(key: "5", modifiers: [], actionID: "com.captureone.rate.5"),
            KeyboardShortcut(key: "g", modifiers: .command, actionID: "com.captureone.group")
        ]
        return ShortcutSet(name: "Default", shortcuts: shortcuts)
    }
    
    public static func createLightroomSet() -> ShortcutSet {
        let shortcuts = [
            KeyboardShortcut(key: "e", modifiers: [], actionID: "com.captureone.library.export"),
            KeyboardShortcut(key: "d", modifiers: [], actionID: "com.captureone.develop"),
            KeyboardShortcut(key: "r", modifiers: [], actionID: "com.captureone.crop")
        ]
        return ShortcutSet(name: "Lightroom Legacy", shortcuts: shortcuts)
    }
}
