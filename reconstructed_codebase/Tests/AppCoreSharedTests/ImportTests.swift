import XCTest
import DataCore
@testable import AppCoreShared

class ImportTests: XCTestCase {
    
    var dbURL: URL!
    
    override func setUp() {
        super.setUp()
        dbURL = FileManager.default.temporaryDirectory.appendingPathComponent("test_import.cocatalogdb")
        try? DataCoreManager.shared.openDatabase(at: dbURL)
        try? DataCoreManager.shared.execute(query: DatabaseSchema.createTablesQuery)
    }
    
    override func tearDown() {
        DataCoreManager.shared.closeDatabase()
        try? FileManager.default.removeItem(at: dbURL)
        super.tearDown()
    }
    
    func testImportSettingsInitialization() {
        let settings = ImportSettings()
        
        XCTAssertEqual(settings.destinationFolderType, .insideCatalog)
        XCTAssertEqual(settings.backupType, .none)
        XCTAssertTrue(settings.includeSubfolders)
        XCTAssertEqual(settings.namingFormat, "[Image Name]")
    }
    
    func testImporterPickedState() {
        let state = ImporterPickedState()
        let url = URL(fileURLWithPath: "/test/image.jpg")
        
        XCTAssertFalse(state.isPicked(url))
        
        state.setPicked(true, for: url)
        XCTAssertTrue(state.isPicked(url))
        XCTAssertEqual(state.count, 1)
        
        state.togglePicked(for: url)
        XCTAssertFalse(state.isPicked(url))
        XCTAssertEqual(state.count, 0)
    }
    
    func testImportMetadata() {
        var metadata = ImportMetadata()
        metadata.jobName = "Test Job"
        metadata.copyright = "2026 Team"
        
        XCTAssertEqual(metadata.jobName, "Test Job")
        XCTAssertEqual(metadata.copyright, "2026 Team")
    }
    
    func testImportSourceScanner() {
        let scanner = ImportSourceScanner()
        let tmpDir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try? FileManager.default.createDirectory(at: tmpDir, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tmpDir) }
        
        let file1 = tmpDir.appendingPathComponent("image1.ARW")
        let file2 = tmpDir.appendingPathComponent("image2.jpg")
        let file3 = tmpDir.appendingPathComponent("notes.txt")
        
        try? "test".write(to: file1, atomically: true, encoding: .utf8)
        try? "test".write(to: file2, atomically: true, encoding: .utf8)
        try? "test".write(to: file3, atomically: true, encoding: .utf8)
        
        let results = scanner.scan(url: tmpDir, includeSubfolders: true)
        
        XCTAssertEqual(results.count, 2)
        XCTAssertTrue(results.contains { $0.lastPathComponent == "image1.ARW" })
        XCTAssertTrue(results.contains { $0.lastPathComponent == "image2.jpg" })
        XCTAssertFalse(results.contains { $0.lastPathComponent == "notes.txt" })
    }
    
    func testPOImporterFullFlow() {
        let importer = POImporter()
        let tmpDir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        let destDir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        try? FileManager.default.createDirectory(at: tmpDir, withIntermediateDirectories: true)
        try? FileManager.default.createDirectory(at: destDir, withIntermediateDirectories: true)
        
        defer { 
            try? FileManager.default.removeItem(at: tmpDir)
            try? FileManager.default.removeItem(at: destDir)
        }
        
        let file1 = tmpDir.appendingPathComponent("dsc001.jpg")
        try? "test".write(to: file1, atomically: true, encoding: .utf8)
        
        importer.settings.destinationFolderType = .customFolder
        importer.settings.destinationCustomPath = destDir.path
        importer.settings.namingFormat = "Imported_[Image Name]"
        
        let expectation = XCTestExpectation(description: "Import completion")
        
        importer.scanSource(url: tmpDir)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(importer.discoveredURLs.count, 1)
            importer.pickedState.setPicked(true, for: file1)
            
            importer.startImport()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if case .completed(let count) = importer.status {
                    XCTAssertEqual(count, 1)
                    
                    // Verify file existence with new name
                    let expectedDest = destDir.appendingPathComponent("Imported_dsc001.jpg")
                    XCTAssertTrue(FileManager.default.fileExists(atPath: expectedDest.path))
                    
                    // Verify database registration
                    let reader = DataCoreManager.shared.reader()
                    let dbCount = reader.countEntities(in: "ZIMAGE")
                    XCTAssertEqual(dbCount, 1)
                } else {
                    XCTFail("Import status should be completed, was \(importer.status)")
                }
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
}
