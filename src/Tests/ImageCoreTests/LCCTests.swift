import XCTest
@testable import ImageCore

class LCCTests: XCTestCase {
    
    func testLCCProfileCreation() {
        let size = CGSize(width: 100, height: 100)
        let rep = RawImageRep(model: "Test Camera", size: size)
        
        // Mock a "white card" image with some falloff
        let buffer = UnsafeMutablePointer<Float>.allocate(capacity: 100 * 100)
        defer { buffer.deallocate() }
        
        for i in 0..<10000 {
            buffer[i] = 0.8 // Uniform gray/white
        }
        
        // Create LCC Profile
        let lccManager = LCCManager.shared
        let profile = lccManager.generateLensCastCorrection(from: buffer, size: size, input: rep)
        
        XCTAssertNotNil(profile)
        XCTAssertEqual(profile.cameraModel, "Test Camera")
        XCTAssertTrue(profile.hasUniformityData)
    }
    
    func testLCCApplication() {
        let size = CGSize(width: 10, height: 10)
        var buffer: [Float] = Array(repeating: 0.5, count: 100)
        
        // Mock profile with 1.2x gain at the center (simple uniform gain for testing)
        let profile = IC_LCCProfile(cameraModel: "Test", size: size, uniformityMap: Array(repeating: 1.2, count: 100))
        
        LCCManager.shared.apply(profile: profile, to: &buffer, count: 100)
        
        // All pixels should be 0.5 * 1.2 = 0.6
        XCTAssertEqual(buffer[0], 0.6, accuracy: 1e-5)
    }
}
