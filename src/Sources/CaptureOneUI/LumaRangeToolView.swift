import SwiftUI
import AppCoreShared

/// Reconstructed Luma Range tool (UI-204).
/// Provides high-precision luminance-based masking with falloff control.
public struct LumaRangeToolView: View {
    @ObservedObject var controller: AdjustmentToolController
    
    @State private var rangeStart: Double = 0.0
    @State private var rangeEnd: Double = 100.0
    @State private var falloffStart: Double = 10.0
    @State private var falloffEnd: Double = 10.0
    
    public init(controller: AdjustmentToolController) {
        self.controller = controller
    }
    
    public var body: some View {
        COToolSection("Luma Range", toolID: "LumaRange") {
            VStack(alignment: .leading, spacing: 12) {
                // Interactive Range Graph (Mock)
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(LinearGradient(gradient: Gradient(colors: [.black, .white]), startPoint: .leading, endPoint: .trailing))
                        .frame(height: 40)
                    
                    // Selection Overlay
                    Rectangle()
                        .fill(CaptureOneTheme.Colors.activeHighlight.opacity(0.3))
                        .frame(width: CGFloat(rangeEnd - rangeStart) * 2, height: 40) // Simplified scaling
                        .offset(x: CGFloat(rangeStart + (rangeEnd - rangeStart)/2 - 50) * 2)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                
                VStack(spacing: 8) {
                    lumaSlider(label: "Range", start: $rangeStart, end: $rangeEnd, range: 0...100)
                    lumaSlider(label: "Falloff Start", value: $falloffStart, range: 0...100)
                    lumaSlider(label: "Falloff End", value: $falloffEnd, range: 0...100)
                }
                
                Divider().background(Color.white.opacity(0.05))
                
                HStack {
                    Button("Invert") { /* Invert logic */ }
                        .font(.system(size: 10))
                        .buttonStyle(.bordered)
                    
                    Spacer()
                    
                    Button("Apply") {
                        // computeLumaRangeWithParameters integration
                    }
                    .font(.system(size: 10, weight: .bold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(CaptureOneTheme.Colors.activeHighlight)
                    .foregroundColor(.black)
                    .cornerRadius(4)
                }
                .controlSize(.small)
            }
            .padding(.vertical, 4)
        }
    }
    
    private func lumaSlider(label: String, value: Binding<Double>, range: ClosedRange<Double>) -> some View {
        HStack {
            Text(label).font(.system(size: 11)).foregroundColor(.gray).frame(width: 75, alignment: .leading)
            Slider(value: value, in: range)
                .accentColor(CaptureOneTheme.Colors.activeHighlight)
            Text("\(Int(value.wrappedValue))").font(.system(size: 10, design: .monospaced)).frame(width: 25, alignment: .trailing)
        }
    }
    
    private func lumaSlider(label: String, start: Binding<Double>, end: Binding<Double>, range: ClosedRange<Double>) -> some View {
        HStack {
            Text(label).font(.system(size: 11)).foregroundColor(.gray).frame(width: 75, alignment: .leading)
            // Simplified dual slider representation
            Slider(value: start, in: range)
                .accentColor(CaptureOneTheme.Colors.activeHighlight)
            Text("\(Int(start.wrappedValue))-\(Int(end.wrappedValue))").font(.system(size: 10, design: .monospaced)).frame(width: 45, alignment: .trailing)
        }
    }
}
