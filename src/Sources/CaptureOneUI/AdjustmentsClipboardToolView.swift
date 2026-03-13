import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Adjustments Clipboard tool.
public struct AdjustmentsClipboardToolView: View {
    @ObservedObject var commands = AppCommandCenter.shared
    @State private var autoSelectAdjusted: Bool = true
    
    // Checkbox states for tool categories
    @State private var exposureSelected: Bool = true
    @State private var colorSelected: Bool = true
    @State private var detailsSelected: Bool = true
    @State private var layersSelected: Bool = true
    
    public init(config: ToolConfiguration) {}
    public init() {}
    
    public var body: some View {
        COToolSection("Adjustments Clipboard", toolID: "AdjustmentsClipboard") {
            VStack(alignment: .leading, spacing: 8) {
                // Auto-Select Checkbox
                Toggle("Autoselect Adjusted", isOn: $autoSelectAdjusted)
                    .font(.system(size: 11))
                    .padding(.bottom, 4)
                
                Divider().background(Color.white.opacity(0.1))
                
                // Select All / None Buttons
                HStack(spacing: 12) {
                    Button("Select All") {
                        exposureSelected = true
                        colorSelected = true
                        detailsSelected = true
                        layersSelected = true
                    }
                    .buttonStyle(.plain)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(CaptureOneTheme.Colors.activeHighlight)
                    
                    Button("Select None") {
                        exposureSelected = false
                        colorSelected = false
                        detailsSelected = false
                        layersSelected = false
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
                    Toggle("Exposure", isOn: $exposureSelected).font(.system(size: 11))
                    Toggle("Color", isOn: $colorSelected).font(.system(size: 11))
                    Toggle("Details", isOn: $detailsSelected).font(.system(size: 11))
                    Toggle("Layers", isOn: $layersSelected).font(.system(size: 11))
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
