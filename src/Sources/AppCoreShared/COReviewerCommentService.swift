import Foundation
import Combine

/// Reconstructed Comment data model for Capture One Live.
public struct COComment: Identifiable, Codable {
    public let id: UUID
    public let imageId: UUID
    public let authorName: String? // nil means Anonymous
    public let content: String
    public let timestamp: Date
    public let isAnonymous: Bool
    
    public init(id: UUID = UUID(), imageId: UUID, authorName: String?, content: String, timestamp: Date = Date()) {
        self.id = id
        self.imageId = imageId
        self.authorName = authorName
        self.content = content
        self.timestamp = timestamp
        self.isAnonymous = authorName == nil
    }
}

/// Reconstructed Service for managing reviewer comments (ENG-012).
/// Supports anonymous feedback from Capture One Live Guest View.
public class COReviewerCommentService: ObservableObject {
    public static let shared = COReviewerCommentService()
    
    @Published public var comments: [COComment] = []
    
    private init() {
        // Mock data for initial testing
        loadMockComments()
    }
    
    /// Adds a new comment (supports anonymous feedback).
    public func postComment(imageId: UUID, author: String?, content: String) {
        let newComment = COComment(imageId: imageId, authorName: author, content: content)
        comments.insert(newComment, at: 0)
        
        print("[COReviewerCommentService] New comment on \(imageId) by \(author ?? "Anonymous")")
        
        // Notify Activity Log
        let userName = author ?? "Anonymous Guest"
        CaptureOneLiveManager.shared.activityLog.insert(
            CaptureOneLiveManager.ActivityLogEntry(timestamp: Date(), user: userName, action: "Added comment: \"\(content.prefix(20))...\""),
            at: 0
        )
    }
    
    public func fetchComments(for imageId: UUID) -> [COComment] {
        return comments.filter { $0.imageId == imageId }
    }
    
    private func loadMockComments() {
        // Simulated existing comments from cloud backend
        let imageId = UUID()
        comments = [
            COComment(imageId: imageId, authorName: "Art Director", content: "Great exposure, but maybe pull back the highlights."),
            COComment(imageId: imageId, authorName: nil, content: "Anonymous feedback: Love the composition!")
        ]
    }
}
