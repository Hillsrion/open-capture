import SwiftUI
import AppCoreShared
import ImageCore

/// Reconstructed `POLevelsControl` interactive histogram widget.
/// Manages Black Point, White Point, and Midtone (Gamma) adjustment via dragging.

public struct POLevelsControl: View {
    @Binding var blackPoint: Float
    @Binding var whitePoint: Float
    @Binding var midtone: Float
    @Binding var targetBlack: Float
    @Binding var targetWhite: Float
    @Binding var histogram: POHistogram
    
    // Add channel selector state (Binding to sync with Controller)
    @Binding var selectedChannel: Int // 0: RGB, 1: Red, 2: Green, 3: Blue
    
    public var isNegative: Bool
    
    public init(
        blackPoint: Binding<Float>,
        whitePoint: Binding<Float>,
        midtone: Binding<Float>,
        targetBlack: Binding<Float>,
        targetWhite: Binding<Float>,
        histogram: Binding<POHistogram>,
        selectedChannel: Binding<Int>,
        isNegative: Bool = false
    ) {
        self._blackPoint = blackPoint
        self._whitePoint = whitePoint
        self._midtone = midtone
        self._targetBlack = targetBlack
        self._targetWhite = targetWhite
        self._histogram = histogram
        self._selectedChannel = selectedChannel
        self.isNegative = isNegative
    }
    
    public var body: some View {
        COToolSection(isNegative ? "Levels (Post-Inversion)" : "Levels", toolID: "Levels") {
            VStack(spacing: 8) {
                // Channel Selector
                Picker("Channel", selection: $selectedChannel) {
                    Text("RGB").tag(0)
                    Text("Red").tag(1)
                    Text("Green").tag(2)
                    Text("Blue").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
                .labelsHidden()
                
                // Interactive Histogram and Output Bar
                HStack(spacing: 4) {
                    // Output bar (Vertical)
                    OutputBar(targetBlack: $targetBlack, targetWhite: $targetWhite)
                        .frame(width: 12, height: 120)

                    GeometryReader { geometry in
                        ZStack {
                            CaptureOneTheme.Colors.histogramBackground
                                .cornerRadius(4)
                            
                            // Real Histogram
                            HistogramView(histogram: histogram, channel: selectedChannel)
                                .opacity(0.4)
                            
                            // Input Handles (Black, Mid, White)
                            InputHandles(
                                blackPoint: $blackPoint,
                                whitePoint: $whitePoint,
                                midtone: $midtone,
                                geometry: geometry
                            )
                        }
                    }
                    .frame(height: 120)
                    .scaleEffect(x: isNegative ? -1 : 1, y: 1)
                }
                
                // Numerical Input (Numerical readouts)
                LevelsReadouts(
                    blackPoint: blackPoint,
                    whitePoint: whitePoint,
                    midtone: midtone,
                    isNegative: isNegative
                )
            }
        }
    }
}

private struct HistogramView: View {
    let histogram: POHistogram
    let channel: Int // 0: RGB/Luma, 1: Red, 2: Green, 3: Blue
    
    var body: some View {
        Canvas { context, size in
            let data: [Float]
            let color: Color
            
            switch channel {
            case 1: data = histogram.red; color = .red
            case 2: data = histogram.green; color = .green
            case 3: data = histogram.blue; color = .blue
            default: data = histogram.luminance; color = .gray
            }
            
            var path = Path()
            path.move(to: CGPoint(x: 0, y: size.height))
            
            for i in 0..<data.count {
                let x = CGFloat(i) / CGFloat(data.count - 1) * size.width
                let y = size.height - CGFloat(data[i]) * size.height
                path.addLine(to: CGPoint(x: x, y: y))
            }
            
            path.addLine(to: CGPoint(x: size.width, y: size.height))
            path.closeSubpath()
            
            context.fill(path, with: .color(color.opacity(0.6)))
        }
    }
}

private struct OutputBar: View {
    @Binding var targetBlack: Float
    @Binding var targetWhite: Float
    
    var body: some View {
        ZStack(alignment: .bottom) {
            LinearGradient(gradient: Gradient(colors: [.black, .white]), startPoint: .bottom, endPoint: .top)
                .cornerRadius(2)
                .background(Color.black.opacity(0.3))
            
            // Output Black Handle
            Handle(value: $targetBlack, isVertical: true, isTargetBlack: true, targetOther: targetWhite)
            
            // Output White Handle
            Handle(value: $targetWhite, isVertical: true, isTargetBlack: false, targetOther: targetBlack)
        }
    }
    
    struct Handle: View {
        @Binding var value: Float
        let isVertical: Bool
        let isTargetBlack: Bool
        let targetOther: Float
        
        var body: some View {
            Color.clear
                .overlay(
                    Rectangle().fill(Color.white).frame(height: 2)
                        .offset(y: isTargetBlack ? -6 : 6)
                )
                .position(x: 6, y: CGFloat(1.0 - value) * 120)
                .gesture(DragGesture().onChanged { val in
                    let newVal = Float(1.0 - (val.location.y / 120))
                    if isTargetBlack {
                        value = min(max(0.0, newVal), targetOther - 0.05)
                    } else {
                        value = max(min(1.0, newVal), targetOther + 0.05)
                    }
                })
        }
    }
}

private struct InputHandles: View {
    @Binding var blackPoint: Float
    @Binding var whitePoint: Float
    @Binding var midtone: Float
    let geometry: GeometryProxy
    
    var body: some View {
        ZStack {
            // Black point handle
            HandleTriangle(value: $blackPoint, range: 0...(whitePoint - 0.05), geometry: geometry, fill: true)
            
            // Midtone handle
            Circle()
                .fill(CaptureOneTheme.Colors.textSecondary)
                .frame(width: 8, height: 8)
                .position(x: CGFloat(midtonePosition()) * geometry.size.width, y: geometry.size.height - 5)
                .gesture(DragGesture().onChanged { value in
                    let newMidX = Float(value.location.x / geometry.size.width)
                    let normalizedPos = (newMidX - blackPoint) / max(0.001, whitePoint - blackPoint)
                    let clampedPos = min(max(0.1, normalizedPos), 0.9)
                    midtone = Float(pow(Double(clampedPos) / 0.5, -1.0))
                })
            
            // White point handle
            HandleTriangle(value: $whitePoint, range: (blackPoint + 0.05)...1.0, geometry: geometry, fill: false)
        }
    }
    
    private func midtonePosition() -> Float {
        let visualPos = Float(pow(0.5, Double(midtone)))
        return blackPoint + visualPos * (whitePoint - blackPoint)
    }
    
    struct HandleTriangle: View {
        @Binding var value: Float
        let range: ClosedRange<Float>
        let geometry: GeometryProxy
        let fill: Bool
        
        var body: some View {
            Image(systemName: fill ? "arrowtriangle.up.fill" : "arrowtriangle.up")
                .font(.system(size: 10))
                .foregroundColor(CaptureOneTheme.Colors.textPrimary)
                .position(x: CGFloat(value) * geometry.size.width, y: geometry.size.height - 5)
                .gesture(DragGesture().onChanged { val in
                    let newVal = Float(val.location.x / geometry.size.width)
                    value = min(max(range.lowerBound, newVal), range.upperBound)
                })
        }
    }
}

private struct LevelsReadouts: View {
    let blackPoint: Float
    let whitePoint: Float
    let midtone: Float
    let isNegative: Bool
    
    var body: some View {
        HStack {
            if isNegative {
                readout("\(Int(whitePoint * 255))")
                Spacer()
                readout(String(format: "%.2f", midtone))
                Spacer()
                readout("\(Int(blackPoint * 255))")
            } else {
                readout("\(Int(blackPoint * 255))")
                Spacer()
                readout(String(format: "%.2f", midtone))
                Spacer()
                readout("\(Int(whitePoint * 255))")
            }
        }
        .padding(.horizontal, 4)
    }
    
    func readout(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 10, design: .monospaced))
            .foregroundColor(.gray)
    }
}

