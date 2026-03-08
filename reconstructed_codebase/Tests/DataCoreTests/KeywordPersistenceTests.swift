import XCTest
import AppCoreShared
@testable import DataCore

class KeywordPersistenceTests: XCTestCase {
    
    var dbURL: URL!
    
    override func setUp() {
        super.setUp()
        dbURL = FileManager.default.temporaryDirectory.appendingPathComponent("test_keywords.cocatalogdb")
        try? DataCoreManager.shared.openDatabase(at: dbURL)
        try? DataCoreManager.shared.execute(query: DatabaseSchema.createTablesQuery)
    }
    
    override func tearDown() {
        DataCoreManager.shared.closeDatabase()
        try? FileManager.default.removeItem(at: dbURL)
        super.tearDown()
    }
    
    func testKeywordCRUD() {
        let writer = DataCoreManager.shared.writer()
        let reader = DataCoreManager.shared.reader()
        
        let uuid = UUID().uuidString
        
        // 1. Create
        do {
            try writer.createKeyword(uuid: uuid, name: "Wedding", parentPK: nil)
            
            // 2. Read
            let keywords = try reader.fetchAllKeywords()
            XCTAssertEqual(keywords.count, 1)
            XCTAssertEqual(keywords[0]["ZNAME"] as? String, "Wedding")
            
            // 3. Nested
            let parentPK = keywords[0]["Z_PK"] as? Int
            try writer.createKeyword(uuid: UUID().uuidString, name: "Ceremony", parentPK: parentPK)
            
            let all = try reader.fetchAllKeywords()
            XCTAssertEqual(all.count, 2)
            XCTAssertTrue(all.contains { ($0["ZNAME"] as? String) == "Ceremony" })
        } catch {
            XCTFail("Keyword persistence failed: \(error)")
        }
    }
}
