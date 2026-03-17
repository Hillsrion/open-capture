import Foundation
import SQLite3

/// Reconstructed central manager for database operations in DataCore.
/// Manages SQLite connections for Catalogs and Sessions.
public class DataCoreManager {
    
    public static let shared = DataCoreManager()
    
    public var db: OpaquePointer?
    
    private init() {
        observeNotifications()
    }
    
    private func observeNotifications() {
        // Variant Metadata (Rating, Color Tag)
        NotificationCenter.default.addObserver(forName: .DCVariantMetadataDidChange, object: nil, queue: .main) { notification in
            guard let userInfo = notification.userInfo,
                  let uuid = userInfo["uuid"] as? String,
                  let rating = userInfo["rating"] as? Int,
                  let colorTag = userInfo["colorTag"] as? Int else { return }
            
            do {
                try self.writer().updateVariantMetadata(
                    uuid: uuid,
                    rating: rating,
                    colorTag: colorTag
                )
                print("[DataCore] Persisted metadata for variant \(uuid)")
            } catch {
                print("[DataCore] Error persisting metadata: \(error.localizedDescription)")
            }
        }
        
        // Image Naming (Renaming file)
        NotificationCenter.default.addObserver(forName: .DCImageNameDidChange, object: nil, queue: .main) { notification in
            guard let userInfo = notification.userInfo,
                  let uuid = userInfo["uuid"] as? String,
                  let displayName = userInfo["displayName"] as? String,
                  let fileName = userInfo["fileName"] as? String,
                  let path = userInfo["path"] as? String else { return }
            
            do {
                try self.writer().updateImageName(
                    uuid: uuid,
                    displayName: displayName,
                    fileName: fileName,
                    path: path
                )
                print("[DataCore] Persisted name change for image \(uuid)")
            } catch {
                print("[DataCore] Error persisting image name: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Document Management
    
    public func createDatabase(at url: URL, for documentType: Int16) throws {
        // Logic recovery
    }
    
    public func openDatabase(at url: URL) throws {
        if sqlite3_open(url.path, &db) != SQLITE_OK {
            let error = String(cString: sqlite3_errmsg(db))
            throw NSError(domain: "DataCore", code: 1, userInfo: [NSLocalizedDescriptionKey: error])
        }
        print("Successfully opened database at \(url.path)")
    }
    
    public func closeDatabase() {
        sqlite3_close(db)
        db = nil
    }
    
    public func reader() -> DatabaseReader {
        return DatabaseReader(database: db)
    }
    
    public func writer() -> DatabaseWriter {
        return DatabaseWriter(database: db)
    }
    
    // MARK: - Query Wrappers
    
    public func execute(query: String) throws {
        guard let db = db else { return }
        if sqlite3_exec(db, query, nil, nil, nil) != SQLITE_OK {
            let error = String(cString: sqlite3_errmsg(db))
            throw NSError(domain: "DataCore", code: 2, userInfo: [NSLocalizedDescriptionKey: error])
        }
    }
}

/// Reconstructed representation of project version info.
public struct DCVersionInfo {
    public let version: Int
    public let compatibleVersion: Int
    public let author: String
    public let format: Int
}

// MARK: - Notifications
extension Notification.Name {
    public static let DCVariantMetadataDidChange = Notification.Name("DCVariantMetadataDidChangeNotification")
    public static let DCImageNameDidChange = Notification.Name("DCImageNameDidChangeNotification")
}
