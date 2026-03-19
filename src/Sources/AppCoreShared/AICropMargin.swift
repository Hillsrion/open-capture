import Foundation
import CoreGraphics

/// Structure for user-defined margins in AI Crop (Consistency) module.
public struct AICropMargin: Codable, Equatable {
    public var top: Double
    public var bottom: Double
    public var left: Double
    public var right: Double
    
    public init(top: Double = 10.0, bottom: Double = 10.0, left: Double = 10.0, right: Double = 10.0) {
        self.top = top
        self.bottom = bottom
        self.left = left
        self.right = right
    }
    
    public static var defaultMargins: AICropMargin {
        return AICropMargin(top: 10.0, bottom: 10.0, left: 10.0, right: 10.0)
    }
}
