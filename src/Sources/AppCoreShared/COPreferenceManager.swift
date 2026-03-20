import SwiftUI
import Combine

/// Manages application-wide preferences.
public class COPreferenceManager: ObservableObject {
    public static let shared = COPreferenceManager()
    
    @Published public var exposureSettings = ExposureSettings()
    
    private init() {}
    
    public struct ExposureSettings: Codable {
        public var highlightThreshold: Double = 250.0
        public var shadowThreshold: Double = 0.0
        public var highlightColor: [CGFloat] = [1.0, 0.0, 0.0, 1.0] // Red
        public var shadowColor: [CGFloat] = [0.0, 0.0, 1.0, 1.0] // Blue
        public var showShadowWarning: Bool = false
        
        public init() {}
        
        public var highlightSwiftUIColor: Color {
            Color(.sRGB, red: highlightColor[0], green: highlightColor[1], blue: highlightColor[2], opacity: highlightColor[3])
        }
        
        public var shadowSwiftUIColor: Color {
            Color(.sRGB, red: shadowColor[0], green: shadowColor[1], blue: shadowColor[2], opacity: shadowColor[3])
        }
    }
}
