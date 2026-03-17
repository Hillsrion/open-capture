import Foundation
import ImageCore

/// Reconstructed Base class for Image entities in AppCoreShared.
/// Based on version 16.5.9.7 metadata.
public class ImageBase: BaseObject, ICImageMetadataProvider, Identifiable {
    
    public var id: String { imageUUID }
    // MARK: - Properties (Core Identity)
    public let imageUUID: String
    @Published public var path: String
    @Published public var displayName: String
    @Published public var imageFileName: String

    // MARK: - Internal Row State (Placeholders)
    internal var row: Any?
    
    // MARK: - Methods

    /// Physically rename the file on disk and update internal paths.
    public func renameFile(to newName: String) {
        guard !newName.isEmpty && newName != displayName else { return }

        let oldURL = URL(fileURLWithPath: path)
        let directory = oldURL.deletingLastPathComponent()
        let extension_ = oldURL.pathExtension

        let newFileName = extension_.isEmpty ? newName : "\(newName).\(extension_)"
        let newURL = directory.appendingPathComponent(newFileName)

        do {
            try FileManager.default.moveItem(at: oldURL, to: newURL)

            // Update properties
            DispatchQueue.main.async {
                self.path = newURL.path
                self.displayName = newName
                self.imageFileName = newFileName
            }

            print("[ImageBase] Successfully renamed \(oldURL.lastPathComponent) to \(newFileName)")

        } catch {
            print("[ImageBase] Error renaming file: \(error.localizedDescription)")
        }
    }
    
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
    
    // MARK: - Reconstructed State (v16.5)
    public var isInsideCatalog: Bool = true
    public var gpsLatitude: Double = 0.0
    public var gpsAltitude: Double = 0.0
    public var rawFileQuickHash: String?
    
    // EXIF Properties (mapped from ZIMAGE or ZMETADATA)
    public var iso: Int { (mcImage?.objectForKey("ZISO") as? Int) ?? 0 }
    public var aperture: Double { (mcImage?.objectForKey("ZAPERTURE") as? Double) ?? 0.0 }
    public var shutter: Double { (mcImage?.objectForKey("ZSHUTTER") as? Double) ?? 0.0 }
    public var focalLength: Int { (mcImage?.objectForKey("ZFOCALLENGTH") as? Int) ?? 0 }
    public var pixelWidth: Int { (mcImage?.objectForKey("ZWIDTH") as? Int) ?? 0 }
    public var pixelHeight: Int { (mcImage?.objectForKey("ZHEIGHT") as? Int) ?? 0 }
    
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
        let name = (path as NSString).lastPathComponent
        self.displayName = name
        self.imageFileName = name
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
