import Foundation

/// Reconstructed state for AI Crop reference image (UI-204).
/// Stores the original crop and the detected feature positions to allow consistency matching.
public struct CORefImageState: Codable {
    public let variantUUID: String
    public let cropRect: CGRect
    public let detectedFeatures: [COVisionFeature]
    
    public init(variantUUID: String, cropRect: CGRect, detectedFeatures: [COVisionFeature]) {
        self.variantUUID = variantUUID
        self.cropRect = cropRect
        self.detectedFeatures = detectedFeatures
    }
}

/// A detected visual feature used for alignment (e.g., Eyes, Face center, Object).
public struct COVisionFeature: Codable {
    public enum FeatureType: Int, Codable {
        case face = 0
        case eyes = 1
        case subject = 2
    }
    
    public let type: FeatureType
    public let boundingBox: CGRect // Normalized 0.0 to 1.0
    public let confidence: Float
    
    public init(type: FeatureType, boundingBox: CGRect, confidence: Float) {
        self.type = type
        self.boundingBox = boundingBox
        self.confidence = confidence
    }
}
