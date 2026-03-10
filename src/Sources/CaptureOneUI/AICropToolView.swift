import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity AI Crop tool (UI-204).
/// Features mode selection, constraint visualization, and Studio-level margin controls.
public struct AICropToolView: View {
    @ObservedObject var controller: AdjustmentToolController
    @State private var isMarginsExpanded: Bool = false
    
    public init(controller: AdjustmentToolController) {
        self.controller = controller
    }
    
    public var body: some View {
        COToolSection("AI Crop", toolID: "AICrop") {
            VStack(alignment: .leading, spacing: 12) {
                // Mode Selection
                VStack(alignment: .leading, spacing: 4) {
                    Text("Mode")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    
                    Picker("", selection: $controller.focusAIMode) {
                        Text("Auto").tag(0)
                        Text("Subject").tag(1)
                        Text("Face").tag(2)
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                }
                
                // Studio Controls: Reference Point & Aspect
                HStack(spacing: 8) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Reference Point")
                            .font(.system(size: 10))
                            .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                        Picker("", selection: .constant(0)) {
                            Text("Center").tag(0)
                            Text("Top").tag(1)
                            Text("Eyes").tag(2)
                        }
                        .pickerStyle(.menu)
                        .labelsHidden()
                        .frame(height: 22)
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(4)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Aspect")
                            .font(.system(size: 10))
                            .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                        Toggle("Lock", isOn: .constant(true))
                            .font(.system(size: 10))
                            .toggleStyle(.button)
                            .frame(height: 22)
                    }
                }
                
                Divider().background(Color.white.opacity(0.05))
                
                // Action Buttons
                HStack(spacing: 8) {
                    Button(action: { /* Set Reference Logic */ }) {
                        VStack(spacing: 2) {
                            Image(systemName: "pin.fill")
                                .font(.system(size: 14))
                            Text("Set Reference")
                                .font(.system(size: 9))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(4)
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: { /* Apply AI Crop Logic */ }) {
                        VStack(spacing: 2) {
                            Image(systemName: "magicmouse.fill")
                                .font(.system(size: 14))
                            Text("Apply")
                                .font(.system(size: 9))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(CaptureOneTheme.Colors.activeHighlight)
                        .foregroundColor(.black)
                        .cornerRadius(4)
                    }
                    .buttonStyle(.plain)
                }
                
                // Margins Section (Studio)
                VStack(spacing: 4) {
                    Button(action: { withAnimation { isMarginsExpanded.toggle() } }) {
                        HStack {
                            Image(systemName: isMarginsExpanded ? "chevron.down" : "chevron.right")
                                .font(.system(size: 8, weight: .bold))
                            Text("Margins")
                                .font(.system(size: 11, weight: .semibold))
                            Spacer()
                        }
                    }
                    .buttonStyle(.plain)
                    
                    if isMarginsExpanded {
                        VStack(spacing: 8) {
                            marginSlider(label: "Top", value: .constant(10), range: 0...100)
                            marginSlider(label: "Bottom", value: .constant(10), range: 0...100)
                            marginSlider(label: "Left", value: .constant(10), range: 0...100)
                            marginSlider(label: "Right", value: .constant(10), range: 0...100)
                        }
                        .padding(.leading, 12)
                        .padding(.top, 4)
                    }
                }
                
                HStack {
                    Image(systemName: "info.circle")
                        .font(.system(size: 10))
                    Text("Teal lines indicate AI alignment constraints.")
                        .font(.system(size: 9))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                }
                .padding(.top, 4)
            }
            .padding(.vertical, 4)
        }
    }
    
    private func marginSlider(label: String, value: Binding<Double>, range: ClosedRange<Double>) -> some View {
        HStack {
            Text(label).font(.system(size: 10)).foregroundColor(.gray).frame(width: 45, alignment: .leading)
            Slider(value: value, in: range)
                .accentColor(CaptureOneTheme.Colors.activeHighlight)
            Text("\(Int(value.wrappedValue))%").font(.system(size: 10, design: .monospaced)).frame(width: 30, alignment: .trailing)
        }
    }
}
