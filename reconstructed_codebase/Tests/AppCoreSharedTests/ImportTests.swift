import XCTest
@testable import AppCoreShared

class ImportTests: XCTestCase {
    
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
}
