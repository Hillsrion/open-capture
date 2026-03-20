import XCTest
@testable import AppCoreShared
import ImageCore

final class SmartAdjustmentsTests: XCTestCase {
    
    func testSmartAdjustmentDeltaCalculation() {
        let reference = COFaceExposureNormalizer.FaceReference(luma: 0.8, kelvin: 5500.0, tint: 10.0)
        let target = COFaceExposureNormalizer.FaceReference(luma: 0.5, kelvin: 5000.0, tint: 5.0)
        
        let normalizer = COFaceExposureNormalizer()
        let deltas = normalizer.calculateDeltas(reference: reference, target: target)
        
        XCTAssertEqual(deltas.exposure, 0.3, accuracy: 0.001, "Exposure delta should be 0.3")
        XCTAssertEqual(deltas.kelvin, 500.0, "Kelvin delta should be 500")
        XCTAssertEqual(deltas.tint, 5.0, "Tint delta should be 5")
    }
    
    func testSmartAdjustmentManagerReference() {
        let variant = VariantBase(variantUUID: UUID().uuidString, image: nil, context: nil)
        COSmartAdjustmentManager.shared.setAsReference(variant)
        
        XCTAssertNotNil(COSmartAdjustmentManager.shared.reference)
        XCTAssertEqual(COSmartAdjustmentManager.shared.referenceVariantID, variant.variantUUID)
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
