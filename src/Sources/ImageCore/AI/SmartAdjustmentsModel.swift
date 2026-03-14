import CoreML

/// Reconstructed wrapper for MatchLookModel CoreML model.
/// Used for Smart Adjustments (Exposure, Color, WB matching).
public class MatchLookModelInput: MLFeatureProvider {
    
    /// Input features as MLMultiArray
    public var input: MLMultiArray
    
    public var featureNames: Set<String> {
        return ["input"]
    }
    
    public func featureValue(for featureName: String) -> MLFeatureValue? {
        if featureName == "input" {
            return MLFeatureValue(multiArray: input)
        }
        return nil
    }
    
    public init(input: MLMultiArray) {
        self.input = input
    }
}

/// Output wrapper for MatchLookModel.
public class MatchLookModelOutput: MLFeatureProvider {
    
    public let provider: MLFeatureProvider
    
    /// Resulting adjustment parameters
    public var output: MLMultiArray {
        return try! provider.featureValue(for: "output")!.multiArrayValue!
    }
    
    public var featureNames: Set<String> {
        return provider.featureNames
    }
    
    public func featureValue(for featureName: String) -> MLFeatureValue? {
        return provider.featureValue(for: featureName)
    }
    
    public init(features: MLFeatureProvider) {
        self.provider = features
    }
}

/// Main class for MatchLook inference.
public class MatchLookModel {
    
    public let model: MLModel
    
    public enum Variant: String {
        case exposure = "MatchLookExp"
        case brightness = "MatchLookBrightness"
        case color = "MatchLookColor"
        case bw = "MatchLookBw"
    }
    
    public class func urlOfModelInThisBundle(variant: Variant) -> URL {
        let bundle = Bundle(for: self)
        return bundle.url(forResource: variant.rawValue, withExtension: "mlmodelc")!
    }
    
    public init(model: MLModel) {
        self.model = model
    }
    
    public convenience init(variant: Variant, configuration: MLModelConfiguration = MLModelConfiguration()) throws {
        try self.init(contentsOf: type(of: self).urlOfModelInThisBundle(variant: variant), configuration: configuration)
    }
    
    public convenience init(contentsOf url: URL, configuration: MLModelConfiguration = MLModelConfiguration()) throws {
        let model = try MLModel(contentsOf: url, configuration: configuration)
        self.init(model: model)
    }
    
    public func prediction(input: MatchLookModelInput) throws -> MatchLookModelOutput {
        let outFeatures = try model.prediction(from: input)
        return MatchLookModelOutput(features: outFeatures)
    }
}
