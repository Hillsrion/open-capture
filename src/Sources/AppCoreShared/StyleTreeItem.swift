import Foundation

/// Reconstructed UI model for hierarchical style and keyword lists.
public struct StyleTreeItem: Identifiable {
    public let id = UUID()
    public let name: String
    public let isFolder: Bool
    public var children: [StyleTreeItem]?
    
    public init(name: String, isFolder: Bool, children: [StyleTreeItem]? = nil) {
        self.name = name
        self.isFolder = isFolder
        self.children = children
    }
}
