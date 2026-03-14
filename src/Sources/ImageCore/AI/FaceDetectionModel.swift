import CoreML

/// Reconstructed wrapper for FaceDetectionFP16 CoreML model.
/// Based on original Objective-C headers from Capture One 16.7.
public class FaceDetectionFP16Input: MLFeatureProvider {
    
    /// Input image as MLMultiArray
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

/// Output wrapper for FaceDetectionFP16 CoreML model.
public class FaceDetectionFP16Output: MLFeatureProvider {
    
    public let provider: MLFeatureProvider
    
    /// Bounding box coordinates
    public var bbox: MLMultiArray {
        return try! provider.featureValue(for: "bbox")!.multiArrayValue!
    }
    
    /// Confidence scores
    public var confidence: MLMultiArray {
        return try! provider.featureValue(for: "confidence")!.multiArrayValue!
    }
    
    /// Facial landmarks
    public var landmark: MLMultiArray {
        return try! provider.featureValue(for: "landmark")!.multiArrayValue!
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

/// Main class for FaceDetectionFP16 inference.
public class FaceDetectionFP16 {
    
    public let model: MLModel
    
    /// Reconstructed URL logic pointing to the bundle.
    /// Original bundle contains -640 and -1080 variants.
    public class func urlOfModelInThisBundle(variant: String = "640") -> URL {
        let bundle = Bundle(for: self)
        return bundle.url(forResource: "FaceDetectionFP16-\(variant)", withExtension: "mlmodelc")!
    }
    
    public init(model: MLModel) {
        self.model = model
    }
    
    public convenience init(variant: String = "640", configuration: MLModelConfiguration = MLModelConfiguration()) throws {
        try self.init(contentsOf: type(of: self).urlOfModelInThisBundle(variant: variant), configuration: configuration)
    }
    
    public convenience init(contentsOf url: URL, configuration: MLModelConfiguration = MLModelConfiguration()) throws {
        let model = try MLModel(contentsOf: url, configuration: configuration)
        self.init(model: model)
    }
    
    public func prediction(input: FaceDetectionFP16Input) throws -> FaceDetectionFP16Output {
        let outFeatures = try model.prediction(from: input)
        return FaceDetectionFP16Output(features: outFeatures)
    }
}
