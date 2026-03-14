import SwiftUI
import AppCoreShared

/// Reconstructed Brush Settings Tool (GAP-404).
/// Matches Capture One 16.7.4 specifications for manual brush control.

public struct BrushSettingsToolView: View {
    @ObservedObject var manager = BrushSettingsManager.shared
    
    public init() {}
    
    public var body: some View {
        COToolSection("Brush Settings", toolID: "BrushSettings") {
            VStack(spacing: 10) {
                // Tool Picker (Draw / Erase / Heal / Clone)
                Picker("", selection: $manager.activeBrushTool) {
                    Image(systemName: "paintbrush").tag(CursorToolType.drawMask)
                    Image(systemName: "eraser").tag(CursorToolType.eraseMask)
                    Image(systemName: "bandage").tag(CursorToolType.heal)
                    Image(systemName: "arrow.up.left.and.arrow.down.right").tag(CursorToolType.clone)
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                
                VStack(spacing: 8) {
                    brushSlider(label: "Size", value: binding(for: \.size), range: 1...5000, unit: "px")
                    brushSlider(label: "Hardness", value: binding(for: \.hardness), range: 0...100, unit: "%")
                    brushSlider(label: "Opacity", value: binding(for: \.opacity), range: 0...100, unit: "%")
                    brushSlider(label: "Flow", value: binding(for: \.flow), range: 0...100, unit: "%")
                }
                
                Divider().background(Color.white.opacity(0.05))
                
                Toggle(isOn: binding(for: \.penPressureEnabled)) {
                    Text("Use Pen Pressure")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                }
                .toggleStyle(CheckboxToggleStyle())
                
                Toggle(isOn: $manager.linkBrushSettings) {
                    Text("Link Brush Settings")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                }
                .toggleStyle(CheckboxToggleStyle())
            }
            .padding(.vertical, 4)
        }
    }
    
    private func brushSlider(label: String, value: Binding<Float>, range: ClosedRange<Float>, unit: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                .frame(width: 60, alignment: .leading)
            
            Slider(value: value, in: range)
                .accentColor(CaptureOneTheme.Colors.activeHighlight)
            
            Text("\(Int(value.wrappedValue))\(unit)")
                .font(.system(size: 10, design: .monospaced))
                .foregroundColor(.white)
                .frame(width: 45, alignment: .trailing)
        }
    }
    
    // Helper to create bindings to properties of the current brush settings
    private func binding<T>(for keyPath: WritableKeyPath<BrushSettings, T>) -> Binding<T> {
        Binding(
            get: {
                let settings = manager.brushSettingsForCursorTool(manager.activeBrushTool) ?? BrushSettings()
                return settings[keyPath: keyPath]
            },
            set: { newValue in
                switch manager.activeBrushTool {
                case .drawMask: manager.drawBrushSettings[keyPath: keyPath] = newValue
                case .eraseMask: manager.eraseBrushSettings[keyPath: keyPath] = newValue
                case .heal: manager.healBrushSettings[keyPath: keyPath] = newValue
                case .clone: manager.cloneBrushSettings[keyPath: keyPath] = newValue
                default: break
                }
            }
        )
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .foregroundColor(configuration.isOn ? CaptureOneTheme.Colors.activeHighlight : .gray)
                .onTapGesture { configuration.isOn.toggle() }
            configuration.label
        }
    }
}
