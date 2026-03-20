import Foundation
import Combine
import DataCore // Assuming Variant/Image models are accessible or we use generic identifiers

public struct CloudComment: Identifiable, Codable {
    public let id: UUID
    public let userId: UUID
    public let imageId: String
    public let text: String
    public let timestamp: Date
}

/// Manages selection and synchronization of ratings, tags, and comments between local session and cloud.
public class COLiveSelectionManager: ObservableObject {
    public static let shared = COLiveSelectionManager()
    
    @Published public var isTriggerFollowEnabled: Bool = false
    @Published public var comments: [String: [CloudComment]] = [:] // ImageID to Comments
    
    private var cancellables = Set<AnyCancellable>()
    
    public init() {}
    
    /// Enable "Trigger Follow" mode. In real app, this ensures the remote client's selection follows the local session's selection.
    public func toggleTriggerFollow() {
        isTriggerFollowEnabled.toggle()
        print("[LiveSelectionManager] Trigger Follow mode is now \(isTriggerFollowEnabled ? "ENABLED" : "DISABLED").")
    }
    
    /// Called when the cloud sends a rating update
    public func syncRatingFromCloud(imageId: String, rating: Int, userId: UUID) {
        guard CaptureOneLiveManager.shared.canRate else {
            print("[LiveSelectionManager] Global session settings do not allow rating.")
            return
        }
        
        guard COCloudAccessManager.shared.canUserRateAndTag(id: userId) else {
            print("[LiveSelectionManager] User \(userId) does not have permission to rate.")
            return
        }
        
        // In a real implementation, this would update the DataCore variant
        print("[LiveSelectionManager] Synced rating \(rating) for image \(imageId) from cloud.")
        
        // Simulating activity log update
        CaptureOneLiveManager.shared.activityLog.insert(
            CaptureOneLiveManager.ActivityLogEntry(timestamp: Date(), user: "User \(userId.uuidString.prefix(4))", action: "Rated image \(imageId) to \(rating) stars"),
            at: 0
        )
    }
    
    /// Called when the cloud sends a color tag update
    public func syncColorTagFromCloud(imageId: String, colorTag: Int, userId: UUID) {
        guard CaptureOneLiveManager.shared.canColorTag else {
            print("[LiveSelectionManager] Global session settings do not allow color tagging.")
            return
        }
        
        guard COCloudAccessManager.shared.canUserRateAndTag(id: userId) else {
            print("[LiveSelectionManager] User \(userId) does not have permission to tag.")
            return
        }
        
        // In a real implementation, this would update the DataCore variant
        print("[LiveSelectionManager] Synced color tag \(colorTag) for image \(imageId) from cloud.")
    }
    
    /// Called when the cloud sends a comment
    public func syncCommentFromCloud(imageId: String, text: String, userId: UUID) {
        guard COCloudAccessManager.shared.canUserComment(id: userId) else {
            print("[LiveSelectionManager] User \(userId) does not have permission to comment.")
            return
        }
        
        let comment = CloudComment(id: UUID(), userId: userId, imageId: imageId, text: text, timestamp: Date())
        if comments[imageId] == nil {
            comments[imageId] = []
        }
        comments[imageId]?.append(comment)
        
        print("[LiveSelectionManager] Synced comment for image \(imageId): '\(text)'.")
    }
    
    /// Notify cloud about local selection changes (Trigger Follow)
    public func notifyLocalSelectionChanged(imageId: String) {
        if isTriggerFollowEnabled {
            print("[LiveSelectionManager] Trigger Follow: Notifying cloud clients to select image \(imageId).")
        }
    }
}
