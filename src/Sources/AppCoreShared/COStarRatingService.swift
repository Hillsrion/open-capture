import Foundation
import Combine

/// Reconstructed Service for managing star ratings (ENG-012).
/// Handles local application and syncs with Capture One Live.
public class COStarRatingService: ObservableObject {
    public static let shared = COStarRatingService()
    
    private init() {}
    
    /// Sets the rating for a variant locally and notifies Live if active.
    public func setRating(_ rating: Int, for variant: VariantBase) {
        guard variant.rating != rating else { return }
        
        variant.rating = rating
        
        // Notify Live if session is active
        if CaptureOneLiveManager.shared.isSessionActive {
            print("[COStarRatingService] Local rating update for \(variant.variantUUID): \(rating) stars. Syncing to cloud...")
            // In a real app, this would call syncAPI.sendRating(...)
        }
        
        // Log activity locally for simulation
        CaptureOneLiveManager.shared.activityLog.insert(
            CaptureOneLiveManager.ActivityLogEntry(timestamp: Date(), user: "Photographer (Me)", action: "Rated image \(rating) stars"),
            at: 0
        )
    }
    
    /// Gets the consensus rating (e.g., highest rating from all sources or specific logic).
    /// For this module, we just return the local rating, but COLiveSelectionManager
    /// provides the multi-source view.
    public func getRating(for variant: VariantBase) -> Int {
        return variant.rating
    }
}
