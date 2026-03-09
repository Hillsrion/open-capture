import AppCoreShared
import XCTest

class ExportEngineTests: XCTestCase {
    
    var context: ObjectContext!
    var variant: VariantBase!
    var queue: BatchQueue!
    var tempDir: URL!
    
    override func setUp() {
        super.setUp()
        context = ObjectContext()
        let image = ImageBase(imageUUID: "export-img", path: "/tmp/test.raw", context: context)
        variant = VariantBase(variantUUID: "export-var", image: image, context: context)
        variant.mcVariant = MCVariant(dictionary: ["ZEXPOSURE": 1.5, "ZCONTRAST": 10.0])
        
        queue = BatchQueue()
        tempDir = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("CaptureOneExportTest")
        try? FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
    }
    
    override func tearDown() {
        try? FileManager.default.removeItem(at: tempDir)
        super.tearDown()
    }
    
    func testExportJobCreation() {
        let recipe = OutputRecipe(name: "JPEG High", recipe: MCRecipe(dictionary: [:]), context: context)
        recipe.format = .jpeg
        recipe.jpegQuality = 90
        recipe.fileNameTokens = "[Image Name]_test"
        
        let expectation = XCTestExpectation(description: "Export Completion")
        
        // Add job
        queue.addJob(variant: variant, recipe: recipe, outputFolder: tempDir)
        
        // Wait for completion (simulated async)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(self.queue.completedJobs.count, 1)
            let job = self.queue.completedJobs.first!
            XCTAssertEqual(job.status, .completed)
            
            // Check file existence
            let expectedPath = self.tempDir.appendingPathComponent("test_test.jpeg").path
            XCTAssertTrue(FileManager.default.fileExists(atPath: expectedPath))
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
}
