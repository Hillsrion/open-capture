import Foundation

// MARK: - Constants (Discovered from ModelCore symbols)
public let MCAdjLayerKeyLensDistortionAmount = "LensDistortionAmount"
public let MCAdjLayerKeyLensDistortionCropType = "LensDistortionCropType"
public let MCAdjLayerKeyLensDistortionPoints = "LensDistortionPoints"
public let MCAdjLayerKeyLensDistortionScale = "LensDistortionScale"

// MARK: - Internal Storage Keys (Z-prefixed)
public let ZLENS_DISTORTION = "ZLENS_DISTORTION"
public let ZLENS_SHARPNESS_FALLOFF = "ZLENS_SHARPNESS_FALLOFF"
public let ZLENS_LIGHT_FALLOFF = "ZLENS_LIGHT_FALLOFF"
public let ZLENS_SHIFT_X = "ZLENS_SHIFT_X"
public let ZLENS_SHIFT_Y = "ZLENS_SHIFT_Y"
public let ZCLIP_DISTORTED_EDGES = "ZCLIP_DISTORTED_EDGES"
public let ZCHROMATIC_ABERRATION = "ZCHROMATIC_ABERRATION"
public let ZDIFFRACTION = "ZDIFFRACTION"
public let ZLCC_ACTIVE = "ZLCC_ACTIVE"
public let ZLCC_PROFILE_UUID = "ZLCC_PROFILE_UUID"

/// Reconstructed Data Model for Lens Correction Settings (ModelCore).
public struct MCLensCorrectionSettings {
    public var distortion: Double = 0.0
    public var sharpnessFalloff: Double = 0.0
    public var lightFalloff: Double = 0.0
    public var lensShiftX: Float = 0.0
    public var lensShiftY: Float = 0.0
    public var clipDistortedEdges: Bool = false
    public var chromaticAberration: Bool = false
    public var diffraction: Bool = false
    public var lccSettings: MCLCCSettings?
    
    public var isLCCActive: Bool {
        return lccSettings?.isActive ?? false
    }
    
    public init() {}
    
    /// Reconstructed logic for extracting settings from a dictionary (MCAdjLayer).
    public init(dictionary: [String: Any]) {
        self.distortion = dictionary[ZLENS_DISTORTION] as? Double ?? (dictionary[MCAdjLayerKeyLensDistortionAmount] as? Double ?? 0.0)
        self.sharpnessFalloff = dictionary[ZLENS_SHARPNESS_FALLOFF] as? Double ?? 0.0
        self.lightFalloff = dictionary[ZLENS_LIGHT_FALLOFF] as? Double ?? 0.0
        self.lensShiftX = dictionary[ZLENS_SHIFT_X] as? Float ?? 0.0
        self.lensShiftY = dictionary[ZLENS_SHIFT_Y] as? Float ?? 0.0
        self.clipDistortedEdges = dictionary[ZCLIP_DISTORTED_EDGES] as? Bool ?? false
        self.chromaticAberration = dictionary[ZCHROMATIC_ABERRATION] as? Bool ?? false
        self.diffraction = dictionary[ZDIFFRACTION] as? Bool ?? false
    }
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
/// Inferred from MCLCCProfile symbols in ModelCore.
public class MCLCCProfile: NSObject, NSCopying {
    public var uuid: String
    public var displayName: String
    private var _cxxProfile: Data? // Placeholder for the actual C++ object data
    
    public init(uuid: String, name: String) {
        self.uuid = uuid
        self.displayName = name
    }
    
    public init(data: Data, displayName: String) {
        self.uuid = UUID().uuidString
        self._cxxProfile = data
        self.displayName = displayName
    }
    
    // Inferred from symbols: profileWithCxxProfile:
    public static func profileWithData(_ data: Data, displayName: String) -> MCLCCProfile {
        return MCLCCProfile(data: data, displayName: displayName)
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = MCLCCProfile(uuid: self.uuid, name: self.displayName)
        copy._cxxProfile = self._cxxProfile
        return copy
    }
    
    public func data() -> Data? {
        return _cxxProfile
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
