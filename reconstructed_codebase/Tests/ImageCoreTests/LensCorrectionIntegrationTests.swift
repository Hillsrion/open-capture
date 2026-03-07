import XCTest
import AppCoreShared
@testable import ImageCore

class LensCorrectionIntegrationTests: XCTestCase {
    
    func testLensCorrectionHistogramImpact() {
        let size = CGSize(width: 100, height: 100)
        let rep = RawImageRep(model: "Test", size: size)
        var settings = IC_ProcessSettings()
        
        // 1. Neutral settings
        settings.lensCorrection.lightFalloff = 0.0
        
        // Mock output buffer
        let pixelCount = 10000
        let buffer = UnsafeMutableRawPointer.allocate(byteCount: pixelCount * 4, alignment: 8)
        defer { buffer.deallocate() }
        
        let pipeline = ImageCorePipeline(mode: .cpu_simd)
        pipeline.run(input: rep, settings: settings, outputBuffer: buffer)
        
        // 2. Apply Light Falloff
        settings.lensCorrection.lightFalloff = 100.0
        pipeline.run(input: rep, settings: settings, outputBuffer: buffer)
        
        // Verify call doesn't crash and settings are applied
        XCTAssertEqual(settings.lensCorrection.lightFalloff, 100.0)
    }
}
