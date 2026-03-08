import XCTest
@testable import AppCoreShared

final class EIPTests: XCTestCase {
    
    var tempDir: URL!
    
    override func setUp() {
        super.setUp()
        tempDir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try? FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
    }
    
    override func tearDown() {
        try? FileManager.default.removeItem(at: tempDir)
        super.tearDown()
    }
    
    func testEIPPackingAndUnpacking() throws {
        // 1. Setup mock RAW and Sidecar
        let rawURL = tempDir.appendingPathComponent("image.nef")
        let sidecarURL = tempDir.appendingPathComponent("image.cos")
        
        try "Mock RAW data".write(to: rawURL, atomically: true, encoding: .utf8)
        try "Mock Settings".write(to: sidecarURL, atomically: true, encoding: .utf8)
        
        let archiveURL = tempDir.appendingPathComponent("image.eip")
        
        // 2. Pack
        XCTAssertNoThrow(try EIPArchive.create(at: archiveURL, rawURL: rawURL, sidecars: [sidecarURL]))
        XCTAssertTrue(FileManager.default.fileExists(atPath: archiveURL.path), "EIP archive should be created")
        
        // 3. Verify Info
        let archive = EIPArchive(path: archiveURL)
        let info = try archive.getPackageInfo()
        XCTAssertEqual(info.originalExtension, "nef")
        XCTAssertTrue(info.contents.contains("image.cos"))
        
        // 4. Unpack
        let unpackDir = tempDir.appendingPathComponent("Unpacked")
        XCTAssertNoThrow(try archive.extract(to: unpackDir))
        
        XCTAssertTrue(FileManager.default.fileExists(atPath: unpackDir.appendingPathComponent("image.nef").path), "RAW should be unpacked")
        XCTAssertTrue(FileManager.default.fileExists(atPath: unpackDir.appendingPathComponent("image.cos").path), "Sidecar should be unpacked")
    }
}
