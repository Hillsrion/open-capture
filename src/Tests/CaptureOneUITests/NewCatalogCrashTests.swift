import XCTest
import AppKit
import SwiftUI
@testable import CaptureOneUI
@testable import AppCoreShared

/// Crash-reproducing test for the New Catalog / New Session flow.
/// Calls the exact same code path as clicking "New Catalog" in the app.
final class NewCatalogCrashTests: XCTestCase {

    @MainActor
    func testNewCatalogDoesNotCrash() throws {
        let _ = NSApplication.shared
        let commands = AppCommandCenter.shared
        commands.newCatalog()

        XCTAssertNotNil(commands.session, "Session should be created after newCatalog()")
        XCTAssertEqual(commands.session?.name, "Untitled Catalog")
    }

    @MainActor
    func testNewSessionDoesNotCrash() throws {
        let _ = NSApplication.shared
        let commands = AppCommandCenter.shared
        commands.newSession()

        XCTAssertNotNil(commands.session, "Session should be created after newSession()")
        XCTAssertEqual(commands.session?.name, "Untitled Session")
    }

    @MainActor
    func testObjectContextLifetime() throws {
        let ctx = ObjectContext()
        let session = SessionBase(documentUUID: "test-lifecycle", type: 0, context: ctx)
        session.name = "Test"

        XCTAssertNotNil(session.managedObjectContext)

        let recipe = OutputRecipe(name: "Test Recipe", recipe: MCRecipe(dictionary: [:]), context: ctx)
        XCTAssertEqual(recipe.name, "Test Recipe")

        recipe.name = "Updated Recipe"
        XCTAssertEqual(recipe.name, "Updated Recipe")
        XCTAssertNotNil(session.managedObjectContext)
    }

    /// Granular test: isolate CullingView creation (SwiftUI hosting)
    @MainActor
    func testCullingViewCreationDoesNotCrash() throws {
        let _ = NSApplication.shared
        let ctx = ObjectContext()
        let session = SessionBase(documentUUID: "test-culling", type: 0, context: ctx)
        session.name = "Test Catalog"

        let browser = CImageBrowser()
        let adjustmentController = AdjustmentToolController.shared
        let recipeManager = OutputRecipeManager.shared
        let batchQueue = BatchQueue()

        // Create the CullingView — this is what openDocumentWindow does
        let contentView = CullingView(
            browser: browser,
            adjustmentController: adjustmentController,
            recipeManager: recipeManager,
            batchQueue: batchQueue,
            session: session
        )

        // Host it in an NSHostingView — this triggers SwiftUI body evaluation
        let hostingView = NSHostingView(rootView: contentView)
        XCTAssertNotNil(hostingView)

        // Force layout to trigger any deferred body evaluation
        hostingView.frame = NSRect(x: 0, y: 0, width: 800, height: 600)
        hostingView.layout()
    }

    /// Granular test: isolate CONativeToolbar creation
    @MainActor
    func testNativeToolbarCreationDoesNotCrash() throws {
        let _ = NSApplication.shared
        let config = WorkspaceManager.shared.activeWorkspace.toolbarConfiguration
        let commands = AppCommandCenter.shared

        let toolbar = CONativeToolbar(configuration: config, commands: commands)
        XCTAssertNotNil(toolbar)
    }

    /// Granular test: full openDocumentWindow pipeline
    @MainActor
    func testOpenDocumentWindowPipeline() throws {
        let _ = NSApplication.shared
        let ctx = ObjectContext()
        let session = SessionBase(documentUUID: "test-pipeline-\(UUID().uuidString)", type: 0, context: ctx)
        session.name = "Pipeline Test"

        AppCommandCenter.shared.configure(
            session: session,
            recipeManager: OutputRecipeManager.shared,
            batchQueue: BatchQueue()
        )

        // This is the method that crashes in the real app
        COWindowManager.shared.openDocumentWindow(for: session)

        // Give the run loop a tick to process deferred work
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.5))

        // If we get here, no crash
        XCTAssertNotNil(AppCommandCenter.shared.session)
    }
}
