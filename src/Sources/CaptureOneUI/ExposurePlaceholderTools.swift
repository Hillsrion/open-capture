import SwiftUI
import AppCoreShared
import DataCore

// MARK: - Match Look (UI-202)
public struct MatchLookToolView: View {
    @StateObject private var viewModel = MatchLookViewModel()
    @ObservedObject var controller = AdjustmentToolController.shared
    
    public init() {}
    
    public var body: some View {
        COToolSection("Match Look", toolID: "MatchLook") {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Impact")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    Slider(value: $controller.matchLookImpact, in: 0...100)
                        .accentColor(CaptureOneTheme.Colors.activeHighlight)
                    Text("\(Int(controller.matchLookImpact))")
                        .font(.system(size: 11, design: .monospaced))
                        .frame(width: 30, alignment: .trailing)
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Reference")
                            .font(.system(size: 10))
                            .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                        Text(viewModel.selectedReferenceVariant?.name ?? "None Set")
                            .font(.system(size: 11, weight: .medium))
                    }
                    Spacer()
                    Button("Set Reference") {
                        // Stub: Pick primary variant
                        viewModel.selectedReferenceVariant = controller.currentVariant
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                }
                .padding(6)
                .background(Color.white.opacity(0.05))
                .cornerRadius(4)
                
                Button(action: {
                    viewModel.matchExposureAndColor(to: [])
                }) {
                    HStack {
                        if viewModel.isMatching {
                            ProgressView().controlSize(.small).scaleEffect(0.6)
                        }
                        Text(viewModel.isMatching ? "Matching..." : "Apply Match")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(CaptureOneTheme.Colors.activeHighlight)
                .disabled(viewModel.isMatching || viewModel.selectedReferenceVariant == nil)
            }
            .padding(.vertical, 4)
        }
    }
}

// MARK: - Black & White (UI-202)
public struct BlackAndWhiteToolView: View {
    @ObservedObject var controller: AdjustmentToolController
    @State private var isSplitTonesExpanded: Bool = false
    
    public init(controller: AdjustmentToolController) {
        self.controller = controller
    }
    
    public var body: some View {
        COToolSection("Black & White", toolID: "BlackAndWhite") {
            VStack(spacing: 12) {
                Toggle("Enable Black & White", isOn: $controller.blackAndWhiteEnabled)
                    .font(.system(size: 11))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if controller.blackAndWhiteEnabled {
                    Divider().background(Color.white.opacity(0.1))
                    
                    VStack(alignment: .leading, spacing: 6) {
                        sliderRow(label: "Red", value: $controller.bwRed)
                        sliderRow(label: "Yellow", value: $controller.bwYellow)
                        sliderRow(label: "Green", value: $controller.bwGreen)
                        sliderRow(label: "Cyan", value: $controller.bwCyan)
                        sliderRow(label: "Blue", value: $controller.bwBlue)
                        sliderRow(label: "Magenta", value: $controller.bwMagenta)
                    }
                    
                    VStack(spacing: 8) {
                        Button(action: { withAnimation { isSplitTonesExpanded.toggle() } }) {
                            HStack {
                                Image(systemName: isSplitTonesExpanded ? "chevron.down" : "chevron.right")
                                    .font(.system(size: 8, weight: .bold))
                                Text("Split Tones")
                                    .font(.system(size: 11, weight: .semibold))
                                Spacer()
                            }
                        }
                        .buttonStyle(.plain)
                        
                        if isSplitTonesExpanded {
                            VStack(spacing: 10) {
                                toneSection(title: "Highlights", hue: $controller.bwSplitToneHighlightHue, sat: $controller.bwSplitToneHighlightSaturation)
                                toneSection(title: "Shadows", hue: $controller.bwSplitToneShadowHue, sat: $controller.bwSplitToneShadowSaturation)
                            }
                            .padding(.leading, 14)
                        }
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
    
    private func sliderRow(label: String, value: Binding<Double>) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                .frame(width: 50, alignment: .leading)
            Slider(value: value, in: -100...100)
                .accentColor(CaptureOneTheme.Colors.activeHighlight)
            Text("\(Int(value.wrappedValue))")
                .font(.system(size: 11, design: .monospaced))
                .frame(width: 30, alignment: .trailing)
        }
    }
    
    private func toneSection(title: String, hue: Binding<Double>, sat: Binding<Double>) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title.uppercased())
                .font(.system(size: 9, weight: .bold))
                .foregroundColor(.gray)
            
            HStack {
                Text("Hue").font(.system(size: 10)).foregroundColor(.gray).frame(width: 30, alignment: .leading)
                Slider(value: hue, in: 0...360)
                Text("\(Int(hue.wrappedValue))°").font(.system(size: 10, design: .monospaced)).frame(width: 35, alignment: .trailing)
            }
            
            HStack {
                Text("Sat").font(.system(size: 10)).foregroundColor(.gray).frame(width: 30, alignment: .leading)
                Slider(value: sat, in: 0...100)
                Text("\(Int(sat.wrappedValue))").font(.system(size: 10, design: .monospaced)).frame(width: 35, alignment: .trailing)
            }
        }
    }
}

// MARK: - Dehaze (UI-202)
public struct DehazeToolView: View {
    @ObservedObject var controller: AdjustmentToolController
    
    public init(controller: AdjustmentToolController) {
        self.controller = controller
    }
    
    public var body: some View {
        COToolSection("Dehaze", toolID: "Dehaze") {
            VStack(spacing: 8) {
                HStack {
                    Text("Amount")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                        .frame(width: 60, alignment: .leading)
                    Slider(value: $controller.dehazeAmount, in: -100...100)
                        .accentColor(CaptureOneTheme.Colors.activeHighlight)
                    Text("\(Int(controller.dehazeAmount))")
                        .font(.system(size: 11, design: .monospaced))
                        .frame(width: 30, alignment: .trailing)
                }
                
                HStack {
                    Text("Shadow Tone")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                        .frame(width: 80, alignment: .leading)
                    Slider(value: $controller.dehazeShadowToneHue, in: 0...360)
                        .accentColor(CaptureOneTheme.Colors.activeHighlight)
                    Circle()
                        .fill(Color(hue: controller.dehazeShadowToneHue/360.0, saturation: 0.5, brightness: 0.8))
                        .frame(width: 14, height: 14)
                        .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1))
                }
            }
            .padding(.vertical, 4)
        }
    }
}

// MARK: - Vignetting (UI-202)
public struct VignettingToolView: View {
    @ObservedObject var controller: AdjustmentToolController
    
    public init(controller: AdjustmentToolController) {
        self.controller = controller
    }
    
    public var body: some View {
        COToolSection("Vignetting", toolID: "Vignetting") {
            VStack(spacing: 8) {
                HStack {
                    Text("Method")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    Spacer()
                    Picker("", selection: $controller.vignettingMethod) {
                        Text("Circular").tag(0)
                        Text("Elliptic").tag(1)
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .frame(width: 100)
                }
                
                HStack {
                    Text("Amount")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                        .frame(width: 60, alignment: .leading)
                    Slider(value: $controller.vignettingAmount, in: -4...4)
                        .accentColor(CaptureOneTheme.Colors.activeHighlight)
                    Text(String(format: "%.1f", controller.vignettingAmount))
                        .font(.system(size: 11, design: .monospaced))
                        .frame(width: 30, alignment: .trailing)
                }
            }
            .padding(.vertical, 4)
        }
    }
}
