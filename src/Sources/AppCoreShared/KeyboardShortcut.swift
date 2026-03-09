import Foundation
import AppKit

/// Reconstructed Data Model for a keyboard shortcut (INT-002).
public struct KeyboardShortcut: Codable, Hashable {
    public var key: String
    public var modifiers: UInt
    public var actionID: String
    
    public init(key: String, modifiers: NSEvent.ModifierFlags, actionID: String) {
        self.key = key
        self.modifiers = modifiers.rawValue
        self.actionID = actionID
    }
    
    public var modifierFlags: NSEvent.ModifierFlags {
        NSEvent.ModifierFlags(rawValue: modifiers)
    }
    
    public var displayString: String {
        var str = ""
        if modifierFlags.contains(.command) { str += "⌘" }
        if modifierFlags.contains(.option) { str += "⌥" }
        if modifierFlags.contains(.shift) { str += "⇧" }
        if modifierFlags.contains(.control) { str += "⌃" }
        return str + key.uppercased()
    }
}

/// Reconstructed container for a full collection of shortcuts.
public struct ShortcutSet: Codable {
    public var name: String
    public var shortcuts: [KeyboardShortcut]
    
    public init(name: String, shortcuts: [KeyboardShortcut] = []) {
        self.name = name
        self.shortcuts = shortcuts
    }
}
