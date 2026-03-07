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
    public func syncToSidecar(imageUUID: String, xmpPath: String) throws {
        // Logic recovery:
        // 1. Fetch metadata from ZMETADATA for the image
        let query = "SELECT ZCREATOR, ZCOPYRIGHT, ZDESCRIPTION, ZKEYWORDS FROM ZMETADATA WHERE ZIMAGE = (SELECT Z_PK FROM ZIMAGE WHERE ZIMAGEUUID = '\(imageUUID)');"
        var statement: OpaquePointer?
        
        guard let db = db else { return }
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_ROW {
                let creator = String(cString: sqlite3_column_text(statement, 0))
                let copyright = String(cString: sqlite3_column_text(statement, 1))
                let description = String(cString: sqlite3_column_text(statement, 2))
                let keywords = String(cString: sqlite3_column_text(statement, 3)).components(separatedBy: ",")
                
                // 2. Generate XMP
                let xmpString = XMPGenerator.generateXMP(
                    rating: 0, // Should fetch from Variant
                    colorTag: "None", 
                    creator: creator,
                    copyright: copyright,
                    description: description,
                    keywords: keywords
                )
                
                try xmpString.write(to: URL(fileURLWithPath: xmpPath), atomically: true, encoding: .utf8)
                print("[MetadataSync] Syncing metadata for \(imageUUID) to \(xmpPath)")
                
                // 3. Update modification date
                let now = NSDate().timeIntervalSince1970
                let updateQuery = "UPDATE ZIMAGE SET ZXMPMETADATAMODIFICATIONDATE = \(now) WHERE ZIMAGEUUID = '\(imageUUID)';"
                try DataCoreManager.shared.execute(query: updateQuery)
            }
        }
        sqlite3_finalize(statement)
    }
    
    /// Reconstructed logic for reading metadata from an XMP sidecar.
    public func readFromSidecar(xmpPath: String) throws -> [String: Any] {
        let data = try Data(contentsOf: URL(fileURLWithPath: xmpPath))
        let parser = XMPParser()
        return parser.parse(xmp: data)
    }
}
