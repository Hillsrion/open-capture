import AppKit
import SwiftUI

/// Reconstructed base class for Capture One UI Views (v16.5+).
/// This serves as the foundation for objective-c bridging and native view structure.
open class COUIView: NSView {
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    open override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
}

/// Reconstructed container view class (v16.5+).
open class COUIContentView: COUIView {
    public var fillColor: NSColor?
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open override func draw(_ dirtyRect: NSRect) {
        if let color = fillColor {
            color.setFill()
            dirtyRect.fill()
        }
        super.draw(dirtyRect)
    }
}

// MARK: - SwiftUI Representable wrappers

public struct COUIContentViewRepresentable: NSViewRepresentable {
    public var fillColor: NSColor?
    
    public init(fillColor: NSColor? = nil) {
        self.fillColor = fillColor
    }
    
    public func makeNSView(context: Context) -> COUIContentView {
        let view = COUIContentView(frame: .zero)
        view.fillColor = fillColor
        return view
    }
    
    public func updateNSView(_ nsView: COUIContentView, context: Context) {
        nsView.fillColor = fillColor
        nsView.needsDisplay = true
    }
}
