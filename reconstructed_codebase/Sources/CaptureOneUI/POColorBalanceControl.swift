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
            ZStack {
                // 1. Angular Hue Gradient
                Circle()
                    .fill(
                        AngularGradient(gradient: Gradient(colors: [
                            .red, .yellow, .green, .cyan, .blue, .magenta, .red
                        ]), center: .center, angle: .degrees(-90))
                    )
                    .opacity(0.8)
                
                // 2. White desaturation overlay (Radial)
                RadialGradient(gradient: Gradient(colors: [.white, .white.opacity(0)]), 
                               center: .center, startRadius: 0, endRadius: 100)
                    .blendMode(.screen)
                
                // 3. Interactive Crosshair
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
                }
            }
            .aspectRatio(1.0, contentMode: .fit)
            .padding(10)
            
            Text(title)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.gray)
        }
    }
}
