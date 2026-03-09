import SwiftUI
import AppCoreShared
import DataCore

// MARK: - Live Preview Composition (ui-205 / live-view)
public struct LivePreviewCompositionToolView: View {
    public init() {}
    
    public var body: some View {
        COToolSection("Live View Composition", toolID: "LivePreviewComposition") {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Orientation")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    Spacer()
                    Picker("", selection: .constant(0)) {
                        Text("Default").tag(0)
                        Text("90° CW").tag(1)
                        Text("90° CCW").tag(2)
                        Text("180°").tag(3)
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .frame(width: 100)
                }
                
                Toggle("Mirror", isOn: .constant(false))
                    .font(.system(size: 11))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    Text("Crop")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    Spacer()
                    Picker("", selection: .constant(0)) {
                        Text("Unconstrained").tag(0)
                        Text("Respect RAW").tag(1)
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .frame(width: 100)
                }
            }
            .padding(.vertical, 4)
        }
    }
}

// MARK: - Live Preview Adjustments (ui-205 / live-view)
public struct LivePreviewAdjustmentsToolView: View {
    public init() {}
    
    public var body: some View {
        COToolSection("Live View Adjustments", toolID: "LivePreviewAdjustments") {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("White Balance")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                        .frame(width: 80, alignment: .leading)
                    Slider(value: .constant(5000), in: 800...14000)
                    Text("5000K")
                        .font(.system(size: 11, design: .monospaced))
                        .frame(width: 40, alignment: .trailing)
                }
                
                HStack {
                    Text("Tint")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                        .frame(width: 80, alignment: .leading)
                    Slider(value: .constant(0), in: -50...50)
                    Text("0")
                        .font(.system(size: 11, design: .monospaced))
                        .frame(width: 40, alignment: .trailing)
                }
                
                HStack {
                    Text("Brightness")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                        .frame(width: 80, alignment: .leading)
                    Slider(value: .constant(0), in: -100...100)
                    Text("0")
                        .font(.system(size: 11, design: .monospaced))
                        .frame(width: 40, alignment: .trailing)
                }
            }
            .padding(.vertical, 4)
        }
    }
}

// MARK: - Live Preview Info (ui-205 / live-view)
public struct LivePreviewInfoToolView: View {
    public init() {}
    
    public var body: some View {
        COToolSection("Live View Info", toolID: "LivePreviewInfoTool") {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Camera")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    Spacer()
                    Text("No Camera Attached")
                        .font(.system(size: 11))
                }
                HStack {
                    Text("Frame Rate")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    Spacer()
                    Text("0 fps")
                        .font(.system(size: 11, design: .monospaced))
                }
                HStack {
                    Text("Status")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    Spacer()
                    Text("Disconnected")
                        .font(.system(size: 11))
                        .foregroundColor(.red)
                }
            }
            .padding(.vertical, 4)
        }
    }
}

// MARK: - Normalize (ui-205 / live-view / capture)
public struct NormalizeToolView: View {
    public init() {}
    
    public var body: some View {
        COToolSection("Normalize", toolID: "Normalize") {
            VStack(alignment: .leading, spacing: 8) {
                Text("Pick an area to define baseline exposure/color.")
                    .font(.system(size: 10))
                    .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                
                HStack {
                    Button(action: {}) { Image(systemName: "eyedropper.halffull") }
                    Button(action: {}) { Text("Apply Normalization") }
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            .padding(.vertical, 4)
        }
    }
}
