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
    
    public init(blackPoint: Binding<Float>, whitePoint: Binding<Float>, midtone: Binding<Float>, targetBlack: Binding<Float>, targetWhite: Binding<Float>) {
        self._blackPoint = blackPoint
        self._whitePoint = whitePoint
        self._midtone = midtone
        self._targetBlack = targetBlack
        self._targetWhite = targetWhite
    }
    
    public var body: some View {
        COToolSection("Levels", toolID: "Levels") {
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
                
                // Interactive Histogram View
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
                        
                        // Handles
                        HStack {
                            // Black point handle
                            Color.clear
                                .overlay(
                                    Image(systemName: "arrowtriangle.up.fill")
                                        .font(.system(size: 10))
                                        .foregroundColor(CaptureOneTheme.Colors.textPrimary)
                                        .offset(y: geometry.size.height / 2 + 5)
                                )
                                .position(x: CGFloat(blackPoint) * geometry.size.width, y: geometry.size.height / 2)
                                .gesture(DragGesture().onChanged { value in
                                    let newBP = Float(value.location.x / geometry.size.width)
                                    blackPoint = min(max(0.0, newBP), whitePoint - 0.05)
                                })
                            
                            // Midtone handle
                            Color.clear
                                .overlay(
                                    Image(systemName: "circle.fill")
                                        .font(.system(size: 8))
                                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                                )
                                .position(x: CGFloat(midtonePosition()) * geometry.size.width, y: geometry.size.height / 2)
                                .gesture(DragGesture().onChanged { value in
                                    let newMidX = Float(value.location.x / geometry.size.width)
                                    // Map position back to gamma value roughly
                                    // middle = 1.0, left = < 1.0, right = > 1.0
                                    let normalizedPos = (newMidX - blackPoint) / max(0.001, whitePoint - blackPoint)
                                    let clampedPos = min(max(0.1, normalizedPos), 0.9)
                                    // Approximation for midtone visual representation
                                    midtone = Float(pow(Double(clampedPos) / 0.5, -1.0))
                                })
                            
                            // White point handle
                            Color.clear
                                .overlay(
                                    Image(systemName: "arrowtriangle.up")
                                        .font(.system(size: 10))
                                        .foregroundColor(CaptureOneTheme.Colors.textPrimary)
                                        .offset(y: geometry.size.height / 2 + 5)
                                )
                                .position(x: CGFloat(whitePoint) * geometry.size.width, y: geometry.size.height / 2)
                                .gesture(DragGesture().onChanged { value in
                                    let newWP = Float(value.location.x / geometry.size.width)
                                    whitePoint = max(min(1.0, newWP), blackPoint + 0.05)
                                })
                        }
                    }
                }
                .frame(height: 120)
                
                // Target Output Levels
                HStack {
                    POSliderControl(label: "Target Black", value: $targetBlack, range: 0...1)
                    POSliderControl(label: "Target White", value: $targetWhite, range: 0...1)
                }
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
