import Foundation

/// Internal protocol to break circular dependency between AppCore and ImageCore for masking.
public protocol ICMaskableLayer {
    var name: String { get }
    var isMagicBrush: Bool { get }
}

public protocol ICImageMetadataProvider {
    var displayName: String { get }
}
