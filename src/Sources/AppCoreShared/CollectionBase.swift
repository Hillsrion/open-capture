import Foundation

/// Reconstructed Base class for Collection entities in AppCoreShared.
/// Based on version 16.5.9.7 metadata.
public class CollectionBase: BaseObject {
    
    // MARK: - Properties (Core Identity)
    public let uuid: String
    public var name: String?
    public var itemCount: Int = 0
    
    // MARK: - State & Metadata
    public var isVariantBased: Bool
    public var isSmartAlbum: Bool = false
    public var isComplete: Bool
    public var isCloud: Bool
    public var isCloudOnly: Bool
    
    // MARK: - Relationships
    public weak var parent: CollectionBase?
    
    // MARK: - Initialization
    public init(uuid: String, context: ObjectContext?) {
        self.uuid = uuid
        self.isVariantBased = false
        self.isComplete = false
        self.isCloud = false
        self.isCloudOnly = false
        super.init(managedObjectContext: context)
    }
}
