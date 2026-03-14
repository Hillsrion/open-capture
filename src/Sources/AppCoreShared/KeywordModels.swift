import Foundation
import Combine

/// Reconstructed Keyword model with Hierarchy support (MET-003).
/// Based on P1::DataCore::Tree<Keyword> architecture.
public class KeywordEntry: Identifiable, Codable, ObservableObject {
    public let id: String
    @Published public var name: String
    public var parent: KeywordEntry?
    @Published public var children: [KeywordEntry] = []
    
    public init(id: String = UUID().uuidString, name: String, parent: KeywordEntry? = nil) {
        self.id = id
        self.name = name
        self.parent = parent
    }
    
    /// Returns the full hierarchical path string.
    /// Original C1 uses '>' or '|' as separators.
    public var fullPath: String {
        if let parent = parent {
            return "\(parent.fullPath) > \(name)"
        }
        return name
    }
    
    // Codable conformance (simplified)
    enum CodingKeys: String, CodingKey {
        case id, name, parentID
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(parent?.id, forKey: .parentID)
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        parent = nil // Parent must be re-linked by the manager during hydration
    }
}

/// Reconstructed Keyword Dictionary / Library (MET-004).
/// Mimics _TtC13AppCoreShared21KeywordLibraryManager.
public class KeywordLibrary: ObservableObject {
    @Published public var rootKeywords: [KeywordEntry] = []
    
    public init() {}
    
    /// Adds a keyword at a specific path (ex: "Places/France/Paris")
    public func addKeyword(at path: String) {
        let components = path.components(separatedBy: CharacterSet(charactersIn: ">|/")).map { $0.trimmingCharacters(in: .whitespaces) }
        var currentLevel: [KeywordEntry] = rootKeywords
        var lastParent: KeywordEntry? = nil
        
        for component in components {
            if let existing = (lastParent?.children ?? rootKeywords).first(where: { $0.name == component }) {
                lastParent = existing
            } else {
                let newKeyword = KeywordEntry(name: component, parent: lastParent)
                if let parent = lastParent {
                    parent.children.append(newKeyword)
                } else {
                    rootKeywords.append(newKeyword)
                }
                lastParent = newKeyword
            }
        }
    }
    
    /// Loads keywords from a flat text file (Lightroom/Media Pro format).
    public func importFromText(_ content: String) {
        let lines = content.components(separatedBy: .newlines)
        for line in lines where !line.isEmpty {
            // Logic to handle tabbed hierarchies (Lightroom style) or slash paths
            addKeyword(at: line)
        }
    }
}
