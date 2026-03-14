import CoreML

/// Reconstructed wrapper for subjectMaskingFP16 CoreML model.
/// Based on original Objective-C headers from Capture One 16.7.
public class SubjectMaskingFP16Input: MLFeatureProvider {
    
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

/// Output wrapper for subjectMaskingFP16 CoreML model.
public class SubjectMaskingFP16Output: MLFeatureProvider {
    
    public let provider: MLFeatureProvider
    
    public var output1: MLMultiArray {
        return try! provider.featureValue(for: "output1")!.multiArrayValue!
    }
    
    public var output2: MLMultiArray {
        return try! provider.featureValue(for: "output2")!.multiArrayValue!
    }
    
    public var output3: MLMultiArray {
        return try! provider.featureValue(for: "output3")!.multiArrayValue!
    }
    
    public var output4: MLMultiArray {
        return try! provider.featureValue(for: "output4")!.multiArrayValue!
    }
    
    public var output5: MLMultiArray {
        return try! provider.featureValue(for: "output5")!.multiArrayValue!
    }
    
    public var output6: MLMultiArray {
        return try! provider.featureValue(for: "output6")!.multiArrayValue!
    }
    
    public var output7: MLMultiArray {
        return try! provider.featureValue(for: "output7")!.multiArrayValue!
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

/// Main class for subjectMaskingFP16 inference.
public class SubjectMaskingFP16 {
    
    public let model: MLModel
    
    /// Reconstructed URL logic pointing to the bundle.
    public class var urlOfModelInThisBundle: URL {
        let bundle = Bundle(for: self)
        return bundle.url(forResource: "subjectMaskingFP16", withExtension: "mlmodelc")!
    }
    
    public init(model: MLModel) {
        self.model = model
    }
    
    public convenience init(configuration: MLModelConfiguration = MLModelConfiguration()) throws {
        try self.init(contentsOf: type(of: self).urlOfModelInThisBundle, configuration: configuration)
    }
    
    public convenience init(contentsOf url: URL, configuration: MLModelConfiguration = MLModelConfiguration()) throws {
        let model = try MLModel(contentsOf: url, configuration: configuration)
        self.init(model: model)
    }
    
    public func prediction(input: SubjectMaskingFP16Input) throws -> SubjectMaskingFP16Output {
        let outFeatures = try model.prediction(from: input)
        return SubjectMaskingFP16Output(features: outFeatures)
    }
}
