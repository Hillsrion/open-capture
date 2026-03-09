import SwiftUI
import AppCoreShared
import ImageCore

/// Reconstructed high-fidelity Keystone tool (UI-006/AI-003).
public struct KeystoneToolView: View {
    @Binding var tiltX: Double
    @Binding var tiltY: Double
    @Binding var amount: Double
    @Binding var aspect: Double
    @Binding var skew: Double
    
    public init(tiltX: Binding<Double>, tiltY: Binding<Double>, amount: Binding<Double>, aspect: Binding<Double>, skew: Binding<Double>) {
        self._tiltX = tiltX
        self._tiltY = tiltY
        self._amount = amount
        self._aspect = aspect
        self._skew = skew
    }
    
    public var body: some View {
        COToolSection("Keystone") {
            VStack(spacing: 8) {
                // Toolbar for Keystone Types (Interactive tools)
                HStack(spacing: 12) {
                    keystoneTypeButton(icon: "rectangle.portrait", label: "Vertical")
                    keystoneTypeButton(icon: "rectangle", label: "Horizontal")
                    keystoneTypeButton(icon: "square", label: "All")
                    Spacer()
                }
                .padding(.bottom, 4)
                
                // Sliders
                POSliderControl(label: "Tilt X", value: Binding(get: { Float(tiltX) }, set: { tiltX = Double($0) }), range: -45...45)
                POSliderControl(label: "Tilt Y", value: Binding(get: { Float(tiltY) }, set: { tiltY = Double($0) }), range: -45...45)
                POSliderControl(label: "Amount", value: Binding(get: { Float(amount) }, set: { amount = Double($0) }), range: 0...100)
                POSliderControl(label: "Aspect", value: Binding(get: { Float(aspect) }, set: { aspect = Double($0) }), range: -50...50)
                POSliderControl(label: "Skew", value: Binding(get: { Float(skew) }, set: { skew = Double($0) }), range: -50...50)
                
                // Auto/Reset Buttons
                HStack {
                    Button("Auto Keystone") {
                        // Logic: Trigger KeystoneEngine.detectGuidelines
                        print("[UI] Triggering Auto Keystone")
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(4)
                    
                    Spacer()
                    
                    Button("Reset") {
                        tiltX = 0; tiltY = 0; amount = 0; aspect = 0; skew = 0
                    }
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                }
                .padding(.top, 4)
            }
        }
    }
    
    private func keystoneTypeButton(icon: String, label: String) -> some View {
        Button(action: {}) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                Text(label)
                    .font(.system(size: 8))
            }
            .frame(width: 50, height: 40)
            .background(Color.white.opacity(0.05))
            .cornerRadius(4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
