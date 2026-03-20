import SwiftUI
import Combine

/// Reconstructed high-fidelity Overlay View Controller (GAP-406).
/// Manages the state and interaction for the Overlay Tool.
public final class COOverlayViewController: ObservableObject {
    public static let shared = COOverlayViewController()
    
    @ObservedObject var model: COOverlayModel = .shared
    
    private init() {}
    
    public func handleMoveOverlayDrag(delta: CGSize, startOffset: CGPoint) {
        model.offset = CGPoint(x: startOffset.x + delta.width, y: startOffset.y + delta.height)
    }
    
    public func handleScaleOverlay(delta: CGFloat) {
        model.scale = max(1, min(200, model.scale + Double(delta)))
    }
    
    public func resetOverlay() {
        model.centerOverlay()
    }
}
