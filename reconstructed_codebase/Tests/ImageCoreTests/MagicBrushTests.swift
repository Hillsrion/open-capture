import XCTest
import CoreGraphics
@testable import ImageCore

class MagicBrushTests: XCTestCase {
    
    func testToleranceGrowth() {
        let engine = MagicBrushEngine.shared
        let size = CGSize(width: 10, height: 10)
        let pixelCount = Int(size.width * size.height)
        
        // 1. Create gradient buffer (0.0 to 1.0)
        var buffer = [Float](repeating: 0, count: pixelCount)
        for i in 0..<pixelCount {
            buffer[i] = Float(i) / Float(pixelCount)
        }
        
        var mask = [Float](repeating: 0, count: pixelCount)
        let startPoint = CGPoint(x: 5, y: 5)
        
        // 2. Grow mask with low tolerance (0.1)
        engine.growMask(from: buffer, into: &mask, size: size, startPoint: startPoint, tolerance: 0.1)
        
        let filledCount = mask.filter { $0 > 0 }.count
        XCTAssertGreaterThan(filledCount, 0)
        XCTAssertLessThan(filledCount, pixelCount)
        
        // 3. Grow mask with high tolerance (1.0) - should fill everything
        var fullMask = [Float](repeating: 0, count: pixelCount)
        engine.growMask(from: buffer, into: &fullMask, size: size, startPoint: startPoint, tolerance: 1.0)
        XCTAssertEqual(fullMask.filter { $0 > 0 }.count, pixelCount)
    }
}
