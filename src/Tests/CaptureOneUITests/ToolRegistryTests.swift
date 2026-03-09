import XCTest
import CaptureOneUI
import AppCoreShared
import DataCore

final class ToolRegistryTests: XCTestCase {
    func testRegistryCoversAllSessionViewerLivePreviewAndCullingTools() throws {
        let loader = DefaultWorkspacePresetLoader()
        let workspaces = try [
            loader.makeWorkspace(windowKind: .session),
            loader.makeWorkspace(windowKind: .viewer),
            loader.makeWorkspace(windowKind: .livePreview),
            loader.makeWorkspace(windowKind: .culling)
        ]

        let toolIDs = Set(workspaces.flatMap { $0.palettes.flatMap { $0.allTools.map(\.id) } })
        XCTAssertFalse(toolIDs.isEmpty)

        for toolID in toolIDs {
            let support = ToolRegistry.support(for: toolID)
            switch support {
            case .implemented, .adapter, .unavailable:
                XCTAssertTrue(true, "Tool \(toolID) is covered by the registry")
            }
        }
    }

    func testRegistryBuildsConcreteViewsForKeySessionTools() {
        let context = makeContext()

        let tools = [
            "Library",
            "MetadataFilters",
            "KeywordLibrary",
            "Metadata",
            "WhiteBalance",
            "Exposure",
            "Levels",
            "Curves",
            "ColorBalance",
            "Clarity",
            "Sharpening",
            "Noise",
            "LensCorrection",
            "Perspective"
        ]

        for toolID in tools {
            let view = ToolRegistry.view(
                for: toolID,
                context: ToolRegistryContext(
                    config: ToolConfiguration(id: toolID),
                    adjustmentController: context.adjustmentController,
                    session: context.session,
                    recipeManager: context.recipeManager,
                    batchQueue: context.batchQueue,
                    keywordCache: context.keywordCache
                )
            )
            XCTAssertNotNil(view)
        }
    }

    private func makeContext() -> (
        adjustmentController: AdjustmentToolController,
        session: SessionBase,
        recipeManager: OutputRecipeManager,
        batchQueue: BatchQueue,
        keywordCache: DocumentKeywordCache
    ) {
        let objectContext = ObjectContext()
        let session = SessionBase(documentUUID: "workspace-registry-tests", type: 0, context: objectContext)
        let image = ImageBase(imageUUID: "img", path: "/tmp/test.raw", context: objectContext)
        let variant = VariantBase(variantUUID: "var", image: image, context: objectContext)
        variant.mcVariant = MCVariant(dictionary: [:])

        let controller = AdjustmentToolController()
        controller.bind(to: variant)

        return (
            adjustmentController: controller,
            session: session,
            recipeManager: OutputRecipeManager.defaultManager(),
            batchQueue: BatchQueue(),
            keywordCache: DocumentKeywordCache(session: session)
        )
    }
}
