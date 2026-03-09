import Foundation

/// Reconstructed Manager for Hardware Controllers (INT-005).
/// Translates physical events (knobs, dials) into software actions based on mappings.
public class HardwareControllerManager: ObservableObject {
    public static let shared = HardwareControllerManager()
    
    @Published public var isConnected: Bool = false
    @Published public var activeMappings: [HardwareMapping] = []
    
    // Delegate to handle the actual software mutation (usually AdjustmentToolController)
    public var actionDelegate: HardwareActionDelegate?
    
    public init() {
        loadDefaultMappings()
    }
    
    private func loadDefaultMappings() {
        // Mock default mappings for a generic controller
        activeMappings = [
            HardwareMapping(controlID: "knob_1", actionID: "adjustExposure", sensitivity: 0.1),
            HardwareMapping(controlID: "knob_2", actionID: "adjustContrast", sensitivity: 0.5),
            HardwareMapping(controlID: "dial_1", actionID: "adjustKelvin", sensitivity: 50.0)
        ]
    }
    
    /// Called by the hardware driver (or mock) when a physical event occurs.
    public func receiveEvent(_ event: HardwareEvent) {
        guard let mapping = activeMappings.first(where: { $0.controlID == event.controlID }) else {
            print("[Hardware] Unmapped control: \(event.controlID)")
            return
        }
        
        let scaledDelta = event.delta * mapping.sensitivity
        print("[Hardware] Routing event: \(mapping.actionID) with delta \(scaledDelta)")
        
        // Dispatch to the UI controller
        actionDelegate?.handleHardwareAction(actionID: mapping.actionID, delta: scaledDelta)
    }
}

/// Protocol for the component that applies hardware actions to the model.
public protocol HardwareActionDelegate: AnyObject {
    func handleHardwareAction(actionID: String, delta: Double)
}
