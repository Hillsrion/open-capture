import Foundation

/// Reconstructed and Neutralized License management classes.
/// These implementations bypass activation and server checks to ensure unrestricted local usage.

public class LicenseInfo: NSObject, NSCopying {
    
    // MARK: - Properties (Mapped from metadata)
    public var licenseKey: String? = "CAPT-UREO-NEPR-OFES-SION-AL00"
    public var trialLicenseKey: String? = nil
    public var companyLicenseKey: String? = "Reconstruction Team"
    public var registrationKey: String? = "REGISTERED"
    public var hardwareId: String? = "LOCAL-HW-ID"
    
    public var holderFirstName: String? = "Pro"
    public var holderLastName: String? = "User"
    public var holderEmail: String? = "pro@reconstructed.local"
    public var holderProfileId: String? = "PROFILE-001"
    public var holderComputerName: String? = "Local-Machine"
    
    // MARK: - Neutralized State Methods
    
    /// Always returns a high number of activations to bypass limits.
    public var activationsLeft: Int32 {
        return 999
    }
    
    /// Always returns Professional (Variant 3 inferred as Pro).
    public var licenseVariant: UInt32 {
        return 3 
    }
    
    /// Always returns highest release level.
    public var releaseLevel: Int32 {
        return 100
    }
    
    public var userMigrated: Bool {
        return true
    }
    
    public var lastCheckResult: String? {
        return "OK"
    }
    
    public var isEligibleForSync: Bool {
        return true
    }
    
    // MARK: - Lifecycle
    
    public override init() {
        super.init()
    }
    
    public func clear() {
        // No-op to prevent license clearing
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = LicenseInfo()
        copy.licenseKey = self.licenseKey
        return copy
    }
}

/// Neutralized Cloud Licensing info
public class CloudSessionLicenseInfo: NSObject {
    public let clientId: String = "CLOUD-CLIENT-ID"
    public let clientName: String = "Cloud-Pro-User"
    public let profileId: String = "CLOUD-PROFILE-ID"
    
    public init(with data: Any? = nil) {
        super.init()
    }
}
