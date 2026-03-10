import SwiftUI
import AppCoreShared

/// Reconstructed Sharpening tool (UI-204).
/// Provides high-fidelity capture and creative sharpening.
public struct SharpeningToolView: View {
    @Binding var amount: Double
    @Binding var radius: Double
    @Binding var threshold: Double
    @Binding var halo: Double
    
    public init(amount: Binding<Double>, radius: Binding<Double>, threshold: Binding<Double>, halo: Binding<Double>) {
        self._amount = amount
        self._radius = radius
        self._threshold = threshold
        self._halo = halo
    }
    
    public var body: some View {
        COToolSection("Sharpening", toolID: "Sharpening") {
            VStack(spacing: 6) {
                COToolValueSlider(label: "Amount", value: $amount, range: 0...1000, decimalPlaces: 0)
                COToolValueSlider(label: "Radius", value: $radius, range: 0.1...2.5, decimalPlaces: 1)
                COToolValueSlider(label: "Threshold", value: $threshold, range: 0...10, decimalPlaces: 1)
                COToolValueSlider(label: "Halo", value: $halo, range: 0...100, decimalPlaces: 0)
            }
            .padding(.vertical, 4)
        }
    }
}
