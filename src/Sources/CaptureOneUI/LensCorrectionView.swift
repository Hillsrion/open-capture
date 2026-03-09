import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Lens Correction tool.
/// Based on disassembly of LensCorrectionView (ENG-006).
public struct LensCorrectionToolView: View {
    @Binding var distortion: Double
    @Binding var sharpnessFalloff: Double
    @Binding var lightFalloff: Double
    @Binding var shiftX: Float
    @Binding var shiftY: Float
    @State private var profile: String = "Generic"
    
    public init(distortion: Binding<Double>, sharpnessFalloff: Binding<Double>, lightFalloff: Binding<Double>, shiftX: Binding<Float>, shiftY: Binding<Float>) {
        self._distortion = distortion
        self._sharpnessFalloff = sharpnessFalloff
        self._lightFalloff = lightFalloff
        self._shiftX = shiftX
        self._shiftY = shiftY
    }
    
    public var body: some View {
        COToolSection("Lens Correction") {
            VStack(spacing: 8) {
                // Profile Selector
                HStack {
                    Text("Profile").font(.system(size: 11))
                    Spacer()
                    
                    Menu {
                        Button("Generic") { profile = "Generic" }
                        Button("Manufacturer") { profile = "Manufacturer" }
                        Button("Phase One IQ4") { profile = "Phase One IQ4" }
                    } label: {
                        HStack {
                            Text(profile).font(.system(size: 11)).foregroundColor(.white)
                            Image(systemName: "chevron.up.chevron.down").font(.system(size: 8))
                        }
                    }
                    .frame(width: 120)
                }
                
                COUISlider(label: "Distortion", value: Binding(get: { Float(distortion) }, set: { distortion = Double($0) }), range: 0...100)
                COUISlider(label: "Sharpness Falloff", value: Binding(get: { Float(sharpnessFalloff) }, set: { sharpnessFalloff = Double($0) }), range: 0...100)
                COUISlider(label: "Light Falloff", value: Binding(get: { Float(lightFalloff) }, set: { lightFalloff = Double($0) }), range: 0...100)
                
                COUISlider(label: "Movement X", value: $shiftX, range: -100...100)
                COUISlider(label: "Movement Y", value: $shiftY, range: -100...100)
                
                HStack {
                    Toggle("Chromatic Aberration", isOn: .constant(true))
                        .font(.system(size: 11))
                    Spacer()
                    Toggle("Diffraction", isOn: .constant(false))
                        .font(.system(size: 11))
                }
                .toggleStyle(POCheckboxStyle())
            }
        }
    }
}

/// Reconstructed high-fidelity LCC tool.
/// Based on disassembly of LCCView (ENG-006).
public struct LCCToolView: View {
    @Binding var isLCCActive: Bool
    @State private var selectedProfile: String = "None"
    
    public init(isLCCActive: Binding<Bool>) {
        self._isLCCActive = isLCCActive
    }
    
    public var body: some View {
        COToolSection("LCC") {
            VStack(spacing: 8) {
                HStack {
                    Text("Active").font(.system(size: 11))
                    Spacer()
                    Toggle("", isOn: $isLCCActive)
                        .toggleStyle(POCheckboxStyle())
                }
                
                HStack {
                    Text("Profile").font(.system(size: 11))
                    Spacer()
                    Menu {
                        Button("None") { selectedProfile = "None" }
                        Button("Default") { selectedProfile = "Default" }
                    } label: {
                        HStack {
                            Text(selectedProfile).font(.system(size: 11)).foregroundColor(.white)
                            Image(systemName: "chevron.up.chevron.down").font(.system(size: 8))
                        }
                    }
                    .frame(width: 120)
                }
                
                Divider().background(Color.white.opacity(0.1))
                
                Button(action: {
                    print("[CaptureOneUI] Create LCC workflow triggered")
                }) {
                    Text("Create LCC...")
                        .font(.system(size: 11, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .padding(6)
                        .background(CaptureOneTheme.Colors.activeHighlight)
                        .foregroundColor(.white)
                        .cornerRadius(4)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

/// Simplified POCheckboxStyle for internal UI verification.
public struct POCheckboxStyle: ToggleStyle {
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .font(.system(size: 11))
                .foregroundColor(configuration.isOn ? CaptureOneTheme.Colors.activeHighlight : .gray)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            configuration.label
        }
    }
}
