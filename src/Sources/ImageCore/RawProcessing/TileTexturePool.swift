import Foundation
import Metal

/// Reuses temporary tile textures to avoid per-tile allocations.
internal final class TileTexturePool {
    private struct TextureKey: Hashable {
        let width: Int
        let height: Int
    }
    
    private let queue = DispatchQueue(label: "ImageCore.TileTexturePool")
    private var pool: [TextureKey: [MTLTexture]] = [:]
    
    func acquire(device: MTLDevice, size: CGSize) -> MTLTexture? {
        let width = max(1, Int(size.width.rounded(.up)))
        let height = max(1, Int(size.height.rounded(.up)))
        let key = TextureKey(width: width, height: height)
        if let texture = queue.sync(execute: { pool[key]?.popLast() }) {
            return texture
        }
        let descriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .rgba16Float,
                                                                  width: width,
                                                                  height: height,
                                                                  mipmapped: false)
        descriptor.usage = [.shaderRead, .shaderWrite, .renderTarget]
        return device.makeTexture(descriptor: descriptor)
    }
    
    func release(_ texture: MTLTexture) {
        let key = TextureKey(width: texture.width, height: texture.height)
        queue.sync {
            pool[key, default: []].append(texture)
        }
    }
    
    func removeAll() {
        queue.sync {
            pool.removeAll()
        }
    }
}
