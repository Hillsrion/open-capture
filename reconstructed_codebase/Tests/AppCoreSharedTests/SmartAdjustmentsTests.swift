import XCTest
@testable import AppCoreShared
import ImageCore

final class SmartAdjustmentsTests: XCTestCase {
    
    func testSmartAdjustmentDeltaCalculation() {
        let reference = SmartAdjustmentsReference(exposure: 1.0, kelvin: 5500.0, tint: 10.0)
        let target = SmartAdjustmentsReference(exposure: 0.5, kelvin: 5000.0, tint: 5.0)
        
        let deltas = SmartAdjustmentsEngine.calculateDeltas(reference: reference, target: target)
        
        XCTAssertEqual(deltas.exposureDelta, 0.5, "Exposure delta should be 0.5")
        XCTAssertEqual(deltas.kelvinDelta, 500.0, "Kelvin delta should be 500")
        XCTAssertEqual(deltas.tintDelta, 5.0, "Tint delta should be 5")
    }
    
    func testSmartAdjustmentHelperAnalysis() {
        let variant = VariantBase(variantUUID: UUID().uuidString, image: nil, context: nil)
        let reference = SmartAdjustmentsHelper.analyzeVariant(variant)
        
        XCTAssertNotNil(reference)
        XCTAssert(2000...50000 ~= reference.faceKelvin)
    }
    
    func testSmartDescriptorPersistence() {
        let descriptor = SmartAdjustmentsDescriptor(exposureEnabled: true, whiteBalanceEnabled: false)
        
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        do {
            let data = try encoder.encode(descriptor)
            let decoded = try decoder.decode(SmartAdjustmentsDescriptor.self, from: data)
            
            XCTAssertTrue(decoded.exposureEnabled)
            XCTAssertFalse(decoded.whiteBalanceEnabled)
        } catch {
            XCTFail("Serialization failed: \(error)")
        }
    }
}
