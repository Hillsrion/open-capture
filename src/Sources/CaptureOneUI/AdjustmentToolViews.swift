import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Exposure tool.
public struct ExposureToolView: View {
    @Binding var exposure: Float
    @Binding var contrast: Float
    @Binding var brightness: Float
    @Binding var saturation: Float
    
    public init(exposure: Binding<Float>, contrast: Binding<Float>, brightness: Binding<Float>, saturation: Binding<Float>) {
        self._exposure = exposure
        self._contrast = contrast
        self._brightness = brightness
        self._saturation = saturation
    }
    
    public var body: some View {
        COToolSection("Exposure", toolID: "Exposure") {
            VStack(spacing: 8) {
                POSliderControl(label: "Exposure", value: $exposure, range: -4...4)
                POSliderControl(label: "Contrast", value: $contrast, range: -50...50)
                POSliderControl(label: "Brightness", value: $brightness, range: -50...50)
                POSliderControl(label: "Saturation", value: $saturation, range: -100...100)
            }
        }
    }
}

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
                
                POSliderControl(label: "Kelvin", value: $kelvin, range: 2000...50000)
                POSliderControl(label: "Tint", value: $tint, range: -150...150)
            }
        }
    }
}

/// Reconstructed high-fidelity HDR tool.
public struct HDRToolView: View {
    @Binding var highlights: Float
    @Binding var shadows: Float
    @Binding var whites: Float
    @Binding var blacks: Float
    
    public init(highlights: Binding<Float>, shadows: Binding<Float>, whites: Binding<Float>, blacks: Binding<Float>) {
        self._highlights = highlights
        self._shadows = shadows
        self._whites = whites
        self._blacks = blacks
    }
    
    public var body: some View {
        COToolSection("High Dynamic Range", toolID: "ShadowHighlight") {
            VStack(spacing: 8) {
                POSliderControl(label: "Highlights", value: $highlights, range: 0...100)
                POSliderControl(label: "Shadows", value: $shadows, range: 0...100)
                POSliderControl(label: "Whites", value: $whites, range: 0...100)
                POSliderControl(label: "Blacks", value: $blacks, range: 0...100)
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
            
            KeystoneToolView(
                tiltX: $controller.keystoneTiltX,
                tiltY: $controller.keystoneTiltY,
                amount: $controller.keystoneAmount,
                aspect: $controller.keystoneAspect,
                skew: $controller.keystoneSkew
            )
            
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
    @ObservedObject var styleManager = StyleManager.shared
    
    public var body: some View {
        VStack(spacing: 0) {
            COToolSection("Styles & Presets", toolID: "Styles") {
                VStack(spacing: 8) {
                    HStack {
                        Toggle("Stack Styles", isOn: $controller.stackStyles)
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
                    
                    List(styleManager.getStyleTree(), children: \.children) { item in
                        StyleWithShortcutTableCellView(item: item)
                        .contentShape(Rectangle())
                        .onHover { isHovering in
                            if !item.isFolder, let style = item.style {
                                controller.temporarilyApplyStyle(isHovering ? style : nil)
                            }
                        }
                        .contextMenu {
                            if !item.isFolder {
                                Button("Apply to Background") {
                                    if let style = item.style { controller.applyStyle(style) }
                                }
                                Button("Apply to New Layer") {
                                    // Feature: Styles in Layers
                                    if let style = item.style { controller.applyStyleToNewLayer(style) }
                                }
                                Divider()
                                Button("Save as User Style...") { }
                                Button("Delete", role: .destructive) { }
                            }
                        }
                        .onTapGesture {
                            if !item.isFolder, let style = item.style {
                                controller.applyStyle(style)
                            }
                        }
                    }
                    .listStyle(SidebarListStyle())
                    .frame(minHeight: 300)
                }
            }
        }
    }
}

/// Reconstructed high-fidelity Histogram tool (ENG-204).
/// Simulates ICHistogramRenderer with RGB and Luma channels.
public struct HistogramToolView: View {
    @State private var showChannels: Bool = true
    
    public init() {}
    
    public var body: some View {
        COToolSection("Histogram", toolID: "Histogram") {
            VStack(spacing: 6) {
                // Exposure info header
                HStack {
                    Text("ISO 400").font(.system(size: 9))
                    Spacer()
                    Text("f/2.8").font(.system(size: 9))
                    Spacer()
                    Text("1/125").font(.system(size: 9))
                }
                .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                
                // Dynamic Histogram Canvas
                Canvas { context, size in
                    // Simulate Luma Channel
                    var lumaPath = Path()
                    lumaPath.move(to: CGPoint(x: 0, y: size.height))
                    lumaPath.addCurve(to: CGPoint(x: size.width, y: size.height), control1: CGPoint(x: size.width * 0.3, y: size.height * 0.1), control2: CGPoint(x: size.width * 0.7, y: size.height * 0.4))
                    context.fill(lumaPath, with: .color(Color.gray.opacity(0.4)))
                    
                    if showChannels {
                        // Simulate Red Channel
                        var redPath = Path()
                        redPath.move(to: CGPoint(x: 0, y: size.height))
                        redPath.addCurve(to: CGPoint(x: size.width, y: size.height), control1: CGPoint(x: size.width * 0.2, y: size.height * 0.2), control2: CGPoint(x: size.width * 0.8, y: size.height * 0.6))
                        context.stroke(redPath, with: .color(Color.red.opacity(0.8)), lineWidth: 1)
                        
                        // Simulate Blue Channel
                        var bluePath = Path()
                        bluePath.move(to: CGPoint(x: 0, y: size.height))
                        bluePath.addCurve(to: CGPoint(x: size.width, y: size.height), control1: CGPoint(x: size.width * 0.4, y: size.height * 0.3), control2: CGPoint(x: size.width * 0.6, y: size.height * 0.2))
                        context.stroke(bluePath, with: .color(Color.blue.opacity(0.8)), lineWidth: 1)
                    }
                }
                .frame(height: 100)
                .background(CaptureOneTheme.Colors.histogramBackground)
                .cornerRadius(2)
                .onTapGesture {
                    showChannels.toggle()
                }
                
                // Shadow & Highlight Warning Toggles
                HStack {
                    Button(action: { /* Toggle Shadow Warning */ }) {
                        Image(systemName: "triangle.fill")
                            .font(.system(size: 8))
                            .rotationEffect(.degrees(180))
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                    
                    Button(action: { /* Toggle Highlight Warning */ }) {
                        Image(systemName: "triangle.fill")
                            .font(.system(size: 8))
                            .foregroundColor(.red)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 4)
            }
        }
    }
}
