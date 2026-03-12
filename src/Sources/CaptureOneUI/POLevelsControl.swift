import SwiftUI
import AppCoreShared

/// Reconstructed `POLevelsControl` interactive histogram widget.
/// Manages Black Point, White Point, and Midtone (Gamma) adjustment via dragging.

public struct POLevelsControl: View {
    @Binding var blackPoint: Float
    @Binding var whitePoint: Float
    @Binding var midtone: Float
    @Binding var targetBlack: Float
    @Binding var targetWhite: Float
    
    // Add channel selector state
    @State private var selectedChannel: Int = 0 // 0: RGB, 1: Red, 2: Green, 3: Blue
    
    public var isNegative: Bool
    
    public init(blackPoint: Binding<Float>, whitePoint: Binding<Float>, midtone: Binding<Float>, targetBlack: Binding<Float>, targetWhite: Binding<Float>, isNegative: Bool = false) {
        self._blackPoint = blackPoint
        self._whitePoint = whitePoint
        self._midtone = midtone
        self._targetBlack = targetBlack
        self._targetWhite = targetWhite
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
                    ZStack(alignment: .bottom) {
                        LinearGradient(gradient: Gradient(colors: [.black, .white]), startPoint: .bottom, endPoint: .top)
                            .frame(width: 12)
                            .cornerRadius(2)
                        
                        // Output Black Handle
                        Color.clear
                            .overlay(
                                Rectangle().fill(Color.white).frame(height: 2).offset(y: -6)
                            )
                            .position(x: 6, y: CGFloat(1.0 - targetBlack) * 120)
                            .gesture(DragGesture().onChanged { value in
                                let newVal = Float(1.0 - (value.location.y / 120))
                                targetBlack = min(max(0.0, newVal), targetWhite - 0.05)
                            })

                        // Output White Handle
                        Color.clear
                            .overlay(
                                Rectangle().fill(Color.white).frame(height: 2).offset(y: 6)
                            )
                            .position(x: 6, y: CGFloat(1.0 - targetWhite) * 120)
                            .gesture(DragGesture().onChanged { value in
                                let newVal = Float(1.0 - (value.location.y / 120))
                                targetWhite = max(min(1.0, newVal), targetBlack + 0.05)
                            })
                    }
                    .frame(width: 12, height: 120)
                    .background(Color.black.opacity(0.3))

                    GeometryReader { geometry in
                        ZStack {
                            CaptureOneTheme.Colors.histogramBackground
                                .cornerRadius(4)
                            
                            // Fake Histogram
                            Path { path in
                                path.move(to: CGPoint(x: 0, y: geometry.size.height))
                                path.addCurve(to: CGPoint(x: geometry.size.width, y: geometry.size.height), control1: CGPoint(x: geometry.size.width * 0.3, y: 0), control2: CGPoint(x: geometry.size.width * 0.7, y: geometry.size.height * 0.5))
                            }
                            .fill(Color.gray.opacity(0.3))
                            
                            // Input Handles (Black, Mid, White)
                            ZStack {
                                // Black point handle
                                Image(systemName: "arrowtriangle.up.fill")
                                    .font(.system(size: 10))
                                    .foregroundColor(CaptureOneTheme.Colors.textPrimary)
                                    .position(x: CGFloat(blackPoint) * geometry.size.width, y: geometry.size.height - 5)
                                    .gesture(DragGesture().onChanged { value in
                                        let newBP = Float(value.location.x / geometry.size.width)
                                        blackPoint = min(max(0.0, newBP), whitePoint - 0.05)
                                    })
                                
                                // Midtone handle
                                Image(systemName: "circle.fill")
                                    .font(.system(size: 8))
                                    .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                                    .position(x: CGFloat(midtonePosition()) * geometry.size.width, y: geometry.size.height - 5)
                                    .gesture(DragGesture().onChanged { value in
                                        let newMidX = Float(value.location.x / geometry.size.width)
                                        let normalizedPos = (newMidX - blackPoint) / max(0.001, whitePoint - blackPoint)
                                        let clampedPos = min(max(0.1, normalizedPos), 0.9)
                                        midtone = Float(pow(Double(clampedPos) / 0.5, -1.0))
                                    })
                                
                                // White point handle
                                Image(systemName: "arrowtriangle.up")
                                    .font(.system(size: 10))
                                    .foregroundColor(CaptureOneTheme.Colors.textPrimary)
                                    .position(x: CGFloat(whitePoint) * geometry.size.width, y: geometry.size.height - 5)
                                    .gesture(DragGesture().onChanged { value in
                                        let newWP = Float(value.location.x / geometry.size.width)
                                        whitePoint = max(min(1.0, newWP), blackPoint + 0.05)
                                    })
                            }
                        }
                    }
                    .frame(height: 120)
                    .scaleEffect(x: isNegative ? -1 : 1, y: 1)
                }
                
                // Numerical Input (Numerical readouts)
                HStack {
                    if isNegative {
                        Text("\(Int(whitePoint * 255))").font(.system(size: 10, design: .monospaced))
                        Spacer()
                        Text(String(format: "%.2f", midtone)).font(.system(size: 10, design: .monospaced))
                        Spacer()
                        Text("\(Int(blackPoint * 255))").font(.system(size: 10, design: .monospaced))
                    } else {
                        Text("\(Int(blackPoint * 255))").font(.system(size: 10, design: .monospaced))
                        Spacer()
                        Text(String(format: "%.2f", midtone)).font(.system(size: 10, design: .monospaced))
                        Spacer()
                        Text("\(Int(whitePoint * 255))").font(.system(size: 10, design: .monospaced))
                    }
                }
                .foregroundColor(.gray)
                .padding(.horizontal, 4)
            }
        }
    }
    
    private func midtonePosition() -> Float {
        // Map gamma to visual 0..1 between black and white point
        // gamma = 1.0 -> 0.5
        let visualPos = Float(pow(0.5, Double(midtone)))
        return blackPoint + visualPos * (whitePoint - blackPoint)
    }
}
