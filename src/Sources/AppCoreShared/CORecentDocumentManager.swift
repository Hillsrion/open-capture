import Foundation

/// Reconstructed manager for tracking recently opened Catalogs and Sessions.
/// Based on POFileHistory and related patterns discovered in metadata.
public final class CORecentDocumentManager: ObservableObject {
    public static let shared = CORecentDocumentManager()
    
    private let storageKey = "com.captureone.reconstructed.recentDocuments"
    private let maxItems = 20
    
    @Published public private(set) var recentDocuments: [RecentDocumentRecord] = []
    
    private init() {
        load()
    }
    
    public struct RecentDocumentRecord: Identifiable, Codable, Equatable {
        public var id: String { path }
        public let name: String
        public let path: String
        public let type: DocumentType
        public let lastOpened: Date
        
        public enum DocumentType: String, Codable {
            case catalog = "Catalog"
            case session = "Session"
        }
    }
    
    public func recordOpenedDocument(name: String, path: String, isCatalog: Bool) {
        let type: RecentDocumentRecord.DocumentType = isCatalog ? .catalog : .session
        let record = RecentDocumentRecord(name: name, path: path, type: type, lastOpened: Date())
        
        var current = recentDocuments
        // Remove existing if present to move to top
        current.removeAll { $0.path == path }
        current.insert(record, at: 0)
        
        if current.count > maxItems {
            current = Array(current.prefix(maxItems))
        }
        
        self.recentDocuments = current
        save()
        
        // Also notify macOS standard recent documents
        let url = URL(fileURLWithPath: path)
        NSDocumentController.shared.noteNewRecentDocumentURL(url)
    }
    
    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([RecentDocumentRecord].self, from: data) else {
            return
        }
        self.recentDocuments = decoded
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(recentDocuments) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    public func clearAll() {
        recentDocuments = []
        save()
        NSDocumentController.shared.clearRecentDocuments(nil)
    }
}

// Add imports needed for NSDocumentController if not in Cocoa environment
#if os(macOS)
import AppKit
#endif
