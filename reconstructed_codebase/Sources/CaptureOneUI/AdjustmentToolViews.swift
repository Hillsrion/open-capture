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
        COToolSection("Exposure") {
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
        COToolSection("White Balance") {
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
        COToolSection("High Dynamic Range") {
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

/// Reconstructed high-fidelity Styles & Presets tool (UI-010).
public struct StyleInspectorTool: View {
    @ObservedObject var controller: AdjustmentToolController
    @ObservedObject var styleManager = StyleManager.shared
    
    public var body: some View {
        VStack(spacing: 0) {
            COToolSection("Styles & Presets") {
                List(styleManager.getStyleTree(), children: \.children) { item in
                    HStack {
                        Image(systemName: item.isFolder ? "folder.fill" : "slider.horizontal.3")
                            .font(.system(size: 10))
                            .foregroundColor(item.isFolder ? .gray : CaptureOneTheme.Colors.activeHighlight)
                        
                        Text(item.name)
                            .font(.system(size: 11))
                        
                        Spacer()
                    }
                    .padding(.vertical, 2)
                    .contentShape(Rectangle())
                    .onHover { isHovering in
                        if !item.isFolder, let style = item.style {
                            controller.temporarilyApplyStyle(isHovering ? style : nil)
                        }
                    }
                    .onTapGesture {
                        if !item.isFolder, let style = item.style {
                            // Task: Implement permanent applyStyle in Phase 3
                            print("[UI] Style clicked: \(style.name)")
                        }
                    }
                }
                .listStyle(SidebarListStyle())
                .frame(minHeight: 300)
            }
        }
    }
}

/// Reconstructed high-fidelity Histogram tool.
public struct HistogramToolView: View {
    public init() {}
    
    public var body: some View {
        COToolSection("Histogram") {
            VStack(spacing: 4) {
                // Exposure info header
                HStack {
                    Text("ISO 400").font(.system(size: 9))
                    Spacer()
                    Text("f/2.8").font(.system(size: 9))
                    Spacer()
                    Text("1/125").font(.system(size: 9))
                }
                .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                
                // Histogram visualization
                ZStack {
                    CaptureOneTheme.Colors.histogramBackground
                    
                    // Faked Histogram Curves (Style match)
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 80))
                        path.addCurve(to: CGPoint(x: 250, y: 80), control1: CGPoint(x: 50, y: 20), control2: CGPoint(x: 150, y: 100))
                    }
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 80))
                        path.addCurve(to: CGPoint(x: 250, y: 80), control1: CGPoint(x: 100, y: 10), control2: CGPoint(x: 200, y: 90))
                    }
                    .stroke(CaptureOneTheme.Colors.activeHighlight.opacity(0.7), lineWidth: 1)
                }
                .frame(height: 80)
                .cornerRadius(2)
            }
        }
    }
}
