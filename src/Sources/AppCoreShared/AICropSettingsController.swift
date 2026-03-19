import Foundation
import CoreGraphics
import Combine
import DataCore
import ImageCore

/// Manages the UI state and interactions for AI Crop (Consistency).
public class AICropSettingsController: ObservableObject {
    public static let shared = AICropSettingsController()
    
    @Published public var currentReference: AICropReference?
    @Published public var margins: AICropMargin = .defaultMargins
    @Published public var showGuides: Bool = true
    @Published public var lockAspect: Bool = true
    @Published public var referencePoint: Int = 0 // 0: Center, 1: Top, 2: Eyes
    
    private init() {}
    
    /// Sets the current variant as the reference for AI Crop.
    public func setReference(from variant: VariantBase?) {
        guard let variant = variant, let image = variant.image, let mc = variant.mcVariant else { return }
        
        print("[AI Crop] Setting reference from \(variant.variantUUID)")
        
        COVisionObjectTracker.shared.detectSubject(in: image.path) { subject in
            guard let detectedSubject = subject else {
                print("[AI Crop] Error: No subject detected to set reference.")
                return
            }
            
            let cropRect = mc.objectForKey("ZCROP_RECT") as? CGRect ?? CGRect(x: 0, y: 0, width: 1, height: 1)
            let aspect = cropRect.width / max(0.01, cropRect.height)
            
            // Calculate alignment of subject within the crop
            let subjectCenter = detectedSubject.rect.origin.x + detectedSubject.rect.width / 2
            let subjectCenterY = detectedSubject.rect.origin.y + detectedSubject.rect.height / 2
            
            let alignmentX = (subjectCenter - cropRect.minX) / max(0.01, cropRect.width)
            let alignmentY = (subjectCenterY - cropRect.minY) / max(0.01, cropRect.height)
            
            DispatchQueue.main.async {
                self.currentReference = AICropReference(
                    alignmentX: alignmentX,
                    alignmentY: alignmentY,
                    subjectCenter: CGPoint(x: subjectCenter, y: subjectCenterY),
                    subjectSize: detectedSubject.rect.size,
                    sizingMode: 0, // Fit by default
                    aspect: aspect
                )
                print("[AI Crop] Reference set successfully. Aspect: \(aspect), Alignment: (\(alignmentX), \(alignmentY))")
            }
        }
    }
    
    /// Applies AI Crop to the specified variants.
    public func applyToVariants(_ variants: [VariantBase]) {
        guard let reference = currentReference else {
            print("[AI Crop] Error: No reference state set.")
            return
        }
        
        print("[AI Crop] Applying reference to \(variants.count) variants.")
        AICropReferenceMapper.shared.mapReference(reference, to: variants, margins: margins)
    }
}
