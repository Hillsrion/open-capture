import SwiftUI
import AppCoreShared
import ImageCore

/// Reconstructed high-fidelity circular color balance control.
public struct POColorBalanceControl: View {
    @Binding var value: ColorBalanceValue
    let title: String
    let wheelDiameter: CGFloat
    let lightnessControlDisabled: Bool

    public init(
        value: Binding<ColorBalanceValue>,
        title: String,
        wheelDiameter: CGFloat = 104,
        lightnessControlDisabled: Bool = false
    ) {
        self._value = value
        self.title = title
        self.wheelDiameter = wheelDiameter
        self.lightnessControlDisabled = lightnessControlDisabled
    }

    public var body: some View {
        VStack(spacing: 8) {
            HStack(alignment: .center, spacing: 8) {
                ColorBalanceWheelSurface(value: $value, diameter: wheelDiameter)

                if !lightnessControlDisabled {
                    CurvedLightnessSlider(value: $value.brightness, height: wheelDiameter)
                        .frame(width: 26, height: wheelDiameter)
                }
            }

            VStack(spacing: 2) {
                Text(title)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(CaptureOneTheme.Colors.textPrimary)

                Text(readout)
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(CaptureOneTheme.Colors.textSecondary)
            }
        }
    }

    private var readout: String {
        if lightnessControlDisabled {
            return "\(Int(value.hue.rounded()))° \(Int(value.saturation.rounded()))%"
        }

        return "\(Int(value.hue.rounded()))° \(Int(value.saturation.rounded()))% \(Int(value.brightness.rounded()))"
    }
}

private struct ColorBalanceWheelSurface: View {
    @Binding var value: ColorBalanceValue
    let diameter: CGFloat

    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let radius = size / 2
            let handlePoint = handlePosition(center: center, radius: radius)

            ZStack {
                Circle()
                    .fill(
                        AngularGradient(
                            gradient: Gradient(colors: [.red, .yellow, .green, .cyan, .blue, .purple, .red]),
                            center: .center,
                            angle: .degrees(-90)
                        )
                    )

                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [.white, .white.opacity(0.03)]),
                            center: .center,
                            startRadius: 0,
                            endRadius: radius
                        )
                    )
                    .blendMode(.screen)

                Circle()
                    .stroke(Color.black.opacity(0.55), lineWidth: 1)

                Circle()
                    .stroke(Color.white.opacity(0.08), lineWidth: 0.8)
                    .padding(1)

                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 1.2)
                    .frame(width: 12, height: 12)

                Circle()
                    .stroke(Color.black.opacity(0.6), lineWidth: 1)
                    .background(Circle().fill(Color.clear))
                    .frame(width: 12, height: 12)
                    .position(handlePoint)

                Circle()
                    .fill(Color.white.opacity(0.92))
                    .frame(width: 4, height: 4)
                    .position(handlePoint)
            }
            .contentShape(Circle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        updateValue(at: gesture.location, center: center, radius: radius)
                    }
            )
            .simultaneousGesture(
                TapGesture(count: 2)
                    .onEnded {
                        value.hue = 0
                        value.saturation = 0
                    }
            )
        }
        .frame(width: diameter, height: diameter)
    }

    private func handlePosition(center: CGPoint, radius: CGFloat) -> CGPoint {
        let position = ColorWheelMath.polarToCartesian(hue: value.hue, saturation: value.saturation)
        let insetRadius = radius - 3
        return CGPoint(
            x: center.x + position.x * insetRadius,
            y: center.y + position.y * insetRadius
        )
    }

    private func updateValue(at location: CGPoint, center: CGPoint, radius: CGFloat) {
        let relativeX = Double((location.x - center.x) / radius)
        let relativeY = Double((location.y - center.y) / radius)
        let polar = ColorWheelMath.cartesianToPolar(x: relativeX, y: relativeY)
        value.hue = polar.hue
        value.saturation = polar.saturation
    }
}

private struct CurvedLightnessSlider: View {
    @Binding var value: Double
    let height: CGFloat

    private let range = -100.0...100.0

    var body: some View {
        GeometryReader { geometry in
            let sliderRect = geometry.frame(in: .local)
            let tickY = tickPosition(in: sliderRect)

            ZStack {
                ArcTrackShape()
                    .stroke(Color.white.opacity(0.45), style: StrokeStyle(lineWidth: 3, lineCap: .round))

                ArcTrackShape(inset: 0.8)
                    .stroke(Color.black.opacity(0.45), style: StrokeStyle(lineWidth: 1, lineCap: .round))

                Rectangle()
                    .fill(CaptureOneTheme.Colors.activeHighlight)
                    .frame(width: 8, height: 2)
                    .offset(x: -3, y: tickY)
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        updateValue(for: gesture.location.y, height: geometry.size.height)
                    }
            )
            .simultaneousGesture(
                TapGesture(count: 2)
                    .onEnded {
                        value = 0
                    }
            )
        }
        .frame(width: 26, height: height)
    }

    private func updateValue(for y: CGFloat, height: CGFloat) {
        let clampedY = min(max(0, y), height)
        let progress = 1.0 - Double(clampedY / max(1, height))
        value = range.lowerBound + progress * (range.upperBound - range.lowerBound)
    }

    private func tickPosition(in rect: CGRect) -> CGFloat {
        let progress = CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound))
        let y = rect.height * (1 - progress)
        return y - rect.midY
    }
}

private struct ArcTrackShape: Shape {
    var inset: CGFloat = 0

    func path(in rect: CGRect) -> Path {
        let radius = min(rect.width, rect.height) / 2 - 4 - inset
        let center = CGPoint(x: rect.midX - 4, y: rect.midY)
        var path = Path()
        path.addArc(
            center: center,
            radius: radius,
            startAngle: .degrees(-65),
            endAngle: .degrees(65),
            clockwise: false
        )
        return path
    }
}
