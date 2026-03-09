import XCTest
import Combine
@testable import AppCoreShared
@testable import CaptureOneUI

final class HardwareControllerTests: XCTestCase {
    
    var controller: AdjustmentToolController!
    var manager: HardwareControllerManager!
    
    override func setUp() {
        super.setUp()
        controller = AdjustmentToolController.shared
        manager = HardwareControllerManager.shared
        manager.actionDelegate = controller
        
        // Reset state
        controller.exposure = 0.0
        controller.contrast = 0.0
    }
    
    func testHardwareEventRouting() {
        let expectation = XCTestExpectation(description: "Exposure updated via hardware event")
        
        var cancellable: AnyCancellable?
        cancellable = controller.$exposure.dropFirst().sink { newExposure in
            XCTAssertEqual(newExposure, 0.1, accuracy: 0.001)
            expectation.fulfill()
        }
        
        // Simulate a single click to the right on knob_1 (mapped to adjustExposure with 0.1 sensitivity)
        let event = HardwareEvent(controlID: "knob_1", delta: 1.0)
        manager.receiveEvent(event)
        
        wait(for: [expectation], timeout: 1.0)
        cancellable?.cancel()
    }
    
    func testHardwareEventClamping() {
        let expectation = XCTestExpectation(description: "Exposure clamped")
        
        // Push exposure to max
        controller.exposure = 4.0
        
        var cancellable: AnyCancellable?
        cancellable = controller.$exposure.dropFirst().sink { newExposure in
            // Delta should be ignored because it's already at max
            XCTAssertEqual(newExposure, 4.0)
            expectation.fulfill()
        }
        
        // Simulate turning past max
        let event = HardwareEvent(controlID: "knob_1", delta: 10.0)
        manager.receiveEvent(event)
        
        wait(for: [expectation], timeout: 1.0)
        cancellable?.cancel()
    }
}
