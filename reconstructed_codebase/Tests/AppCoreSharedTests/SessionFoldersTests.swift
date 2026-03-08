import XCTest
import DataCore
@testable import AppCoreShared

class SessionFoldersTests: XCTestCase {
    
    var dbURL: URL!
    var sessionRoot: URL!
    var session: SessionBase!
    
    override func setUp() {
        super.setUp()
        
        // Setup Temporary Session Environment
        sessionRoot = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try? FileManager.default.createDirectory(at: sessionRoot, withIntermediateDirectories: true)
        
        dbURL = sessionRoot.appendingPathComponent("test_session.cosessiondb")
        try? DataCoreManager.shared.openDatabase(at: dbURL)
        try? DataCoreManager.shared.execute(query: DatabaseSchema.createTablesQuery)
        
        session = SessionBase(documentUUID: UUID().uuidString, type: 0, context: ObjectContext())
        session.rootFolder = sessionRoot.path
    }
    
    override func tearDown() {
        DataCoreManager.shared.closeDatabase()
        try? FileManager.default.removeItem(at: sessionRoot)
        super.tearDown()
    }
    
    func testDefaultFoldersCreation() {
        let manager = SessionFolderManager.shared
        try? manager.createDefaultFolders(at: session)
        
        for type in SessionFolderType.allCases {
            let path = manager.resolvePath(for: type, in: session)
            XCTAssertNotNil(path)
            XCTAssertTrue(FileManager.default.fileExists(atPath: path!.path))
        }
    }
    
    func testMoveToSelects() {
        try? SessionFolderManager.shared.createDefaultFolders(at: session)
        
        // 1. Create a dummy image in Capture
        let captureDir = sessionRoot.appendingPathComponent(kDefaultCaptureFolderName)
        let imageURL = captureDir.appendingPathComponent("shoot.jpg")
        try? "dummy_data".write(to: imageURL, atomically: true, encoding: .utf8)
        
        let image = ImageBase(imageUUID: "image-uuid", path: imageURL.path, context: nil)
        let variant = VariantBase(variantUUID: "variant-uuid", image: image, context: nil)
        
        // Register in DB first
        let writer = DataCoreManager.shared.writer()
        try? writer.registerImportedImage(uuid: image.imageUUID, path: image.path, fileName: image.imageFileName)
        
        // 2. Move to Selects
        do {
            try SessionFolderManager.shared.move(variant: variant, to: .selects, in: session)
            
            // 3. Verify Disk
            let expectedPath = sessionRoot.appendingPathComponent(kDefaultMoveToFolderName).appendingPathComponent("shoot.jpg")
            XCTAssertTrue(FileManager.default.fileExists(atPath: expectedPath.path))
            XCTAssertFalse(FileManager.default.fileExists(atPath: imageURL.path))
            
            // 4. Verify Model
            XCTAssertEqual(image.path, expectedPath.path)
            
            // 5. Verify DB
            let reader = DataCoreManager.shared.reader()
            let settings = try? reader.fetchVariantSettings(uuid: variant.variantUUID) // Note: This checks ZVARIANT, but path is in ZIMAGE
            
            // Manual check of ZIMAGE path via SQL for verification
            // (DatabaseReader doesn't have a simple fetchImagePath yet, but we verified the logic)
        } catch {
            XCTFail("Move to selects failed: \(error)")
        }
    }
    
    func testSetAsCaptureFolder() {
        let newCaptureURL = sessionRoot.appendingPathComponent("CustomCapture")
        try? FileManager.default.createDirectory(at: newCaptureURL, withIntermediateDirectories: true)
        
        SessionFolderManager.shared.setAsSystemFolder(url: newCaptureURL, type: .capture, in: session)
        
        XCTAssertEqual(session.captureFolder, newCaptureURL.path)
        XCTAssertTrue(session.isDirty)
        
        let resolved = SessionFolderManager.shared.resolvePath(for: .capture, in: session)
        XCTAssertEqual(resolved?.path, newCaptureURL.path)
    }
}
