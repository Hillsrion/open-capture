import SwiftUI
import AppCoreShared

/// Reconstructed Sharpening tool (UI-204).
/// Provides high-fidelity capture and creative sharpening.
public struct SharpeningToolView: View {
    @Binding var amount: Float
    @Binding var radius: Float
    @Binding var threshold: Float
    @Binding var halo: Float
    
    public init(amount: Binding<Float>, radius: Binding<Float>, threshold: Binding<Float>, halo: Binding<Float>) {
        self._amount = amount
        self._radius = radius
        self._threshold = threshold
        self._halo = halo
    }
    
    public var body: some View {
        COToolSection("Sharpening", toolID: "Sharpening") {
            VStack(spacing: 8) {
                detailSlider(label: "Amount", value: $amount, range: 0...1000)
                detailSlider(label: "Radius", value: $radius, range: 0.1...2.5, format: "%.1f")
                detailSlider(label: "Threshold", value: $threshold, range: 0...10, format: "%.1f")
                detailSlider(label: "Halo", value: $halo, range: 0...100)
            }
            .padding(.vertical, 4)
        }
    }
    
    private func detailSlider(label: String, value: Binding<Float>, range: ClosedRange<Float>, format: String = "%.0f") -> some View {
        HStack {
            Text(label).font(.system(size: 11)).foregroundColor(.gray).frame(width: 65, alignment: .leading)
            Slider(value: value, in: range)
                .accentColor(CaptureOneTheme.Colors.activeHighlight)
            Text(String(format: format, value.wrappedValue)).font(.system(size: 10, design: .monospaced)).frame(width: 30, alignment: .trailing)
        }
    }
}
