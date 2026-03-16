import Foundation
import CoreGraphics
import Metal

/// Tile-level GPU cache used to avoid re-rendering tiles during interactive updates.
internal final class TileResultCache {
    struct Key: Hashable {
        let settingsKey: Int
        let quality: IC_ProcessQuality
        let scale: CGFloat
        let tile: TileRegion
    }
    
    private struct Entry {
        let texture: MTLTexture
        let cost: Int
        var lastAccess: Date
    }
    
    private let queue = DispatchQueue(label: "ImageCore.TileResultCache")
    private var entries: [Key: Entry] = [:]
    private var lru: [Key] = []
    private var currentBytes: Int = 0
    
    private let maxBytes: Int
    private let maxItems: Int
    
    init(maxBytes: Int = 256 * 1024 * 1024, maxItems: Int = 512) {
        self.maxBytes = maxBytes
        self.maxItems = maxItems
    }
    
    func texture(for key: Key) -> MTLTexture? {
        queue.sync {
            guard let entry = entries[key] else { return nil }
            touch(key)
            return entry.texture
        }
    }
    
    func insert(texture: MTLTexture, for key: Key, cost: Int) {
        queue.sync {
            if let existing = entries[key] {
                currentBytes -= existing.cost
            }
            entries[key] = Entry(texture: texture, cost: max(1, cost), lastAccess: Date())
            currentBytes += max(1, cost)
            touch(key)
            enforceLimits()
        }
    }
    
    func removeAll() {
        queue.sync {
            entries.removeAll()
            lru.removeAll()
            currentBytes = 0
        }
    }
    
    private func touch(_ key: Key) {
        if let index = lru.firstIndex(of: key) {
            lru.remove(at: index)
        }
        lru.append(key)
        if var entry = entries[key] {
            entry.lastAccess = Date()
            entries[key] = entry
        }
    }
    
    private func enforceLimits() {
        while currentBytes > maxBytes || entries.count > maxItems {
            guard let oldest = lru.first else { break }
            lru.removeFirst()
            if let removed = entries.removeValue(forKey: oldest) {
                currentBytes -= removed.cost
            }
        }
    }
    
    static func estimateCost(width: Int, height: Int) -> Int {
        let pixels = max(1, width) * max(1, height)
        let bytesPerPixel = 8 // RGBAh
        return pixels * bytesPerPixel
    }
}
