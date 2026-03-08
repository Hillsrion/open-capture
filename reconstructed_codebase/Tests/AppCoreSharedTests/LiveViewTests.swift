import XCTest
@testable import AppCoreShared

final class LiveViewTests: XCTestCase {
    
    func testLiveViewAutoPauseDuringCapture() {
        let camera = P1CaptureCore_Camera(id: "TEST-001", name: "Test Camera")
        
        // 1. Enable Live View
        let expectationActive = XCTestExpectation(description: "Live View becomes active")
        camera.startLiveView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if camera.liveViewState == .active {
                expectationActive.fulfill()
            }
        }
        wait(for: [expectationActive], timeout: 1.0)
        
        // 2. Trigger Capture
        camera.shutterRelease()
        XCTAssertEqual(camera.liveViewState, .paused, "Live View should pause during capture")
        XCTAssertTrue(camera.isCapturing)
        
        // 3. Wait for completion
        let expectationResume = XCTestExpectation(description: "Live View resumes after capture")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            if camera.liveViewState == .active {
                expectationResume.fulfill()
            }
        }
        wait(for: [expectationResume], timeout: 2.0)
        
        XCTAssertFalse(camera.isCapturing)
    }
    
    func testLiveViewFetchLogic() {
        let camera = P1CaptureCore_Camera(id: "TEST-002", name: "Test Camera 2")
        camera.liveViewState = .active
        
        let frame = camera.getNextLiveViewImage()
        XCTAssertNotNil(frame)
        XCTAssertGreaterThan(frame!.timestamp, 0)
        XCTAssert(0...2 ~= frame!.focusStatus)
    }
}
