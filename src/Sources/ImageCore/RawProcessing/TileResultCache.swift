import Foundation
import CoreGraphics
import Metal

import Foundation
import CoreGraphics
import Metal

/// Processing stages for tile-level caching.
public enum TileStage: String, Hashable, CaseIterable {
    case precolor
    case lut
    case local
    case nr
}

/// Statistics for cache performance tracking.
public struct CacheStats {
    public var hits: [TileStage: Int] = [:]
    public var misses: [TileStage: Int] = [:]
    
    public init() {
        for stage in TileStage.allCases {
            hits[stage] = 0
            misses[stage] = 0
        }
    }
}

/// Tile-level GPU cache used to avoid re-rendering tiles during interactive updates.
internal final class TileResultCache: MemoryEvictable {
    struct Key: Hashable {
        let settingsKey: Int
        let quality: IC_ProcessQuality
        let scale: CGFloat
        let operationKey: Int
        let tile: TileRegion
        let stage: TileStage
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
    private var stats = CacheStats()
    
    private var maxBytes: Int
    private var maxItems: Int
    
    init(maxBytes: Int = 256 * 1024 * 1024, maxItems: Int = 512) {
        self.maxBytes = maxBytes
        self.maxItems = maxItems
        
        VRAMMonitor.shared.register(cache: self, priority: 100)
    }
    
    func texture(for key: Key) -> MTLTexture? {
        queue.sync {
            if let entry = entries[key] {
                stats.hits[key.stage, default: 0] += 1
                touch(key)
                return entry.texture
            } else {
                stats.misses[key.stage, default: 0] += 1
                return nil
            }
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
            stats = CacheStats()
        }
    }

    func invalidate(settingsKey: Int, from stage: TileStage) {
        queue.sync {
            let stagesToInvalidate = TileStage.allCases.filter { s in
                // Logic: invalidate stages that come after (or are) the affected stage
                // This assumes a fixed order: precolor -> lut -> local -> nr
                let order: [TileStage] = [.precolor, .lut, .local, .nr]
                guard let affectedIndex = order.firstIndex(of: stage),
                      let currentIndex = order.firstIndex(of: s) else { return false }
                return currentIndex >= affectedIndex
            }
            
            let keysToRemove = entries.keys.filter { 
                $0.settingsKey == settingsKey && stagesToInvalidate.contains($0.stage)
            }
            
            for key in keysToRemove {
                if let removed = entries.removeValue(forKey: key) {
                    currentBytes -= removed.cost
                    if let index = lru.firstIndex(of: key) {
                        lru.remove(at: index)
                    }
                }
            }
        }
    }
    
    func getStats() -> CacheStats {
        queue.sync { stats }
    }
    
    func usageBytes() -> Int {
        queue.sync { currentBytes }
    }
    
    func trim(toBytes target: Int) {
        queue.sync {
            let limit = max(0, target)
            while currentBytes > limit, let oldest = lru.first {
                lru.removeFirst()
                if let removed = entries.removeValue(forKey: oldest) {
                    currentBytes -= removed.cost
                }
            }
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
    
    func evict(amount: Int) -> Int {
        let start = usageBytes()
        let target = max(0, start - amount)
        trim(toBytes: target)
        return start - usageBytes()
    }
    
    func clearAll() {
        removeAll()
    }
}
