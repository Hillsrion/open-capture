import Foundation
import Combine

/// Reconstructed Follow Mode states for Capture One Live collaboration.
public enum COFollowMode: String, CaseIterable, Identifiable {
    case none = "None"
    case followCaptures = "Follow captures"
    case followEdits = "Follow edits"
    
    public var id: String { self.rawValue }
}

/// Reconstructed API for Capture One Live synchronization (ENG-012).
/// Handles the communication between Capture One and the (simulated) web clients.
public class COLiveSyncAPI: ObservableObject {
    public static let shared = COLiveSyncAPI()
    
    @Published public var followMode: COFollowMode = .none
    @Published public var isSyncing: Bool = false
    
    private init() {}
    
    /// Notifies web clients when a new capture is added (used in Follow Captures mode).
    public func notifyNewCapture(imageId: UUID) {
        guard followMode == .followCaptures else { return }
        print("[COLiveSyncAPI] Real-time Sync: Notifying web clients of new capture (\(imageId))")
        // Simulated WebSocket/Push notification
    }
    
    /// Notifies web clients of adjustment changes (used in Follow Edits mode).
    public func notifyEditUpdate(imageId: UUID, adjustments: [String: Any]) {
        guard followMode == .followEdits else { return }
        print("[COLiveSyncAPI] Real-time Sync: Sending edit updates for \(imageId) to web clients")
    }
    
    /// Receives rating/tag sync from the web portal.
    public func receiveWebInteraction(imageId: UUID, rating: Int?, colorTag: String?) {
        print("[COLiveSyncAPI] Received interaction from Guest View: Image \(imageId) -> Rating: \(String(describing: rating)), Tag: \(String(describing: colorTag))")
        
        // Log interaction in CaptureOneLiveManager
        let user = "Guest \(UUID().uuidString.prefix(4))"
        var action = ""
        if let r = rating { action += "Rated \(r) stars " }
        if let t = colorTag { action += "Tagged \(t)" }
        
        CaptureOneLiveManager.shared.activityLog.insert(
            CaptureOneLiveManager.ActivityLogEntry(timestamp: Date(), user: user, action: action),
            at: 0
        )
    }
    
    public func setFollowMode(_ mode: COFollowMode) {
        self.followMode = mode
        print("[COLiveSyncAPI] Collaboration Lock: Follow Mode set to \(mode.rawValue)")
    }
}
