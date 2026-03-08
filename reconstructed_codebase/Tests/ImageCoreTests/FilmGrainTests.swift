import XCTest
@testable import ImageCore

class FilmGrainTests: XCTestCase {
    
    func testFilmGrainApplication() {
        let pixelCount = 100
        var buffer = [Float](repeating: 0.5, count: pixelCount)
        
        var settings = IC_FilmGrainSettings()
        settings.amount = 50.0 // 50% grain
        
        // 1. Apply grain
        FilmGrainKernel.apply(to: &buffer, count: pixelCount, settings: settings)
        
        // 2. Verify pixel variance
        let allEqual = buffer.allSatisfy { $0 == 0.5 }
        XCTAssertFalse(allEqual, "Film grain should introduce pixel variance")
        
        // 3. Verify luminance masking (deep black should have less grain)
        var blackBuffer = [Float](repeating: 0.0, count: pixelCount)
        FilmGrainKernel.apply(to: &blackBuffer, count: pixelCount, settings: settings)
        
        let blackVariance = blackBuffer.map { abs($0 - 0.0) }.reduce(0, +)
        let midVariance = buffer.map { abs($0 - 0.5) }.reduce(0, +)
        
        XCTAssertLessThan(blackVariance, midVariance, "Luminance masking should reduce grain in blacks")
    }
}
