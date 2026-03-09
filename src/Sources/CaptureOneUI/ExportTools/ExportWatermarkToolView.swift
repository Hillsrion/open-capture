import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Export Watermark tool (TD-601).
public struct ExportWatermarkToolView: View {
    @State private var kind: Int = 0 // 0: None, 1: Text, 2: Image
    @State private var text: String = ""
    @State private var opacity: Double = 100.0
    @State private var scale: Double = 10.0
    
    public init() {}
    
    public var body: some View {
        COToolSection("Watermark", toolID: "Watermark") {
            VStack(alignment: .leading, spacing: 10) {
                Picker("", selection: $kind) {
                    Text("None").tag(0)
                    Text("Text").tag(1)
                    Text("Image").tag(2)
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                
                if kind == 1 {
                    TextField("Enter watermark text...", text: $text)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.system(size: 11))
                }
                
                if kind != 0 {
                    VStack(spacing: 8) {
                        watermarkSlider(label: "Opacity", value: $opacity, range: 0...100)
                        watermarkSlider(label: "Scale", value: $scale, range: 1...100)
                    }
                    .padding(.top, 4)
                }
            }
            .padding(.vertical, 4)
        }
    }
    
    private func watermarkSlider(label: String, value: Binding<Double>, range: ClosedRange<Double>) -> some View {
        HStack {
            Text(label).font(.system(size: 11)).foregroundColor(.gray).frame(width: 50, alignment: .leading)
            Slider(value: value, in: range).accentColor(CaptureOneTheme.Colors.activeHighlight)
            Text("\(Int(value.wrappedValue))").font(.system(size: 10, design: .monospaced)).frame(width: 25, alignment: .trailing)
        }
    }
}
