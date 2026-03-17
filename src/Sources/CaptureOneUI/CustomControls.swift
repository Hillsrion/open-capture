import SwiftUI
import AppKit

/// Reconstructed high-fidelity custom controls for Capture One.
/// Logic recovered from COUIButtonCell and NSColor(CaptureOne) disassembly.

// MARK: - Capture One Button Style (High Fidelity)
public struct COUButtonStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(
                ZStack {
                    // Base Background
                    RoundedRectangle(cornerRadius: 3)
                        .fill(CaptureOneTheme.Colors.buttonBackground)
                    
                    // Subtle Inner Shadow / Top Highlight (Inferred from coLightShadowColor)
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(configuration.isPressed ? Color.black.opacity(0.3) : Color.white.opacity(0.05), lineWidth: 1)
                }
            )
            .foregroundColor(configuration.isPressed ? CaptureOneTheme.Colors.activeHighlight : CaptureOneTheme.Colors.textPrimary)
            .font(.system(size: 11))
            .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: 1) // Shadow found in disassembly
    }
}

// MARK: - Inspector Text Field (High Fidelity)
public struct InspectorTextField: View {
    let label: String
    @Binding var value: Float
    
    public init(label: String, value: Binding<Float>) {
        self.label = label
        self._value = value
    }
    
    public var body: some View {
        TextField("", value: $value, formatter: NumberFormatter.coDefault)
            .font(.system(size: 11, design: .monospaced))
            .textFieldStyle(PlainTextFieldStyle())
            .multilineTextAlignment(.trailing)
            .padding(.horizontal, 4)
            .frame(width: 45, height: 18)
            .background(Color.black.opacity(0.2))
            .cornerRadius(2)
            .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
            )
    }
}

// MARK: - POSliderControl (Composite Control)
public struct POSliderControl: View {
    let label: String
    @Binding var value: Float
    let range: ClosedRange<Float>
    
    public init(label: String, value: Binding<Float>, range: ClosedRange<Float>) {
        self.label = label
        self._value = value
        self.range = range
    }
    
    public var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(CaptureOneTheme.Colors.textPrimary)
                .frame(width: 85, alignment: .leading)
            
            COUISlider(label: "", value: $value, range: range, showLabel: false)
            
            InspectorTextField(label: label, value: $value)
        }
        .frame(height: 20)
    }
}

// MARK: - Draggable Divider (WS-106)
public struct DraggableDivider: View {
    public enum Direction {
        case horizontal
        case vertical
    }
    
    let direction: Direction
    @Binding var size: Double
    let range: ClosedRange<Double>
    let isReversed: Bool // If true, dragging left/up increases size
    let onResizeEnd: (() -> Void)?
    
    @State private var isHovering = false
    @State private var initialSize: Double?
    
    public init(direction: Direction, size: Binding<Double>, range: ClosedRange<Double>, isReversed: Bool = false, onResizeEnd: (() -> Void)? = nil) {
        self.direction = direction
        self._size = size
        self.range = range
        self.isReversed = isReversed
        self.onResizeEnd = onResizeEnd
    }
    
    public var body: some View {
        Rectangle()
            .fill(isHovering ? CaptureOneTheme.Colors.activeHighlight : Color.black)
            .frame(width: direction == .horizontal ? 1 : nil, height: direction == .vertical ? 1 : nil)
            .frame(width: direction == .horizontal ? 5 : nil, height: direction == .vertical ? 5 : nil)
            .contentShape(Rectangle())
            .onHover { hovering in isHovering = hovering }
            .onContinuousHover { _ in
                if direction == .horizontal {
                    NSCursor.resizeLeftRight.set()
                } else {
                    NSCursor.resizeUpDown.set()
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if initialSize == nil {
                            initialSize = size
                        }
                        
                        let translation = direction == .horizontal ? value.translation.width : value.translation.height
                        let multiplier = isReversed ? -1.0 : 1.0
                        
                        if let baseSize = initialSize {
                            let newSize = (baseSize + Double(translation) * multiplier).clamped(to: range)
                            if newSize != size {
                                size = newSize
                            }
                        }
                    }
                    .onEnded { _ in
                        initialSize = nil
                        onResizeEnd?()
                    }
            )
    }
}

extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}

// Extension to NumberFormatter for C1 style
extension NumberFormatter {
    public static var coDefault: NumberFormatter {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.maximumFractionDigits = 1
        f.minimumFractionDigits = 0
        return f
    }
}

// MARK: - Reconstructed AppKit Cell (Pixel Perfect)
public class COUIButtonCell: NSButtonCell {
    
    public override func drawBezel(withFrame frame: NSRect, in controlView: NSView) {
        // Logic recovery: Align to backing pixels to avoid blur (backingAlignedRect)
        let alignedFrame = controlView.window?.convertToBacking(frame) ?? frame
        let pixelFrame = controlView.window?.convertFromBacking(alignedFrame) ?? frame
        
        let path = NSBezierPath(roundedRect: pixelFrame.insetBy(dx: 0.5, dy: 0.5), xRadius: 3, yRadius: 3)
        
        if isHighlighted {
            CaptureOneTheme.Colors.activeHighlight.nsColor.set()
        } else {
            CaptureOneTheme.Colors.buttonBackground.nsColor.set()
        }
        
        path.fill()
        
        // Stroke logic from disassembly (coLightShadowColor)
        NSColor(white: 1.0, alpha: 0.05).set()
        path.lineWidth = 1.0
        path.stroke()
    }
}
