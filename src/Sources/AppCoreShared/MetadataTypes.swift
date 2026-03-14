import Foundation

/// Reconstructed IPTC Metadata model (MET-001).
/// Based on AppCoreShared _ImporterMetadata keys and XMP standards.
public struct IPTCData: Codable {
    public var headline: String?
    public var caption: String?
    public var copyright: String?
    public var creator: String?
    public var jobIdentifier: String?
    public var keywords: [String]
    
    // Geographical
    public var city: String?
    public var state: String?
    public var country: String?
    
    public init() {
        self.keywords = []
    }
}

/// Tracking state for metadata synchronization.
/// Mimics MCMetadataState from ModelCore.
public enum MetadataSyncStatus: Int, Codable {
    case synchronized = 0
    case localChanges = 1
    case remoteChanges = 2 // XMP file newer than DB
    case conflict = 3
}

/// Container for Image metadata and its sync state.
public struct ImageMetadata: Identifiable, Codable {
    public var id: String { imagePath }
    public let imagePath: String
    public var iptc: IPTCData
    public var syncStatus: MetadataSyncStatus
    public var lastSyncDate: Date
    
    public init(imagePath: String) {
        self.imagePath = imagePath
        self.iptc = IPTCData()
        self.syncStatus = .synchronized
        self.lastSyncDate = Date()
    }
}
