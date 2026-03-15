import Foundation
import CoreImage
import CryptoKit
import Metal

/// Managed proxy cache that mirrors C1's memory+disk proxy behavior.
/// Uses LRU eviction by total cost (bytes) and persists proxies to disk.
internal final class ProxyCache {
    private struct MemoryItem {
        let pipeline: RawImageEngine.RenderPipeline
        let cost: Int
        var lastAccess: Date
    }
    
    private let queue = DispatchQueue(label: "ImageCore.ProxyCache")
    private var memory: [URL: MemoryItem] = [:]
    private var lru: [URL] = []
    private var currentBytes: Int = 0
    
    private let maxMemoryBytes: Int
    private let maxItems: Int
    private let diskStore: DiskStore
    
    init(maxMemoryBytes: Int = 512 * 1024 * 1024,
         maxItems: Int = 8,
         maxDiskBytes: Int = 2 * 1024 * 1024 * 1024) {
        self.maxMemoryBytes = maxMemoryBytes
        self.maxItems = maxItems
        self.diskStore = DiskStore(maxDiskBytes: maxDiskBytes)
    }
    
    func pipeline(for url: URL, context: CIContext, loader: () -> CIImage?) -> RawImageEngine.RenderPipeline? {
        if let existing = memoryPipeline(for: url) {
            return existing
        }
        
        let diskImage = diskStore.loadImage(for: url)
        let sourceImage = diskImage ?? loader()
        guard let image = sourceImage else { return nil }
        
        let pipeline = queue.sync { () -> RawImageEngine.RenderPipeline in
            if let existing = memory[url] {
                touch(url)
                return existing.pipeline
            }
            let pipeline = RawImageEngine.RenderPipeline(sourceImage: image, context: context)
            let cost = estimateCost(for: image)
            insert(url: url, pipeline: pipeline, cost: cost)
            return pipeline
        }
        
        if diskImage == nil {
            diskStore.storeImage(image, for: url)
        }
        
        return pipeline
    }
    
    private func memoryPipeline(for url: URL) -> RawImageEngine.RenderPipeline? {
        queue.sync {
            guard let item = memory[url] else { return nil }
            touch(url)
            return item.pipeline
        }
    }
    
    private func insert(url: URL, pipeline: RawImageEngine.RenderPipeline, cost: Int) {
        if let existing = memory[url] {
            currentBytes -= existing.cost
        }
        memory[url] = MemoryItem(pipeline: pipeline, cost: max(1, cost), lastAccess: Date())
        currentBytes += max(1, cost)
        touch(url)
        enforceLimits()
    }
    
    private func touch(_ url: URL) {
        if let index = lru.firstIndex(of: url) {
            lru.remove(at: index)
        }
        lru.append(url)
        if var item = memory[url] {
            item.lastAccess = Date()
            memory[url] = item
        }
    }
    
    private func enforceLimits() {
        while currentBytes > maxMemoryBytes || memory.count > maxItems {
            guard let oldest = lru.first else { break }
            lru.removeFirst()
            if let removed = memory.removeValue(forKey: oldest) {
                currentBytes -= removed.cost
            }
        }
    }
    
    private func estimateCost(for image: CIImage) -> Int {
        let extent = image.extent
        guard !extent.isInfinite, !extent.isNull, extent.width > 0, extent.height > 0 else { return 0 }
        let pixels = Int(extent.width * extent.height)
        let bytesPerPixel = 8 // RGBAh
        return pixels * bytesPerPixel
    }
}

internal final class DiskStore {
    private struct DiskEntry {
        let url: URL
        let size: Int
        let lastAccess: Date
    }
    
    private let queue = DispatchQueue(label: "ImageCore.ProxyCache.disk")
    private let maxDiskBytes: Int
    private var currentBytes: Int = 0
    private var entries: [String: DiskEntry] = [:]
    private let directory: URL
    private let context: CIContext
    
    init(maxDiskBytes: Int) {
        self.maxDiskBytes = maxDiskBytes
        let baseURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        self.directory = baseURL.appendingPathComponent("capture-uncompile-proxies", isDirectory: true)
        
        let options: [CIContextOption: Any] = [
            .workingFormat: CIFormat.RGBAh,
            .workingColorSpace: CGColorSpaceCreateDeviceRGB(),
            .cacheIntermediates: false,
            .useSoftwareRenderer: false
        ]
        
        if let device = MTLCreateSystemDefaultDevice() {
            self.context = CIContext(mtlDevice: device, options: options)
        } else {
            var softwareOptions = options
            softwareOptions[.useSoftwareRenderer] = true
            self.context = CIContext(options: softwareOptions)
        }
        
        queue.sync {
            createDirectoryIfNeeded()
            rebuildIndex()
        }
    }
    
    func loadImage(for url: URL) -> CIImage? {
        let key = keyForURL(url)
        let fileURL = fileURLForKey(key)
        return queue.sync {
            guard FileManager.default.fileExists(atPath: fileURL.path) else { return nil }
            touch(fileURL: fileURL, key: key)
            return CIImage(contentsOf: fileURL)
        }
    }
    
    func storeImage(_ image: CIImage, for url: URL) {
        let key = keyForURL(url)
        let fileURL = fileURLForKey(key)
        
        queue.async {
            guard let data = self.context.tiffRepresentation(of: image,
                                                             format: .RGBAh,
                                                             colorSpace: CGColorSpaceCreateDeviceRGB(),
                                                             options: [:]) else { return }
            do {
                try data.write(to: fileURL, options: .atomic)
                self.updateEntry(for: fileURL, key: key)
                self.enforceLimits()
            } catch {
                print("[ProxyCache] Failed to write proxy to disk: \(error)")
            }
        }
    }
    
    private func createDirectoryIfNeeded() {
        if !FileManager.default.fileExists(atPath: directory.path) {
            try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        }
    }
    
    private func rebuildIndex() {
        entries.removeAll()
        currentBytes = 0
        guard let files = try? FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: [.fileSizeKey, .contentModificationDateKey]) else { return }
        for file in files {
            let attributes = try? FileManager.default.attributesOfItem(atPath: file.path)
            let size = (attributes?[.size] as? NSNumber)?.intValue ?? 0
            let lastAccess = (attributes?[.modificationDate] as? Date) ?? Date()
            currentBytes += size
            entries[file.lastPathComponent] = DiskEntry(url: file, size: size, lastAccess: lastAccess)
        }
    }
    
    private func updateEntry(for fileURL: URL, key: String) {
        let attributes = try? FileManager.default.attributesOfItem(atPath: fileURL.path)
        let size = (attributes?[.size] as? NSNumber)?.intValue ?? 0
        entries[key] = DiskEntry(url: fileURL, size: size, lastAccess: Date())
        currentBytes = entries.values.reduce(0) { $0 + $1.size }
    }
    
    private func touch(fileURL: URL, key: String) {
        let now = Date()
        try? FileManager.default.setAttributes([.modificationDate: now], ofItemAtPath: fileURL.path)
        if var entry = entries[key] {
            entry = DiskEntry(url: entry.url, size: entry.size, lastAccess: now)
            entries[key] = entry
        } else {
            updateEntry(for: fileURL, key: key)
        }
    }
    
    private func enforceLimits() {
        guard currentBytes > maxDiskBytes else { return }
        let sorted = entries.values.sorted { $0.lastAccess < $1.lastAccess }
        var bytes = currentBytes
        for entry in sorted {
            guard bytes > maxDiskBytes else { break }
            try? FileManager.default.removeItem(at: entry.url)
            entries.removeValue(forKey: entry.url.lastPathComponent)
            bytes -= entry.size
        }
        currentBytes = bytes
    }
    
    private func keyForURL(_ url: URL) -> String {
        let digest = SHA256.hash(data: Data(url.absoluteString.utf8))
        return digest.map { String(format: "%02x", $0) }.joined() + ".tiff"
    }
    
    private func fileURLForKey(_ key: String) -> URL {
        directory.appendingPathComponent(key, isDirectory: false)
    }
}
