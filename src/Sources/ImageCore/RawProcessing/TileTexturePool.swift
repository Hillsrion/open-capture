import Foundation
import Metal

/// Reuses temporary tile textures to avoid per-tile allocations.
internal final class TileTexturePool: MemoryEvictable {
    private let queue = DispatchQueue(label: "ImageCore.TileTexturePool")
    
    private struct TextureKey: Hashable {
        let width: Int
        let height: Int
    }
    
    private struct PooledTexture {
        let texture: MTLTexture
        let lastUsed: Date
        
        var estimatedSize: Int {
            return texture.width * texture.height * 8 // approx 8 bytes per pixel for rgba16Float
        }
    }
    
    private var pool: [TextureKey: [PooledTexture]] = [:]
    
    private var idleWorkItem: DispatchWorkItem?
    
    func acquire(device: MTLDevice, size: CGSize) -> MTLTexture? {
        let roundedWidth = max(1, Int(size.width.rounded(.up)))
        let roundedHeight = max(1, Int(size.height.rounded(.up)))
        let key = TextureKey(width: roundedWidth, height: roundedHeight)
        
        if let texture = queue.sync(execute: { () -> MTLTexture? in
            resetIdleTimer()
            if var textures = pool[key], !textures.isEmpty {
                let pooled = textures.removeLast()
                pool[key] = textures
                return pooled.texture
            }
            return nil
        }) {
            return texture
        }
        
        let descriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .rgba16Float,
                                                                  width: roundedWidth,
                                                                  height: roundedHeight,
                                                                  mipmapped: false)
        descriptor.usage = [.shaderRead, .shaderWrite, .renderTarget]
        return device.makeTexture(descriptor: descriptor)
    }
    
    func release(_ texture: MTLTexture) {
        let key = TextureKey(width: texture.width, height: texture.height)
        queue.sync {
            resetIdleTimer()
            let pooled = PooledTexture(texture: texture, lastUsed: Date())
            pool[key, default: []].append(pooled)
        }
    }
    
    private func resetIdleTimer() {
        idleWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            self?.clearAll()
        }
        idleWorkItem = workItem
        DispatchQueue.global().asyncAfter(deadline: .now() + 5.0, execute: workItem)
    }
    
    func removeAll() {
        queue.sync {
            pool.removeAll()
            idleWorkItem?.cancel()
        }
    }
    
    func evict(amount: Int) -> Int {
        return queue.sync {
            var freed = 0
            
            // Collect all textures from the pool
            var allTextures: [(key: TextureKey, pooled: PooledTexture)] = []
            for (key, textures) in pool {
                for pooled in textures {
                    allTextures.append((key, pooled))
                }
            }
            
            // Sort by oldest lastUsed date first
            allTextures.sort { $0.pooled.lastUsed < $1.pooled.lastUsed }
            
            // Rebuild pool to keep track of remaining textures
            var newPool = pool
            
            for item in allTextures {
                if freed >= amount { break }
                let key = item.key
                
                // Find and remove this texture from the newPool
                if var textures = newPool[key] {
                    if let index = textures.firstIndex(where: { $0.texture === item.pooled.texture }) {
                        textures.remove(at: index)
                        newPool[key] = textures
                        freed += item.pooled.estimatedSize
                    }
                }
            }
            
            pool = newPool
            return freed
        }
    }
    
    func clearAll() {
        removeAll()
    }
}
