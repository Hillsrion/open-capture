import SwiftUI
import AppCoreShared

/// Reconstructed Noise Reduction tool (UI-204).
/// Provides high-fidelity luminance and color noise removal.
public struct NoiseReductionToolView: View {
    @Binding var luminance: Double
    @Binding var details: Double
    @Binding var color: Double
    @Binding var singlePixel: Double
    
    public init(luminance: Binding<Double>, details: Binding<Double>, color: Binding<Double>, singlePixel: Binding<Double>) {
        self._luminance = luminance
        self._details = details
        self._color = color
        self._singlePixel = singlePixel
    }
    
    public var body: some View {
        COToolSection("Noise Reduction", toolID: "Noise") {
            VStack(spacing: 6) {
                COToolValueSlider(label: "Luminance", value: $luminance, range: 0...100, decimalPlaces: 0)
                COToolValueSlider(label: "Details", value: $details, range: 0...100, decimalPlaces: 0)
                COToolValueSlider(label: "Color", value: $color, range: 0...100, decimalPlaces: 0)
                COToolValueSlider(label: "Single Pixel", value: $singlePixel, range: 0...100, decimalPlaces: 0)
            }
            .padding(.vertical, 4)
        }
    }
}
