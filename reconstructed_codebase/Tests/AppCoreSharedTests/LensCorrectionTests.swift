import XCTest
@testable import AppCoreShared

class LensCorrectionTests: XCTestCase {
    
    func testLensCorrectionSettingsInitialization() {
        let settings = MCLensCorrectionSettings()
        
        // Default values should be zero/neutral
        XCTAssertEqual(settings.distortion, 0.0)
        XCTAssertEqual(settings.lightFalloff, 0.0)
        XCTAssertEqual(settings.sharpnessFalloff, 0.0)
        XCTAssertFalse(settings.isLCCActive)
    }
    
    func testLensCorrectionSettingsModification() {
        var settings = MCLensCorrectionSettings()
        
        settings.distortion = 50.0
        settings.lightFalloff = 25.0
        settings.sharpnessFalloff = 10.0
        
        XCTAssertEqual(settings.distortion, 50.0)
        XCTAssertEqual(settings.lightFalloff, 25.0)
        XCTAssertEqual(settings.sharpnessFalloff, 10.0)
    }
    
    func testLCCSettings() {
        let lccProfile = MCLCCProfile(uuid: "test-lcc-uuid", name: "Test LCC Profile")
        let settings = MCLCCSettings(profile: lccProfile, isActive: true)
        
        XCTAssertEqual(settings.profile?.uuid, "test-lcc-uuid")
        XCTAssertEqual(settings.profile?.displayName, "Test LCC Profile")
        XCTAssertTrue(settings.isActive)
    }
    
    func testLensCorrectionManager() {
        let manager = LensCorrectionManager.shared
        let profile = MCLCCProfile(uuid: "manager-test-uuid", name: "Manager Test Profile")
        
        manager.addProfile(profile)
        
        let retrieved = manager.profile(withUUID: "manager-test-uuid")
        XCTAssertNotNil(retrieved)
        XCTAssertEqual(retrieved?.displayName, "Manager Test Profile")
        
        XCTAssertNil(manager.profile(withUUID: "non-existent"))
    }
}
