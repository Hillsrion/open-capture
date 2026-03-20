import Foundation

/// Protocol for images that can be used with Smart Selection (Magic Brush).
public protocol SmartSelectionImageProvider {
    var size: CGSize { get }
    func getLumaBuffer() -> [Float]
}
