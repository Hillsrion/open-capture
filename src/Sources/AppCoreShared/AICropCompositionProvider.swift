import Foundation
import CoreGraphics
import ImageCore

/// Reconstructed logic to calculate crop rectangles based on vision data (AI Crop Consistency).
public class AICropCompositionProvider {
    public static let shared = AICropCompositionProvider()
    
    private init() {}
    
    /// Calculates a stable crop rectangle for a target image based on a reference state.
    /// - Parameters:
    ///   - targetSubject: The detected subject in the target image.
    ///   - reference: The reference AI crop state to maintain consistency with.
    ///   - margins: User-defined margins to apply.
    /// - Returns: A normalized CGRect for the crop.
    public func calculateCrop(for targetSubject: COVisionSubject,
                              usingReference reference: AICropReference,
                              margins: AICropMargin) -> CGRect {
        // Step 1: Determine target size based on sizing mode.
        // For simplicity in this reconstruction, we'll focus on the 'Fit' mode (0).
        
        let targetSubjectCenter = targetSubject.rect.origin.x + targetSubject.rect.width / 2
        let targetSubjectCenterY = targetSubject.rect.origin.y + targetSubject.rect.height / 2
        
        // We want the subject to be at (reference.alignmentX, reference.alignmentY) within the crop.
        // We also want the subject size relative to the crop to be similar to the reference if sizingMode is set.
        
        // Simple 'Consistency' logic:
        // Crop width = (Subject width) / (Reference Subject Width Relative to Reference Crop)
        // This is a bit complex, let's simplify for the mock.
        
        // Assuming reference.subjectSize is normalized relative to original image,
        // we can try to maintain the same "Subject Size to Crop Size" ratio.
        
        // Let's use a fixed logic for now as this is a reconstruction.
        // Assume crop width is 3x subject width if margins are default.
        let marginX = (margins.left + margins.right) / 100.0
        let marginY = (margins.top + margins.bottom) / 100.0
        
        var cropWidth = targetSubject.rect.width * (1.0 + marginX * 2.0)
        var cropHeight = cropWidth / reference.aspect
        
        // If fixed sizing mode, we might use reference subject size
        if reference.sizingMode == 2 { // Fixed
             // Scale crop so subject matches reference size exactly?
             // Not implemented for mock.
        }
        
        // Step 2: Center crop around subject center with alignment offsets.
        // alignmentX = 0.5 means subject is centered.
        // alignmentX = 0.0 means subject is at the left edge.
        
        let offsetX = (reference.alignmentX - 0.5) * cropWidth
        let offsetY = (reference.alignmentY - 0.5) * cropHeight
        
        let cropX = (targetSubjectCenter - cropWidth / 2) - offsetX
        let cropY = (targetSubjectCenterY - cropHeight / 2) - offsetY
        
        let cropRect = CGRect(x: cropX, y: cropY, width: cropWidth, height: cropHeight)
        
        // Step 3: Clamp to image bounds [0, 1]
        return cropRect.intersection(CGRect(x: 0, y: 0, width: 1, height: 1))
    }
}
