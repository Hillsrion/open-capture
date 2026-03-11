import SwiftUI
import AppCoreShared
import ImageCore

/// Reconstructed high-fidelity Keystone tool (UI-204).
/// Features a tabbed interface for interactive Guides and manual Sliders.
public struct KeystoneToolView: View {
    @Binding var tiltX: Double
    @Binding var tiltY: Double
    @Binding var amount: Double
    @Binding var aspect: Double
    @Binding var skew: Double
    @Binding var focalLength: Double
    var autoAction: (() -> Void)?
    
    @State private var selectedTab: Int = 0 // 0: Guides, 1: Sliders
    
    public init(tiltX: Binding<Double>, tiltY: Binding<Double>, amount: Binding<Double>, aspect: Binding<Double>, skew: Binding<Double>, focalLength: Binding<Double>, autoAction: (() -> Void)? = nil) {
        self._tiltX = tiltX
        self._tiltY = tiltY
        self._amount = amount
        self._aspect = aspect
        self._skew = skew
        self._focalLength = focalLength
        self.autoAction = autoAction
    }
    
    public var body: some View {
        COToolSection("Keystone", toolID: "Perspective") {
            VStack(spacing: 12) {
                // Tab Picker
                Picker("", selection: $selectedTab) {
                    Text("Guides").tag(0)
                    Text("Sliders").tag(1)
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                
                if selectedTab == 0 {
                    guidesTabView
                } else {
                    slidersTabView
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
    
    // MARK: - Tab Views
    
    private var guidesTabView: some View {
        VStack(spacing: 10) {
            HStack(spacing: 8) {
                keystoneTypeButton(icon: "rectangle.portrait", label: "Vertical", tag: 0)
                keystoneTypeButton(icon: "rectangle", label: "Horizontal", tag: 1)
                keystoneTypeButton(icon: "square", label: "All", tag: 2)
                
                Spacer()
                
                Button(action: {
                    autoAction?()
                }) {
                    Image(systemName: "a.circle.fill")
                        .font(.system(size: 18))
                        .foregroundColor(CaptureOneTheme.Colors.activeHighlight)
                }
                .buttonStyle(.plain)
                .help("Auto Adjust")
            }
            
            Text("Click icons to place guides on the image.")
                .font(.system(size: 10))
                .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button(action: {
                // Apply guides logic
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
    }
    
    private var slidersTabView: some View {
        VStack(spacing: 6) {
            keystoneSlider(label: "Tilt X", value: $tiltX, range: -45...45)
            keystoneSlider(label: "Tilt Y", value: $tiltY, range: -45...45)
            keystoneSlider(label: "Amount", value: $amount, range: 0...100)
            keystoneSlider(label: "Aspect", value: $aspect, range: -50...100) // Anamorphic support
            keystoneSlider(label: "Skew", value: $skew, range: -50...50)
        }
    }
    
    // MARK: - Components
    
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
        Button(action: {
            // Activate Guide Tool logic
        }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                Text(label)
                    .font(.system(size: 9))
            }
            .frame(width: 54, height: 40)
            .background(Color.white.opacity(0.05))
            .cornerRadius(4)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
