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
    
    public class func urlOfModelInThisBundle(variant: Variant) -> URL? {
        let bundle = Bundle.module
        let resourceName = variant.rawValue
        return bundle.url(forResource: resourceName, withExtension: "mlmodelc") ??
               bundle.url(forResource: "Resources/\(resourceName)", withExtension: "mlmodelc")
    }
    
    public init(model: MLModel) {
        self.model = model
    }
    
    public convenience init(variant: Variant, configuration: MLModelConfiguration = MLModelConfiguration()) throws {
        guard let url = type(of: self).urlOfModelInThisBundle(variant: variant) else {
            throw NSError(domain: "ImageCore.AI", code: 404, userInfo: [NSLocalizedDescriptionKey: "\(variant.rawValue).mlmodelc not found in bundle."])
        }
        try self.init(contentsOf: url, configuration: configuration)
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
import Foundation

/// Reconstructed Descriptor for Smart Adjustments (AI-002).
/// Based on MCSmartAdjustmentsDescriptor.
public struct SmartAdjustmentsDescriptor: Codable, Hashable {
    public var exposureEnabled: Bool
    public var whiteBalanceEnabled: Bool
    
    /// Reference data (e.g., face exposure/Kelvin values).
    /// In the real app, this is a serialized buffer or dictionary.
    public var adjustmentsDescription: Data?
    
    public init(exposureEnabled: Bool = true, whiteBalanceEnabled: Bool = true, description: Data? = nil) {
        self.exposureEnabled = exposureEnabled
        self.whiteBalanceEnabled = whiteBalanceEnabled
        self.adjustmentsDescription = description
    }
}

/// Reference data for Smart Adjustments matching.
public struct SmartAdjustmentsReference: Codable {
    public var faceExposure: Double
    public var faceKelvin: Double
    public var faceTint: Double
    
    public init(exposure: Double, kelvin: Double, tint: Double) {
        self.faceExposure = exposure
        self.faceKelvin = kelvin
        self.faceTint = tint
    }
}
