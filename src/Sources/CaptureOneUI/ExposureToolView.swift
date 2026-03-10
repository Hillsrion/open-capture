import SwiftUI
import AppCoreShared

/// Reconstructed Exposure tool (UI-204).
/// Provides intelligent exposure, contrast, brightness, and saturation (vibrance) adjustments.
public struct ExposureToolView: View {
    @Binding var exposure: Float
    @Binding var contrast: Float
    @Binding var brightness: Float
    @Binding var saturation: Float
    
    public init(exposure: Binding<Float>, contrast: Binding<Float>, brightness: Binding<Float>, saturation: Binding<Float>) {
        self._exposure = exposure
        self._contrast = contrast
        self._brightness = brightness
        self._saturation = saturation
    }
    
    public var body: some View {
        COToolSection("Exposure", toolID: "Exposure") {
            VStack(spacing: 6) {
                COToolValueSlider(label: "Exposure", value: $exposure, range: -4...4, decimalPlaces: 2)
                COToolValueSlider(label: "Contrast", value: $contrast, range: -50...50, decimalPlaces: 0)
                COToolValueSlider(label: "Brightness", value: $brightness, range: -50...50, decimalPlaces: 0)
                COToolValueSlider(label: "Saturation", value: $saturation, range: -100...100, decimalPlaces: 0)
            }
            .padding(.vertical, 4)
        }
    }
}
