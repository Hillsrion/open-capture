import Foundation
import SQLite3

/// Reconstructed logic for writing to Capture One databases.
/// Implements the 'Document Writer' pattern found in disassembly.
public class DatabaseWriter {
    
    private var db: OpaquePointer?
    
    public init(database: OpaquePointer?) {
        self.db = database
    }
    
    /// Reconstructed logic for registering a newly imported image.
    public func registerImportedImage(uuid: String, path: String, fileName: String) throws {
        let query = "INSERT INTO ZIMAGE (ZIMAGEUUID, ZSIDECARPATH, ZDISPLAYNAME, ZIMAGEFILENAME, ZRAWMETADATAMODIFICATIONDATE) VALUES (?, ?, ?, ?, ?);"
        var statement: OpaquePointer?
        
        guard let db = db else { throw NSError(domain: "DataCore", code: 3, userInfo: nil) }
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (uuid as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (path as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (fileName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, (fileName as NSString).utf8String, -1, nil)
            sqlite3_bind_double(statement, 5, Date().timeIntervalSince1970)
            
            if sqlite3_step(statement) != SQLITE_DONE {
                let error = String(cString: sqlite3_errmsg(db))
                sqlite3_finalize(statement)
                throw NSError(domain: "DataCore", code: 5, userInfo: [NSLocalizedDescriptionKey: error])
            }
        }
        sqlite3_finalize(statement)
    }
    
    /// Updates the image name and filename in the database (WF-501).
    public func updateImageName(uuid: String, displayName: String, fileName: String, path: String) throws {
        let query = "UPDATE ZIMAGE SET ZDISPLAYNAME = ?, ZIMAGEFILENAME = ?, ZSIDECARPATH = ? WHERE ZIMAGEUUID = ?;"
        var statement: OpaquePointer?
        
        guard let db = db else { throw NSError(domain: "DataCore", code: 3, userInfo: nil) }
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (displayName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (fileName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (path as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, (uuid as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) != SQLITE_DONE {
                let error = String(cString: sqlite3_errmsg(db))
                sqlite3_finalize(statement)
                throw NSError(domain: "DataCore", code: 11, userInfo: [NSLocalizedDescriptionKey: error])
            }
        }
        sqlite3_finalize(statement)
    }
    
    /// Reconstructed logic for creating a variant for an image.
    public func createVariant(uuid: String, imagePK: Int) throws {
        let query = "INSERT INTO ZVARIANT (ZVARIANTUUID, ZIMAGE, ZISMODIFIED) VALUES (?, ?, ?);"
        var statement: OpaquePointer?
        
        guard let db = db else { throw NSError(domain: "DataCore", code: 3, userInfo: nil) }
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (uuid as NSString).utf8String, -1, nil)
            sqlite3_bind_int(statement, 2, Int32(imagePK))
            sqlite3_bind_int(statement, 3, 0)
            
            if sqlite3_step(statement) != SQLITE_DONE {
                let error = String(cString: sqlite3_errmsg(db))
                sqlite3_finalize(statement)
                throw NSError(domain: "DataCore", code: 6, userInfo: [NSLocalizedDescriptionKey: error])
            }
        }
        sqlite3_finalize(statement)
    }
    
    /// Reconstructed logic for updating an image's path (e.g., during move to selects/trash).
    public func updateImagePath(imageUUID: String, newPath: String) throws {
        let query = "UPDATE ZIMAGE SET ZSIDECARPATH = ? WHERE ZIMAGEUUID = ?;"
        var statement: OpaquePointer?
        
        guard let db = db else { throw NSError(domain: "DataCore", code: 3, userInfo: nil) }
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (newPath as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (imageUUID as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) != SQLITE_DONE {
                let error = String(cString: sqlite3_errmsg(db))
                sqlite3_finalize(statement)
                throw NSError(domain: "DataCore", code: 7, userInfo: [NSLocalizedDescriptionKey: error])
            }
        }
        sqlite3_finalize(statement)
    }
    
    /// Reconstructed logic for saving session metadata.
    public func saveSessionInfo(uuid: String, capture: String?, selects: String?, output: String?, trash: String?) throws {
        let query = "UPDATE ZDOCUMENTCONTENT SET ZCAPTUREFOLDER = ?, ZSELECTSFOLDER = ?, ZOUTPUTFOLDER = ?, ZTRASHFOLDER = ? WHERE ZDOCUMENTUUID = ?;"
        var statement: OpaquePointer?
        
        guard let db = db else { throw NSError(domain: "DataCore", code: 3, userInfo: nil) }
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (capture as NSString?)?.utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (selects as NSString?)?.utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (output as NSString?)?.utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, (trash as NSString?)?.utf8String, -1, nil)
            sqlite3_bind_text(statement, 5, (uuid as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) != SQLITE_DONE {
                let error = String(cString: sqlite3_errmsg(db))
                sqlite3_finalize(statement)
                throw NSError(domain: "DataCore", code: 8, userInfo: [NSLocalizedDescriptionKey: error])
            }
        }
        sqlite3_finalize(statement)
    }
    
    /// Reconstructed logic for updating variant metadata (rating, color tag) (CORE-009).
    /// Updated to match Capture One 16.7.x schema using ZVARIANTMETADATA.
    public func updateVariantMetadata(uuid: String, rating: Int, colorTag: Int) throws {
        guard let db = db else { throw NSError(domain: "DataCore", code: 3, userInfo: nil) }

        // 1. Update ZVARIANTMETADATA through ZVARIANT -> ZVARIANTLAYER relationship
        let metadataQuery = """
            UPDATE ZVARIANTMETADATA 
            SET ZBASIC_RATING = ?, ZCOLOR_TAG_INDEX = ? 
            WHERE Z_PK = (
                SELECT ZMETADATA FROM ZVARIANTLAYER 
                WHERE Z_PK = (SELECT ZDEFAULTLAYER FROM ZVARIANT WHERE ZVARIANTUUID = ?)
            );
        """
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, metadataQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(rating))
            sqlite3_bind_int(statement, 2, Int32(colorTag))
            sqlite3_bind_text(statement, 3, (uuid as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) != SQLITE_DONE {
                let error = String(cString: sqlite3_errmsg(db))
                sqlite3_finalize(statement)
                throw NSError(domain: "DataCore", code: 10, userInfo: [NSLocalizedDescriptionKey: error])
            }
        }
        sqlite3_finalize(statement)
        
        // 2. Mark variant as modified
        let modifiedQuery = "UPDATE ZVARIANT SET ZISMODIFIED = 1 WHERE ZVARIANTUUID = ?;"
        if sqlite3_prepare_v2(db, modifiedQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (uuid as NSString).utf8String, -1, nil)
            sqlite3_step(statement)
        }
        sqlite3_finalize(statement)
    }
}
