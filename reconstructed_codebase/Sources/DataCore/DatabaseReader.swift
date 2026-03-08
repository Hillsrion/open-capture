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
    
    /// Reconstructed logic for fetching variants based on a predicate.
    /// Used by Smart Albums and Browser filtering.
    public func fetchVariants(with predicate: COFilterPredicate) throws -> [String] {
        let whereClause = predicate.toSQL()
        let query = """
        SELECT ZVARIANTUUID FROM ZVARIANT 
        JOIN ZIMAGE ON ZVARIANT.ZIMAGE = ZIMAGE.Z_PK
        WHERE \(whereClause);
        """
        
        var statement: OpaquePointer?
        var results: [String] = []
        
        guard let db = db else { throw NSError(domain: "DataCore", code: 3, userInfo: nil) }
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                if let uuid = sqlite3_column_text(statement, 0) {
                    results.append(String(cString: uuid))
                }
            }
        }
        sqlite3_finalize(statement)
        return results
    }
    
    /// Reconstructed logic for fetching full variant settings from ZVARIANT.
    public func fetchVariantSettings(uuid: String) throws -> [String: Any] {
        let query = "SELECT ZLENS_DISTORTION, ZLENS_SHARPNESS_FALLOFF, ZLENS_LIGHT_FALLOFF, ZLENS_SHIFT_X, ZLENS_SHIFT_Y, ZCHROMATIC_ABERRATION, ZLCC_ACTIVE, ZLCC_PROFILE_UUID FROM ZVARIANT WHERE ZVARIANTUUID = ?;"
        var statement: OpaquePointer?
        var settings: [String: Any] = [:]
        
        guard let db = db else { throw NSError(domain: "DataCore", code: 3, userInfo: nil) }
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (uuid as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_ROW {
                settings["ZLENS_DISTORTION"] = sqlite3_column_double(statement, 0)
                settings["ZLENS_SHARPNESS_FALLOFF"] = sqlite3_column_double(statement, 1)
                settings["ZLENS_LIGHT_FALLOFF"] = sqlite3_column_double(statement, 2)
                settings["ZLENS_SHIFT_X"] = Float(sqlite3_column_double(statement, 3))
                settings["ZLENS_SHIFT_Y"] = Float(sqlite3_column_double(statement, 4))
                settings["ZCHROMATIC_ABERRATION"] = sqlite3_column_int(statement, 5) != 0
                settings["ZLCC_ACTIVE"] = sqlite3_column_int(statement, 6) != 0
                if let profileUUID = sqlite3_column_text(statement, 7) {
                    settings["ZLCC_PROFILE_UUID"] = String(cString: profileUUID)
                }
            }
        }
        sqlite3_finalize(statement)
        return settings
    }
    
    /// Reconstructed logic for fetching session metadata from ZDOCUMENTCONTENT.
    public func fetchSessionInfo() throws -> [String: Any] {
        let query = "SELECT ZDOCUMENTUUID, ZDOCUMENTTYPE, ZCAPTUREFOLDER, ZSELECTSFOLDER, ZOUTPUTFOLDER, ZTRASHFOLDER FROM ZDOCUMENTCONTENT LIMIT 1;"
        var statement: OpaquePointer?
        var info: [String: Any] = [:]
        
        guard let db = db else { throw NSError(domain: "DataCore", code: 3, userInfo: nil) }
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_ROW {
                if let uuid = sqlite3_column_text(statement, 0) {
                    info["ZDOCUMENTUUID"] = String(cString: uuid)
                }
                info["ZDOCUMENTTYPE"] = sqlite3_column_int(statement, 1)
                
                if let path = sqlite3_column_text(statement, 2) { info["ZCAPTUREFOLDER"] = String(cString: path) }
                if let path = sqlite3_column_text(statement, 3) { info["ZSELECTSFOLDER"] = String(cString: path) }
                if let path = sqlite3_column_text(statement, 4) { info["ZOUTPUTFOLDER"] = String(cString: path) }
                if let path = sqlite3_column_text(statement, 5) { info["ZTRASHFOLDER"] = String(cString: path) }
            }
        }
        sqlite3_finalize(statement)
        return info
    }
}
