import XCTest
@testable import AppCoreShared

final class PluginTests: XCTestCase {
    
    func testPluginManagerDiscovery() {
        let manager = COPluginManager.shared
        manager.discoverPlugins() // This will load mock plugins
        
        let expectation = XCTestExpectation(description: "Plugins loaded asynchronously")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertFalse(manager.installedPlugins.isEmpty, "Should load mock plugins if none found")
        
        // Verify mock plugin structure
        let openWith = manager.installedPlugins.first(where: { $0.id == "com.captureone.openwith" })
        XCTAssertNotNil(openWith)
        XCTAssertEqual(openWith?.name, "Open With")
        XCTAssertEqual(openWith?.type, .system)
    }
    
    func testPluginHostConnection() {
        let plugin = COPlugin(id: "test", name: "Test Plugin", version: "1.0", path: URL(fileURLWithPath: "/"), type: .utility)
        let connection = COPluginHostConnection(plugin: plugin)
        
        let expectation = XCTestExpectation(description: "Action executed")
        connection.performAction(actionID: "do_something", parameters: [:]) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data["status"] as? String, "success")
                expectation.fulfill()
            case .failure:
                XCTFail("Action should succeed in mock")
            }
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
}
