import XCTest
import AppCoreShared
import ImageCore
@testable import CaptureOneUI

final class ColorBalanceControllerTests: XCTestCase {
    func testColorBalanceChangesCommitToVariantAndReload() {
        let controller = AdjustmentToolController()
        let image = ImageBase(imageUUID: "img", path: "/tmp/test.raw", context: nil)
        let variant = VariantBase(variantUUID: "var", image: image, context: nil)
        variant.mcVariant = MCVariant(dictionary: [:])

        controller.bind(to: variant)
        controller.cbShadow = ColorBalanceValue(hue: 267, saturation: 33, brightness: -8)
        controller.cbMidtone = ColorBalanceValue(hue: 120, saturation: 18, brightness: 10)
        controller.cbHighlight = ColorBalanceValue(hue: 40, saturation: 12, brightness: 7)
        controller.cbMaster = ColorBalanceValue(hue: 15, saturation: 22, brightness: 50)

        RunLoop.current.run(until: Date().addingTimeInterval(0.08))

        let stored = ColorBalanceStorage.settings(from: variant.mcVariant)
        XCTAssertEqual(stored.shadow, controller.cbShadow)
        XCTAssertEqual(stored.midtone, controller.cbMidtone)
        XCTAssertEqual(stored.highlight, controller.cbHighlight)
        XCTAssertEqual(stored.master.brightness, 0)
        XCTAssertEqual(controller.cbMaster.brightness, 0)

        controller.cbShadow = .neutral
        controller.cbMidtone = .neutral
        controller.cbHighlight = .neutral
        controller.cbMaster = .neutral

        controller.refreshToolValues()

        XCTAssertEqual(controller.cbShadow, stored.shadow)
        XCTAssertEqual(controller.cbMidtone, stored.midtone)
        XCTAssertEqual(controller.cbHighlight, stored.highlight)
        XCTAssertEqual(controller.cbMaster, stored.master)
    }
}
