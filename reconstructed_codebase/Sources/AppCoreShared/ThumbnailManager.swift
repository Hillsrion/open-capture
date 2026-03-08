import Foundation
import QuickLookThumbnailing
import AppKit

/// Reconstructed high-speed thumbnail management logic.
/// Utilizes QuickLookThumbnailing for performant extraction of RAW and standard image previews.

public class ThumbnailCache {
    public static let shared = ThumbnailCache()
    private let cache = NSCache<NSString, NSData>()
    
    private init() {
        cache.countLimit = 500 // Limit to 500 thumbnails in memory
    }
    
    public func thumbnail(for identifier: String) -> NSData? {
        return cache.object(forKey: identifier as NSString)
    }
    
    public func setThumbnail(_ data: NSData, for identifier: String) {
        cache.setObject(data, forKey: identifier as NSString)
    }
}

public class ThumbnailManager {
    
    public static let shared = ThumbnailManager()
    private let cache = ThumbnailCache.shared
    
    private init() {}
    
    /// Logic recovery: Request a thumbnail for an image path.
    /// Returns cached data immediately if available, otherwise triggers asynchronous extraction.
    public func requestThumbnail(for path: String, size: CGSize, completion: @escaping (NSImage?) -> Void) {
        let identifier = "\(path)_\(Int(size.width))"
        
        // 1. Check Memory Cache
        if let cachedData = cache.thumbnail(for: identifier) {
            completion(NSImage(data: cachedData as Data))
            return
        }
        
        // 2. Extract using QuickLook (Local-only, high performance)
        let url = URL(fileURLWithPath: path)
        let request = QLThumbnailGenerator.Request(fileAt: url, size: size, scale: 1.0, representationTypes: .thumbnail)
        
        QLThumbnailGenerator.shared.generateRepresentations(for: request) { (representation, type, error) in
            if let thumbnail = representation?.nsImage {
                // Store in cache
                if let tiffData = thumbnail.tiffRepresentation {
                    self.cache.setThumbnail(NSData(data: tiffData), for: identifier)
                }
                DispatchQueue.main.async {
                    completion(thumbnail)
                }
            } else {
                print("[System] Thumbnail extraction failed for \(path): \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}
