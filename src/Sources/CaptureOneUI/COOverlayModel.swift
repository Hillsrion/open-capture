import SwiftUI
import Combine

/// Reconstructed high-fidelity Overlay Model (GAP-406).
/// Manages settings for the Composition Aid overlay.
public final class COOverlayModel: ObservableObject {
    public static let shared = COOverlayModel()
    
    @Published public var showOverlay: Bool = false
    @Published public var opacity: Double = 50.0 // 0 to 100
    @Published public var scale: Double = 100.0 // Percentage
    @Published public var offset: CGPoint = .zero
    @Published public var imagePath: String = ""
    @Published public var followCrop: Bool = false
    
    @Published public var overlayImage: NSImage? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        $imagePath
            .sink { [weak self] path in
                self?.loadOverlayImage(path: path)
            }
            .store(in: &cancellables)
    }
    
    private func loadOverlayImage(path: String) {
        guard !path.isEmpty else {
            self.overlayImage = nil
            return
        }
        
        // In a real app, this would be done on a background thread
        if let image = NSImage(contentsOfFile: path) {
            self.overlayImage = image
        } else {
            self.overlayImage = nil
        }
    }
    
    public func centerOverlay() {
        self.offset = .zero
    }
}
