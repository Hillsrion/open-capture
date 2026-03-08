import Foundation

/// Reconstructed Descriptor for Smart Adjustments (AI-002).
/// Based on MCSmartAdjustmentsDescriptor.
public struct SmartAdjustmentsDescriptor: Codable, Hashable {
    public var exposureEnabled: Bool
    public var whiteBalanceEnabled: Bool
    
    /// Reference data (e.g., face exposure/Kelvin values).
    /// In the real app, this is a serialized buffer or dictionary.
    public var adjustmentsDescription: Data?
    
    public init(exposureEnabled: Bool = true, whiteBalanceEnabled: Bool = true, description: Data? = nil) {
        self.exposureEnabled = exposureEnabled
        self.whiteBalanceEnabled = whiteBalanceEnabled
        self.adjustmentsDescription = description
    }
}

/// Reference data for Smart Adjustments matching.
public struct SmartAdjustmentsReference: Codable {
    public var faceExposure: Double
    public var faceKelvin: Double
    public var faceTint: Double
    
    public init(exposure: Double, kelvin: Double, tint: Double) {
        self.faceExposure = exposure
        self.faceKelvin = kelvin
        self.faceTint = tint
    }
}
