import ImageCore
import XCTest
// Note: Verification tests for ImageCore logic.

class ImageCoreEngineTests: XCTestCase {
    
    func testProcessSettingsInitialization() {
        var settings = IC_ProcessSettings()
        settings.engineVersion = 1600
        XCTAssertEqual(settings.engineVersion, 1600)
        XCTAssertEqual(settings.exposure, 0.0)
        XCTAssertEqual(settings.contrast, 0.0)
    }
    
    func testTilingInRender() {
        let engine = RawImageEngine.shared
        let settings = IC_ProcessSettings()
        // Use a real image from the repo to trigger the pipeline
        let imagePath = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
            .deletingLastPathComponent()
            .appendingPathComponent("skills/c1-doc-spec-extractor/docs_raw/images/Local_Article_220_21078270988573.jpg")
        
        // Non-interactive render (isLiveDrag: false)
        // This should trigger renderTiles now with Ticket [ID-8]
        _ = engine.developImage(at: imagePath, with: settings, isLiveDrag: false)
    }
    
    func testPipelineCoordination() {
        let pipeline = ImageCorePipeline(mode: .cpu_simd)
        let rep = RawImageRep(model: "Test Camera", size: CGSize(width: 100, height: 100))
        var settings = IC_ProcessSettings()
        
        // Add Lens Correction settings
        settings.lensCorrection.distortion = 10.0
        
        // Dry run simulation of pipeline execution
        pipeline.run(input: rep, settings: settings, outputBuffer: UnsafeMutableRawPointer.allocate(byteCount: 100, alignment: 1))
    }
}
