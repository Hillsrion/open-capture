import Foundation
import CoreImage
import Metal

internal final class TileGPUExecutor {
    private let context: CIContext
    private let device: MTLDevice?
    private let commandQueue: MTLCommandQueue?
    private let tileManager = TileExecutionManager()
    private let colorSpace = CGColorSpaceCreateDeviceRGB()
    
    init(context: CIContext) {
        self.context = context
        self.device = MTLCreateSystemDefaultDevice()
        self.commandQueue = device?.makeCommandQueue()
    }
    
    func render(image: CIImage,
                baseImage: CIImage?,
                viewport: CGRect?,
                fullSize: CGSize) -> CIImage {
        guard let device = device else { return image }
        let width = max(1, Int(fullSize.width))
        let height = max(1, Int(fullSize.height))
        
        let descriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .rgba16Float,
                                                                  width: width,
                                                                  height: height,
                                                                  mipmapped: false)
        descriptor.usage = [.shaderRead, .shaderWrite, .renderTarget]
        guard let texture = device.makeTexture(descriptor: descriptor) else { return image }
        
        guard let commandBuffer = commandQueue?.makeCommandBuffer() else { return image }
        
        let fullRect = CGRect(origin: .zero, size: fullSize)
        if let baseImage = baseImage {
            context.render(baseImage, to: texture, commandBuffer: commandBuffer, bounds: fullRect, colorSpace: colorSpace)
        }
        
        let plan = tileManager.planExecution(for: fullSize, viewport: viewport)
        for tile in plan.tiles {
            let tileRect = tile.rect
            let tileImage = image.cropped(to: tileRect)
            context.render(tileImage, to: texture, commandBuffer: commandBuffer, bounds: tileRect, colorSpace: colorSpace)
        }
        
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
        
        guard let outputImage = CIImage(mtlTexture: texture, options: [.colorSpace: colorSpace]) else {
            return image
        }
        
        return outputImage.cropped(to: fullRect)
    }
}
