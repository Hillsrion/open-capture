import Foundation
import Vision
import AppKit

/// AI eye detection engine for focus tracking (UI-203).
/// Decompiled: _TtC10CaptureOne13COEyeDetector
public class COEyeDetector {
    public static let shared = COEyeDetector()
    
    private init() {}
    
    /// Finds eye locations in the given image.
    /// Returns normalized coordinates (0.0 to 1.0).
    public func detectEyes(in image: NSImage, completion: @escaping ([CGPoint]) -> Void) {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            completion([])
            return
        }
        
        let request = VNDetectFaceLandmarksRequest { request, error in
            guard error == nil, let results = request.results as? [VNFaceObservation] else {
                completion([])
                return
            }
            
            var eyePoints: [CGPoint] = []
            for face in results {
                if let landmarks = face.landmarks {
                    // Try to get left and right eyes
                    if let leftEye = landmarks.leftEye {
                        let center = self.calculateCenter(for: leftEye, in: face.boundingBox)
                        eyePoints.append(center)
                    }
                    if let rightEye = landmarks.rightEye {
                        let center = self.calculateCenter(for: rightEye, in: face.boundingBox)
                        eyePoints.append(center)
                    }
                }
            }
            completion(eyePoints)
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("[COEyeDetector] Detection failed: \(error)")
                completion([])
            }
        }
    }
    
    private func calculateCenter(for region: VNFaceLandmarkRegion2D, in boundingBox: CGRect) -> CGPoint {
        let points = region.normalizedPoints
        guard !points.isEmpty else { return .zero }
        
        let sumX = points.reduce(0) { $0 + $1.x }
        let sumY = points.reduce(0) { $0 + $1.y }
        
        let avgX = sumX / CGFloat(points.count)
        let avgY = sumY / CGFloat(points.count)
        
        // Convert landmark coordinates (relative to bounding box) to image coordinates (normalized 0...1)
        // Landmarks are already normalized relative to the bounding box in some versions of Vision, 
        // but let's be careful. Actually in VNFaceLandmarkRegion2D, they are normalized to the bounding box.
        
        let x = boundingBox.origin.x + (avgX * boundingBox.width)
        let y = boundingBox.origin.y + (avgY * boundingBox.height)
        
        return CGPoint(x: x, y: y)
    }
}
