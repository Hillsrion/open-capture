import XCTest
// Note: Verification tests for ImageCore logic.

class ImageCoreEngineTests: XCTestCase {
    
    func testProcessSettingsInitialization() {
        let settings = IC_ProcessSettings(version: 1600)
        XCTAssertEqual(settings.engineVersion, 1600)
        XCTAssertEqual(settings.exposure, 0.0)
        XCTAssertEqual(settings.contrast, 0.0)
    }
    
    func testPipelineCoordination() {
        let pipeline = ImageCorePipeline(mode: .cpu_simd)
        let rep = RawImageRep(model: "Test Camera", size: CGSize(width: 100, height: 100))
        let settings = IC_ProcessSettings()
        
        // Dry run simulation of pipeline execution
        // Verify that the call doesn't crash and initializes correctly.
        pipeline.run(input: rep, settings: settings, outputBuffer: UnsafeMutableRawPointer.allocate(byteCount: 100, alignment: 1))
    }
    
    func testMaskParameters() {
        var params = IC_MaskRangeParametersLuma()
        XCTAssertEqual(params.lumaMin, 0.0)
        XCTAssertEqual(params.lumaMax, 1.0)
        
        params.lumaMin = 0.2
        XCTAssertEqual(params.lumaMin, 0.2)
    }
}
