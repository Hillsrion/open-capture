import XCTest
import AppCoreShared
import ImageCore

final class ColorBalanceStorageTests: XCTestCase {
    override func tearDown() {
        WorkspaceManager.persistenceDirectoryOverride = nil
        super.tearDown()
    }

    func testColorBalanceCodecRoundTrip() {
        let variant = MCVariant(dictionary: [:])
        let value = ColorBalanceValue(hue: 267, saturation: 33, brightness: 12)

        ColorBalanceStorage.setValue(value, forKey: ColorBalanceStorageKeys.highlight, on: variant)

        let restored = ColorBalanceStorage.value(forKey: ColorBalanceStorageKeys.highlight, from: variant)
        XCTAssertEqual(restored, value)
    }

    func testMasterLightnessIsNormalizedOnStorage() {
        let variant = MCVariant(dictionary: [:])
        let settings = ColorBalanceSettings(
            master: ColorBalanceValue(hue: 42, saturation: 18, brightness: 55),
            shadow: .neutral,
            midtone: .neutral,
            highlight: .neutral
        )

        ColorBalanceStorage.apply(settings, to: variant)

        let restored = ColorBalanceStorage.settings(from: variant)
        XCTAssertEqual(restored.master.brightness, 0)
        XCTAssertEqual(restored.master.hue, 42)
        XCTAssertEqual(restored.master.saturation, 18)
    }

    func testWorkspaceToolStatePersistsColorBalanceSelectedTab() {
        let tempDir = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString, isDirectory: true)
        WorkspaceManager.persistenceDirectoryOverride = tempDir

        let manager = WorkspaceManager.shared
        manager.activeWorkspace = WorkspaceManager.createDefaultWorkspace()
        manager.activeWorkspace.name = "ColorBalanceWorkspaceTest"

        manager.setToolStateValue("3", toolID: "ColorBalance", key: "ColorBalanceInspectorToolSelectedTab", autosave: false)
        manager.saveWorkspace()

        manager.activeWorkspace = WorkspaceManager.createDefaultWorkspace()
        manager.loadWorkspace(named: "ColorBalanceWorkspaceTest")

        XCTAssertEqual(
            manager.toolStateValue(toolID: "ColorBalance", key: "ColorBalanceInspectorToolSelectedTab"),
            "3"
        )
    }

    func testExportTranslatorReadsColorBalanceSettings() {
        let image = ImageBase(imageUUID: "img", path: "/tmp/test.raw", context: nil)
        let variant = VariantBase(variantUUID: "var", image: image, context: nil)
        let mcVariant = MCVariant(dictionary: [:])
        variant.mcVariant = mcVariant

        let settings = ColorBalanceSettings(
            master: ColorBalanceValue(hue: 20, saturation: 10, brightness: 0),
            shadow: ColorBalanceValue(hue: 200, saturation: 40, brightness: -10),
            midtone: .neutral,
            highlight: ColorBalanceValue(hue: 35, saturation: 12, brightness: 8)
        )
        ColorBalanceStorage.apply(settings, to: mcVariant)

        let recipe = OutputRecipe(name: "Test", recipe: MCRecipe(dictionary: [:]), context: ObjectContext())
        let translated = ExportTranslator().translate(variant: variant, recipe: recipe)

        XCTAssertEqual(translated.0.colorBalance, ColorBalanceStorage.normalizedSettings(settings))
    }
}
