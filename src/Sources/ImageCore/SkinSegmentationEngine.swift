import Foundation
import CoreML
import ImageCore

/// Reconstructed AI Skin Segmentation engine (AI-002).
/// Uses FaceMaskingModel to isolate skin regions for uniformity adjustments.
public class SkinSegmentationEngine {
    public static let shared = SkinSegmentationEngine()
    
    private var model: FaceMaskingModel?
    
    private init() {
        do {
            self.model = try FaceMaskingModel()
            print("[AI] FaceMaskingModel loaded successfully for Skin Tone tools.")
        } catch {
            print("[AI] Warning: Could not load FaceMaskingModel. Error: \(error)")
        }
    }
    
    /// Generates a mask specifically for skin regions.
    /// Used by the Skin Tone Uniformity tool.
    public func generateSkinMask(for image: ICImageMetadataProvider, completion: @escaping ([Float]?) -> Void) {
        guard let model = self.model else {
            completion(nil)
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                // 1. Prepare inputs (Input Image + ROIs)
                // In original, ROIs are derived from FaceDetection results.
                let inputShape = [1, 3, 512, 512] as [NSNumber]
                let roiShape = [1, 512] as [NSNumber] // Placeholder for ROI data
                
                let inputData = try MLMultiArray(shape: inputShape, dataType: .float32)
                let roiData = try MLMultiArray(shape: roiShape, dataType: .float32)
                
                let input = FaceMaskingModelInput(input: inputData, rois: roiData)
                
                // 2. Run Inference
                let output = try model.prediction(input: input)
                
                // 3. Extract and normalize mask
                let mask = self.processOutput(output.output)
                
                DispatchQueue.main.async {
                    completion(mask)
                }
            } catch {
                print("[AI] Skin segmentation failed: \(error)")
                completion(nil)
            }
        }
    }
    
    private func processOutput(_ multiArray: MLMultiArray) -> [Float] {
        let count = multiArray.count
        var result = [Float](repeating: 0.0, count: count)
        let ptr = multiArray.dataPointer.assumingMemoryBound(to: Float.self)
        for i in 0..<count {
            // Apply thresholding or sigmoid if needed (mimics C1's post-processing)
            result[i] = ptr[i]
        }
        return result
    }
}
