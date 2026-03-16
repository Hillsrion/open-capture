import Foundation
import CoreImage
import Metal

internal final class TileGPUExecutor {
    private let context: CIContext
    private let device: MTLDevice?
    private let commandQueue: MTLCommandQueue?
    private let tileManager = TileExecutionManager()
    private let colorSpace = CGColorSpaceCreateDeviceRGB()
    private let displayCache = TileResultCache(maxBytes: 256 * 1024 * 1024, maxItems: 512)
    private let renderCache = TileResultCache(maxBytes: 128 * 1024 * 1024, maxItems: 256)
    private var baseTexture: MTLTexture?
    private var workingTexture: MTLTexture?
    private var cachedSize: CGSize = .zero
    private var cachedBaseID: ObjectIdentifier?
    private var pendingBuffer: MTLCommandBuffer?
    
    init(context: CIContext) {
        self.context = context
        self.device = MTLCreateSystemDefaultDevice()
        self.commandQueue = device?.makeCommandQueue()
    }
    
    func render(image: CIImage,
                baseImage: CIImage?,
                viewport: CGRect?,
                fullSize: CGSize,
                overlap: Int? = nil,
                waitForCompletion: Bool = true,
                cacheKey: Int? = nil,
                quality: IC_ProcessQuality? = nil,
                scale: CGFloat = 1) -> CIImage {
        guard let device = device else { return image }
        if let overlap = overlap { tileManager.tileOverlap = overlap }
        let width = max(1, Int(fullSize.width.rounded(.up)))
        let height = max(1, Int(fullSize.height.rounded(.up)))
        
        guard let textures = ensureTextures(device: device, width: width, height: height) else { return image }
        
        if waitForCompletion {
            pendingBuffer?.waitUntilCompleted()
            pendingBuffer = nil
        }
        guard let commandBuffer = commandQueue?.makeCommandBuffer() else { return image }
        
        let fullRect = CGRect(origin: .zero, size: CGSize(width: width, height: height))
        if let baseImage = baseImage {
            let baseID = ObjectIdentifier(baseImage)
            if cachedBaseID != baseID {
                context.render(baseImage,
                               to: textures.base,
                               commandBuffer: commandBuffer,
                               bounds: fullRect,
                               colorSpace: colorSpace)
                cachedBaseID = baseID
            }
            if let blit = commandBuffer.makeBlitCommandEncoder() {
                blit.copy(from: textures.base,
                          sourceSlice: 0,
                          sourceLevel: 0,
                          sourceOrigin: MTLOrigin(x: 0, y: 0, z: 0),
                          sourceSize: MTLSize(width: width, height: height, depth: 1),
                          to: textures.working,
                          destinationSlice: 0,
                          destinationLevel: 0,
                          destinationOrigin: MTLOrigin(x: 0, y: 0, z: 0))
                blit.endEncoding()
            }
            
            let plan = tileManager.planExecution(for: CGSize(width: width, height: height), viewport: viewport)
            for tile in plan.tiles {
                let tileRect = tile.renderRect
                if let cache = cache(for: quality),
                   let cacheKey,
                   let quality,
                   let cached = cache.texture(for: TileResultCache.Key(settingsKey: cacheKey,
                                                                       quality: quality,
                                                                       scale: scale,
                                                                       tile: tile)) {
                    blit(texture: cached,
                         to: textures.working,
                         origin: tileRect.origin,
                         size: tileRect.size,
                         commandBuffer: commandBuffer)
                    continue
                }
                
                guard let tileTexture = makeTileTexture(device: device, size: tileRect.size) else { continue }
                let tileImage = image.cropped(to: tileRect)
                let localImage = tileImage.transformed(by: CGAffineTransform(translationX: -tileRect.origin.x,
                                                                             y: -tileRect.origin.y))
                context.render(localImage,
                               to: tileTexture,
                               commandBuffer: commandBuffer,
                               bounds: CGRect(origin: .zero, size: tileRect.size),
                               colorSpace: colorSpace)
                blit(texture: tileTexture,
                     to: textures.working,
                     origin: tileRect.origin,
                     size: tileRect.size,
                     commandBuffer: commandBuffer)
                
                if let cache = cache(for: quality),
                   let cacheKey,
                   let quality {
                    let cost = TileResultCache.estimateCost(width: Int(tileRect.width), height: Int(tileRect.height))
                    cache.insert(texture: tileTexture,
                                 for: TileResultCache.Key(settingsKey: cacheKey,
                                                          quality: quality,
                                                          scale: scale,
                                                          tile: tile),
                                 cost: cost)
                }
            }
        } else {
            let plan = tileManager.planExecution(for: CGSize(width: width, height: height), viewport: nil)
            for tile in plan.tiles {
                let tileRect = tile.renderRect
                if let cache = cache(for: quality),
                   let cacheKey,
                   let quality,
                   let cached = cache.texture(for: TileResultCache.Key(settingsKey: cacheKey,
                                                                       quality: quality,
                                                                       scale: scale,
                                                                       tile: tile)) {
                    blit(texture: cached,
                         to: textures.base,
                         origin: tileRect.origin,
                         size: tileRect.size,
                         commandBuffer: commandBuffer)
                    continue
                }
                
                guard let tileTexture = makeTileTexture(device: device, size: tileRect.size) else { continue }
                let tileImage = image.cropped(to: tileRect)
                let localImage = tileImage.transformed(by: CGAffineTransform(translationX: -tileRect.origin.x,
                                                                             y: -tileRect.origin.y))
                context.render(localImage,
                               to: tileTexture,
                               commandBuffer: commandBuffer,
                               bounds: CGRect(origin: .zero, size: tileRect.size),
                               colorSpace: colorSpace)
                blit(texture: tileTexture,
                     to: textures.base,
                     origin: tileRect.origin,
                     size: tileRect.size,
                     commandBuffer: commandBuffer)
                
                if let cache = cache(for: quality),
                   let cacheKey,
                   let quality {
                    let cost = TileResultCache.estimateCost(width: Int(tileRect.width), height: Int(tileRect.height))
                    cache.insert(texture: tileTexture,
                                 for: TileResultCache.Key(settingsKey: cacheKey,
                                                          quality: quality,
                                                          scale: scale,
                                                          tile: tile),
                                 cost: cost)
                }
            }
            if let blit = commandBuffer.makeBlitCommandEncoder() {
                blit.copy(from: textures.base,
                          sourceSlice: 0,
                          sourceLevel: 0,
                          sourceOrigin: MTLOrigin(x: 0, y: 0, z: 0),
                          sourceSize: MTLSize(width: width, height: height, depth: 1),
                          to: textures.working,
                          destinationSlice: 0,
                          destinationLevel: 0,
                          destinationOrigin: MTLOrigin(x: 0, y: 0, z: 0))
                blit.endEncoding()
            }
        }
        
        commandBuffer.commit()
        if waitForCompletion {
            commandBuffer.waitUntilCompleted()
        } else {
            pendingBuffer = commandBuffer
        }
        
        if baseImage == nil {
            guard let outputImage = CIImage(mtlTexture: textures.base, options: [.colorSpace: colorSpace]) else {
                return image
            }
            cachedBaseID = ObjectIdentifier(outputImage)
            return outputImage.cropped(to: fullRect)
        }
        
        guard let outputImage = CIImage(mtlTexture: textures.working, options: [.colorSpace: colorSpace]) else {
            return image
        }
        return outputImage.cropped(to: fullRect)
    }
    
    func renderTiles(baseImage: CIImage?,
                     viewport: CGRect?,
                     fullSize: CGSize,
                     overlap: Int? = nil,
                     waitForCompletion: Bool = true,
                     cacheKey: Int? = nil,
                     quality: IC_ProcessQuality? = nil,
                     scale: CGFloat = 1,
                     tileProvider: (CGRect) -> CIImage) -> CIImage {
        guard let device = device else { return CIImage.empty() }
        if let overlap = overlap { tileManager.tileOverlap = overlap }
        let width = max(1, Int(fullSize.width.rounded(.up)))
        let height = max(1, Int(fullSize.height.rounded(.up)))
        
        guard let textures = ensureTextures(device: device, width: width, height: height) else { return CIImage.empty() }
        
        if waitForCompletion {
            pendingBuffer?.waitUntilCompleted()
            pendingBuffer = nil
        }
        guard let commandBuffer = commandQueue?.makeCommandBuffer() else { return CIImage.empty() }
        
        let fullRect = CGRect(origin: .zero, size: CGSize(width: width, height: height))
        if let baseImage = baseImage {
            let baseID = ObjectIdentifier(baseImage)
            if cachedBaseID != baseID {
                context.render(baseImage,
                               to: textures.base,
                               commandBuffer: commandBuffer,
                               bounds: fullRect,
                               colorSpace: colorSpace)
                cachedBaseID = baseID
            }
            if let blit = commandBuffer.makeBlitCommandEncoder() {
                blit.copy(from: textures.base,
                          sourceSlice: 0,
                          sourceLevel: 0,
                          sourceOrigin: MTLOrigin(x: 0, y: 0, z: 0),
                          sourceSize: MTLSize(width: width, height: height, depth: 1),
                          to: textures.working,
                          destinationSlice: 0,
                          destinationLevel: 0,
                          destinationOrigin: MTLOrigin(x: 0, y: 0, z: 0))
                blit.endEncoding()
            }
            
            let plan = tileManager.planExecution(for: CGSize(width: width, height: height), viewport: viewport)
            for tile in plan.tiles {
                let tileRect = tile.renderRect
                if let cache = cache(for: quality),
                   let cacheKey,
                   let quality,
                   let cached = cache.texture(for: TileResultCache.Key(settingsKey: cacheKey,
                                                                       quality: quality,
                                                                       scale: scale,
                                                                       tile: tile)) {
                    blit(texture: cached,
                         to: textures.working,
                         origin: tileRect.origin,
                         size: tileRect.size,
                         commandBuffer: commandBuffer)
                    continue
                }
                
                guard let tileTexture = makeTileTexture(device: device, size: tileRect.size) else { continue }
                let tileImage = tileProvider(tileRect)
                let localImage = tileImage.transformed(by: CGAffineTransform(translationX: -tileRect.origin.x,
                                                                             y: -tileRect.origin.y))
                context.render(localImage,
                               to: tileTexture,
                               commandBuffer: commandBuffer,
                               bounds: CGRect(origin: .zero, size: tileRect.size),
                               colorSpace: colorSpace)
                blit(texture: tileTexture,
                     to: textures.working,
                     origin: tileRect.origin,
                     size: tileRect.size,
                     commandBuffer: commandBuffer)
                
                if let cache = cache(for: quality),
                   let cacheKey,
                   let quality {
                    let cost = TileResultCache.estimateCost(width: Int(tileRect.width), height: Int(tileRect.height))
                    cache.insert(texture: tileTexture,
                                 for: TileResultCache.Key(settingsKey: cacheKey,
                                                          quality: quality,
                                                          scale: scale,
                                                          tile: tile),
                                 cost: cost)
                }
            }
        } else {
            let plan = tileManager.planExecution(for: CGSize(width: width, height: height), viewport: nil)
            for tile in plan.tiles {
                let tileRect = tile.renderRect
                if let cache = cache(for: quality),
                   let cacheKey,
                   let quality,
                   let cached = cache.texture(for: TileResultCache.Key(settingsKey: cacheKey,
                                                                       quality: quality,
                                                                       scale: scale,
                                                                       tile: tile)) {
                    blit(texture: cached,
                         to: textures.base,
                         origin: tileRect.origin,
                         size: tileRect.size,
                         commandBuffer: commandBuffer)
                    continue
                }
                
                guard let tileTexture = makeTileTexture(device: device, size: tileRect.size) else { continue }
                let tileImage = tileProvider(tileRect)
                let localImage = tileImage.transformed(by: CGAffineTransform(translationX: -tileRect.origin.x,
                                                                             y: -tileRect.origin.y))
                context.render(localImage,
                               to: tileTexture,
                               commandBuffer: commandBuffer,
                               bounds: CGRect(origin: .zero, size: tileRect.size),
                               colorSpace: colorSpace)
                blit(texture: tileTexture,
                     to: textures.base,
                     origin: tileRect.origin,
                     size: tileRect.size,
                     commandBuffer: commandBuffer)
                
                if let cache = cache(for: quality),
                   let cacheKey,
                   let quality {
                    let cost = TileResultCache.estimateCost(width: Int(tileRect.width), height: Int(tileRect.height))
                    cache.insert(texture: tileTexture,
                                 for: TileResultCache.Key(settingsKey: cacheKey,
                                                          quality: quality,
                                                          scale: scale,
                                                          tile: tile),
                                 cost: cost)
                }
            }
            if let blit = commandBuffer.makeBlitCommandEncoder() {
                blit.copy(from: textures.base,
                          sourceSlice: 0,
                          sourceLevel: 0,
                          sourceOrigin: MTLOrigin(x: 0, y: 0, z: 0),
                          sourceSize: MTLSize(width: width, height: height, depth: 1),
                          to: textures.working,
                          destinationSlice: 0,
                          destinationLevel: 0,
                          destinationOrigin: MTLOrigin(x: 0, y: 0, z: 0))
                blit.endEncoding()
            }
        }
        
        commandBuffer.commit()
        if waitForCompletion {
            commandBuffer.waitUntilCompleted()
        } else {
            pendingBuffer = commandBuffer
        }
        
        guard let outputImage = CIImage(mtlTexture: baseImage == nil ? textures.base : textures.working,
                                        options: [.colorSpace: colorSpace]) else {
            return CIImage.empty()
        }
        return outputImage.cropped(to: fullRect)
    }

    private func ensureTextures(device: MTLDevice, width: Int, height: Int) -> (base: MTLTexture, working: MTLTexture)? {
        if let baseTexture = baseTexture,
           let workingTexture = workingTexture,
           cachedSize.width == CGFloat(width),
           cachedSize.height == CGFloat(height) {
            return (base: baseTexture, working: workingTexture)
        }
        
        let descriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .rgba16Float,
                                                                  width: width,
                                                                  height: height,
                                                                  mipmapped: false)
        descriptor.usage = [.shaderRead, .shaderWrite, .renderTarget]
        guard let base = device.makeTexture(descriptor: descriptor),
              let working = device.makeTexture(descriptor: descriptor) else { return nil }
        baseTexture = base
        workingTexture = working
        cachedSize = CGSize(width: width, height: height)
        cachedBaseID = nil
        return (base: base, working: working)
    }
    
    private func cache(for quality: IC_ProcessQuality?) -> TileResultCache? {
        guard let quality else { return nil }
        switch quality {
        case .display: return displayCache
        case .render: return renderCache
        case .export: return nil
        }
    }
    
    private func makeTileTexture(device: MTLDevice, size: CGSize) -> MTLTexture? {
        let width = max(1, Int(size.width.rounded(.up)))
        let height = max(1, Int(size.height.rounded(.up)))
        let descriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .rgba16Float,
                                                                  width: width,
                                                                  height: height,
                                                                  mipmapped: false)
        descriptor.usage = [.shaderRead, .shaderWrite, .renderTarget]
        return device.makeTexture(descriptor: descriptor)
    }
    
    private func blit(texture: MTLTexture,
                      to target: MTLTexture,
                      origin: CGPoint,
                      size: CGSize,
                      commandBuffer: MTLCommandBuffer) {
        guard let blit = commandBuffer.makeBlitCommandEncoder() else { return }
        let sourceOrigin = MTLOrigin(x: 0, y: 0, z: 0)
        let destinationOrigin = MTLOrigin(x: max(0, Int(origin.x.rounded(.down))),
                                          y: max(0, Int(origin.y.rounded(.down))),
                                          z: 0)
        let copySize = MTLSize(width: max(1, Int(size.width.rounded(.up))),
                               height: max(1, Int(size.height.rounded(.up))),
                               depth: 1)
        blit.copy(from: texture,
                  sourceSlice: 0,
                  sourceLevel: 0,
                  sourceOrigin: sourceOrigin,
                  sourceSize: copySize,
                  to: target,
                  destinationSlice: 0,
                  destinationLevel: 0,
                  destinationOrigin: destinationOrigin)
        blit.endEncoding()
    }
}
