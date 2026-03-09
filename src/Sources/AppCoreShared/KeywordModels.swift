import Foundation

/// Reconstructed Data Model for a Keyword entry (CORE-005).
/// Based on MCMetadataKeywordLibraryEntry.
public class KeywordEntry: Identifiable, Codable {
    public let id: String
    public var name: String
    public var parentID: String?
    
    public init(id: String = UUID().uuidString, name: String, parentID: String? = nil) {
        self.id = id
        self.name = name
        self.parentID = parentID
    }
}

/// Reconstructed hierarchical container for keywords.
public class KeywordLibrary: ObservableObject {
    @Published public var keywords: [KeywordEntry] = []
    
    public init() {}
    
    /// Returns the root keywords (those without a parent).
    public var rootKeywords: [KeywordEntry] {
        keywords.filter { $0.parentID == nil }
    }
    
    /// Returns children for a specific keyword.
    public func children(of parent: KeywordEntry) -> [KeywordEntry] {
        keywords.filter { $0.parentID == parent.id }
    }
    
    /// Adds a new keyword to the library.
    public func addKeyword(name: String, parent: KeywordEntry? = nil) -> KeywordEntry {
        let entry = KeywordEntry(name: name, parentID: parent?.id)
        keywords.append(entry)
        return entry
    }
    
    /// Finds a keyword by its UUID.
    public func keyword(withID id: String) -> KeywordEntry? {
        keywords.first { $0.id == id }
    }
}
