import Foundation
import SQLite3

/// Reconstructed logic for reading and inspecting Capture One databases.
/// Implements the 'Document Reader' pattern found in disassembly.
public class DatabaseReader {
    
    private var db: OpaquePointer?
    
    public init(database: OpaquePointer?) {
        self.db = database
    }
    
    // MARK: - Metadata Retrieval
    
    /// Reconstructed logic for fetching version information.
    public func getVersionInfo() throws -> DCVersionInfo {
        let query = "SELECT ZVERSION, ZCOMPATIBLEVERSION, ZAUTHOR, ZFORMAT FROM ZVERSIONINFO ORDER BY ROWID DESC LIMIT 1;"
        var statement: OpaquePointer?
        
        guard let db = db else { throw NSError(domain: "DataCore", code: 3, userInfo: nil) }
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_ROW {
                let version = sqlite3_column_int(statement, 0)
                let compVersion = sqlite3_column_int(statement, 1)
                let author = String(cString: sqlite3_column_text(statement, 2))
                let format = sqlite3_column_int(statement, 3)
                
                sqlite3_finalize(statement)
                return DCVersionInfo(version: Int(version), compatibleVersion: Int(compVersion), author: author, format: Int(format))
            }
        }
        sqlite3_finalize(statement)
        throw NSError(domain: "DataCore", code: 4, userInfo: [NSLocalizedDescriptionKey: "Failed to read version info"])
    }
    
    /// Reconstructed logic for counting entities in a table.
    public func countEntities(in table: String) -> Int {
        let query = "SELECT COUNT(*) FROM \(table);"
        var statement: OpaquePointer?
        var count = 0
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_ROW {
                count = Int(sqlite3_column_int(statement, 0))
            }
        }
        sqlite3_finalize(statement)
        return count
    }
}
