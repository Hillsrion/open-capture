import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Focus Mask tool (ENG-204).
/// Highlights sharp areas in the image based on local contrast.
public struct FocusMaskToolView: View {
    @ObservedObject var commands = AppCommandCenter.shared
    @State private var threshold: Double = 250.0 // Raw threshold mapped to 0-100 in UI
    @State private var opacity: Double = 50.0
    @State private var colorIndex: Int = 0 // 0: Green, 1: Red, 2: Blue
    
    public init() {}
    
    public var body: some View {
        COToolSection("Focus Mask", toolID: "FocusMask") {
            VStack(spacing: 8) {
                HStack {
                    Toggle("Show Focus Mask", isOn: $commands.showFocusMask)
                        .font(.system(size: 11))
                    Spacer()
                }
                
                Divider().background(Color.white.opacity(0.1))
                
                focusSlider(label: "Threshold", value: $threshold, range: 0...100)
                focusSlider(label: "Opacity", value: $opacity, range: 0...100)
                
                HStack {
                    Text("Color")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    Spacer()
                    Picker("", selection: $colorIndex) {
                        Text("Green").tag(0)
                        Text("Red").tag(1)
                        Text("Blue").tag(2)
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .frame(width: 100)
                }
            }
            .padding(.vertical, 4)
        }
    }
    
    private func focusSlider(label: String, value: Binding<Double>, range: ClosedRange<Double>) -> some View {
        HStack {
            Text(label).font(.system(size: 11)).foregroundColor(.gray).frame(width: 65, alignment: .leading)
            Slider(value: value, in: range)
                .accentColor(CaptureOneTheme.Colors.activeHighlight)
            Text("\(Int(value.wrappedValue))").font(.system(size: 10, design: .monospaced)).frame(width: 30, alignment: .trailing)
        }
    }
}
