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
            VStack(spacing: 8) {
                noiseSlider(label: "Luminance", value: $luminance, range: 0...100)
                noiseSlider(label: "Details", value: $details, range: 0...100)
                noiseSlider(label: "Color", value: $color, range: 0...100)
                noiseSlider(label: "Single Pixel", value: $singlePixel, range: 0...100)
            }
            .padding(.vertical, 4)
        }
    }
    
    private func noiseSlider(label: String, value: Binding<Double>, range: ClosedRange<Double>) -> some View {
        HStack {
            Text(label).font(.system(size: 11)).foregroundColor(.gray).frame(width: 75, alignment: .leading)
            Slider(value: value, in: range)
                .accentColor(CaptureOneTheme.Colors.activeHighlight)
            Text("\(Int(value.wrappedValue))").font(.system(size: 10, design: .monospaced)).frame(width: 30, alignment: .trailing)
        }
    }
}
