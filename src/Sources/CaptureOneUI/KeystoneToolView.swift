import SwiftUI
import AppCoreShared
import ImageCore

/// Reconstructed high-fidelity Keystone tool (UI-204).
/// Provides manual sliders and activation for interactive guides.
public struct KeystoneToolView: View {
    @ObservedObject var controller = COKeystoneController.shared
    @ObservedObject var adjController = AdjustmentToolController.shared
    @ObservedObject var commands = AppCommandCenter.shared
    
    public init() {}
    
    public var body: some View {
        COToolSection("Keystone", toolID: "Perspective") {
            VStack(spacing: 12) {
                // Mode Buttons
                HStack(spacing: 8) {
                    keystoneModeButton(mode: .vertical, icon: "rectangle.portrait", label: "Vertical")
                    keystoneModeButton(mode: .horizontal, icon: "rectangle", label: "Horizontal")
                    keystoneModeButton(mode: .verticalAndHorizontal, icon: "square", label: "All")
                    Spacer()
                }
                
                VStack(spacing: 6) {
                    keystoneSlider(label: "Amount", value: $controller.amount, range: 0...100)
                    
                    Divider().background(Color.white.opacity(0.1)).padding(.vertical, 4)
                    
                    keystoneSlider(label: "Tilt X", value: $adjController.keystoneTiltX, range: -45...45)
                    keystoneSlider(label: "Tilt Y", value: $adjController.keystoneTiltY, range: -45...45)
                    keystoneSlider(label: "Aspect", value: $adjController.keystoneAspect, range: -50...100)
                }
                
                HStack(spacing: 8) {
                    Button(action: {
                        controller.resetPoints()
                    }) {
                        Text("Reset")
                            .font(.system(size: 11))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(4)
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: {
                        controller.apply()
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
                }
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
            Text(String(format: "%.0f%%", value.wrappedValue))
                .font(.system(size: 10, design: .monospaced))
                .frame(width: 35, alignment: .trailing)
        }
    }
    
    private func keystoneModeButton(mode: COKeystoneController.KeystoneMode, icon: String, label: String) -> some View {
        let isSelected = controller.mode == mode && commands.selectedCursorToolID.contains("Keystone")
        let toolID = mode == .vertical ? "KeystoneVertical" : (mode == .horizontal ? "KeystoneHorizontal" : "Keystone")
        
        return Button(action: {
            controller.mode = mode
            commands.selectedCursorToolID = toolID
            controller.isVisible = true
        }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                Text(label)
                    .font(.system(size: 9))
            }
            .frame(width: 54, height: 40)
            .background(isSelected ? CaptureOneTheme.Colors.activeHighlight : Color.white.opacity(0.05))
            .foregroundColor(isSelected ? .black : .white)
            .cornerRadius(4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
