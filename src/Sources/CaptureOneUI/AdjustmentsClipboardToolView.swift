import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Adjustments Clipboard tool.
public struct AdjustmentsClipboardToolView: View {
    @ObservedObject var commands = AppCommandCenter.shared
    
    public init(config: ToolConfiguration) {}
    public init() {}
    
    public var body: some View {
        COToolSection("Adjustments Clipboard", toolID: "AdjustmentsClipboard") {
            VStack(alignment: .leading, spacing: 8) {
                // Auto-Select Checkbox
                Toggle("Autoselect Adjusted", isOn: $commands.clipboardAutoSelectAdjusted)
                    .font(.system(size: 11))
                    .padding(.bottom, 4)
                
                Divider().background(Color.white.opacity(0.1))
                
                // Select All / None Buttons
                HStack(spacing: 12) {
                    Button("Select All") {
                        commands.clipboardExposureSelected = true
                        commands.clipboardColorSelected = true
                        commands.clipboardDetailsSelected = true
                        commands.clipboardLayersSelected = true
                    }
                    .buttonStyle(.plain)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(CaptureOneTheme.Colors.activeHighlight)
                    
                    Button("Select None") {
                        commands.clipboardExposureSelected = false
                        commands.clipboardColorSelected = false
                        commands.clipboardDetailsSelected = false
                        commands.clipboardLayersSelected = false
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
                    Toggle("Exposure", isOn: $commands.clipboardExposureSelected).font(.system(size: 11))
                    Toggle("Color", isOn: $commands.clipboardColorSelected).font(.system(size: 11))
                    Toggle("Details", isOn: $commands.clipboardDetailsSelected).font(.system(size: 11))
                    Toggle("Layers", isOn: $commands.clipboardLayersSelected).font(.system(size: 11))
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
