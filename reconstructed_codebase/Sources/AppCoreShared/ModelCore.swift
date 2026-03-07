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

/// Reconstructed Base class for Variant settings in ModelCore.
/// Handles the layer stack, styles, and non-destructive adjustments.
public class MCVariant: NSObject {
    public var properties: [String: Any] = [:]
    public var layers: [MCAdjLayer] = []
    
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
    
    public func variantByAddingStyle(_ style: Any) -> MCVariant {
        // Implementation logic recovery: 
        // Create a copy and merge style properties
        let newVariant = MCVariant(dictionary: self.properties)
        newVariant.layers = self.layers
        // Style merge logic here
        return newVariant
    }
}
