import Foundation
import Combine

/// Reconstructed store for managing browser zoom levels (UI-005).
/// Based on _TtC13AppCoreShared26ImageBrowserZoomLevelStore.
public class ImageBrowserZoomLevelStore: ObservableObject {
    
    public static let shared = ImageBrowserZoomLevelStore()
    
    @Published public var thumbnailSize: Double {
        didSet {
            UserDefaults.standard.set(thumbnailSize, forKey: "COImageBrowserThumbnailSize")
        }
    }
    
    public init() {
        let savedSize = UserDefaults.standard.double(forKey: "COImageBrowserThumbnailSize")
        self.thumbnailSize = savedSize > 0 ? savedSize : 160.0
    }
    
    public func setSize(_ size: Double) {
        self.thumbnailSize = size
    }
}
