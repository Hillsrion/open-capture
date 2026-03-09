import Foundation
import DataCore

/// Reconstructed Keyword Cache for a session (CORE-005).
/// Based on disassembly of DocumentKeywordCache.
public class DocumentKeywordCache: ObservableObject {
    @Published public var library: KeywordLibrary
    private let session: SessionBase
    
    public init(session: SessionBase) {
        self.session = session
        self.library = KeywordLibrary()
        loadFromDatabase()
    }
    
    /// Loads all keywords from the session database.
    public func loadFromDatabase() {
        guard DataCoreManager.shared.db != nil else { return }
        do {
            let reader = DataCoreManager.shared.reader()
            let rows = try reader.fetchAllKeywords()
            
            var entries: [KeywordEntry] = []
            for row in rows {
                if let uuid = row["ZUUID"] as? String,
                   let name = row["ZNAME"] as? String {
                    let entry = KeywordEntry(id: uuid, name: name, parentID: row["ZPARENT"] as? String)
                    entries.append(entry)
                }
            }
            
            DispatchQueue.main.async {
                self.library.keywords = entries
            }
        } catch {
            print("[KeywordCache] Failed to load keywords: \(error)")
        }
    }
    
    /// Assigns a keyword to a variant (simulated logic).
    public func assignKeyword(_ keyword: KeywordEntry, to variant: VariantBase) {
        // In original, this adds to MCAdjLayerKeyMetadataContentKeywords serialized list
        var current = variant.keywords
        if !current.contains(where: { $0.id == keyword.id }) {
            current.append(keyword)
            variant.keywords = current
            variant.isModified = true
        }
    }
}
