import Foundation

/// Reconstructed Data Model for a Hardware Control Event (INT-005).
/// Represents a physical interaction from a surface like Tangent or Loupedeck.
public struct HardwareEvent {
    public let controlID: String // e.g., "knob_1", "dial_2"
    public let delta: Double     // +1.0 for right, -1.0 for left
    public let isPressed: Bool   // For buttons or pressable knobs
    
    public init(controlID: String, delta: Double, isPressed: Bool = false) {
        self.controlID = controlID
        self.delta = delta
        self.isPressed = isPressed
    }
}

/// Reconstructed Mapping Model linking a physical control to a software action.
public struct HardwareMapping: Codable {
    public let controlID: String
    public let actionID: String // e.g., "adjustExposure", "adjustContrast"
    public let sensitivity: Double // Multiplier for the delta
    
    public init(controlID: String, actionID: String, sensitivity: Double = 0.1) {
        self.controlID = controlID
        self.actionID = actionID
        self.sensitivity = sensitivity
    }
}
