import SwiftUI
import AppCoreShared
import DataCore

// MARK: - Exposure (UI-202)
public struct ExposureToolView: View {
    @ObservedObject var controller: AdjustmentToolController
    
    public init(controller: AdjustmentToolController) {
        self.controller = controller
    }
    
    public var body: some View {
        COToolSection("Exposure", toolID: "Exposure") {
            VStack(spacing: 8) {
                exposureSlider(label: "Exposure", value: $controller.exposure, range: -4.0...4.0, step: 0.01)
                exposureSlider(label: "Contrast", value: $controller.contrast, range: -50...50)
                exposureSlider(label: "Brightness", value: $controller.brightness, range: -50...50)
                exposureSlider(label: "Saturation", value: $controller.saturation, range: -100...100)
            }
            .padding(.vertical, 4)
        }
    }
    
    private func exposureSlider(label: String, value: Binding<Float>, range: ClosedRange<Float>, step: Float = 1.0) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                .frame(width: 60, alignment: .leading)
            
            Slider(value: value, in: range, step: step)
                .accentColor(CaptureOneTheme.Colors.activeHighlight)
            
            Text(String(format: step < 1.0 ? "%.2f" : "%.0f", value.wrappedValue))
                .font(.system(size: 11, design: .monospaced))
                .frame(width: 35, alignment: .trailing)
        }
    }
}

// MARK: - High Dynamic Range (UI-202)
public struct HDRToolView: View {
    @ObservedObject var controller: AdjustmentToolController
    
    public init(controller: AdjustmentToolController) {
        self.controller = controller
    }
    
    public var body: some View {
        COToolSection("High Dynamic Range", toolID: "HDR") {
            VStack(spacing: 8) {
                hdrSlider(label: "Highlights", value: $controller.highlights)
                hdrSlider(label: "Shadows", value: $controller.shadows)
                hdrSlider(label: "Whites", value: $controller.whites)
                hdrSlider(label: "Blacks", value: $controller.blacks)
            }
            .padding(.vertical, 4)
        }
    }
    
    private func hdrSlider(label: String, value: Binding<Float>) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                .frame(width: 60, alignment: .leading)
            
            Slider(value: value, in: -100...100)
                .accentColor(CaptureOneTheme.Colors.activeHighlight)
            
            Text(String(format: "%.0f", value.wrappedValue))
                .font(.system(size: 11, design: .monospaced))
                .frame(width: 30, alignment: .trailing)
        }
    }
}

// MARK: - Levels (UI-202)
public struct LevelsToolView: View {
    @ObservedObject var controller: AdjustmentToolController
    
    public init(controller: AdjustmentToolController) {
        self.controller = controller
    }
    
    public var body: some View {
        COToolSection("Levels", toolID: "Levels") {
            VStack(spacing: 10) {
                // Simplified Levels UI
                Rectangle()
                    .fill(Color.black.opacity(0.3))
                    .frame(height: 80)
                    .overlay(
                        Text("Histogram & Levels Handles")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                    )
                
                HStack {
                    Button("Auto") { controller.autoLevels() }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                    Spacer()
                }
            }
            .padding(.vertical, 4)
        }
    }
}

// MARK: - Dehaze (UI-202)
public struct DehazeToolView: View {
    @ObservedObject var controller: AdjustmentToolController
    @ObservedObject var commands = AppCommandCenter.shared
    
    public init(controller: AdjustmentToolController) {
        self.controller = controller
    }
    
    public var body: some View {
        COToolSection("Dehaze", toolID: "Dehaze") {
            VStack(spacing: 8) {
                HStack {
                    Text("Amount")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                        .frame(width: 60, alignment: .leading)
                    Slider(value: $controller.dehazeAmount, in: -100...100)
                        .accentColor(CaptureOneTheme.Colors.activeHighlight)
                    Text("\(Int(controller.dehazeAmount))")
                        .font(.system(size: 11, design: .monospaced))
                        .frame(width: 30, alignment: .trailing)
                }
                
                HStack {
                    Text("Shadow Tone")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    
                    Spacer()
                    
                    // Shadow Tone Color Patch
                    RoundedRectangle(cornerRadius: 2)
                        .fill(controller.dehazeColor)
                        .frame(width: 24, height: 14)
                        .overlay(RoundedRectangle(cornerRadius: 2).stroke(Color.white.opacity(0.2), lineWidth: 0.5))
                    
                    // Pick Shadow Tone (Eyedropper)
                    Button(action: {
                        commands.selectedCursorToolID = commands.selectedCursorToolID == "DehazePicker" ? "Select" : "DehazePicker"
                    }) {
                        Image(systemName: "eyedropper.halffull")
                            .font(.system(size: 12))
                            .foregroundColor(commands.selectedCursorToolID == "DehazePicker" ? CaptureOneTheme.Colors.activeHighlight : .white)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 4)
        }
    }
}
