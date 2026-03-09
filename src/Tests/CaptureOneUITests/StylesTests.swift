import XCTest
import SwiftUI
import AppCoreShared
@testable import CaptureOneUI

class StylesTests: XCTestCase {
    
    func testStyleHoverPreview() {
        let controller = AdjustmentToolController()
        let style = Style(name: "Test Style", adjustments: ["ZEXPOSURE": AnyCodable(2.0)])
        
        let image = ImageBase(imageUUID: "img", path: "/test.jpg", context: nil)
        let variant = VariantBase(variantUUID: "var", image: image, context: nil)
        variant.mcVariant = MCVariant(dictionary: [:])
        controller.bind(to: variant)
        
        // Initial exposure should be 0
        XCTAssertEqual(controller.exposure, 0.0)
        
        // 1. Start Hover
        controller.temporarilyApplyStyle(style)
        XCTAssertEqual(controller.exposure, 2.0)
        XCTAssertEqual(controller.previewingStyle?.name, "Test Style")
        
        // 2. End Hover
        controller.temporarilyApplyStyle(nil)
        XCTAssertEqual(controller.exposure, 0.0)
        XCTAssertNil(controller.previewingStyle)
    }
    
    func testStylePermanentApplication() {
        let controller = AdjustmentToolController()
        let style = Style(name: "Test Style", adjustments: ["ZEXPOSURE": AnyCodable(2.0)])
        
        let image = ImageBase(imageUUID: "img", path: "/test.jpg", context: nil)
        let variant = VariantBase(variantUUID: "var", image: image, context: nil)
        variant.mcVariant = MCVariant(dictionary: [:])
        controller.bind(to: variant)
        
        // Apply permanently
        controller.applyStyle(style)
        XCTAssertEqual(controller.exposure, 2.0)
        XCTAssertNil(controller.previewingStyle) // Preview should be cleared
    }
    
    func testStyleStacking() {
        let controller = AdjustmentToolController()
        controller.stackStyles = true
        
        let style1 = Style(name: "Exposure", adjustments: ["ZEXPOSURE": AnyCodable(1.0)])
        let style2 = Style(name: "Contrast", adjustments: ["ZCONTRAST": AnyCodable(50.0)])
        
        let image = ImageBase(imageUUID: "img", path: "/test.jpg", context: nil)
        let variant = VariantBase(variantUUID: "var", image: image, context: nil)
        variant.mcVariant = MCVariant(dictionary: [:])
        controller.bind(to: variant)
        
        controller.applyStyle(style1)
        controller.applyStyle(style2)
        
        XCTAssertEqual(controller.exposure, 1.0)
        XCTAssertEqual(controller.contrast, 50.0)
    }
}
