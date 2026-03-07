import Foundation

/// Reconstructed Data Model for Lens Correction Settings (ModelCore).
public struct MCLensCorrectionSettings {
    public var distortion: Double = 0.0
    public var lightFalloff: Double = 0.0
    public var sharpnessFalloff: Double = 0.0
    public var lccSettings: MCLCCSettings?
    
    public var isLCCActive: Bool {
        return lccSettings?.isActive ?? false
    }
    
    public init() {}
}

/// Reconstructed Data Model for Lens Cast Calibration (LCC) Settings (ModelCore).
public struct MCLCCSettings {
    public var profile: MCLCCProfile?
    public var isActive: Bool = false
    
    public init(profile: MCLCCProfile? = nil, isActive: Bool = false) {
        self.profile = profile
        self.isActive = isActive
    }
}

/// Reconstructed Data Model for LCC Profile (ModelCore).
public struct MCLCCProfile {
    public var uuid: String
    public var name: String
    
    public init(uuid: String, name: String) {
        self.uuid = uuid
        self.name = name
    }
}

/// Reconstructed Manager for Lens Correction and Profiles.
public class LensCorrectionManager {
    public static let shared = LensCorrectionManager()
    
    private var profiles: [MCLCCProfile] = []
    
    public init() {}
    
    public func addProfile(_ profile: MCLCCProfile) {
        profiles.append(profile)
    }
    
    public func profile(withUUID uuid: String) -> MCLCCProfile? {
        return profiles.first { $0.uuid == uuid }
    }
}
