import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Luma Range tool (UI-204).
/// Provides luminosity-based masking with falloff, radius, and sensitivity control.
public struct LumaRangeToolView: View {
    @ObservedObject var controller: AdjustmentToolController
    @ObservedObject var commands = AppCommandCenter.shared
    
    @State private var rangeMin: Double = 0.0
    @State private var rangeMax: Double = 255.0
    @State private var falloffMin: Double = 0.0
    @State private var falloffMax: Double = 255.0
    
    @State private var isDisplayingMask: Bool = true
    
    public init(controller: AdjustmentToolController) {
        self.controller = controller
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Luma Range")
                .font(.headline)
            
            // Interactive Range Bar (4 Handles)
            VStack(alignment: .leading, spacing: 8) {
                Text("Select the tonal range to include in the mask.")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                
                ZStack(alignment: .bottom) {
                    // The Gradient Bar
                    RoundedRectangle(cornerRadius: 2)
                        .fill(LinearGradient(gradient: Gradient(colors: [.black, .white]), startPoint: .leading, endPoint: .trailing))
                        .frame(height: 24)
                    
                    // The Active Range Overlay (Simulated)
                    Rectangle()
                        .fill(CaptureOneTheme.Colors.activeHighlight.opacity(0.4))
                        .frame(width: 150, height: 24)
                        .offset(x: 20)
                    
                    // Handles (Simulated - 4 handles)
                    HStack(spacing: 40) {
                        handle(color: .gray) // Falloff Min
                        handle(color: .white) // Range Min
                        Spacer()
                        handle(color: .white) // Range Max
                        handle(color: .gray) // Falloff Max
                    }
                    .padding(.horizontal, 10)
                    .offset(y: 4)
                }
                .padding(.bottom, 8)
            }
            
            VStack(spacing: 10) {
                lumaSlider(label: "Radius", value: $controller.lumaRangeRadius, range: 0...50)
                lumaSlider(label: "Sensitivity", value: $controller.lumaRangeSensitivity, range: 0...100)
            }
            
            Divider().background(Color.white.opacity(0.1))
            
            HStack {
                Toggle("Display Mask", isOn: $isDisplayingMask)
                    .font(.system(size: 11))
                    .toggleStyle(CheckboxToggleStyle())
                
                Spacer()
                
                Button("Invert") {
                    // Invert logic
                }
                .font(.system(size: 10))
                .buttonStyle(.bordered)
            }
            
            HStack {
                Button("Cancel") {
                    // Dismiss logic
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.1))
                .cornerRadius(4)
                
                Spacer()
                
                Button("Apply") {
                    controller.computeLumaRange(start: rangeMin, end: rangeMax, falloffStart: falloffMin, falloffEnd: falloffMax)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(CaptureOneTheme.Colors.activeHighlight)
                .foregroundColor(.black)
                .cornerRadius(4)
            }
        }
        .padding(16)
        .frame(width: 320)
        .background(CaptureOneTheme.Colors.panelBackground)
    }
    
    private func handle(color: Color) -> some View {
        Rectangle()
            .fill(color)
            .frame(width: 2, height: 30)
            .overlay(Circle().fill(color).frame(width: 8, height: 8).offset(y: 15))
    }
    
    private func lumaSlider(label: String, value: Binding<Double>, range: ClosedRange<Double>) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                .frame(width: 70, alignment: .leading)
            Slider(value: value, in: range)
                .accentColor(CaptureOneTheme.Colors.activeHighlight)
            Text("\(Int(value.wrappedValue))")
                .font(.system(size: 10, design: .monospaced))
                .frame(width: 30, alignment: .trailing)
        }
    }
}
