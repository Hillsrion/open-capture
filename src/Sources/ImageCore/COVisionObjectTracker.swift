import Foundation
import CoreGraphics
import Vision

/// Structure representing a detected subject for AI Crop.
public struct COVisionSubject: Codable, Equatable {
    public var rect: CGRect
    public var confidence: Float
    public var label: String
    
    public init(rect: CGRect, confidence: Float = 1.0, label: String = "subject") {
        self.rect = rect
        self.confidence = confidence
        self.label = label
    }
}

/// Reconstructed Vision-based object tracker for AI Crop (Consistency).
/// Provides detection and tracking of subjects to calculate stable crop rectangles.
public class COVisionObjectTracker {
    public static let shared = COVisionObjectTracker()
    
    private init() {}
    
    /// Detects the primary subject in an image.
    /// In a real implementation, this would use VNAnimalDetector, VNHumanDetector, or custom CoreML models.
    public func detectSubject(in imagePath: String, completion: @escaping (COVisionSubject?) -> Void) {
        // Mock implementation: Simulate detection after a short delay.
        // In reality, this would use VNImageRequestHandler.
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.5) {
            // Simulated subject: a 20% rectangle in the center of the image.
            let subject = COVisionSubject(rect: CGRect(x: 0.4, y: 0.4, width: 0.2, height: 0.2))
            completion(subject)
        }
    }
    
    /// Detects multiple subjects.
    public func detectSubjects(in imagePath: String, completion: @escaping ([COVisionSubject]) -> Void) {
        detectSubject(in: imagePath) { subject in
            if let s = subject {
                completion([s])
            } else {
                completion([])
            }
        }
    }
}
