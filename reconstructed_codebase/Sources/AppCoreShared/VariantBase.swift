import Foundation

/// Reconstructed Base class for Variant entities in AppCoreShared.
/// Based on version 16.5.9.7 metadata.
public class VariantBase: BaseObject {
    
    // MARK: - Properties (Core Identity)
    public let variantUUID: String
    public var tempUUID: String?
    
    // MARK: - Internal Row State (Placeholders)
    internal var row: Any?
    
    // MARK: - State Flags
    @objc public var isModified: Bool {
        willSet { willChangeValue(forKey: "isModified") }
        didSet { didChangeValue(forKey: "isModified") }
    }
    
    public var isLoading: Bool
    public var isProxyReady: Bool
    public var isAlive: Bool
    
    // MARK: - Relationships
    public var image: ImageBase?
    public var mcVariant: MCVariant?
    
    // MARK: - Initialization
    public init(variantUUID: String, image: ImageBase?, context: ObjectContext?) {
        self.variantUUID = variantUUID
        self.image = image
        self.isModified = false
        self.isLoading = false
        self.isProxyReady = false
        self.isAlive = true
        super.init(managedObjectContext: context)
    }
    
    // MARK: - Methods
    
    public func reset() {
        willChangeValue(forKey: "isModified")
        self.isModified = false
        didChangeValue(forKey: "isModified")
    }
}
