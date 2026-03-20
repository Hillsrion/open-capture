import Foundation
import ImageCore

/// High-level wrapper for an export recipe.
/// Based on _TtC12AppCoreShared12OutputRecipe metadata.
public class OutputRecipe: BaseObject, Identifiable, ExportRecipeInfo {
    public var id: String { name }
    public let mcRecipe: MCRecipe
    
    public enum FileFormat: String, Codable, CaseIterable {
        case jpeg = "JPEG"
        case tiff = "TIFF"
        case png = "PNG"
        case psd = "PSD"
        case dng = "DNG"
    }
    
    public enum ScaleType: Int, Codable {
        case fixed = 0
        case width = 1
        case height = 2
        case longEdge = 3
        case shortEdge = 4
        case widthAndHeight = 5
        case percentage = 6
    }
    
    public init(name: String, recipe: MCRecipe, context: ObjectContext) {
        self.mcRecipe = recipe
        self._name = name
        super.init(managedObjectContext: context)
    }
    
    private var _name: String = "Untitled Recipe"
    public var name: String {
        get { _name }
        set {
            _name = newValue
            notifyChange()
        }
    }
    
    public var format: FileFormat {
        get {
            let val = mcRecipe.objectForKey("MCRecipeKeyFileFormat") as? String ?? "JPEG"
            return FileFormat(rawValue: val) ?? .jpeg
        }
        set {
            mcRecipe.setObject(newValue.rawValue, forKey: "MCRecipeKeyFileFormat")
            notifyChange()
        }
    }
    
    public var jpegQuality: Int {
        get { return mcRecipe.objectForKey("MCRecipeKeyJpegQuality") as? Int ?? 80 }
        set {
            mcRecipe.setObject(newValue, forKey: "MCRecipeKeyJpegQuality")
            notifyChange()
        }
    }
    
    public var iccProfile: String {
        get { return mcRecipe.objectForKey("MCRecipeKeyICCOutputProfile") as? String ?? "Adobe RGB (1998)" }
        set {
            mcRecipe.setObject(newValue, forKey: "MCRecipeKeyICCOutputProfile")
            notifyChange()
        }
    }
    
    public var scaleType: ScaleType {
        get {
            let val = mcRecipe.objectForKey("MCRecipeKeyScaleType") as? Int ?? 0
            return ScaleType(rawValue: val) ?? .fixed
        }
        set {
            mcRecipe.setObject(newValue.rawValue, forKey: "MCRecipeKeyScaleType")
            notifyChange()
        }
    }
    
    public var isEnabled: Bool = true {
        didSet { notifyChange() }
    }
    
    public var outputFolder: String? {
        get { return mcRecipe.objectForKey("MCRecipeKeyDestinationRootFolder") as? String }
        set {
            mcRecipe.setObject(newValue, forKey: "MCRecipeKeyDestinationRootFolder")
            notifyChange()
        }
    }
    
    public var fileNameTokens: String {
        get { return mcRecipe.objectForKey("MCRecipeKeyNamingFormat") as? String ?? "[Image Name]" }
        set {
            mcRecipe.setObject(newValue, forKey: "MCRecipeKeyNamingFormat")
            notifyChange()
        }
    }
    
    // EIP Support (CORE-006)
    public var packAsEIP: Bool {
        get { return mcRecipe.objectForKey("MCRecipeKeyPackAsEIP") as? Bool ?? false }
        set {
            mcRecipe.setObject(newValue, forKey: "MCRecipeKeyPackAsEIP")
            notifyChange()
        }
    }
    
    // Annotations Support (UI-204)
    public var includeAnnotations: Bool {
        get { return mcRecipe.objectForKey("MCRecipeKeyIncludeAnnotations") as? Bool ?? false }
        set {
            mcRecipe.setObject(newValue, forKey: "MCRecipeKeyIncludeAnnotations")
            notifyChange()
        }
    }
    
    public var annotationsAsLayer: Bool {
        get { return mcRecipe.objectForKey("MCRecipeKeyAnnotationsAsLayer") as? Bool ?? false }
        set {
            mcRecipe.setObject(newValue, forKey: "MCRecipeKeyAnnotationsAsLayer")
            notifyChange()
        }
    }
}

/// Manages the collection of recipes.
/// Based on _TtC12AppCoreShared19OutputRecipeManager.
public class OutputRecipeManager: ObservableObject {
    public static let shared = OutputRecipeManager() // Make it a singleton for easier access
    
    @Published public var recipes: [OutputRecipe] = []
    
    // The "primary" recipe is the one that settings are being edited for (orange highlight)
    @Published public var primaryRecipe: OutputRecipe? {
        didSet {
            // Ensure the primary recipe is also enabled if it's selected for editing
            // (Capture One behavior: clicking a recipe selects it as primary)
            if let primary = primaryRecipe {
                // Not necessarily enabled just by being primary, but often they are.
                // However, we must ensure it's NOT nil if we have recipes.
            }
        }
    }
    
    public init() {}
    
    public func addRecipe(_ recipe: OutputRecipe) {
        recipes.append(recipe)
        if primaryRecipe == nil {
            primaryRecipe = recipe
        }
    }
    
    public func removeRecipe(_ recipe: OutputRecipe) {
        let index = recipes.firstIndex { $0 === recipe }
        recipes.removeAll { $0 === recipe }
        if primaryRecipe === recipe {
            primaryRecipe = recipes.first
        }
    }
    
    public var activeRecipes: [OutputRecipe] {
        return recipes.filter { $0.isEnabled }
    }
    
    public static func defaultManager() -> OutputRecipeManager {
        let manager = OutputRecipeManager()
        // Add some default recipes
        let context = ObjectContext()
        manager.addRecipe(OutputRecipe(name: "JPEG Full Size", recipe: MCRecipe(dictionary: [:]), context: context))
        manager.recipes.last?.format = .jpeg
        
        manager.addRecipe(OutputRecipe(name: "TIFF 16-bit", recipe: MCRecipe(dictionary: [:]), context: context))
        manager.recipes.last?.format = .tiff
        
        manager.primaryRecipe = manager.recipes.first
        return manager
    }
}
