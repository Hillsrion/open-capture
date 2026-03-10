import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Annotations tool (UI-204).
/// Based on disassembly of AnnotationsInspectorTool.
public struct AnnotationsInspectorTool: View {
    @ObservedObject var variant: VariantBase
    @State private var includeInExport: Bool = true
    @State private var alwaysShow: Bool = false
    @State private var brushSize: Double = 10.0
    @State private var selectedColorIndex: Int = 0
    @State private var activeToolMode: Int = 0 // 0: Pen, 1: Eraser
    
    let colors: [Color] = [.red, .yellow, .green, .blue, .purple, .white, .black]
    
    public init(variant: VariantBase) {
        self.variant = variant
    }
    
    public var body: some View {
        COToolSection("Annotations", toolID: "Annotations") {
            VStack(spacing: 12) {
                // Tool Selection
                Picker("", selection: $activeToolMode) {
                    Image(systemName: "pencil").tag(0)
                    Image(systemName: "eraser").tag(1)
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                
                // Color Picker
                HStack(spacing: 8) {
                    Text("Color")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                        .frame(width: 45, alignment: .leading)
                    
                    ForEach(0..<colors.count, id: \.self) { index in
                        Circle()
                            .fill(colors[index])
                            .frame(width: 14, height: 14)
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: selectedColorIndex == index ? 1.5 : 0)
                            )
                            .onTapGesture { selectedColorIndex = index }
                    }
                    Spacer()
                }
                
                // Brush Size
                HStack {
                    Text("Size")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                        .frame(width: 45, alignment: .leading)
                    Slider(value: $brushSize, in: 1...100)
                        .accentColor(CaptureOneTheme.Colors.activeHighlight)
                    Text("\(Int(brushSize))")
                        .font(.system(size: 10, design: .monospaced))
                        .frame(width: 30, alignment: .trailing)
                }
                
                Divider().background(Color.white.opacity(0.1))
                
                Toggle("Always Show Annotations", isOn: $alwaysShow)
                    .toggleStyle(POCheckboxStyle())
                    .font(.system(size: 11))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Toggle("Include Annotations in Export", isOn: $includeInExport)
                    .toggleStyle(POCheckboxStyle())
                    .font(.system(size: 11))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider().background(Color.white.opacity(0.1))
                
                Button(action: {
                    variant.annotations.lines = []
                    variant.annotations.notes = []
                    variant.isModified = true
                }) {
                    Text("Clear Annotations")
                        .font(.system(size: 11, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                        .background(Color.red.opacity(0.2))
                        .foregroundColor(.red)
                        .cornerRadius(4)
                }
                .buttonStyle(.plain)
            }
            .padding(.vertical, 4)
        }
    }
}
