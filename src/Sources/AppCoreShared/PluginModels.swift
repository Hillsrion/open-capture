import Foundation

/// Reconstructed Data Model for a Capture One Plugin (INT-003).
/// Based on COPlugin metadata from PluginCore.
public struct COPlugin: Identifiable, Codable, Hashable {
    public let id: String
    public let name: String
    public let version: String
    public let path: URL
    public let type: PluginType
    
    public enum PluginType: String, Codable {
        case export = "Export"
        case publish = "Publish"
        case utility = "Utility"
        case system = "System"
    }
    
    public init(id: String, name: String, version: String, path: URL, type: PluginType = .utility) {
        self.id = id
        self.name = name
        self.version = version
        self.path = path
        self.type = type
    }
}
