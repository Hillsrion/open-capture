import Foundation
import Combine

/// Reconstructed Service for managing color tags (ENG-012).
/// Handles local application and syncs with Capture One Live.
public class COColorTagService: ObservableObject {
    public static let shared = COColorTagService()
    
    private init() {}
    
    /// Sets the color tag for a variant locally and notifies Live if active.
    public func setColorTag(_ colorTag: VariantBase.ColorTag, for variant: VariantBase) {
        guard variant.colorTag != colorTag else { return }
        
        variant.colorTag = colorTag
        
        // Notify Live if session is active
        if CaptureOneLiveManager.shared.isSessionActive {
            print("[COColorTagService] Local color tag update for \(variant.variantUUID): \(colorTag). Syncing to cloud...")
            // In a real app, this would call syncAPI.sendColorTag(...)
        }
        
        // Log activity locally for simulation
        CaptureOneLiveManager.shared.activityLog.insert(
            CaptureOneLiveManager.ActivityLogEntry(timestamp: Date(), user: "Photographer (Me)", action: "Tagged image \(colorTag)"),
            at: 0
        )
    }
}
