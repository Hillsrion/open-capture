import XCTest
@testable import AppCoreShared

class TokenTests: XCTestCase {
    
    func testTokenEvaluation() {
        let evaluator = TokenEvaluator()
        let context = TokenEvaluator.Context(
            imageName: "DSC001",
            date: Date(timeIntervalSince1970: 1772928000), // Fixed date for test
            sequence: 5,
            jobName: "Portfolio"
        )
        
        let result = evaluator.evaluate(format: "[Job Name]_[Image Name]_[Sequence]_[Date]", context: context)
        
        // Expected: Portfolio_DSC001_0005_20260308
        XCTAssertEqual(result, "Portfolio_DSC001_0005_20260308")
    }
    
    func testLiteralEvaluation() {
        let evaluator = TokenEvaluator()
        let context = TokenEvaluator.Context(imageName: "A", date: Date(), sequence: 1, jobName: "B")
        
        let result = evaluator.evaluate(format: "Custom_Fixed_Name", context: context)
        XCTAssertEqual(result, "Custom_Fixed_Name")
    }
}
