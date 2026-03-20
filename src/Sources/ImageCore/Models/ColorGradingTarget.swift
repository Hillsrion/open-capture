import Foundation

/// Protocol for objects that can receive color grading transfers.
public protocol ColorGradingTarget {
    var variantUUID: String { get }
    // Add methods to apply adjustments if needed
}
