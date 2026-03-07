import Foundation

/// Reconstructed Base class for Image entities in AppCoreShared.
/// Based on version 16.5.9.7 metadata.
public class ImageBase: BaseObject {
    
    // MARK: - Properties (Core Identity)
    public let imageUUID: String
    public var path: String
    public var displayName: String
    public var imageFileName: String
    
    // MARK: - Internal Row State (Placeholders)
    internal var row: Any?
    
    // MARK: - State Flags
    @objc public var isTrashed: Bool {
        willSet { willChangeValue(forKey: "isTrashed") }
        didSet { didChangeValue(forKey: "isTrashed") }
    }
    
    public var isOffline: Bool
    public var isMissing: Bool
    public var processable: Bool
    public var isMovie: Bool
    public var isPacked: Bool
    public var isCloud: Bool
    public var isCloudOnly: Bool
    
    // EXIF Properties (mapped from ZIMAGE or ZMETADATA)
    public var iso: Int { (mcImage?.objectForKey("ZISO") as? Int) ?? 0 }
    public var aperture: Double { (mcImage?.objectForKey("ZAPERTURE") as? Double) ?? 0.0 }
    public var shutter: Double { (mcImage?.objectForKey("ZSHUTTER") as? Double) ?? 0.0 }
    public var focalLength: Int { (mcImage?.objectForKey("ZFOCALLENGTH") as? Int) ?? 0 }
    
    // MARK: - Capabilities (Inferred from MOImage metadata)
    @objc public var canApplyLensCorrection: Bool {
        // In original, this checks if the image is RAW or has lens profile support
        return true
    }
    
    @objc public var canApplyChromaticAberration: Bool {
        return true
    }
    
    @objc public var canApplyPurpleDeFringe: Bool {
        return true
    }
    
    // MARK: - Relationships
    public var mcImage: MCImage?
    public var variants: [VariantBase] = []
    public var primaryVariant: VariantBase? {
        return variants.first
    }
    
    // MARK: - Initialization
    public init(imageUUID: String, path: String, context: ObjectContext?) {
        self.imageUUID = imageUUID
        self.path = path
        self.displayName = (path as NSString).lastPathComponent
        self.imageFileName = self.displayName
        self.isTrashed = false
        self.isOffline = false
        self.isMissing = false
        self.processable = true
        self.isMovie = false
        self.isPacked = false
        self.isCloud = false
        self.isCloudOnly = false
        super.init(managedObjectContext: context)
    }
}
