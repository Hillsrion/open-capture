import SwiftUI
import AppCoreShared
import ImageCore

/// Reconstructed high-fidelity Keystone tool (UI-204).
/// Provides manual sliders and activation for interactive guides.
public struct KeystoneToolView: View {
    @ObservedObject var controller = AdjustmentToolController.shared
    @ObservedObject var commands = AppCommandCenter.shared
    
    public init() {}
    
    public var body: some View {
        COToolSection("Keystone", toolID: "Perspective") {
            VStack(spacing: 12) {
                // Mode Buttons
                HStack(spacing: 8) {
                    keystoneModeButton(id: "KeystoneVertical", icon: "rectangle.portrait", label: "Vertical")
                    keystoneModeButton(id: "KeystoneHorizontal", icon: "rectangle", label: "Horizontal")
                    keystoneModeButton(id: "Keystone", icon: "square", label: "All")
                    Spacer()
                }
                
                VStack(spacing: 6) {
                    keystoneSlider(label: "Tilt X", value: $controller.keystoneTiltX, range: -45...45)
                    keystoneSlider(label: "Tilt Y", value: $controller.keystoneTiltY, range: -45...45)
                    keystoneSlider(label: "Amount", value: $controller.keystoneAmount, range: 0...100)
                    keystoneSlider(label: "Aspect", value: $controller.keystoneAspect, range: -50...100)
                    keystoneSlider(label: "Skew", value: $controller.keystoneSkew, range: -50...50)
                }
                
                Divider().background(Color.white.opacity(0.05))
                
                HStack {
                    Text("Focal Length (mm)")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    Spacer()
                    TextField("", value: $controller.keystoneFocalLength, formatter: NumberFormatter())
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(4)
                        .frame(width: 50)
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(2)
                        .font(.system(size: 11, design: .monospaced))
                }
                
                Button(action: {
                    controller.applyKeystone()
                }) {
                    Text("Apply")
                        .font(.system(size: 11, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                        .background(CaptureOneTheme.Colors.activeHighlight)
                        .foregroundColor(.black)
                        .cornerRadius(4)
                }
                .buttonStyle(.plain)
                .padding(.top, 4)
            }
            .padding(.vertical, 4)
        }
    }
    
    private func keystoneSlider(label: String, value: Binding<Double>, range: ClosedRange<Double>) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                .frame(width: 50, alignment: .leading)
            Slider(value: value, in: range)
                .accentColor(CaptureOneTheme.Colors.activeHighlight)
            Text(String(format: "%.1f", value.wrappedValue))
                .font(.system(size: 10, design: .monospaced))
                .frame(width: 35, alignment: .trailing)
        }
    }
    
    private func keystoneModeButton(id: String, icon: String, label: String) -> some View {
        Button(action: {
            commands.selectedCursorToolID = commands.selectedCursorToolID == id ? "Select" : id
        }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                Text(label)
                    .font(.system(size: 9))
            }
            .frame(width: 54, height: 40)
            .background(commands.selectedCursorToolID == id ? CaptureOneTheme.Colors.activeHighlight : Color.white.opacity(0.05))
            .foregroundColor(commands.selectedCursorToolID == id ? .black : .white)
            .cornerRadius(4)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
