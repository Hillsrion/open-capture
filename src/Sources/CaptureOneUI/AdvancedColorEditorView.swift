import SwiftUI
import AppCoreShared

/// Reconstructed Advanced Color Editor tool (UI-204).
/// Supports Basic, Advanced, and Skin Tone modes with high-fidelity UI.
public struct AdvancedColorEditorView: View {
    @ObservedObject var controller: AdjustmentToolController
    
    // Internal state for color selection (mock for now)
    @State private var selectedColorIndex: Int = 0
    
    public init(controller: AdjustmentToolController) {
        self.controller = controller
    }
    
    public var body: some View {
        COToolSection("Color Editor", toolID: "ColorEditor") {
            VStack(spacing: 12) {
                // Tab Picker
                Picker("", selection: $controller.colorEditorMode) {
                    Text("Basic").tag(0)
                    Text("Advanced").tag(1)
                    Text("Skin Tone").tag(2)
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                
                if controller.colorEditorMode == 0 {
                    basicModeView
                } else if controller.colorEditorMode == 1 {
                    advancedModeView
                } else {
                    skinToneModeView
                }
                
                Divider().background(Color.white.opacity(0.05))
                
                // Footer: Direct Color Editor & Color Picker
                HStack {
                    Button(action: { 
                        AppCommandCenter.shared.selectedCursorToolID = AppCommandCenter.shared.selectedCursorToolID == "DirectColorEditor" ? "Select" : "DirectColorEditor"
                    }) {
                        Image(systemName: "cursorarrow.and.square.on.square.dashed")
                            .font(.system(size: 14))
                            .padding(6)
                            .background(AppCommandCenter.shared.selectedCursorToolID == "DirectColorEditor" ? CaptureOneTheme.Colors.activeHighlight : Color.white.opacity(0.05))
                            .cornerRadius(4)
                    }
                    .buttonStyle(.plain)
                    .help("Direct Color Editor (D)")
                    
                    Spacer()
                    
                    Button(action: { 
                        AppCommandCenter.shared.selectedCursorToolID = AppCommandCenter.shared.selectedCursorToolID == "PickColorEditor" ? "Select" : "PickColorEditor"
                    }) {
                        Image(systemName: "eyedropper")
                            .font(.system(size: 12))
                            .padding(6)
                            .background(AppCommandCenter.shared.selectedCursorToolID == "PickColorEditor" ? CaptureOneTheme.Colors.activeHighlight : Color.white.opacity(0.05))
                            .cornerRadius(4)
                    }
                    .buttonStyle(.plain)
                    .help("Color Editor Picker")
                }
            }
            .padding(.vertical, 4)
        }
    }
    
    // MARK: - Mode Views
    
    private var basicModeView: some View {
        VStack(spacing: 8) {
            // Color Patches Grid (Simulated)
            let colors: [Color] = [.red, .orange, .yellow, .green, .cyan, .blue, .purple, .pink]
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 8) {
                ForEach(0..<8) { index in
                    Circle()
                        .fill(colors[index])
                        .frame(width: 20, height: 20)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: selectedColorIndex == index ? 2 : 0)
                        )
                        .onTapGesture { selectedColorIndex = index }
                }
            }
            .padding(.vertical, 4)
            
            VStack(spacing: 6) {
                colorSlider(label: "Hue", value: .constant(0), range: -30...30)
                colorSlider(label: "Saturation", value: .constant(0), range: -100...100)
                colorSlider(label: "Lightness", value: .constant(0), range: -100...100)
            }
        }
    }
    
    private var advancedModeView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Select a color range to adjust specifically.")
                .font(.system(size: 10))
                .foregroundColor(CaptureOneTheme.Colors.textSecondary)
            
            // Color Wheel Simulation
            ZStack {
                Circle()
                    .stroke(LinearGradient(gradient: Gradient(colors: [.red, .yellow, .green, .cyan, .blue, .purple, .red]), startPoint: .top, endPoint: .bottom), lineWidth: 20)
                    .frame(width: 120, height: 120)
                
                // Active Slice (Simulation)
                Path { path in
                    path.addArc(center: CGPoint(x: 60, y: 60), radius: 60, startAngle: .degrees(-30), endAngle: .degrees(30), clockwise: false)
                }
                .stroke(Color.white, lineWidth: 2)
                .frame(width: 120, height: 120)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 8)

            // Mock Color Range List
            VStack(spacing: 1) {
                colorRangeRow(name: "Selected Range", color: .red, isActive: true)
            }
            .background(Color.black.opacity(0.2))
            .cornerRadius(4)
            
            HStack {
                Toggle("View selected color range", isOn: .constant(false))
                    .font(.system(size: 10))
                    .toggleStyle(CheckboxToggleStyle())
                
                Spacer()
                
                Button(action: { /* Invert logic */ }) {
                    Image(systemName: "arrow.left.and.right.righttriangle.left.righttriangle.right")
                        .font(.system(size: 10))
                }
                .buttonStyle(.bordered)
                .help("Invert Selection")
            }
            
            VStack(spacing: 6) {
                colorSlider(label: "Hue", value: .constant(5.0), range: -30...30)
                colorSlider(label: "Saturation", value: .constant(12.0), range: -100...100)
                colorSlider(label: "Lightness", value: .constant(-3.0), range: -100...100)
                colorSlider(label: "Smoothness", value: .constant(20.0), range: 0...100)
            }
            
            Button("Invert Slice") { }
                .font(.system(size: 10))
                .buttonStyle(.bordered)
                .controlSize(.small)
        }
    }
    
    private var skinToneModeView: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(spacing: 6) {
                Text("Adjust")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                colorSlider(label: "Hue", value: .constant(0), range: -10...10)
                colorSlider(label: "Saturation", value: .constant(0), range: -50...50)
                colorSlider(label: "Lightness", value: .constant(0), range: -50...50)
            }
            
            Divider().background(Color.white.opacity(0.05))
            
            VStack(spacing: 6) {
                Text("Uniformity")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                colorSlider(label: "Hue", value: Binding(get: { Double(controller.skinHueUniformity) }, set: { controller.skinHueUniformity = Float($0) }), range: 0...100)
                colorSlider(label: "Saturation", value: Binding(get: { Double(controller.skinSatUniformity) }, set: { controller.skinSatUniformity = Float($0) }), range: 0...100)
                colorSlider(label: "Lightness", value: Binding(get: { Double(controller.skinLumaUniformity) }, set: { controller.skinLumaUniformity = Float($0) }), range: 0...100)
            }
            
            Divider().background(Color.white.opacity(0.05))
            
            VStack(spacing: 6) {
                Text("Amount")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                colorSlider(label: "Hue", value: .constant(0), range: -30...30)
                colorSlider(label: "Saturation", value: .constant(0), range: -100...100)
                colorSlider(label: "Lightness", value: .constant(0), range: -100...100)
            }
        }
    }
    
    // MARK: - Components
    
    private func colorSlider(label: String, value: Binding<Double>, range: ClosedRange<Double>) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                .frame(width: 65, alignment: .leading)
            Slider(value: value, in: range)
                .accentColor(CaptureOneTheme.Colors.activeHighlight)
            Text("\(Int(value.wrappedValue))")
                .font(.system(size: 10, design: .monospaced))
                .frame(width: 30, alignment: .trailing)
        }
    }
    
    private func colorRangeRow(name: String, color: Color, isActive: Bool) -> some View {
        HStack {
            Circle().fill(color).frame(width: 8, height: 8)
            Text(name).font(.system(size: 11))
            Spacer()
            if isActive {
                Image(systemName: "checkmark").font(.system(size: 8))
            }
        }
        .padding(.horizontal, 8)
        .frame(height: 24)
        .background(isActive ? CaptureOneTheme.Colors.activeHighlight.opacity(0.1) : Color.clear)
    }
}
