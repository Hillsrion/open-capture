import SwiftUI
import AppKit

/// Reconstructed visual theme for Capture One.
/// Based on NSColor(CaptureOne) extensions from version 16.5.9.7.
public struct CaptureOneTheme {
    
    public struct Colors {
        // MARK: - Core Backgrounds
        public static let applicationBackground = Color(NSColor(calibratedWhite: 0.12, alpha: 1.0)) // coApplicationBackgroundColor
        public static let mainWindowTitleAndToolbar = Color(NSColor(calibratedWhite: 0.15, alpha: 1.0)) // coMainWindowTitleAndToolbarColor
        public static let histogramBackground = Color(NSColor(calibratedWhite: 0.10, alpha: 1.0)) // coHistogramBackgroundColor
        
        // MARK: - Highlights & Selection
        public static let activeHighlight = Color.orange // coActiveHighlightColor (Inferred from C1 aesthetic)
        public static let inactiveHighlight = Color.gray // coInactiveHighlightColor
        
        // MARK: - Text & Icons
        public static let mainText = Color.white // coMainTextColor (Inferred)
        public static let disabledText = Color.gray // coDisabledTextColor
        public static let iconColor = Color(white: 0.8) // coIconColor
        
        // MARK: - Specialized Tool Colors
        public static let redHistogram = Color.red // coRedHistogramColor
        public static let greenHistogram = Color.green // coGreenHistogramColor
        public static let blueHistogram = Color.blue // coBlueHistogramColor
        public static let lumaHistogram = Color.white // coLumaHistogramColor
        
        // MARK: - UI Elements
        public static let buttonBackground = Color(white: 0.2) // coButtonBackgroundColor
        public static let separatorDark = Color(white: 0.05) // coDarkSeparatorColor
        public static let separatorLight = Color(white: 0.2) // coLightSeparatorColor
    }
}

// MARK: - AppKit Compatibility
extension NSColor {
    public static var coApplicationBackground: NSColor { NSColor(calibratedWhite: 0.12, alpha: 1.0) }
    public static var coActiveHighlight: NSColor { NSColor.orange }
}
