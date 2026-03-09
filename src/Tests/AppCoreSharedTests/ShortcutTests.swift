import XCTest
import AppKit
@testable import AppCoreShared

class ShortcutTests: XCTestCase {
    
    func testShortcutRegistrationAndTrigger() {
        let manager = ShortcutManager.shared
        var actionTriggered = false
        
        // 1. Register action
        manager.registerAction(id: "test.reset") {
            actionTriggered = true
        }
        
        // 2. Map shortcut
        let shortcut = KeyboardShortcut(key: "r", modifiers: .command, actionID: "test.reset")
        manager.activeSet.shortcuts.append(shortcut)
        
        // 3. Trigger
        let handled = manager.handleShortcut(shortcut)
        XCTAssertTrue(handled)
        XCTAssertTrue(actionTriggered)
    }
    
    func testConflictDetection() {
        let manager = ShortcutManager.shared
        let s1 = KeyboardShortcut(key: "e", modifiers: .command, actionID: "action.1")
        manager.activeSet.shortcuts = [s1]
        
        let conflict = manager.hasConflict(for: s1)
        XCTAssertEqual(conflict, "action.1")
        
        let s2 = KeyboardShortcut(key: "x", modifiers: .command, actionID: "action.2")
        XCTAssertNil(manager.hasConflict(for: s2))
    }
}
