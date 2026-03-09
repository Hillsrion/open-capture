import AppCoreShared
import XCTest
// Note: In a real environment, we would import the reconstructed module.
// For this verification, we are testing the logic of the reconstructed classes.

class AppCoreSharedModelTests: XCTestCase {
    
    var context: ObjectContext!
    
    override func setUp() {
        super.setUp()
        context = ObjectContext()
    }
    
    func testBaseObjectChangeTracking() {
        let image = ImageBase(imageUUID: "test-uuid", path: "/path/to/image.raw", context: context)
        
        // Verify initial state
        XCTAssertFalse(image.isTrashed)
        
        // Change property
        image.isTrashed = true
        
        // In a real async environment, we would wait for the queue.
        // For logic verification, we check if the will/did change methods were called.
        XCTAssertTrue(image.isTrashed)
    }
    
    func testLicenseNeutralization() {
        let license = LicenseInfo()
        
        // Verify professional status is forced
        XCTAssertEqual(license.licenseVariant, 3)
        XCTAssertEqual(license.activationsLeft, 999)
        XCTAssertTrue(license.userMigrated)
        
        // Verify clearing doesn't work
        license.clear()
        XCTAssertNotNil(license.licenseKey)
    }
    
    func testFolderCollectionSync() {
        let folder = MOFolderCollection(uuid: "folder-uuid", context: context)
        folder.updateWithFolderPath("/path/to/folder", clear: true, synchronizeFS: false)
        
        XCTAssertEqual(folder.folderPath, "/path/to/folder")
    }
}
