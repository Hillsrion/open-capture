import XCTest
import AppCoreShared
import DataCore

final class WorkspacePresetLoaderTests: XCTestCase {
    override func tearDown() {
        WorkspaceManager.persistenceDirectoryOverride = nil
        super.tearDown()
    }

    func testSessionWorkspaceMatchesDecompiledTabOrder() throws {
        let workspace = try DefaultWorkspacePresetLoader().makeWorkspace(windowKind: .session)

        XCTAssertEqual(
            workspace.palettes.map(\.id),
            [
                "OrganizeToolTab",
                "CaptureToolTab",
                "LensToolTab",
                "SettingsToolTab",
                "ExposureToolTab",
                "DetailsToolTab"
            ]
        )
        XCTAssertEqual(workspace.selectedPaletteID, "OrganizeToolTab")
    }

    func testSessionWorkspacePreservesFixedVsScrolledTools() throws {
        let workspace = try DefaultWorkspacePresetLoader().makeWorkspace(windowKind: .session)
        let organize = try XCTUnwrap(workspace.palettes.first(where: { $0.id == "OrganizeToolTab" }))
        let exposure = try XCTUnwrap(workspace.palettes.first(where: { $0.id == "ExposureToolTab" }))

        XCTAssertEqual(organize.fixedTools.map(\.id), ["Library"])
        XCTAssertEqual(organize.scrolledTools.map(\.id), ["MetadataFilters", "Keywords", "KeywordLibrary", "Metadata"])

        XCTAssertEqual(exposure.fixedTools.map(\.id), ["Histogram", "LocalAdjustments"])
        XCTAssertEqual(
            exposure.scrolledTools.map(\.id),
            [
                "StyleBrushes",
                "MatchLook",
                "WhiteBalance",
                "Exposure",
                "ShadowHighlight",
                "Levels",
                "Curves",
                "SelectiveColorControl",
                "ColorBalance",
                "BlackAndWhite",
                "Clarity",
                "Dehaze",
                "Vignetting"
            ]
        )
    }

    func testOtherPresetWindowsLoadWithExpectedPalettes() throws {
        let loader = DefaultWorkspacePresetLoader()

        XCTAssertEqual(
            try loader.makeWorkspace(windowKind: .viewer).palettes.map(\.id),
            [
                "QuickToolTab",
                "ExposureToolTab",
                "ColorToolTab",
                "CompositionToolTab",
                "DetailsToolTab",
                "SettingsToolTab",
                "MetaDataToolTab"
            ]
        )
        XCTAssertEqual(
            try loader.makeWorkspace(windowKind: .livePreview).palettes.map(\.id),
            ["LivePreviewToolTab", "CaptureToolTab"]
        )
        XCTAssertEqual(
            try loader.makeWorkspace(windowKind: .culling).palettes.map(\.id),
            ["CullingWindowToolTab"]
        )
    }

    func testSelectedPalettePersistsAcrossWorkspaceSaveLoad() {
        let tempDir = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString, isDirectory: true)
        WorkspaceManager.persistenceDirectoryOverride = tempDir

        let manager = WorkspaceManager.shared
        manager.activeWorkspace = WorkspaceManager.createWorkspace(windowKind: .session, name: "WorkspaceSelectionPersistence")
        manager.setSelectedPaletteID("ExposureToolTab", autosave: false)
        manager.saveWorkspace()

        manager.activeWorkspace = WorkspaceManager.createDefaultWorkspace()
        manager.loadWorkspace(named: "WorkspaceSelectionPersistence")

        XCTAssertEqual(manager.activeWorkspace.selectedPaletteID, "ExposureToolTab")
    }

    func testToolStateFallsBackToPresetDefaultValues() throws {
        let workspace = try DefaultWorkspacePresetLoader().makeWorkspace(windowKind: .session)
        XCTAssertEqual(
            workspace.defaultToolStateValue(toolID: "Levels", key: "selectedLevelsType")?.stringValue,
            "0"
        )
    }
}
