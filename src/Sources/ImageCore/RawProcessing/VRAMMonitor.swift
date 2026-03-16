import Foundation
import Metal

public protocol MemoryEvictable: AnyObject {
    func evict(amount: Int) -> Int
    func clearAll()
}

public final class VRAMMonitor {
    public static let shared = VRAMMonitor()
    
    private let device: MTLDevice?
    
    private struct CacheEntry {
        weak var cache: MemoryEvictable?
        let priority: Int
    }
    private var caches: [CacheEntry] = []
    
    public private(set) var budgetBytes: Int = 0
    private let queue = DispatchQueue(label: "ImageCore.VRAMMonitor")
    private var memoryPressureSource: DispatchSourceMemoryPressure?
    
    public init(device: MTLDevice? = MTLCreateSystemDefaultDevice()) {
        self.device = device
        
        if let d = device {
            let isUnified = d.hasUnifiedMemory
            let recommended = d.recommendedMaxWorkingSetSize
            
            // Adjust budget strategy based on architecture
            if isUnified {
                budgetBytes = Int(Double(recommended) * 0.7) // Leave room for OS
            } else {
                budgetBytes = Int(Double(recommended) * 0.9) // Dedicated GPU can use more
            }
        } else {
            budgetBytes = 1024 * 1024 * 1024 // Fallback 1GB
        }
        
        setupMemoryPressureHandler()
    }
    
    private func setupMemoryPressureHandler() {
        memoryPressureSource = DispatchSource.makeMemoryPressureSource(eventMask: [.warning, .critical], queue: queue)
        memoryPressureSource?.setEventHandler { [weak self] in
            guard let self = self, let source = self.memoryPressureSource else { return }
            let event = source.data
            
            if event.contains(.critical) {
                self.handleCriticalPressure()
            } else if event.contains(.warning) {
                self.handleWarningPressure()
            }
        }
        memoryPressureSource?.resume()
    }
    
    public func register(cache: MemoryEvictable, priority: Int) {
        queue.async {
            self.caches.append(CacheEntry(cache: cache, priority: priority))
            self.caches.sort { $0.priority > $1.priority } // Highest priority to evict first
        }
    }
    
    public func checkBudget(currentUsage: Int) {
        queue.async {
            // Remove nil weak references
            self.caches.removeAll { $0.cache == nil }
            
            if currentUsage > self.budgetBytes {
                let overage = currentUsage - self.budgetBytes
                self.performEviction(targetAmount: overage)
            }
        }
    }
    
    private func performEviction(targetAmount: Int) {
        var remainingToEvict = targetAmount
        for entry in caches {
            if remainingToEvict <= 0 { break }
            if let cache = entry.cache {
                let freed = cache.evict(amount: remainingToEvict)
                remainingToEvict -= freed
            }
        }
    }
    
    private func handleWarningPressure() {
        queue.async {
            self.caches.removeAll { $0.cache == nil }
            let targetAmount = self.budgetBytes / 2
            self.performEviction(targetAmount: targetAmount)
        }
    }
    
    private func handleCriticalPressure() {
        queue.async {
            self.caches.removeAll { $0.cache == nil }
            for entry in self.caches {
                entry.cache?.clearAll()
            }
        }
    }
}