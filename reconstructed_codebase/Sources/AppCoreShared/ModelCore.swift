import Foundation

/// Reconstructed Base class for Image settings in ModelCore.
/// This class handles the actual raw settings and persistency.
public class MCImage: NSObject {
    public var settings: [String: Any] = [:]
    
    public init(dictionary: [String: Any]) {
        self.settings = dictionary
        super.init()
    }
    
    public func objectForKey(_ key: String) -> Any? {
        return settings[key]
    }
}

/// Reconstructed Base class for Adjustment Layers in ModelCore.
public class MCAdjLayer: NSObject {
    public var properties: [String: Any] = [:]
    public var layerKey: String?
    
    public init(dictionary: [String: Any]) {
        self.properties = dictionary
        super.init()
    }
    
    public func objectForKey(_ key: String) -> Any? {
        return properties[key]
    }
    
    public func setObject(_ object: Any?, forKey key: String) {
        if let object = object {
            properties[key] = object
        } else {
            properties.removeValue(forKey: key)
        }
    }
}

public class MCSidecarsTracker: NSObject {
    // Stub for tracking sidecar changes
}

/// Reconstructed Base class for Variant settings in ModelCore.
/// Handles the layer stack, styles, and non-destructive adjustments.
public class MCVariant: NSObject {
    public var properties: [String: Any] = [:]
    public var layers: [MCAdjLayer] = []
    
    public init(dictionary: [String: Any]) {
        self.properties = dictionary
        super.init()
    }
    
    public static func variantWithDictionary(_ dictionary: [String: Any]) -> MCVariant {
        return MCVariant(dictionary: dictionary)
    }
    
    public func cloneWithDictionary(_ dictionary: [String: Any]) -> MCVariant {
        let clone = MCVariant(dictionary: dictionary)
        clone.layers = self.layers
        return clone
    }
    
    public func objectForKey(_ key: String) -> Any? {
        return properties[key]
    }
    
    public func objectForKeyedSubscript(_ key: String) -> Any? {
        return properties[key]
    }
    
    public func setObject(_ object: Any?, forKey key: String) {
        if let object = object {
            properties[key] = object
        } else {
            properties.removeValue(forKey: key)
        }
    }
    
    public func variantByAddingStyle(_ style: Any, sidecarsTracker: MCSidecarsTracker? = nil) -> MCVariant {
        let newVariant = cloneWithDictionary(self.properties)
        // Style merge logic here
        return newVariant
    }
    
    public func layerObjectForLayerKey(_ key: String, sidecarsTracker: MCSidecarsTracker? = nil) -> MCAdjLayer? {
        return layers.first { $0.layerKey == key }
    }
}

/// Reconstructed Base class for Export Recipes in ModelCore.
public class MCRecipe: NSObject {
    public var properties: [String: Any] = [:]
    
    public init(dictionary: [String: Any]) {
        self.properties = dictionary
        super.init()
    }
    
    public func objectForKey(_ key: String) -> Any? {
        return properties[key]
    }
    
    public func setObject(_ object: Any?, forKey key: String) {
        if let object = object {
            properties[key] = object
        } else {
            properties.removeValue(forKey: key)
        }
    }
    
    public static func allKeys() -> [String] {
        return [
            "MCRecipeKeyFileFormat",
            "MCRecipeKeyJpegQuality",
            "MCRecipeKeyDestinationRootFolder",
            "MCRecipeKeyDestinationSubFolder",
            "MCRecipeKeyICCOutputProfile",
            "MCRecipeKeyScaleType",
            "MCRecipeKeyScaleValue",
            "MCRecipeKeyMetadataIncludeAll",
            "MCRecipeKeyNamingFormat"
        ]
    }
}
