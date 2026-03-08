import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Sharpening tool (ENG-007).
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
        COToolSection("Sharpening") {
            VStack(spacing: 8) {
                COUISlider(label: "Amount", value: Binding(get: { Float(amount) }, set: { amount = Double($0) }), range: 0...500)
                COUISlider(label: "Radius", value: Binding(get: { Float(radius) }, set: { radius = Double($0) }), range: 0.1...2.5)
                COUISlider(label: "Threshold", value: Binding(get: { Float(threshold) }, set: { threshold = Double($0) }), range: 0...10)
                COUISlider(label: "Halo Control", value: Binding(get: { Float(halo) }, set: { halo = Double($0) }), range: 0...100)
            }
        }
    }
}

/// Reconstructed high-fidelity Noise Reduction tool (ENG-007).
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
        COToolSection("Noise Reduction") {
            VStack(spacing: 8) {
                COUISlider(label: "Luminance", value: Binding(get: { Float(luminance) }, set: { luminance = Double($0) }), range: 0...100)
                COUISlider(label: "Details", value: Binding(get: { Float(details) }, set: { details = Double($0) }), range: 0...100)
                COUISlider(label: "Color", value: Binding(get: { Float(color) }, set: { color = Double($0) }), range: 0...100)
                COUISlider(label: "Single Pixel", value: Binding(get: { Float(singlePixel) }, set: { singlePixel = Double($0) }), range: 0...100)
            }
        }
    }
}

/// Reconstructed high-fidelity Style row view (UI-010).
/// Based on disassembly of _TtC10CaptureOne30StyleWithShortcutTableCellView.
public struct StyleWithShortcutTableCellView: View {
    let item: StyleTreeItem
    
    public var body: some View {
        HStack {
            Image(systemName: item.isFolder ? "folder.fill" : "slider.horizontal.3")
                .font(.system(size: 10))
                .foregroundColor(item.isFolder ? .gray : CaptureOneTheme.Colors.activeHighlight)
            
            Text(item.name)
                .font(.system(size: 11))
            
            Spacer()
            
            // Shortcut placeholder if available (simulated)
            if !item.isFolder {
                Text("⌘1")
                    .font(.system(size: 9))
                    .foregroundColor(.gray.opacity(0.5))
            }
        }
        .padding(.vertical, 2)
    }
}
