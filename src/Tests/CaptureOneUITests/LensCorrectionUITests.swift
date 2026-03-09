import XCTest
import AppCoreShared
import CaptureOneUI

class LensCorrectionUITests: XCTestCase {
    
    var controller: AdjustmentToolController!
    
    override func setUp() {
        super.setUp()
        controller = AdjustmentToolController()
    }
    
    func testLensCorrectionStateChanges() {
        // Initial state
        XCTAssertEqual(controller.lensDistortion, 0.0)
        XCTAssertEqual(controller.lensLightFalloff, 0.0)
        
        // Change state
        controller.lensDistortion = 25.0
        controller.lensLightFalloff = 50.0
        
        XCTAssertEqual(controller.lensDistortion, 25.0)
        XCTAssertEqual(controller.lensLightFalloff, 50.0)
    }
    
    func testLCCStateChange() {
        XCTAssertFalse(controller.isLCCActive)
        
        controller.isLCCActive = true
        XCTAssertTrue(controller.isLCCActive)
    }
}
