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
    private let tilePool: TileTexturePool
    private let vramMonitor: VRAMMonitor
    private var baseTexture: MTLTexture?
    private var workingTexture: MTLTexture?
    private var cachedSize: CGSize = .zero
    private var cachedBaseID: ObjectIdentifier?
    private var pendingBuffer: MTLCommandBuffer?
    private var currentGenerationToken = UUID()
    private let submissionQueue = DispatchQueue(label: "com.imagecore.tilegpu.submission")
    private let frameGate = DispatchSemaphore(value: 3)
    
    init(context: CIContext) {
        let pool = TileTexturePool()
        self.context = context
        self.device = MTLCreateSystemDefaultDevice()
        self.commandQueue = device?.makeCommandQueue()
        self.tilePool = pool
        self.vramMonitor = VRAMMonitor.shared
    }
    
    func render(image: CIImage,
                baseImage: CIImage?,
                viewport: CGRect?,
                fullSize: CGSize,
                overlap: Int? = nil,
                waitForCompletion: Bool = true,
                cacheKey: Int? = nil,
                quality: IC_ProcessQuality? = nil,
                scale: CGFloat = 1,
                operationKey: Int = 0) -> CIImage {
        return renderTiles(baseImage: baseImage,
                           viewport: viewport,
                           fullSize: fullSize,
                           overlap: overlap,
                           waitForCompletion: waitForCompletion,
                           settingsKeyProvider: { _ in cacheKey ?? 0 },
                           quality: quality,
                           scale: scale,
                           operationKey: operationKey,
                           sourceImage: image,
                           stageProvider: { stage, rect, input in
                                if stage == .precolor {
                                    return image.cropped(to: rect)
                                }
                                return input
                           })
    }
    
    func renderTiles(baseImage: CIImage?,
                     viewport: CGRect?,
                     fullSize: CGSize,
                     overlap: Int? = nil,
                     waitForCompletion: Bool = true,
                     settingsKeyProvider: ((TileStage) -> Int)? = nil,
                     quality: IC_ProcessQuality? = nil,
                     scale: CGFloat = 1,
                     operationKey: Int = 0,
                     sourceImage: CIImage? = nil,
                     stageProvider: @escaping (TileStage, CGRect, CIImage) -> CIImage) -> CIImage {
        guard let device = device else { return CIImage.empty() }
        if let overlap = overlap { tileManager.tileOverlap = overlap }
        let width = max(1, Int(fullSize.width.rounded(.up)))
        let height = max(1, Int(fullSize.height.rounded(.up)))
        
        guard let textures = ensureTextures(device: device, width: width, height: height) else { return CIImage.empty() }
        vramMonitor.checkBudget(currentUsage: displayCache.usageBytes() + renderCache.usageBytes())
        
        let generationToken = UUID()
        self.currentGenerationToken = generationToken
        
        if waitForCompletion {
            pendingBuffer?.waitUntilCompleted()
            pendingBuffer = nil
        }
        
        let fullRect = CGRect(origin: .zero, size: CGSize(width: width, height: height))
        let plan = tileManager.planExecution(for: fullRect.size, viewport: baseImage == nil ? nil : viewport)
        let tiles = plan.tiles
        let batches = stride(from: 0, to: tiles.count, by: 6).map {
            Array(tiles[$0..<min($0 + 6, tiles.count)])
        }
        
        let work = { [weak self] in
            guard let self = self else { return }
            
            if let baseImage = baseImage {
                self.frameGate.wait()
                guard self.currentGenerationToken == generationToken else {
                    self.frameGate.signal()
                    return
                }
                
                if let cb = self.commandQueue?.makeCommandBuffer() {
                    let baseID = ObjectIdentifier(baseImage)
                    if self.cachedBaseID != baseID {
                        self.context.render(baseImage, to: textures.base, commandBuffer: cb, bounds: fullRect, colorSpace: self.colorSpace)
                        self.cachedBaseID = baseID
                    }
                    if let blit = cb.makeBlitCommandEncoder() {
                        blit.copy(from: textures.base,
                                  sourceSlice: 0, sourceLevel: 0, sourceOrigin: .init(x: 0, y: 0, z: 0),
                                  sourceSize: .init(width: width, height: height, depth: 1),
                                  to: textures.working,
                                  destinationSlice: 0, destinationLevel: 0, destinationOrigin: .init(x: 0, y: 0, z: 0))
                        blit.endEncoding()
                    }
                    cb.addCompletedHandler { _ in self.frameGate.signal() }
                    cb.commit()
                    if waitForCompletion { 
                        cb.waitUntilCompleted() 
                    } else {
                        self.pendingBuffer = cb
                    }
                } else {
                    self.frameGate.signal()
                }
            }
            
            let target = baseImage == nil ? textures.base : textures.working
            for batch in batches {
                self.frameGate.wait()
                guard self.currentGenerationToken == generationToken else {
                    self.frameGate.signal()
                    return
                }
                
                guard let cb = self.commandQueue?.makeCommandBuffer() else {
                    self.frameGate.signal()
                    return
                }
                
                for tile in batch {
                    let tileRect = tile.renderRect
                    var currentTileTexture: MTLTexture? = nil
                    var currentInputImage: CIImage? = sourceImage?.cropped(to: tileRect)
                        .transformed(by: CGAffineTransform(translationX: -tileRect.origin.x, y: -tileRect.origin.y))
                    
                    let cache = self.cache(for: quality)
                    
                    for stage in TileStage.allCases {
                        let sKey = settingsKeyProvider?(stage) ?? 0
                        let key = TileResultCache.Key(settingsKey: sKey,
                                                      quality: quality ?? .display,
                                                      scale: scale,
                                                      operationKey: operationKey,
                                                      tile: tile,
                                                      stage: stage)
                        
                        if let cached = cache?.texture(for: key) {
                            currentTileTexture = cached
                            currentInputImage = CIImage(mtlTexture: cached, options: [.colorSpace: self.colorSpace])
                        } else {
                            guard let stageTexture = self.tilePool.acquire(device: device, size: tileRect.size) else { break }
                            let stageInput = currentInputImage ?? CIImage.empty()
                            let stageOutput = stageProvider(stage, tileRect, stageInput)
                            
                            self.context.render(stageOutput,
                                                to: stageTexture,
                                                commandBuffer: cb,
                                                bounds: CGRect(origin: .zero, size: tileRect.size),
                                                colorSpace: self.colorSpace)
                            
                            if let cache = cache, settingsKeyProvider != nil {
                                let cost = TileResultCache.estimateCost(width: Int(tileRect.width), height: Int(tileRect.height))
                                cache.insert(texture: stageTexture, for: key, cost: cost)
                            } else {
                                if stage == TileStage.allCases.last {
                                    cb.addCompletedHandler { _ in self.tilePool.release(stageTexture) }
                                }
                            }
                            
                            currentTileTexture = stageTexture
                            currentInputImage = CIImage(mtlTexture: stageTexture, options: [.colorSpace: self.colorSpace])
                        }
                    }
                    
                    if let finalTexture = currentTileTexture {
                        self.blit(texture: finalTexture, to: target, origin: tileRect.origin, size: tileRect.size, commandBuffer: cb)
                    }
                }
                
                cb.addCompletedHandler { _ in self.frameGate.signal() }
                cb.commit()
                if waitForCompletion { 
                    cb.waitUntilCompleted() 
                } else {
                    self.pendingBuffer = cb
                }
            }
            
            if baseImage == nil {
                self.frameGate.wait()
                guard self.currentGenerationToken == generationToken else {
                    self.frameGate.signal()
                    return
                }
                if let cb = self.commandQueue?.makeCommandBuffer() {
                    if let blit = cb.makeBlitCommandEncoder() {
                        blit.copy(from: textures.base,
                                  sourceSlice: 0, sourceLevel: 0, sourceOrigin: .init(x: 0, y: 0, z: 0),
                                  sourceSize: .init(width: width, height: height, depth: 1),
                                  to: textures.working,
                                  destinationSlice: 0, destinationLevel: 0, destinationOrigin: .init(x: 0, y: 0, z: 0))
                        blit.endEncoding()
                    }
                    cb.addCompletedHandler { _ in self.frameGate.signal() }
                    cb.commit()
                    if waitForCompletion { 
                        cb.waitUntilCompleted() 
                    } else {
                        self.pendingBuffer = cb
                    }
                } else {
                    self.frameGate.signal()
                }
            }
        }
        
        if waitForCompletion {
            work()
        } else {
            submissionQueue.async(execute: work)
        }
        
        guard let outputImage = CIImage(mtlTexture: baseImage == nil ? textures.base : textures.working,
                                        options: [.colorSpace: colorSpace]) else {
            return CIImage.empty()
        }
        if baseImage == nil {
            cachedBaseID = ObjectIdentifier(outputImage)
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
