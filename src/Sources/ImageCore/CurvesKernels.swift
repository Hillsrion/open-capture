import Foundation
import Accelerate

/// Reconstructed Curves spline interpolation and LUT generation.

public struct CurvesKernels {

    /// Generates a LUT from a set of control points using Cubic Spline Interpolation.
    public static func generateLUT(from points: [ICCurvePoint], count: Int, lutSize: Int = 256) -> [Float] {
        guard count > 1 else {
            return (0..<lutSize).map { Float($0) / Float(lutSize - 1) }
        }

        let sortedPoints = points.prefix(count).sorted { $0.x < $1.x }
        let n = sortedPoints.count

        var a = [Float](repeating: 0, count: n)
        for i in 0..<n { a[i] = sortedPoints[i].y }
        
        var h = [Float](repeating: 0, count: n - 1)
        for i in 0..<(n - 1) { h[i] = sortedPoints[i+1].x - sortedPoints[i].x }
        
        var alpha = [Float](repeating: 0, count: n - 1)
        for i in 1..<(n - 1) {
            alpha[i] = (3.0 / h[i]) * (a[i+1] - a[i]) - (3.0 / h[i-1]) * (a[i] - a[i-1])
        }
        
        var l = [Float](repeating: 0, count: n)
        var mu = [Float](repeating: 0, count: n)
        var z = [Float](repeating: 0, count: n)
        
        l[0] = 1.0
        mu[0] = 0.0
        z[0] = 0.0
        
        for i in 1..<(n - 1) {
            l[i] = 2.0 * (sortedPoints[i+1].x - sortedPoints[i-1].x) - h[i-1] * mu[i-1]
            mu[i] = h[i] / l[i]
            z[i] = (alpha[i] - h[i-1] * z[i-1]) / l[i]
        }
        
        l[n-1] = 1.0
        z[n-1] = 0.0
        var c = [Float](repeating: 0, count: n)
        var b = [Float](repeating: 0, count: n - 1)
        var d = [Float](repeating: 0, count: n - 1)
        
        for j in stride(from: n - 2, through: 0, by: -1) {
            c[j] = z[j] - mu[j] * c[j+1]
            b[j] = (a[j+1] - a[j]) / h[j] - h[j] * (c[j+1] + 2.0 * c[j]) / 3.0
            d[j] = (c[j+1] - c[j]) / (3.0 * h[j])
        }
        
        var lut = [Float](repeating: 0, count: lutSize)
        for i in 0..<lutSize {
            let x = Float(i) / Float(lutSize - 1)
            var currentSegment = 0
            while currentSegment < n - 2 && x > sortedPoints[currentSegment + 1].x {
                currentSegment += 1
            }
            
            if x <= sortedPoints[0].x {
                lut[i] = sortedPoints[0].y
            } else if x >= sortedPoints[n-1].x {
                lut[i] = sortedPoints[n-1].y
            } else {
                let dx = x - sortedPoints[currentSegment].x
                let y = a[currentSegment] + b[currentSegment] * dx + c[currentSegment] * dx * dx + d[currentSegment] * dx * dx * dx
                lut[i] = max(0.0, min(1.0, y))
            }
        }
        
        return lut
    }
    
    /// Applies a pre-calculated LUT to a buffer
    public static func applyLUT(_ lut: [Float], to buffer: UnsafeMutablePointer<Float>, count: Int) {
        let maxIndex = Float(lut.count - 1)
        for i in 0..<count {
            let val = max(0.0, min(1.0, buffer[i]))
            let indexFloat = val * maxIndex
            
            let indexLower = Int(floor(indexFloat))
            let indexUpper = min(indexLower + 1, lut.count - 1)
            let fraction = indexFloat - Float(indexLower)
            
            let valLower = lut[indexLower]
            let valUpper = lut[indexUpper]
            
            buffer[i] = valLower + (valUpper - valLower) * fraction
        }
    }
}
