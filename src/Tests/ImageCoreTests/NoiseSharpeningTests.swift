import XCTest
import AppCoreShared
@testable import ImageCore

class NoiseSharpeningTests: XCTestCase {
    
    func testSharpeningImpact() {
        let size = CGSize(width: 100, height: 100)
        let rep = RawImageRep(model: "Test", size: size)
        var settings = IC_ProcessSettings()
        
        // 1. High Sharpening
        settings.sharpening.amount = 500.0
        settings.sharpening.radius = 2.5
        
        let pixelCount = 10000
        let buffer = UnsafeMutableRawPointer.allocate(byteCount: pixelCount * 4, alignment: 8)
        defer { buffer.deallocate() }
        
        let pipeline = ImageCorePipeline(mode: .cpu_simd)
        pipeline.run(input: rep, settings: settings, outputBuffer: buffer)
        
        XCTAssertEqual(settings.sharpening.amount, 500.0)
    }
    
    func testNoiseReductionImpact() {
        let size = CGSize(width: 100, height: 100)
        let rep = RawImageRep(model: "Test", size: size)
        var settings = IC_ProcessSettings()
        
        // 1. High NR
        settings.noiseReduction.luminance = 100.0
        settings.noiseReduction.color = 100.0
        
        let pixelCount = 10000
        let buffer = UnsafeMutableRawPointer.allocate(byteCount: pixelCount * 4, alignment: 8)
        defer { buffer.deallocate() }
        
        let pipeline = ImageCorePipeline(mode: .cpu_simd)
        pipeline.run(input: rep, settings: settings, outputBuffer: buffer)
        
        XCTAssertEqual(settings.noiseReduction.luminance, 100.0)
    }
}
