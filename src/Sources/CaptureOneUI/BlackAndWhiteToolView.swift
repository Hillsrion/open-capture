import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Black & White tool (UI-202).
/// Features color-to-luma sensitivity sliders and Split Toning.
public struct BlackAndWhiteToolView: View {
    @ObservedObject var controller: COBlackAndWhiteToolController
    
    public init(controller: COBlackAndWhiteToolController) {
        self.controller = controller
    }
    
    public var body: some View {
        COToolSection("Black & White", toolID: "BlackAndWhite") {
            VStack(spacing: 10) {
                HStack {
                    Toggle("Enable Black & White", isOn: $controller.adjustmentController.blackAndWhiteEnabled)
                        .font(.system(size: 11, weight: .semibold))
                    Spacer()
                }
                
                if controller.adjustmentController.blackAndWhiteEnabled {
                    VStack(spacing: 6) {
                        bwSlider(label: "Red", value: $controller.adjustmentController.bwRed, color: .red)
                        bwSlider(label: "Orange", value: $controller.adjustmentController.bwOrange, color: .orange)
                        bwSlider(label: "Yellow", value: $controller.adjustmentController.bwYellow, color: .yellow)
                        bwSlider(label: "Green", value: $controller.adjustmentController.bwGreen, color: .green)
                        bwSlider(label: "Blue", value: $controller.adjustmentController.bwBlue, color: .blue)
                        bwSlider(label: "Magenta", value: $controller.adjustmentController.bwMagenta, color: .purple)
                    }
                    .padding(.top, 4)
                    
                    Divider().background(Color.white.opacity(0.05))
                    
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Split Toning").font(.system(size: 10, weight: .bold)).foregroundColor(.gray)
                        
                        HStack(spacing: 30) {
                            POColorBalanceControl(
                                value: $controller.highlightValue,
                                title: "Highlights",
                                wheelDiameter: 92,
                                lightnessControlDisabled: true
                            )
                            
                            POColorBalanceControl(
                                value: $controller.shadowValue,
                                title: "Shadows",
                                wheelDiameter: 92,
                                lightnessControlDisabled: true
                            )
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
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
