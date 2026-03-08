import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity circular color balance control (UI-003).
/// Based on disassembly of POColorBalanceControl.
public struct POColorBalanceControl: View {
    @Binding var value: ColorBalanceValue
    let title: String
    
    public init(value: Binding<ColorBalanceValue>, title: String) {
        self._value = value
        self.title = title
    }
    
    public var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 12) {
                // 1. Brightness Slider (Arc-based simulation)
                // In v16.5, this is a vertical arc on the left.
                VStack {
                    Slider(value: $value.brightness, in: -100...100)
                        .rotationEffect(.degrees(-90))
                        .frame(width: 140, height: 20)
                        .accentColor(.gray)
                    
                    Text("B").font(.system(size: 8)).foregroundColor(.gray)
                }
                .frame(width: 20)
                
                // 2. Main Color Wheel
                ZStack {
                    Circle()
                        .fill(
                            AngularGradient(gradient: Gradient(colors: [
                                .red, .yellow, .green, .cyan, .blue, .magenta, .red
                            ]), center: .center, angle: .degrees(-90))
                        )
                        .opacity(0.8)
                    
                    RadialGradient(gradient: Gradient(colors: [.white, .white.opacity(0)]), 
                                   center: .center, startRadius: 0, endRadius: 100)
                        .blendMode(.screen)
                    
                    GeometryReader { geo in
                        let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
                        let pos = ColorWheelMath.polarToCartesian(hue: value.hue, saturation: value.saturation)
                        let absolutePos = CGPoint(x: center.x + pos.x * (geo.size.width / 2), 
                                                  y: center.y + pos.y * (geo.size.height / 2))
                        
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                            .frame(width: 12, height: 12)
                            .position(absolutePos)
                            .shadow(radius: 2)
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { gesture in
                                        let relativeX = (gesture.location.x - center.x) / (geo.size.width / 2)
                                        let relativeY = (gesture.location.y - center.y) / (geo.size.height / 2)
                                        let polar = ColorWheelMath.cartesianToPolar(x: Double(relativeX), y: Double(relativeY))
                                        value.hue = polar.hue
                                        value.saturation = polar.saturation
                                    }
                            )
                            .onTapGesture(count: 2) {
                                // Reset logic (Task 3)
                                value.hue = 0
                                value.saturation = 0
                            }
                    }
                }
                .aspectRatio(1.0, contentMode: .fit)
            }
            .padding(10)
            
            // 3. Title & Numeric Info
            HStack {
                Text(title.uppercased())
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text("\(Int(value.hue))° \(Int(value.saturation))% \(Int(value.brightness))")
                    .font(.system(size: 9, weight: .monospaced))
                    .foregroundColor(CaptureOneTheme.Colors.textSecondary)
            }
            .padding(.horizontal, 4)
        }
    }
}
