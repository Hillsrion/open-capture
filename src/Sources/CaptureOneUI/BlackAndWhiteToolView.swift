import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Black & White tool (UI-202).
/// Features color-to-luma sensitivity sliders and Split Toning.
public struct BlackAndWhiteToolView: View {
    @ObservedObject var controller: AdjustmentToolController
    
    public init(controller: AdjustmentToolController) {
        self.controller = controller
    }
    
    public var body: some View {
        COToolSection("Black & White", toolID: "BlackAndWhite") {
            VStack(spacing: 10) {
                HStack {
                    Toggle("Enable Black & White", isOn: $controller.blackAndWhiteEnabled)
                        .font(.system(size: 11, weight: .semibold))
                    Spacer()
                }
                
                if controller.blackAndWhiteEnabled {
                    VStack(spacing: 6) {
                        bwSlider(label: "Red", value: $controller.bwRed, color: .red)
                        bwSlider(label: "Yellow", value: $controller.bwYellow, color: .yellow)
                        bwSlider(label: "Green", value: $controller.bwGreen, color: .green)
                        bwSlider(label: "Cyan", value: $controller.bwCyan, color: .cyan)
                        bwSlider(label: "Blue", value: $controller.bwBlue, color: .blue)
                        bwSlider(label: "Magenta", value: $controller.bwMagenta, color: .purple)
                    }
                    .padding(.top, 4)
                    
                    Divider().background(Color.white.opacity(0.05))
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Split Toning").font(.system(size: 10, weight: .bold)).foregroundColor(.gray)
                        
                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Highlights").font(.system(size: 9))
                                ColorPicker("", selection: .constant(.orange)).labelsHidden().scaleEffect(0.8)
                            }
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Shadows").font(.system(size: 9))
                                ColorPicker("", selection: .constant(.blue)).labelsHidden().scaleEffect(0.8)
                            }
                            Spacer()
                        }
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
    
    private func bwSlider(label: String, value: Binding<Double>, color: Color) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                .frame(width: 50, alignment: .leading)
            
            Slider(value: value, in: -100...100)
                .accentColor(color.opacity(0.6))
            
            Text("\(Int(value.wrappedValue))")
                .font(.system(size: 10, design: .monospaced))
                .frame(width: 30, alignment: .trailing)
        }
    }
}
