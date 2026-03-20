import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Adjustments Clipboard tool.
public struct AdjustmentsClipboardToolView: View {
    @ObservedObject var commands = AppCommandCenter.shared
    @ObservedObject var clipboardController = COAdjustmentsClipboardController.shared
    
    public init(config: ToolConfiguration) {}
    public init() {}
    
    public var body: some View {
        COToolSection("Adjustments Clipboard", toolID: "AdjustmentsClipboard") {
            VStack(alignment: .leading, spacing: 8) {
                // Auto-Select Checkbox
                Toggle("Autoselect Adjusted", isOn: $clipboardController.autoSelectAdjusted)
                    .font(.system(size: 11))
                    .padding(.bottom, 4)
                
                Divider().background(Color.white.opacity(0.1))
                
                // Select All / None Buttons
                HStack(spacing: 12) {
                    Button("Select All") {
                        clipboardController.selectAll()
                    }
                    .buttonStyle(.plain)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(CaptureOneTheme.Colors.activeHighlight)
                    
                    Button("Select None") {
                        clipboardController.selectNone()
                    }
                    .buttonStyle(.plain)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(CaptureOneTheme.Colors.activeHighlight)
                    Spacer()
                }
                .padding(.vertical, 2)
                
                Divider().background(Color.white.opacity(0.1))
                
                // Tool Hierarchy (Simplified for spec)
                VStack(alignment: .leading, spacing: 6) {
                    Toggle("Exposure", isOn: Binding(
                        get: { clipboardController.state.exposure },
                        set: { clipboardController.state.exposure = $0 }
                    )).font(.system(size: 11))
                    Toggle("Color", isOn: Binding(
                        get: { clipboardController.state.color },
                        set: { clipboardController.state.color = $0 }
                    )).font(.system(size: 11))
                    Toggle("Details", isOn: Binding(
                        get: { clipboardController.state.details },
                        set: { clipboardController.state.details = $0 }
                    )).font(.system(size: 11))
                    Toggle("Layers", isOn: Binding(
                        get: { clipboardController.state.layers },
                        set: { clipboardController.state.layers = $0 }
                    )).font(.system(size: 11))
                    Toggle("Crop", isOn: Binding(
                        get: { clipboardController.state.crop },
                        set: { clipboardController.state.crop = $0 }
                    )).font(.system(size: 11))
                }
                
                HStack {
                    Spacer()
                    Button("Copy") {
                        commands.copyAdjustments()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Apply") {
                        commands.applyCopiedAdjustments()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.top, 4)
            }
        }
    }
}
