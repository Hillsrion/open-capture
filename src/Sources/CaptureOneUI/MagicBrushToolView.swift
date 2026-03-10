import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Magic Brush & Eraser settings tool (UI-204).
/// Based on disassembly of MagicBrushSettingsToolController.
public struct MagicBrushToolView: View {
    @ObservedObject var settings: MagicBrushSettings
    @State private var linkBrushAndEraser: Bool = true
    @State private var activeTab: Int = 0 // 0: Brush, 1: Eraser
    
    public init(settings: MagicBrushSettings) {
        self.settings = settings
    }
    
    public var body: some View {
        COToolSection("Magic Brush", toolID: "MagicBrush") {
            VStack(spacing: 10) {
                if !linkBrushAndEraser {
                    Picker("", selection: $activeTab) {
                        Text("Brush").tag(0)
                        Text("Eraser").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                }
                
                COUISlider(label: "Size", value: Binding(get: { Float(settings.size) }, set: { settings.size = Double($0) }), range: 1...100)
                COUISlider(label: "Tolerance", value: Binding(get: { Float(settings.tolerance) }, set: { settings.tolerance = Double($0) }), range: 1...100)
                COUISlider(label: "Refine Edge", value: Binding(get: { Float(settings.refineEdge) }, set: { settings.refineEdge = Double($0) }), range: 0...100)
                COUISlider(label: "Opacity", value: Binding(get: { Float(settings.opacity) }, set: { settings.opacity = Double($0) }), range: 1...100)
                
                Divider().background(Color.white.opacity(0.1))
                
                Toggle("Link Brush and Eraser", isOn: $linkBrushAndEraser)
                    .toggleStyle(POCheckboxStyle())
                    .font(.system(size: 11))
                
                Button(action: {
                    // Logic for sample color selection
                }) {
                    Text("Sample Color")
                        .font(.system(size: 11, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .padding(6)
                        .background(CaptureOneTheme.Colors.activeHighlight)
                        .foregroundColor(.black)
                        .cornerRadius(4)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}
