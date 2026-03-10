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
        self._exposure: Binding<Float> = exposure
        self._contrast: Binding<Float> = contrast
        self._brightness: Binding<Float> = brightness
        self._saturation: Binding<Float> = saturation
    }
    
    public var body: some View {
        COToolSection("Exposure", toolID: "Exposure") {
            VStack(spacing: 8) {
                exposureSlider(label: "Exposure", value: $exposure, range: -4...4, step: 0.01, format: "%.2f")
                exposureSlider(label: "Contrast", value: $contrast, range: -50...50)
                exposureSlider(label: "Brightness", value: $brightness, range: -50...50)
                exposureSlider(label: "Saturation", value: $saturation, range: -100...100)
                
                HStack {
                    Spacer()
                    Button(action: {
                        // Auto exposure logic
                    }) {
                        Image(systemName: "a.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(CaptureOneTheme.Colors.activeHighlight)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, 4)
            }
            .padding(.vertical, 4)
        }
    }
    
    private func exposureSlider(label: String, value: Binding<Float>, range: ClosedRange<Float>, step: Float = 1.0, format: String = "%.0f") -> some View {
        HStack {
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                .frame(width: 65, alignment: .leading)
            Slider(value: value, in: range, step: step)
                .accentColor(CaptureOneTheme.Colors.activeHighlight)
            Text(String(format: format, value.wrappedValue))
                .font(.system(size: 10, design: .monospaced))
                .frame(width: 35, alignment: .trailing)
        }
    }
}
