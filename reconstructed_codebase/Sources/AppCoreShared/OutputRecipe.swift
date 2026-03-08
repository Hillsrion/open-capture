import Foundation

/// High-level wrapper for an export recipe.
/// Based on _TtC12AppCoreShared12OutputRecipe metadata.
public class OutputRecipe: BaseObject {
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
        super.init(managedObjectContext: context)
        self.name = name
    }
    
    public var name: String = "Untitled Recipe" {
        didSet { notifyChange() }
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
}

/// Manages the collection of recipes.
/// Based on _TtC12AppCoreShared19OutputRecipeManager.
public class OutputRecipeManager: ObservableObject {
    public static let shared = OutputRecipeManager() // Make it a singleton for easier access
    
    @Published public var recipes: [OutputRecipe] = []
    @Published public var primaryRecipe: OutputRecipe? // ENG-011
    
    public init() {}
    
    public func addRecipe(_ recipe: OutputRecipe) {
        recipes.append(recipe)
    }
    
    public func removeRecipe(_ recipe: OutputRecipe) {
        recipes.removeAll { $0 === recipe }
    }
    
    public var activeRecipes: [OutputRecipe] {
        return recipes.filter { $0.isEnabled }
    }
    
    public static func defaultManager() -> OutputRecipeManager {
        let manager = OutputRecipeManager()
        // Add some default recipes if needed
        return manager
    }
}
