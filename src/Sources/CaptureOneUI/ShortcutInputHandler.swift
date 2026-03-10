import Foundation
import AppKit
import AppCoreShared

/// Reconstructed global keyboard event listener and Speed Edit engine (INT-002, UI-204).
/// Based on disassembly of keyboardShortcutsMonitor and SpeedEdit controller.
public class ShortcutInputHandler {
    public static let shared = ShortcutInputHandler()
    private var keyDownMonitor: Any?
    private var keyUpMonitor: Any?
    private var scrollMonitor: Any?
    
    // Speed Edit state
    private var activeSpeedEditKey: String? = nil
    
    private init() {}
    
    /// Starts monitoring local key and scroll events for the application.
    public func startMonitoring() {
        keyDownMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            return self?.handleKeyDown(event) ?? event
        }
        
        keyUpMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyUp) { [weak self] event in
            return self?.handleKeyUp(event) ?? event
        }
        
        scrollMonitor = NSEvent.addLocalMonitorForEvents(matching: .scrollWheel) { [weak self] event in
            return self?.handleScroll(event) ?? event
        }
    }
    
    private func handleKeyDown(_ event: NSEvent) -> NSEvent? {
        guard let chars = event.charactersIgnoringModifiers?.lowercased() else { return event }
        
        // Speed Edit Keys (Default Capture One mapping)
        if !event.isARepeat {
            switch chars {
            case "q": activeSpeedEditKey = "Exposure"; return nil
            case "w": activeSpeedEditKey = "Contrast"; return nil
            case "e": activeSpeedEditKey = "Brightness"; return nil
            case "r": activeSpeedEditKey = "Saturation"; return nil
            case "a": activeSpeedEditKey = "Highlights"; return nil
            case "s": activeSpeedEditKey = "Shadows"; return nil
            case "d": activeSpeedEditKey = "Whites"; return nil
            case "f": activeSpeedEditKey = "Blacks"; return nil
            default: break
            }
        }
        
        // Normal Shortcut Resolution
        let shortcut = KeyboardShortcut(
            key: chars,
            modifiers: event.modifierFlags,
            actionID: ""
        )
        
        if ShortcutManager.shared.handleShortcut(shortcut) {
            return nil // Handled
        }
        
        return event
    }
    
    private func handleKeyUp(_ event: NSEvent) -> NSEvent? {
        guard let chars = event.charactersIgnoringModifiers?.lowercased() else { return event }
        
        let releasedKey: String?
        switch chars {
        case "q": releasedKey = "Exposure"
        case "w": releasedKey = "Contrast"
        case "e": releasedKey = "Brightness"
        case "r": releasedKey = "Saturation"
        case "a": releasedKey = "Highlights"
        case "s": releasedKey = "Shadows"
        case "d": releasedKey = "Whites"
        case "f": releasedKey = "Blacks"
        default: releasedKey = nil
        }
        
        if releasedKey != nil && releasedKey == activeSpeedEditKey {
            activeSpeedEditKey = nil
        }
        
        return event
    }
    
    private func handleScroll(_ event: NSEvent) -> NSEvent? {
        guard let speedEditKey = activeSpeedEditKey else { return event }
        
        // deltaY > 0 means scrolling up (increase), deltaY < 0 means scrolling down (decrease)
        let delta = Float(event.deltaY)
        guard delta != 0 else { return event }
        
        let controller = AdjustmentToolController.shared
        let sensitivity: Float = 1.0 // Could be tied to AppPreferences
        
        // Dispatch to adjustment
        switch speedEditKey {
        case "Exposure": controller.exposure = max(-4.0, min(4.0, controller.exposure + (delta * sensitivity * 0.1)))
        case "Contrast": controller.contrast = max(-50, min(50, controller.contrast + (delta * sensitivity)))
        case "Brightness": controller.brightness = max(-50, min(50, controller.brightness + (delta * sensitivity)))
        case "Saturation": controller.saturation = max(-100, min(100, controller.saturation + (delta * sensitivity)))
        case "Highlights": controller.highlights = max(-100, min(100, controller.highlights + (delta * sensitivity)))
        case "Shadows": controller.shadows = max(-100, min(100, controller.shadows + (delta * sensitivity)))
        case "Whites": controller.whites = max(-100, min(100, controller.whites + (delta * sensitivity)))
        case "Blacks": controller.blacks = max(-100, min(100, controller.blacks + (delta * sensitivity)))
        default: break
        }
        
        // Show temporary HUD overlay for Speed Edit (simulated)
        print("Speed Edit: \(speedEditKey) adjusted by \(delta)")
        
        return nil // Consume scroll event
    }
    
    public func stopMonitoring() {
        if let km = keyDownMonitor { NSEvent.removeMonitor(km) }
        if let ku = keyUpMonitor { NSEvent.removeMonitor(ku) }
        if let sm = scrollMonitor { NSEvent.removeMonitor(sm) }
    }
}
