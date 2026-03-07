import SwiftUI
import AppKit

/// Reconstructed custom controls for Capture One.
/// Mimics the behavior found in COUIButtonCell and other custom AppKit cells.

// MARK: - Capture One Button Style
public struct COUButtonStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(CaptureOneTheme.Colors.buttonBackground)
            .foregroundColor(configuration.isPressed ? CaptureOneTheme.Colors.activeHighlight : .white)
            .cornerRadius(4)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
    }
}

// MARK: - Reconstructed AppKit Cell Wrappers
public class COUIButtonCell: NSButtonCell {
    public override func drawBezel(withFrame frame: NSRect, in controlView: NSView) {
        // Logic recovery: Custom bezel drawing using C1 theme colors
        CaptureOneTheme.Colors.buttonBackground.nsColor.set()
        frame.fill()
        
        if isHighlighted {
            CaptureOneTheme.Colors.activeHighlight.nsColor.set()
            frame.frame()
        }
    }
}

// MARK: - Helper Extensions
extension Color {
    var nsColor: NSColor {
        // Simple conversion for reconstruction purposes
        return NSColor(self)
    }
}
