import AppCoreShared
import XCTest

class RatingTaggingTests: XCTestCase {
    
    var context: ObjectContext!
    var variant: VariantBase!
    
    override func setUp() {
        super.setUp()
        context = ObjectContext()
        let image = ImageBase(imageUUID: "test-img-uuid", path: "/test/path.raw", context: context)
        variant = VariantBase(variantUUID: "test-var-uuid", image: image, context: context)
        variant.mcVariant = MCVariant(dictionary: [:]) // Mock
    }
    
    func testRatingAssignment() {
        XCTAssertEqual(variant.rating, 0)
        XCTAssertFalse(variant.isModified)
        
        variant.rating = 5
        XCTAssertEqual(variant.rating, 5)
        XCTAssertTrue(variant.isModified)
        
        // Test clamping or typical ranges if applicable
        // The implementation simply sets the int, so we verify persistence into mcVariant
        XCTAssertEqual(variant.mcVariant?.objectForKey("ZRATING") as? Int, 5)
    }
    
    func testColorTagAssignment() {
        XCTAssertEqual(variant.colorTag, .none)
        
        variant.colorTag = .red
        XCTAssertEqual(variant.colorTag, .red)
        XCTAssertTrue(variant.isModified)
        XCTAssertEqual(variant.mcVariant?.objectForKey("ZCOLOR_TAG") as? Int, VariantBase.ColorTag.red.rawValue)
        
        variant.colorTag = .green
        XCTAssertEqual(variant.colorTag, .green)
        XCTAssertEqual(variant.mcVariant?.objectForKey("ZCOLOR_TAG") as? Int, VariantBase.ColorTag.green.rawValue)
    }
}
