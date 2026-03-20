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
    
    /// Remote ratings from different collaborators (ImageID -> UserID -> Rating)
    @Published public var cloudRatings: [String: [UUID: Int]] = [:]
    /// Remote color tags from different collaborators (ImageID -> UserID -> ColorTagValue)
    @Published public var cloudColorTags: [String: [UUID: Int]] = [:]
    
    private var cancellables = Set<AnyCancellable>()
    
    public init() {}
    
    /// Aggregates all ratings for a given image (Local + Cloud).
    public func getConsensusRatings(for imageId: String, localRating: Int) -> Set<Int> {
        var ratings = Set<Int>()
        if localRating > 0 { ratings.insert(localRating) }
        
        if let cloud = cloudRatings[imageId] {
            for (_, rating) in cloud {
                if rating > 0 { ratings.insert(rating) }
            }
        }
        return ratings
    }

    /// Aggregates all color tags for a given image (Local + Cloud).
    public func getConsensusColorTags(for imageId: String, localTag: Int) -> Set<Int> {
        var tags = Set<Int>()
        if localTag > 0 { tags.insert(localTag) }
        
        if let cloud = cloudColorTags[imageId] {
            for (_, tag) in cloud {
                if tag > 0 { tags.insert(tag) }
            }
        }
        return tags
    }

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
        
        // Store cloud rating
        if cloudRatings[imageId] == nil { cloudRatings[imageId] = [:] }
        cloudRatings[imageId]?[userId] = rating
        
        print("[LiveSelectionManager] Synced rating \(rating) for image \(imageId) from user \(userId).")
        
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
        
        // Store cloud tag
        if cloudColorTags[imageId] == nil { cloudColorTags[imageId] = [:] }
        cloudColorTags[imageId]?[userId] = colorTag
        
        print("[LiveSelectionManager] Synced color tag \(colorTag) for image \(imageId) from user \(userId).")
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
