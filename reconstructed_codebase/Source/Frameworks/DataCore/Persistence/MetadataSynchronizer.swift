import Foundation
import SQLite3

/// Reconstructed logic for synchronizing database metadata with sidecar files (XMP).
public class MetadataSynchronizer {
    
    private var db: OpaquePointer?
    
    public init(database: OpaquePointer?) {
        self.db = database
    }
    
    /// Reconstructed logic for checking and fixing sidecar entities.
    /// Based on disassembly of ContentCheck::CheckSidecars.
    public func validateSidecars() throws {
        guard let db = db else { return }
        
        // 1. Check for inconsistent Z_ENT in ZSIDECAR
        let checkQuery = "SELECT COUNT(*) FROM ZSIDECAR WHERE Z_ENT != 29;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, checkQuery, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_ROW {
                let invalidCount = sqlite3_column_int(statement, 0)
                if invalidCount > 0 {
                    print("Found \(invalidCount) invalid sidecar entities. Fixing...")
                    try fixSidecarEntities()
                }
            }
        }
        sqlite3_finalize(statement)
    }
    
    private func fixSidecarEntities() throws {
        let fixQuery = "UPDATE ZSIDECAR SET Z_ENT = 29 WHERE Z_ENT != 29;"
        try DataCoreManager.shared.execute(query: fixQuery)
    }
    
    /// Reconstructed logic for synchronizing metadata to XMP.
    public func syncToSidecar(imageUUID: String, xmpPath: String) {
        // Logic recovery:
        // 1. Fetch metadata from ZVARIANTMETADATA for the variant
        // 2. Format as XMP XML
        // 3. Write to file at xmpPath
        // 4. Update ZXMPMETADATAMODIFICATIONDATE in ZIMAGE
    }
}
