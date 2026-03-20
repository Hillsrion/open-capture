import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Luma Range tool (UI-204).
/// Provides luminosity-based masking with falloff, radius, and sensitivity control.
public struct LumaRangeToolView: View {
    @ObservedObject var controller: COLumaRangeViewController
    
    public init(adjustmentController: AdjustmentToolController) {
        self.controller = COLumaRangeViewController(adjustmentController: adjustmentController)
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Luma Range")
                .font(.headline)
            
            // Luma Curve / Histogram Display (Simulated)
            VStack(alignment: .leading, spacing: 8) {
                Text("Select the tonal range to include in the mask.")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                
                ZStack(alignment: .bottom) {
                    // Histogram / Curve Background
                    LumaRangeBackgroundView()
                        .frame(height: 80)
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(4)
                    
                    // Interactive Range Bar (4 handles)
                    LumaRangeSlider(
                        rangeMin: $controller.rangeMin,
                        rangeMax: $controller.rangeMax,
                        falloffMin: $controller.falloffMin,
                        falloffMax: $controller.falloffMax
                    )
                    .frame(height: 30)
                    .offset(y: 10)
                }
                .padding(.bottom, 12)
            }
            
            VStack(spacing: 10) {
                lumaSlider(label: "Radius", value: $controller.radius, range: 0...50)
                lumaSlider(label: "Sensitivity", value: $controller.sensitivity, range: 0...100)
            }
            
            Divider().background(Color.white.opacity(0.1))
            
            HStack {
                Toggle("Display Mask", isOn: $controller.isDisplayingMask)
                    .font(.system(size: 11))
                    .toggleStyle(CheckboxToggleStyle())
                
                Spacer()
                
                Button("Invert") {
                    let oldMin = controller.rangeMin
                    let oldMax = controller.rangeMax
                    controller.rangeMin = 255 - oldMax
                    controller.rangeMax = 255 - oldMin
                }
                .font(.system(size: 10))
                .buttonStyle(.bordered)
            }
            
            HStack {
                Button("Cancel") {
                    // Dismiss logic - in a real app would be handled by popover binding
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.1))
                .cornerRadius(4)
                
                Spacer()
                
                Button("Apply") {
                    controller.apply()
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(CaptureOneTheme.Colors.activeHighlight)
                .foregroundColor(.black)
                .cornerRadius(4)
            }
        }
        .padding(16)
        .frame(width: 320)
        .background(CaptureOneTheme.Colors.panelBackground)
    }
    
    private func lumaSlider(label: String, value: Binding<Double>, range: ClosedRange<Double>) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                .frame(width: 70, alignment: .leading)
            Slider(value: value, in: range)
                .accentColor(CaptureOneTheme.Colors.activeHighlight)
            Text("\(Int(value.wrappedValue))")
                .font(.system(size: 10, design: .monospaced))
                .frame(width: 30, alignment: .trailing)
        }
    }
}

/// Simulated Histogram + Luma Curve for the background.
struct LumaRangeBackgroundView: View {
    var body: some View {
        GeometryReader { geo in
            Path { path in
                // Simulated Histogram
                for x in stride(from: 0, to: geo.size.width, by: 2) {
                    let h = Double.random(in: 10...geo.size.height * 0.8)
                    path.move(to: CGPoint(x: x, y: geo.size.height))
                    path.addLine(to: CGPoint(x: x, y: geo.size.height - CGFloat(h)))
                }
            }
            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            
            // Luma mapping gradient
            LinearGradient(gradient: Gradient(colors: [.black, .white]), startPoint: .leading, endPoint: .trailing)
                .frame(height: 4)
                .offset(y: geo.size.height - 4)
        }
    }
}

/// Custom 4-handle slider for Luma Range.
struct LumaRangeSlider: View {
    @Binding var rangeMin: Double
    @Binding var rangeMax: Double
    @Binding var falloffMin: Double
    @Binding var falloffMax: Double
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                // Active Range Overlay
                Rectangle()
                    .fill(CaptureOneTheme.Colors.activeHighlight.opacity(0.3))
                    .frame(width: CGFloat((rangeMax - rangeMin) / 255.0) * geo.size.width)
                    .offset(x: CGFloat(rangeMin / 255.0) * geo.size.width)
                
                // Falloff lines
                Path { path in
                    let fMinX = CGFloat(falloffMin / 255.0) * geo.size.width
                    let rMinX = CGFloat(rangeMin / 255.0) * geo.size.width
                    let rMaxX = CGFloat(rangeMax / 255.0) * geo.size.width
                    let fMaxX = CGFloat(falloffMax / 255.0) * geo.size.width
                    
                    path.move(to: CGPoint(x: fMinX, y: geo.size.height))
                    path.addLine(to: CGPoint(x: rMinX, y: 0))
                    
                    path.move(to: CGPoint(x: rMaxX, y: 0))
                    path.addLine(to: CGPoint(x: fMaxX, y: geo.size.height))
                }
                .stroke(CaptureOneTheme.Colors.activeHighlight, lineWidth: 1)
                
                // Handles
                HandleView(value: $falloffMin, color: .gray, geo: geo)
                HandleView(value: $rangeMin, color: .white, geo: geo)
                HandleView(value: $rangeMax, color: .white, geo: geo)
                HandleView(value: $falloffMax, color: .gray, geo: geo)
            }
        }
    }
    
    struct HandleView: View {
        @Binding var value: Double
        let color: Color
        let geo: GeometryProxy
        
        var body: some View {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
                .overlay(Circle().stroke(Color.black, lineWidth: 1))
                .offset(x: CGFloat(value / 255.0) * geo.size.width - 6, y: -6)
                .gesture(DragGesture().onChanged { val in
                    let newValue = Double(val.location.x / geo.size.width) * 255.0
                    self.value = max(0, min(255, newValue))
                })
        }
    }
}
