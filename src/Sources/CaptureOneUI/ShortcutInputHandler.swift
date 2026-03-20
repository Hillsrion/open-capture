import Foundation
import AppKit
import AppCoreShared

/// Reconstructed global keyboard event listener and Speed Edit engine (INT-002, UI-204).
/// Based on disassembly of keyboardShortcutsMonitor and SpeedEdit controller.
@MainActor
public class ShortcutInputHandler {
    public static let shared = ShortcutInputHandler()
    private var keyDownMonitor: Any?
    private var keyUpMonitor: Any?
    private var scrollMonitor: Any?
    private var flagsMonitor: Any?
    private var mouseMonitor: Any?
    
    // Speed Edit state
    private var speedEditController = COSpeedEditController.shared
    private var initialMousePos: CGPoint? = nil
    
    // Pan Tool state
    private var isSpaceBarPressed: Bool = false
    private var previousCursorToolID: String? = nil
    
    private init() {}
    
    public func startMonitoring() {
        // Prevent duplicate monitors
        stopMonitoring()
        
        flagsMonitor = NSEvent.addLocalMonitorForEvents(matching: .flagsChanged) { [weak self] event in
            Task { @MainActor in
                AdjustmentToolController.shared.multiViewPanning = event.modifierFlags.contains(.shift)
            }
            return event
        }
        
        keyDownMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            return self?.handleKeyDown(event) ?? event
        }
        
        keyUpMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyUp) { [weak self] event in
            return self?.handleKeyUp(event) ?? event
        }
        
        scrollMonitor = NSEvent.addLocalMonitorForEvents(matching: .scrollWheel) { [weak self] event in
            return self?.handleScroll(event) ?? event
        }
        
        mouseMonitor = NSEvent.addLocalMonitorForEvents(matching: [.leftMouseDown, .leftMouseDragged, .leftMouseUp]) { [weak self] event in
            return self?.handleMouseEvent(event) ?? event
        }
    }
    
    private func handleMouseEvent(_ event: NSEvent) -> NSEvent? {
        guard speedEditController.activeAction != nil else { return event }
        
        switch event.type {
        case .leftMouseDown:
            initialMousePos = event.locationInWindow
            return nil // Consume to prevent standard interaction if Speed Edit key is held
            
        case .leftMouseDragged:
            guard let startPos = initialMousePos else { return event }
            let currentPos = event.locationInWindow
            let delta = Float(currentPos.x - startPos.x)
            
            // Apply speed edit based on horizontal drag
            speedEditController.handleDrag(deltaX: delta)
            
            // Reset start position for incremental delta
            initialMousePos = currentPos
            return nil
            
        case .leftMouseUp:
            initialMousePos = nil
            return nil
            
        default:
            return event
        }
    }
    
    private func applySpeedEdit(key: String, delta: Float) {
        // Legacy method maintained for scroll support
        let controller = AdjustmentToolController.shared
        let sensitivity: Float = 0.5 // Adjust as needed
        
        switch key {
        case "Exposure": controller.exposure = max(-4.0, min(4.0, controller.exposure + (delta * sensitivity * 0.01)))
        case "Contrast": controller.contrast = max(-50, min(50, controller.contrast + (delta * sensitivity)))
        case "Brightness": controller.brightness = max(-50, min(50, controller.brightness + (delta * sensitivity)))
        case "Saturation": controller.saturation = max(-100, min(100, controller.saturation + (delta * sensitivity)))
        case "Highlights": controller.highlights = max(-100, min(100, controller.highlights + (delta * sensitivity)))
        case "Shadows": controller.shadows = max(-100, min(100, controller.shadows + (delta * sensitivity)))
        case "Whites": controller.whites = max(-100, min(100, controller.whites + (delta * sensitivity)))
        case "Blacks": controller.blacks = max(-100, min(100, controller.blacks + (delta * sensitivity)))
        default: break
        }
        speedEditController.updateCurrentValue()
    }
    
    private func handleKeyDown(_ event: NSEvent) -> NSEvent? {
        guard let chars = event.charactersIgnoringModifiers?.lowercased() else { return event }
        
        // Temporary Pan Tool (Spacebar)
        if chars == " " && !event.isARepeat {
            isSpaceBarPressed = true
            Task { @MainActor in
                let commands = AppCommandCenter.shared
                if commands.selectedCursorToolID != "Pan" {
                    self.previousCursorToolID = commands.selectedCursorToolID
                    commands.selectedCursorToolID = "Pan"
                }
            }
            return nil
        }
        
        // Apply Crop (Enter)
        if chars == "\r" {
            Task { @MainActor in
                AppCommandCenter.shared.applyCrop()
            }
            return nil
        }
        
        // Brush Adjustments (Portrait Workflow Spec)
        if chars == "[" || chars == "]" {
            let increment: Float = event.modifierFlags.contains(.shift) ? 0 : (chars == "]" ? 5 : -5)
            let hardnessIncrement: Float = event.modifierFlags.contains(.shift) ? (chars == "]" ? 10 : -10) : 0
            
            Task { @MainActor in
                let manager = BrushSettingsManager.shared
                if increment != 0 {
                    manager.drawBrushSettings.size = max(1, min(500, manager.drawBrushSettings.size + increment))
                }
                if hardnessIncrement != 0 {
                    manager.drawBrushSettings.hardness = max(0, min(100, manager.drawBrushSettings.hardness + hardnessIncrement))
                }
            }
            return nil
        }
        
        // Speed Edit Keys (Default Capture One mapping)
        if !event.isARepeat {
            switch chars {
            case "q": speedEditController.handleKeyDown(action: .exposure)
            case "w": speedEditController.handleKeyDown(action: .contrast)
            case "e": speedEditController.handleKeyDown(action: .brightness)
            case "r": speedEditController.handleKeyDown(action: .saturation)
            case "a": speedEditController.handleKeyDown(action: .highlights)
            case "s": speedEditController.handleKeyDown(action: .shadows)
            case "d": speedEditController.handleKeyDown(action: .whites)
            case "f": speedEditController.handleKeyDown(action: .blacks)
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
            return nil // Handled by ShortcutManager
        }
        
        return event
    }
    
    private func handleKeyUp(_ event: NSEvent) -> NSEvent? {
        guard let chars = event.charactersIgnoringModifiers?.lowercased() else { return event }
        
        // Temporary Pan Tool Release
        if chars == " " {
            isSpaceBarPressed = false
            if let prev = previousCursorToolID {
                Task { @MainActor in
                    AppCommandCenter.shared.selectedCursorToolID = prev
                }
                previousCursorToolID = nil
            }
            return nil
        }
        
        let releasedAction: COSpeedEditController.SpeedEditAction?
        switch chars {
        case "q": releasedAction = .exposure
        case "w": releasedAction = .contrast
        case "e": releasedAction = .brightness
        case "r": releasedAction = .saturation
        case "a": releasedAction = .highlights
        case "s": releasedAction = .shadows
        case "d": releasedAction = .whites
        case "f": releasedAction = .blacks
        default: releasedAction = nil
        }
        
        if let releasedAction = releasedAction, releasedAction == speedEditController.activeAction {
            speedEditController.handleKeyUp()
        }
        
        return event
    }
    
    private func handleScroll(_ event: NSEvent) -> NSEvent? {
        // deltaY > 0 means scrolling up (increase), deltaY < 0 means scrolling down (decrease)
        let delta = Float(event.deltaY)
        guard delta != 0 else { return event }
        
        let controller = AdjustmentToolController.shared
        
        if let activeAction = speedEditController.activeAction {
            // Dispatch to speed edit logic
            speedEditController.handleDrag(deltaX: delta * 10.0) 
            return nil // Consume scroll event
        } else {
            // Scroll wheel Zoom logic
            // In Capture One, scroll zooms when Pan tool is active OR Option is held
            let isOptionHeld = event.modifierFlags.contains(.option)
            let isPanTool = AppCommandCenter.shared.selectedCursorToolID == "Pan"
            
            if isPanTool || isOptionHeld {
                let zoomSensitivity: Double = 0.05
                let currentZoom = controller.zoomLevel
                let newZoom = max(0.1, min(4.0, currentZoom + (Double(delta) * zoomSensitivity)))
                
                if newZoom != currentZoom {
                    Task { @MainActor in
                        controller.zoomLevel = newZoom
                    }
                    return nil // Consume scroll event
                }
            }
        }
        
        return event
    }
    
    public func stopMonitoring() {
        if let km = keyDownMonitor { NSEvent.removeMonitor(km) }
        if let ku = keyUpMonitor { NSEvent.removeMonitor(ku) }
        if let sm = scrollMonitor { NSEvent.removeMonitor(sm) }
        if let fm = flagsMonitor { NSEvent.removeMonitor(fm) }
        if let mm = mouseMonitor { NSEvent.removeMonitor(mm) }
    }
}
