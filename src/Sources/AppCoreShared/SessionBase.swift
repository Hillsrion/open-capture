import Foundation

/// Reconstructed Base class for Session/Catalog entities in AppCoreShared.
/// Represents the primary database and project management container.
/// Based on version 16.5.9.7 metadata.
public class SessionBase: BaseObject {
    
    // MARK: - Properties (Core Identity)
    public let documentUUID: String
    public var name: String?
    public var documentType: Int16 // 0 for Session, 1 for Catalog (inferred)
    
    public var isCatalog: Bool {
        return documentType == 1
    }
    
    // MARK: - Folders & Paths
    public var rootFolder: String?
    public var captureFolder: String?
    public var selectsFolder: String?
    public var outputFolder: String?
    public var trashFolder: String?
    
    @available(*, deprecated, renamed: "outputFolder")
    public var processPath: String? {
        get { outputFolder }
        set { outputFolder = newValue }
    }
    
    public var importFolder: String?
    
    // MARK: - State & Metadata
    public var dateCreated: Date?
    public var dateModified: Date?
    public var lastBackupDate: Date?
    public var isDirty: Bool
    public var readOnly: Bool
    
    // MARK: - Automation & Settings
    public var selectedRecipeName: String?
    public var captureNamingTokenBasedFormat: String?
    
    // MARK: - Relationships
    public var arrangedFixedCollections: [CollectionBase] = []
    public var arrangedUserAlbumCollections: [CollectionBase] = []
    public var arrangedUserFavouriteCollections: [CollectionBase] = []
    public var arrangedUserCachedFolderCollections: [String] = [] // Assuming strings for now, or could be a system folder model
    
    // public var allCollections: FetchArray
    // public var trashCollection: MOCollection?
    // public var captureCollection: MOCollection?
    
    // MARK: - Initialization
    public init(documentUUID: String, type: Int16, context: ObjectContext?) {
        self.documentUUID = documentUUID
        self.documentType = type
        self.isDirty = false
        self.readOnly = false
        super.init(managedObjectContext: context)
    }
    
    /// Reconstructed logic for hydrating a session from database info.
    public init(dictionary: [String: Any], context: ObjectContext?) {
        self.documentUUID = dictionary["ZDOCUMENTUUID"] as? String ?? UUID().uuidString
        self.documentType = dictionary["ZDOCUMENTTYPE"] as? Int16 ?? 0
        self.captureFolder = dictionary["ZCAPTUREFOLDER"] as? String
        self.selectsFolder = dictionary["ZSELECTSFOLDER"] as? String
        self.outputFolder = dictionary["ZOUTPUTFOLDER"] as? String
        self.trashFolder = dictionary["ZTRASHFOLDER"] as? String
        self.isDirty = false
        self.readOnly = false
        super.init(managedObjectContext: context)
    }
    
    // MARK: - Methods (Stubs)
    
    public func backup(to location: URL) {
        // Implementation logic recovery in Phase 2
    }
    
    public func close() {
        // Implementation logic recovery in Phase 2
    }
    
    public func synchronizeCollections() {
        // Implementation logic recovery in Phase 2
    }
}
