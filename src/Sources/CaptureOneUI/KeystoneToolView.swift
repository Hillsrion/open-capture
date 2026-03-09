import SwiftUI
import AppCoreShared
import ImageCore

/// Reconstructed high-fidelity Keystone tool (UI-006/AI-003).
/// Matches Capture One 16.7.4 specifications.

public struct KeystoneToolView: View {
    @Binding var tiltX: Double
    @Binding var tiltY: Double
    @Binding var amount: Double
    @Binding var aspect: Double
    @Binding var skew: Double
    @Binding var focalLength: Double
    
    public init(tiltX: Binding<Double>, tiltY: Binding<Double>, amount: Binding<Double>, aspect: Binding<Double>, skew: Binding<Double>, focalLength: Binding<Double>) {
        self._tiltX = tiltX
        self._tiltY = tiltY
        self._amount = amount
        self._aspect = aspect
        self._skew = skew
        self._focalLength = focalLength
    }
    
    public init(tiltX: Binding<Double>, tiltY: Binding<Double>, amount: Binding<Double>, aspect: Binding<Double>, skew: Binding<Double>) {
        // Compatibility init
        self._tiltX = tiltX
        self._tiltY = tiltY
        self._amount = amount
        self._aspect = aspect
        self._skew = skew
        self._focalLength = .constant(35.0)
    }

    public var body: some View {
        COToolSection("Keystone", toolID: "Perspective") {
            VStack(spacing: 10) {
                // Toolbar for Keystone Types
                HStack(spacing: 8) {
                    keystoneTypeButton(icon: "rectangle.portrait", label: "Vertical", tag: 0)
                    keystoneTypeButton(icon: "rectangle", label: "Horizontal", tag: 1)
                    keystoneTypeButton(icon: "square", label: "All", tag: 2)
                    Spacer()
                    
                    Button(action: {
                        // AI logic
                    }) {
                        Text("Auto")
                            .font(.system(size: 10, weight: .bold))
                            .frame(width: 40, height: 24)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(4)
                    }
                    .buttonStyle(.plain)
                }
                
                VStack(spacing: 6) {
                    keystoneSlider(label: "Tilt X", value: $tiltX, range: -45...45)
                    keystoneSlider(label: "Tilt Y", value: $tiltY, range: -45...45)
                    keystoneSlider(label: "Amount", value: $amount, range: 0...100)
                    keystoneSlider(label: "Aspect", value: $aspect, range: -50...50)
                    keystoneSlider(label: "Skew", value: $skew, range: -50...50)
                }
                
                Divider().background(Color.white.opacity(0.05))
                
                HStack {
                    Text("Focal Length (mm)")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    Spacer()
                    TextField("", value: $focalLength, formatter: NumberFormatter())
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 50)
                        .font(.system(size: 11, design: .monospaced))
                }
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
    
    private func keystoneTypeButton(icon: String, label: String, tag: Int) -> some View {
        Button(action: {}) {
            VStack(spacing: 2) {
                Image(systemName: icon)
                    .font(.system(size: 12))
                Text(label)
                    .font(.system(size: 8))
            }
            .frame(width: 48, height: 32)
            .background(Color.white.opacity(0.05))
            .cornerRadius(4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
