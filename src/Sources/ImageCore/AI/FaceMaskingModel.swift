import CoreML

/// Reconstructed wrapper for FaceMaskingModel CoreML model.
/// Used for precise skin and face segmentation.
public class FaceMaskingModelInput: MLFeatureProvider {
    
    /// Input image as MLMultiArray
    public var input: MLMultiArray
    
    /// Region of Interest (ROIs) for specific face detection
    public var rois: MLMultiArray
    
    public var featureNames: Set<String> {
        return ["input", "rois"]
    }
    
    public func featureValue(for featureName: String) -> MLFeatureValue? {
        if featureName == "input" {
            return MLFeatureValue(multiArray: input)
        } else if featureName == "rois" {
            return MLFeatureValue(multiArray: rois)
        }
        return nil
    }
    
    public init(input: MLMultiArray, rois: MLMultiArray) {
        self.input = input
        self.rois = rois
    }
}

/// Output wrapper for FaceMaskingModel.
public class FaceMaskingModelOutput: MLFeatureProvider {
    
    public let provider: MLFeatureProvider
    
    /// Resulting segmentation mask
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

/// Main class for FaceMaskingModel inference.
public class FaceMaskingModel {
    
    public let model: MLModel
    
    public class var urlOfModelInThisBundle: URL {
        let bundle = Bundle.module
        return bundle.url(forResource: "FaceMaskingModel", withExtension: "mlmodelc")!
    }
    
    public init(model: MTLModel) {
        self.model = model as! MLModel
    }
    
    public convenience init(configuration: MLModelConfiguration = AIConfiguration.default) throws {
        let model = try MLModel(contentsOf: type(of: self).urlOfModelInThisBundle, configuration: configuration)
        self.init(model: model as! MTLModel)
    }
    
    public func prediction(input: FaceMaskingModelInput) throws -> FaceMaskingModelOutput {
        let outFeatures = try model.prediction(from: input)
        return FaceMaskingModelOutput(features: outFeatures)
    }
}
