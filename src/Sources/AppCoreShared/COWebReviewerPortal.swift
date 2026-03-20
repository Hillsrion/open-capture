import Foundation
import Combine

/// Reconstructed Web Portal Simulator for Capture One Live Guest View (ENG-012).
/// Represents the logic of the web interface (Gallery Grid, Viewer, Interactions).
public class COWebReviewerPortal: ObservableObject {
    public static let shared = COWebReviewerPortal()
    
    // Web Interface Mock State
    @Published public var isGalleryVisible: Bool = true
    @Published public var isFullScreenViewerActive: Bool = false
    @Published public var selectedImageId: UUID? = nil
    @Published public var sidebarVisible: Bool = true // Comment Sidebar
    @Published public var followActive: Bool = false
    
    private init() {
        // Observe sync changes from C1
        setupObservation()
    }
    
    private func setupObservation() {
        // In reality, this would be a WebSocket listener. 
        // Here we simulate it by observing COLiveSyncAPI shared state.
    }
    
    // --- Web Component Actions ---
    
    /// User clicks an image in the Gallery Grid.
    public func selectImage(_ id: UUID) {
        selectedImageId = id
        isFullScreenViewerActive = true
        print("[COWebReviewerPortal] Web View: Image selected \(id)")
    }
    
    /// User interacts with the Rating Bar (Rating/Tag).
    public func submitInteraction(rating: Int?, colorTag: String?) {
        guard let imageId = selectedImageId else { return }
        print("[COWebReviewerPortal] Web Interaction: Submitting Rating/Tag for \(imageId)")
        COLiveSyncAPI.shared.receiveWebInteraction(imageId: imageId, rating: rating, colorTag: colorTag)
    }
    
    /// User types a comment in the Sidebar (Anonymous/Guest).
    public func submitComment(text: String, author: String? = nil) {
        guard let imageId = selectedImageId else { return }
        print("[COWebReviewerPortal] Web Interaction: Submitting comment for \(imageId)")
        COReviewerCommentService.shared.postComment(imageId: imageId, author: author, content: text)
    }
    
    /// User toggles "Follow Mode" in the Interaction Bar.
    public func toggleFollow() {
        followActive.toggle()
        print("[COWebReviewerPortal] Web UI: Follow mode is now \(followActive ? "ON" : "OFF")")
    }
    
    /// Simulates real-time update from C1.
    public func handleRemoteSyncEvent(_ event: String) {
        print("[COWebReviewerPortal] Web UI: Received remote event: \(event)")
        // Logic to update the UI based on C1 actions (e.g., jumping to new capture)
    }
}
