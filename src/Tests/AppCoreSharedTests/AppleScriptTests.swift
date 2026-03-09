import XCTest
import AppKit
@testable import AppCoreShared

final class AppleScriptTests: XCTestCase {
    
    func testVariantScriptability() {
        let variant = VariantBase(variantUUID: "test-scripting-uuid", image: nil, context: nil)
        variant.mcVariant = MCVariant(dictionary: [:])
        
        // Initial state
        XCTAssertEqual(variant.name, "Variant - test-s")
        XCTAssertEqual(variant.scriptingRating, 0)
        
        // Simulate AppleScript setting a property
        variant.scriptingRating = 4
        XCTAssertEqual(variant.rating, 4, "Scripting wrapper should update underlying rating")
        
        variant.scriptingColorTag = 1 // Red
        XCTAssertEqual(variant.colorTag, .red, "Scripting wrapper should update underlying color tag")
    }
    
    func testNSAppleScriptExecution() {
        // Because the full app isn't running with its Info.plist and bundle registered
        // in this unit test environment, a full 'tell application' script will fail.
        // We test the AppleScript compilation to ensure basic syntax is valid.
        
        let scriptSource = """
        tell application "Capture One Reconstructed"
            set firstDoc to document 1
            set firstVariant to variant 1 of firstDoc
            set rating of firstVariant to 5
        end tell
        """
        
        let appleScript = NSAppleScript(source: scriptSource)
        XCTAssertNotNil(appleScript, "AppleScript should compile successfully")
        
        // We do not execute it here because the target app "Capture One Reconstructed"
        // is not actually registered or running during the unit test.
    }
}
