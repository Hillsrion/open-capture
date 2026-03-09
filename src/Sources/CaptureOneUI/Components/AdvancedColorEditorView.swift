import SwiftUI
import ImageCore

public struct AdvancedColorEditorView: View {
    @ObservedObject var controller: AdjustmentToolController
    
    public init(controller: AdjustmentToolController) {
        self.controller = controller
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Advanced Color Editor")
                .font(.headline)
                .padding(.bottom, 4)
            
            if controller.colorCorrections.isEmpty {
                Text("No color corrections.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                ForEach(0..<controller.colorCorrections.count, id: \.self) { index in
                    colorCorrectionEditor(for: index)
                }
            }
            
            Button(action: {
                if controller.colorCorrections.count < 35 {
                    var newCorrection = IC_ColorCorrection()
                    newCorrection.smoothness = 10.0
                    controller.colorCorrections.append(newCorrection)
                }
            }) {
                Label("Add Color Correction", systemImage: "plus")
            }
            .buttonStyle(BorderedButtonStyle())
            .disabled(controller.colorCorrections.count >= 35)
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
    }
    
    @ViewBuilder
    private func colorCorrectionEditor(for index: Int) -> some View {
        let binding = Binding<IC_ColorCorrection>(
            get: {
                if index < self.controller.colorCorrections.count {
                    return self.controller.colorCorrections[index]
                }
                return IC_ColorCorrection()
            },
            set: { newValue in
                if index < self.controller.colorCorrections.count {
                    self.controller.colorCorrections[index] = newValue
                }
            }
        )
        
        VStack(spacing: 8) {
            HStack {
                Text("Correction \(index + 1)")
                    .font(.subheadline)
                    .bold()
                Spacer()
                Button(action: {
                    self.controller.colorCorrections.remove(at: index)
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Hue Rotation Slider
            HStack {
                Text("Hue")
                    .frame(width: 80, alignment: .leading)
                Slider(value: binding.hueRotation, in: -180...180)
                Text(String(format: "%.1f", binding.wrappedValue.hueRotation))
                    .frame(width: 40, alignment: .trailing)
            }
            
            // Saturation Change Slider
            HStack {
                Text("Saturation")
                    .frame(width: 80, alignment: .leading)
                Slider(value: binding.saturationChange, in: -100...100)
                Text(String(format: "%.1f", binding.wrappedValue.saturationChange))
                    .frame(width: 40, alignment: .trailing)
            }
            
            // Lightness Change Slider
            HStack {
                Text("Lightness")
                    .frame(width: 80, alignment: .leading)
                Slider(value: binding.lightnessChange, in: -100...100)
                Text(String(format: "%.1f", binding.wrappedValue.lightnessChange))
                    .frame(width: 40, alignment: .trailing)
            }
            
            // Smoothness Slider
            HStack {
                Text("Smoothness")
                    .frame(width: 80, alignment: .leading)
                Slider(value: binding.smoothness, in: 0...30)
                Text(String(format: "%.1f", binding.wrappedValue.smoothness))
                    .frame(width: 40, alignment: .trailing)
            }
            
            Divider()
        }
    }
}
