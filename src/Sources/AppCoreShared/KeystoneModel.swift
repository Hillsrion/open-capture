import Foundation

/// Reconstructed Keystone model for perspective correction (ENG-002/AI-003).
/// Based on disassembly of MOVariant(State) geometryKeystone properties.
public struct KeystoneModel: Codable, Hashable {
    public var tiltX: Double
    public var tiltY: Double
    public var amount: Double
    public var aspect: Double
    public var skew: Double
    public var focalLength: Double
    
    public init() {
        self.tiltX = 0.0
        self.tiltY = 0.0
        self.amount = 0.0
        self.aspect = 0.0
        self.skew = 0.0
        self.focalLength = 35.0 // Default for 35mm equivalent
    }
}

/// Directions for Auto Keystone detection.
public enum KeystoneDirections: Int, Codable {
    case vertical = 1
    case horizontal = 2
    case all = 3
}

/// Interactive Keystone points for the UI.
public struct KeystonePoints: Codable, Hashable {
    public var p0: CGPoint
    public var p1: CGPoint
    public var p2: CGPoint
    public var p3: CGPoint
    
    public init(p0: CGPoint, p1: CGPoint, p2: CGPoint, p3: CGPoint) {
        self.p0 = p0
        self.p1 = p1
        self.p2 = p2
        self.p3 = p3
    }
}
