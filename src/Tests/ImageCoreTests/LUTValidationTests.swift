import XCTest
import ImageCore
@testable import ImageCore

final class LUTValidationTests: XCTestCase {
    
    func compareLUTs(cpuLUT: ColorLUT, gpuLUT: ColorLUT, tolerance: Float = 0.002) {
        XCTAssertEqual(cpuLUT.dimension, gpuLUT.dimension)
        XCTAssertEqual(cpuLUT.data.count, gpuLUT.data.count)
        
        let cpuData = cpuLUT.data.withUnsafeBytes { Array($0.bindMemory(to: Float.self)) }
        let gpuData = gpuLUT.data.withUnsafeBytes { Array($0.bindMemory(to: Float.self)) }
        
        for i in 0..<cpuData.count {
            if abs(cpuData[i] - gpuData[i]) > tolerance {
                XCTFail("Mismatch at index \(i): CPU \(cpuData[i]) vs GPU \(gpuData[i]) (delta: \(abs(cpuData[i] - gpuData[i])))")
                return
            }
        }
    }
    
    func testNeutralSettings() {
        let settings = IC_ProcessSettings()
        let cpuBuilder = ColorLUTBuilder()
        let gpuBuilder = MetalColorLUTBuilder()
        
        XCTAssertNotNil(gpuBuilder, "MetalColorLUTBuilder initialization failed (Is Metal available on this host?)")
        guard let gpuBuilder = gpuBuilder else { return }
        
        let cpuLUT = cpuBuilder.build(settings: settings)
        let gpuLUT = gpuBuilder.build(settings: settings)
        
        XCTAssertNotNil(gpuLUT)
        compareLUTs(cpuLUT: cpuLUT, gpuLUT: gpuLUT!)
    }
    
    func testSCurve() {
        var settings = IC_ProcessSettings()
        var points = Array(repeating: ICCurvePoint(), count: 16)
        points[0] = ICCurvePoint(x: 0, y: 0)
        points[1] = ICCurvePoint(x: 0.25, y: 0.15)
        points[2] = ICCurvePoint(x: 0.5, y: 0.5)
        points[3] = ICCurvePoint(x: 0.75, y: 0.85)
        points[4] = ICCurvePoint(x: 1, y: 1)
        
        settings.gradationCurves.curveX.points = points
        settings.gradationCurves.curveX.count = 5
        
        let cpuBuilder = ColorLUTBuilder()
        let gpuBuilder = MetalColorLUTBuilder()
        
        XCTAssertNotNil(gpuBuilder)
        guard let gpuBuilder = gpuBuilder else { return }
        
        let cpuLUT = cpuBuilder.build(settings: settings)
        let gpuLUT = gpuBuilder.build(settings: settings)
        
        XCTAssertNotNil(gpuLUT)
        compareLUTs(cpuLUT: cpuLUT, gpuLUT: gpuLUT!)
    }
    
    func testStrongColorBalance() {
        var settings = IC_ProcessSettings()
        settings.colorBalance.shadow = ColorBalanceValue(hue: 210, saturation: 50, brightness: -5)
        settings.colorBalance.highlight = ColorBalanceValue(hue: 30, saturation: 40, brightness: 10)
        
        let cpuBuilder = ColorLUTBuilder()
        let gpuBuilder = MetalColorLUTBuilder()
        
        XCTAssertNotNil(gpuBuilder)
        guard let gpuBuilder = gpuBuilder else { return }
        
        let cpuLUT = cpuBuilder.build(settings: settings)
        let gpuLUT = gpuBuilder.build(settings: settings)
        
        XCTAssertNotNil(gpuLUT)
        compareLUTs(cpuLUT: cpuLUT, gpuLUT: gpuLUT!)
    }
    
    func testCombinedSettings() {
        var settings = IC_ProcessSettings()
        settings.exposure = 0.5
        settings.contrast = 15
        settings.saturation = 20
        
        let cpuBuilder = ColorLUTBuilder()
        let gpuBuilder = MetalColorLUTBuilder()
        
        XCTAssertNotNil(gpuBuilder)
        guard let gpuBuilder = gpuBuilder else { return }
        
        let cpuLUT = cpuBuilder.build(settings: settings)
        let gpuLUT = gpuBuilder.build(settings: settings)
        
        XCTAssertNotNil(gpuLUT)
        compareLUTs(cpuLUT: cpuLUT, gpuLUT: gpuLUT!)
    }
    
    func testBenchmark() {
        let settings = IC_ProcessSettings()
        let cpuBuilder = ColorLUTBuilder()
        let gpuBuilder = MetalColorLUTBuilder()
        
        XCTAssertNotNil(gpuBuilder)
        guard let gpuBuilder = gpuBuilder else { return }
        
        let iterations = 10
        
        let cpuStart = Date()
        for _ in 0..<iterations {
            _ = cpuBuilder.build(settings: settings)
        }
        let cpuDuration = Date().timeIntervalSince(cpuStart) / Double(iterations)
        
        let gpuStart = Date()
        for _ in 0..<iterations {
            _ = gpuBuilder.build(settings: settings)
        }
        let gpuDuration = Date().timeIntervalSince(gpuStart) / Double(iterations)
        
        print("--- LUT Builder Benchmark ---")
        print("CPU: \(String(format: "%.3f", cpuDuration * 1000)) ms")
        print("GPU: \(String(format: "%.3f", gpuDuration * 1000)) ms")
        print("Speedup: \(String(format: "%.2f", cpuDuration / gpuDuration))x")
    }
}
