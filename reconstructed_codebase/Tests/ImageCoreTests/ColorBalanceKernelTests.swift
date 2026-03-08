import XCTest
import ImageCore

final class ColorBalanceKernelTests: XCTestCase {
    func testColorWheelMathClampsOutsideWheel() {
        let polar = ColorWheelMath.cartesianToPolar(x: 2.0, y: 0.0)
        XCTAssertEqual(polar.saturation, 100, accuracy: 0.001)
        XCTAssertEqual(polar.hue, 90, accuracy: 0.001)
    }

    func testColorBalanceKernelChangesPixelsForNonNeutralSettings() {
        var red = [Float](repeating: 0.5, count: 8)
        var green = [Float](repeating: 0.5, count: 8)
        var blue = [Float](repeating: 0.5, count: 8)

        let settings = ColorBalanceSettings(
            master: .neutral,
            shadow: ColorBalanceValue(hue: 210, saturation: 60, brightness: -10),
            midtone: ColorBalanceValue(hue: 35, saturation: 30, brightness: 8),
            highlight: .neutral
        )

        ColorBalanceKernel.apply(to: &red, green: &green, blue: &blue, settings: settings)

        XCTAssertNotEqual(red, [Float](repeating: 0.5, count: 8))
        XCTAssertNotEqual(green, [Float](repeating: 0.5, count: 8))
        XCTAssertNotEqual(blue, [Float](repeating: 0.5, count: 8))
    }

    func testProcessSettingsExposeColorBalanceDefaults() {
        let settings = IC_ProcessSettings()
        XCTAssertEqual(settings.colorBalance, ColorBalanceSettings())

        let local = IC_LocalAdjustmentSettings()
        XCTAssertEqual(local.colorBalance, ColorBalanceSettings())
    }
}
