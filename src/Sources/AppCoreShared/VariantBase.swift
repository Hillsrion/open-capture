import Foundation

/// Reconstructed Base class for Variant entities in AppCoreShared.
/// Based on version 16.5.9.7 metadata.
public class VariantBase: BaseObject, Identifiable {
    
    public var id: String { variantUUID }
    
    // MARK: - Properties (Core Identity)
    public let variantUUID: String
    public var tempUUID: String?
    
    // MARK: - Core Data Row IDs (Reconstructed from v16.5)
    public var adjustmentLayerRowID: Int64 = 0
    public var defaultLayerRowID: Int64 = 0
    public var combinedSettingsRowID: Int64 = 0
    public var image_rowid: UInt64 = 0
    
    // MARK: - Geometry & Layout
    public var canvasSize: CGSize = .zero
    
    // MARK: - Relationships
    public var collectionLinks: [Any]? // MOCollectionLink placeholder
    public var primaryInCollections: [Any]?
    
    // MARK: - Internal Row State (Placeholders)
    internal var row: Any?
    
    // MARK: - State Flags
    @objc public var isModified: Bool = false {
        willSet { willChangeValue(forKey: "isModified") }
        didSet { didChangeValue(forKey: "isModified") }
    }

    @objc public var isReadOnly: Bool = false {
        willSet { willChangeValue(forKey: "isReadOnly") }
        didSet { didChangeValue(forKey: "isReadOnly") }
    }

    public var isLoading: Bool
    public var isProxyReady: Bool
    public var isAlive: Bool
    
    // MARK: - Relationships
    public var image: ImageBase?
    public var mcVariant: MCVariant?
    
    // MARK: - Layers (ENG-005)
    public var layers: [LayerBase] = []
    public var activeLayerIndex: Int = 0
    
    public var activeLayer: LayerBase? {
        guard activeLayerIndex < layers.count else { return nil }
        return layers[activeLayerIndex]
    }
    
    // MARK: - Rating & Color Tag (CORE-009)
    public var rating: Int {
        get { return (mcVariant?.objectForKey("ZRATING") as? Int) ?? 0 }
        set {
            mcVariant?.setObject(newValue, forKey: "ZRATING")
            isModified = true
        }
    }
    
    public enum ColorTag: Int, Codable, CaseIterable {
        case none = 0
        case red = 1
        case orange = 2
        case yellow = 3
        case green = 4
        case blue = 5
        case purple = 6
        case pink = 7
    }
    
    public var colorTag: ColorTag {
        get {
            let val = (mcVariant?.objectForKey("ZCOLOR_TAG") as? Int) ?? 0
            return ColorTag(rawValue: val) ?? .none
        }
        set {
            mcVariant?.setObject(newValue.rawValue, forKey: "ZCOLOR_TAG")
            isModified = true
        }
    }
    
    // MARK: - Metadata (ENG-005)
    public var keywords: [KeywordEntry] = []
    
    // MARK: - Annotations (UI-007)
    public var annotations: MCAnnotations = MCAnnotations()
    
    // MARK: - Capabilities (Inferred from MOVariant metadata)
    @objc public var canApplyLensCorrection: Bool {
        return image?.canApplyLensCorrection ?? false
    }
    
    @objc public var canApplyChromaticAberration: Bool {
        return image?.canApplyChromaticAberration ?? false
    }
    
    @objc public var canApplyPurpleDeFringe: Bool {
        return image?.canApplyPurpleDeFringe ?? false
    }
    
    // MARK: - Initialization
    public init(variantUUID: String, image: ImageBase?, context: ObjectContext?) {
        self.variantUUID = variantUUID
        self.image = image
        self.isModified = false
        self.isLoading = false
        self.isProxyReady = false
        self.isAlive = true
        super.init(managedObjectContext: context)
        
        // Add default background layer
        let bgLayer = LayerBase(uuid: UUID().uuidString, name: "Background", type: .background, context: context)
        self.layers = [bgLayer]
    }
    
    // MARK: - Methods
    
    public func reset() {
        willChangeValue(forKey: "isModified")
        self.isModified = false
        didChangeValue(forKey: "isModified")
    }
    
    /// Adds a repair arrow to the active layer if it's a heal/clone layer.
    public func addRepairArrow(source: CGPoint, destination: CGPoint, type: RepairArrow.ArrowType) {
        guard let active = activeLayer, (active.type == .heal || active.type == .clone) else { return }
        let arrow = RepairArrow(source: source, destination: destination, type: type)
        active.repairArrows.append(arrow)
        isModified = true
    }
}
