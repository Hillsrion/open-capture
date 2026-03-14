import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Magic Brush & Eraser settings tool (UI-204).
/// Matches Capture One 16.7.4 visual standards and logic.
public struct MagicBrushToolView: View {
    @ObservedObject var settings: MagicBrushSettings
    @ObservedObject var brushManager = BrushSettingsManager.shared
    
    public init(settings: MagicBrushSettings) {
        self.settings = settings
    }
    
    public var body: some View {
        COToolSection("Magic Brush", toolID: "MagicBrush") {
            VStack(spacing: 10) {
                // Main Sliders
                VStack(spacing: 8) {
                    sliderRow(label: "Size", value: $settings.size, range: 1...100, unit: "px")
                    sliderRow(label: "Tolerance", value: $settings.tolerance, range: 1...100, unit: "%")
                    sliderRow(label: "Refine Edge", value: $settings.refineEdge, range: 0...100, unit: "%")
                    sliderRow(label: "Opacity", value: $settings.opacity, range: 1...100, unit: "%")
                    sliderRow(label: "Flow", value: $settings.flow, range: 1...100, unit: "%")
                }
                
                Divider().background(Color.white.opacity(0.05))
                
                VStack(alignment: .leading, spacing: 8) {
                    Toggle("Sample Entire Photo", isOn: $settings.sampleEntirePhoto)
                        .toggleStyle(CheckboxToggleStyle())
                        .font(.system(size: 11))
                    
                    Toggle("Link Brush and Eraser", isOn: $brushManager.linkBrushSettings)
                        .toggleStyle(CheckboxToggleStyle())
                        .font(.system(size: 11))
                }
                .padding(.top, 2)
            }
            .padding(.vertical, 4)
        }
    }
    
    private func sliderRow(label: String, value: Binding<Double>, range: ClosedRange<Double>, unit: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                .frame(width: 70, alignment: .leading)
            
            Slider(value: value, in: range)
                .accentColor(CaptureOneTheme.Colors.activeHighlight)
            
            Text("\(Int(value.wrappedValue))\(unit)")
                .font(.system(size: 10, design: .monospaced))
                .foregroundColor(.white)
                .frame(width: 45, alignment: .trailing)
        }
    }
}
