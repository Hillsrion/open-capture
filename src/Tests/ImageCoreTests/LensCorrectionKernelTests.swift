import XCTest
@testable import ImageCore

class LensCorrectionKernelTests: XCTestCase {
    
    func testDistortionCorrection() {
        // Create a small grid of "pixels" (coordinates)
        // For testing, we'll verify that the kernel shifts coordinates correctly.
        var x: [Float] = [-1.0, 0.0, 1.0]
        var y: [Float] = [-1.0, 0.0, 1.0]
        
        // Apply positive distortion (barrel)
        LensCorrectionKernels.applyDistortion(x: &x, y: &y, count: 3, k1: 0.1)
        
        // Center (0,0) should remain at (0,0)
        XCTAssertEqual(x[1], 0.0, accuracy: 1e-5)
        XCTAssertEqual(y[1], 0.0, accuracy: 1e-5)
        
        // Corners should be pushed outwards
        XCTAssertGreaterThan(abs(x[0]), 1.0)
        XCTAssertGreaterThan(abs(y[0]), 1.0)
    }
    
    func testLightFalloffCompensation() {
        var buffer: [Float] = [0.5, 0.5, 0.5] // Center, Mid, Edge
        let distances: [Float] = [0.0, 0.5, 1.0]
        
        LensCorrectionKernels.applyLightFalloff(to: &buffer, distances: distances, count: 3, amount: 1.0)
        
        // Center should remain unchanged (distance 0)
        XCTAssertEqual(buffer[0], 0.5, accuracy: 1e-5)
        
        // Edge should be brighter (compensated for falloff)
        XCTAssertGreaterThan(buffer[2], 0.5)
    }
    
    func testChromaticAberrationCorrection() {
        var r: [Float] = [1.0, 1.0, 1.0]
        var g: [Float] = [1.0, 1.0, 1.0]
        var b: [Float] = [1.0, 1.0, 1.0]
        
        LensCorrectionKernels.applyCA(r: &r, g: &g, b: &b, count: 3, rScale: 0.9, bScale: 1.1)
        
        XCTAssertEqual(r[0], 0.9, accuracy: 1e-5)
        XCTAssertEqual(g[0], 1.0, accuracy: 1e-5)
        XCTAssertEqual(b[0], 1.1, accuracy: 1e-5)
    }
}
