import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Export Watermark tool (ENG-204).
/// Supports text (with tokens), images, and overlay inclusion.
public struct ExportWatermarkToolView: View {
    @State private var kind: Int = 0 // 0: None, 1: Text, 2: Image
    @State private var text: String = "© [Date] [Image Name]"
    @State private var opacity: Double = 100.0
    @State private var scale: Double = 10.0
    @State private var includeOverlay: Bool = false
    @State private var imagePath: String = "No image selected"
    
    // Parses the text to identify tokens (pill UI simulation)
    private var parsedTokens: [CaptureNamingToken] {
        CaptureNamingFormatter.parse(formatString: text)
    }
    
    public init() {}
    
    public var body: some View {
        COToolSection("Watermark", toolID: "Watermark") {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Kind")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    Spacer()
                    Picker("", selection: $kind) {
                        Text("None").tag(0)
                        Text("Text").tag(1)
                        Text("Image").tag(2)
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .frame(width: 120)
                }
                
                if kind == 1 { // Text
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Text")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                        
                        HStack {
                            TextField("", text: $text)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .font(.system(size: 11))
                            
                            Button(action: { /* Open Token picker */ }) {
                                Image(systemName: "ellipsis")
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                        }
                        
                        // Sample Preview
                        HStack {
                            Text("Preview:")
                                .font(.system(size: 10))
                                .foregroundColor(.gray)
                            Text(CaptureNamingFormatter.format(tokens: parsedTokens, cameraName: "Studio", counter: 1))
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                                .lineLimit(1)
                        }
                    }
                } else if kind == 2 { // Image
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Image")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                        
                        HStack {
                            Text(imagePath)
                                .font(.system(size: 11))
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .truncationMode(.middle)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 4)
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(4)
                            
                            Button(action: { /* File open dialog */ }) {
                                Image(systemName: "folder")
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                        }
                    }
                }
                
                if kind != 0 {
                    VStack(spacing: 8) {
                        watermarkSlider(label: "Opacity", value: $opacity, range: 0...100)
                        watermarkSlider(label: "Scale", value: $scale, range: 1...100)
                    }
                    .padding(.top, 4)
                }
                
                Divider().background(Color.white.opacity(0.1))
                
                Toggle("Include Overlay", isOn: $includeOverlay)
                    .toggleStyle(POCheckboxStyle())
                    .font(.system(size: 11))
            }
            .padding(.vertical, 4)
        }
    }
    
    private func watermarkSlider(label: String, value: Binding<Double>, range: ClosedRange<Double>) -> some View {
        HStack {
            Text(label).font(.system(size: 11)).foregroundColor(.gray).frame(width: 50, alignment: .leading)
            Slider(value: value, in: range).accentColor(CaptureOneTheme.Colors.activeHighlight)
            Text("\(Int(value.wrappedValue))").font(.system(size: 10, design: .monospaced)).frame(width: 30, alignment: .trailing)
        }
    }
}
