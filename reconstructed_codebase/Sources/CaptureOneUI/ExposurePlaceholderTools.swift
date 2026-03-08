import SwiftUI
import AppCoreShared
import DataCore

// MARK: - Match Look (UI-202)
public struct MatchLookToolView: View {
    public init() {}
    
    public var body: some View {
        COToolSection("Match Look") {
            VStack(alignment: .leading, spacing: 8) {
                Text("Match exposure and color between images.")
                    .font(.system(size: 10))
                    .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                
                Button(action: {
                    // Stub for Match Look triggering
                }) {
                    Text("Match")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            .padding(.vertical, 4)
        }
    }
}

// MARK: - Black & White (UI-202)
public struct BlackAndWhiteToolView: View {
    @ObservedObject var controller: AdjustmentToolController
    
    public init(controller: AdjustmentToolController) {
        self.controller = controller
    }
    
    public var body: some View {
        COToolSection("Black & White") {
            VStack(spacing: 12) {
                Toggle("Enable Black & White", isOn: Binding(
                    get: { controller.blackAndWhiteEnabled },
                    set: { controller.blackAndWhiteEnabled = $0 }
                ))
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
            Text("\(Int(value.wrappedValue))")
                .font(.system(size: 11, design: .monospaced))
                .frame(width: 30, alignment: .trailing)
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
        COToolSection("Dehaze") {
            VStack(spacing: 8) {
                HStack {
                    Text("Amount")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                        .frame(width: 60, alignment: .leading)
                    Slider(value: Binding(
                        get: { controller.dehazeAmount },
                        set: { controller.dehazeAmount = $0 }
                    ), in: 0...100)
                    Text("\(Int(controller.dehazeAmount))")
                        .font(.system(size: 11, design: .monospaced))
                        .frame(width: 30, alignment: .trailing)
                }
                
                HStack {
                    Text("Shadow Tone")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    Spacer()
                    ColorPicker("", selection: .constant(.gray)) // Mock shadow tone color picker
                        .labelsHidden()
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
        COToolSection("Vignetting") {
            VStack(spacing: 8) {
                HStack {
                    Text("Method")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    Spacer()
                    Picker("", selection: Binding(
                        get: { controller.vignettingMethod },
                        set: { controller.vignettingMethod = $0 }
                    )) {
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
                    Slider(value: Binding(
                        get: { controller.vignettingAmount },
                        set: { controller.vignettingAmount = $0 }
                    ), in: -4...4)
                    Text(String(format: "%.1f", controller.vignettingAmount))
                        .font(.system(size: 11, design: .monospaced))
                        .frame(width: 30, alignment: .trailing)
                }
            }
            .padding(.vertical, 4)
        }
    }
}
