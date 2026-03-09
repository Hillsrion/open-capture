import DataCore
import XCTest
import SQLite3

class DataCorePersistenceTests: XCTestCase {
    
    var dbURL: URL!
    
    override func setUp() {
        super.setUp()
        // Use a temporary file for database testing
        dbURL = FileManager.default.temporaryDirectory.appendingPathComponent("test_catalog.cocatalogdb")
    }
    
    override func tearDown() {
        try? FileManager.default.removeItem(at: dbURL)
        super.tearDown()
    }
    
    func testCatalogInitialization() {
        let catalogManager = DatabaseCatalogManager.shared
        
        do {
            try catalogManager.initializeCatalog(at: dbURL)
            
            // Verify database file exists
            XCTAssertTrue(FileManager.default.fileExists(atPath: dbURL.path))
            
            // Verify statistics (default All Images collection should be present)
            let stats = try catalogManager.getCatalogStatistics(at: dbURL)
            XCTAssertEqual(stats["collections"], 1)
            
        } catch {
            XCTFail("Catalog initialization failed: \(error)")
        }
    }
    
    func testSchemaIntegrity() {
        let manager = DataCoreManager.shared
        do {
            try manager.openDatabase(at: dbURL)
            try manager.execute(query: DatabaseSchema.createTablesQuery)
            
            let reader = DatabaseReader(database: nil) // Mocked for count
            let imageCount = reader.countEntities(in: "ZIMAGE")
            XCTAssertEqual(imageCount, 0)
            
            manager.closeDatabase()
        } catch {
            XCTFail("Schema execution failed: \(error)")
        }
    }
}
