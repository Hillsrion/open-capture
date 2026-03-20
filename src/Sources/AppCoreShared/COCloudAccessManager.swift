import Foundation
import Combine

/// Access roles for Capture One Live Collaboration.
public enum CloudAccessRole: String, Codable {
    case viewOnly = "View Only"
    case rateAndTag = "Rate & Tag"
    case comment = "Comment"
    case admin = "Admin"
}

public struct CloudUser: Identifiable, Codable {
    public let id: UUID
    public let name: String
    public let email: String
    public var role: CloudAccessRole
    public var isVerified: Bool
}

/// Manages access, roles, and identity verification for the Collaborate Live module.
public class COCloudAccessManager: ObservableObject {
    public static let shared = COCloudAccessManager()
    
    @Published public var connectedUsers: [CloudUser] = []
    @Published public var defaultRole: CloudAccessRole = .viewOnly
    
    public init() {}
    
    public func addUser(name: String, email: String, role: CloudAccessRole) {
        let user = CloudUser(id: UUID(), name: name, email: email, role: role, isVerified: true)
        connectedUsers.append(user)
        print("[CloudAccessManager] Added user \(name) with role \(role.rawValue).")
    }
    
    public func removeUser(id: UUID) {
        connectedUsers.removeAll { $0.id == id }
        print("[CloudAccessManager] Removed user \(id).")
    }
    
    public func updateRole(for id: UUID, newRole: CloudAccessRole) {
        if let index = connectedUsers.firstIndex(where: { $0.id == id }) {
            connectedUsers[index].role = newRole
            print("[CloudAccessManager] Updated user \(connectedUsers[index].name) to role \(newRole.rawValue).")
        }
    }
    
    public func canUserRateAndTag(id: UUID) -> Bool {
        guard let user = connectedUsers.first(where: { $0.id == id }) else { return false }
        return user.role == .rateAndTag || user.role == .admin || user.role == .comment
    }
    
    public func canUserComment(id: UUID) -> Bool {
        guard let user = connectedUsers.first(where: { $0.id == id }) else { return false }
        return user.role == .comment || user.role == .admin
    }
}
