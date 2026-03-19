import Foundation
import CoreGraphics
import ImageCore
import DataCore

/// Service to map a reference AI crop state to multiple target images (AI Crop Consistency).
public class AICropReferenceMapper {
    public static let shared = AICropReferenceMapper()
    
    private init() {}
    
    /// Maps a reference state to a list of target variants.
    /// - Parameters:
    ///   - reference: The source AI Crop Reference.
    ///   - variants: Target image variants to apply the crop to.
    ///   - margins: User-defined margins to apply.
    public func mapReference(_ reference: AICropReference, to variants: [VariantBase], margins: AICropMargin) {
        for variant in variants {
            guard let image = variant.image else { continue }
            
            COVisionObjectTracker.shared.detectSubject(in: image.path) { subject in
                guard let detectedSubject = subject else { 
                    print("[AI Crop Mapper] Warning: No subject detected in \(image.path)")
                    return 
                }
                
                let cropRect = AICropCompositionProvider.shared.calculateCrop(
                    for: detectedSubject,
                    usingReference: reference,
                    margins: margins
                )
                
                // Update the variant crop
                DispatchQueue.main.async {
                    if let mc = variant.mcVariant {
                        mc.setObject(cropRect, forKey: "ZCROP_RECT")
                        variant.isModified = true
                        // Note: If AdjustmentToolController is observing, it will pick it up
                        // or we might need to trigger a refresh.
                    }
                }
            }
        }
    }
}
