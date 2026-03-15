import SwiftUI
import AppCoreShared



/// Reconstructed high-fidelity White Balance tool.
public struct WhiteBalanceToolView: View {
    @Binding var kelvin: Float
    @Binding var tint: Float
    @State private var mode: String = "Shot"
    
    public init(kelvin: Binding<Float>, tint: Binding<Float>) {
        self._kelvin = kelvin
        self._tint = tint
    }
    
    public var body: some View {
        COToolSection("White Balance", toolID: "WhiteBalance") {
            VStack(spacing: 8) {
                // Mode Selector and Picker
                HStack {
                    Text("Mode").font(.system(size: 11))
                    Spacer()
                    
                    // Eyedropper icon (CursorToolControl)
                    Button(action: {}) {
                        Image(systemName: "eyedropper")
                            .font(.system(size: 10))
                            .padding(4)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(3)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Menu {
                        Button("Shot") { mode = "Shot" }
                        Button("Auto") { mode = "Auto" }
                        Button("Custom") { mode = "Custom" }
                    } label: {
                        HStack {
                            Text(mode).font(.system(size: 11)).foregroundColor(.white)
                            Image(systemName: "chevron.up.chevron.down").font(.system(size: 8))
                        }
                    }
                    .frame(width: 80)
                }
                
                COToolValueSlider(label: "Kelvin", value: $kelvin, range: 2000...50000, decimalPlaces: 0)
                COToolValueSlider(label: "Tint", value: $tint, range: -150...150, decimalPlaces: 1)
            }
        }
    }
}



/// The integrated Lens Correction and LCC tools in the sidebar.
public struct LensCorrectionInspectorTool: View {
    @ObservedObject var controller: AdjustmentToolController
    
    public var body: some View {
        VStack(spacing: 0) {
            LensCorrectionToolView(
                distortion: $controller.lensDistortion,
                sharpnessFalloff: $controller.lensSharpnessFalloff,
                lightFalloff: $controller.lensLightFalloff,
                shiftX: $controller.lensShiftX,
                shiftY: $controller.lensShiftY
            )
            
            KeystoneToolView()
            
            LCCToolView(isLCCActive: $controller.isLCCActive)
        }
    }
}

/// The integrated Details tools (Sharpening, NR).
public struct DetailInspectorTool: View {
    @ObservedObject var controller: AdjustmentToolController
    
    public var body: some View {
        VStack(spacing: 0) {
            SharpeningToolView(
                amount: $controller.sharpAmount,
                radius: $controller.sharpRadius,
                threshold: $controller.sharpThreshold,
                halo: $controller.sharpHalo
            )
            
            NoiseReductionToolView(
                luminance: $controller.nrLuminance,
                details: $controller.nrDetails,
                color: $controller.nrColor,
                singlePixel: $controller.nrSinglePixel
            )
        }
    }
}

/// Reconstructed high-fidelity Styles & Presets tool (UI-204).
/// Supports Styles in Layers, stacking, and .costylepack import.
public struct StyleInspectorTool: View {
    @ObservedObject var controller: AdjustmentToolController
    
    public var body: some View {
        VStack(spacing: 0) {
            COToolSection("Styles & Presets", toolID: "Styles") {
                VStack(spacing: 8) {
                    HStack {
                        Toggle("Stack Styles", isOn: $controller.stackCOStyles)
                            .toggleStyle(POCheckboxStyle())
                            .font(.system(size: 11))
                        Spacer()
                        
                        Button(action: {
                            // Import .costylepack logic
                        }) {
                            Image(systemName: "square.and.arrow.down")
                                .font(.system(size: 10))
                        }
                        .buttonStyle(.plain)
                        .help("Import Styles Pack...")
                    }
                    .padding(.bottom, 4)
                    
                    List(COStyleManager.shared.getStyleTree(), children: \.children) { item in
                        StyleWithShortcutTableCellView(item: item)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if !item.isFolder {
                                // Reconstructed: Apply style logic
                                print("[UI] Apply style requested: \(item.name)")
                            }
                        }
                    }
                    .listStyle(SidebarListStyle())
                    .frame(minHeight: 250)
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(4)

                    // Style Opacity (UI-204)
                    VStack(spacing: 4) {
                        HStack {
                            Text("Opacity")
                                .font(.system(size: 11))
                                .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                            Spacer()
                            Slider(value: $controller.styleOpacity, in: 0...100)
                                .accentColor(CaptureOneTheme.Colors.activeHighlight)
                                .frame(width: 120)
                            Text("\(Int(controller.styleOpacity))%")
                                .font(.system(size: 10, design: .monospaced))
                                .frame(width: 35, alignment: .trailing)
                        }
                    }
                    .padding(.top, 4)
                }
                .padding(.vertical, 4)
            }
        }
    }
}

/// Reconstructed high-fidelity Histogram tool (ENG-204).
/// Displays real-time POHistogram with channel overlays.
public struct HistogramToolView: View {
    @ObservedObject var controller = AdjustmentToolController.shared
    @ObservedObject var commands = AppCommandCenter.shared
    @State private var showChannels: Bool = true
    
    public init() {}
    
    public var body: some View {
        COToolSection("Histogram", toolID: "Histogram") {
            VStack(spacing: 6) {
                // Exposure info header (Mock metadata for now)
                HStack {
                    Text("ISO 400").font(.system(size: 9))
                    Spacer()
                    Text("f/2.8").font(.system(size: 9))
                    Spacer()
                    Text("1/125").font(.system(size: 9))
                }
                .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                
                // Dynamic Histogram Canvas
                ZStack {
                    CaptureOneTheme.Colors.histogramBackground
                        .cornerRadius(2)
                    
                    // Luma Channel (Gray)
                    HistogramPath(data: controller.currentHistogram.luminance)
                        .fill(Color.gray.opacity(0.4))
                    
                    if showChannels {
                        // RGB Overlays
                        HistogramPath(data: controller.currentHistogram.red)
                            .stroke(Color.red.opacity(0.6), lineWidth: 1)
                        HistogramPath(data: controller.currentHistogram.green)
                            .stroke(Color.green.opacity(0.6), lineWidth: 1)
                        HistogramPath(data: controller.currentHistogram.blue)
                            .stroke(Color.blue.opacity(0.6), lineWidth: 1)
                    }
                }
                .frame(height: 100)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showChannels.toggle()
                    }
                }
                
                // Shadow & Highlight Warning Toggles
                HStack {
                    Button(action: { commands.showExposureWarning.toggle() }) {
                        Image(systemName: "triangle.fill")
                            .font(.system(size: 8))
                            .rotationEffect(.degrees(180))
                            .foregroundColor(commands.showExposureWarning ? .blue : .gray)
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                    
                    Button(action: { commands.showExposureWarning.toggle() }) {
                        Image(systemName: "triangle.fill")
                            .font(.system(size: 8))
                            .foregroundColor(commands.showExposureWarning ? .red : .gray)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 4)
            }
        }
    }
}

private struct HistogramPath: Shape {
    let data: [Float]
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard !data.isEmpty else { return path }
        
        path.move(to: CGPoint(x: 0, y: rect.height))
        for i in 0..<data.count {
            let x = CGFloat(i) / CGFloat(data.count - 1) * rect.width
            let y = rect.height - CGFloat(data[i]) * rect.height
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        return path
    }
}
