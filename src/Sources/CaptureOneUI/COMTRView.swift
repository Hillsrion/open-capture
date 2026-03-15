import SwiftUI
import MetalKit
import CoreImage

public struct COMTRView: NSViewRepresentable {
    private static let sharedDevice = MTLCreateSystemDefaultDevice()
    public static var supportsMetal: Bool { sharedDevice != nil }
    public var image: CIImage?
    
    public init(image: CIImage?) {
        self.image = image
    }
    
    public class Coordinator: NSObject, MTKViewDelegate {
        var image: CIImage?
        let commandQueue: MTLCommandQueue?
        let context: CIContext
        
        init(device: MTLDevice?) {
            self.commandQueue = device?.makeCommandQueue()
            
            // Setting workingFormat to .RGBAh (16-bit float) for high-precision live viewer
            let options: [CIContextOption: Any] = [
                .workingFormat: CIFormat.RGBAh,
                .workingColorSpace: CGColorSpaceCreateDeviceRGB(),
                .cacheIntermediates: false,
                .useSoftwareRenderer: false
            ]
            
            if let device = device {
                self.context = CIContext(mtlDevice: device, options: options)
            } else {
                var softwareOptions = options
                softwareOptions[.useSoftwareRenderer] = true
                self.context = CIContext(options: softwareOptions)
            }
            super.init()
        }
        
        public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
        
        public func draw(in view: MTKView) {
            guard let image = image,
                  let drawable = view.currentDrawable,
                  let commandBuffer = commandQueue?.makeCommandBuffer() else {
                return
            }
            
            // Calculate aspect fit scale
            let scaleX = view.drawableSize.width / image.extent.width
            let scaleY = view.drawableSize.height / image.extent.height
            let scale = min(scaleX, scaleY)
            
            // Scale
            let scaledImage = image.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
            
            // Center
            let xOffset = (view.drawableSize.width - scaledImage.extent.width) / 2
            let yOffset = (view.drawableSize.height - scaledImage.extent.height) / 2
            let centeredImage = scaledImage.transformed(by: CGAffineTransform(translationX: xOffset, y: yOffset))
            
            // Render directly from CIImage to Metal Texture (Zero CPU readback)
            context.render(centeredImage,
                           to: drawable.texture,
                           commandBuffer: commandBuffer,
                           bounds: CGRect(origin: .zero, size: view.drawableSize),
                           colorSpace: CGColorSpaceCreateDeviceRGB())
                           
            commandBuffer.present(drawable)
            commandBuffer.commit()
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(device: Self.sharedDevice)
    }
    
    public func makeNSView(context: Context) -> MTKView {
        let mtkView = MTKView()
        mtkView.device = Self.sharedDevice
        mtkView.delegate = context.coordinator
        mtkView.framebufferOnly = false // Required for CoreImage CIContext rendering
        mtkView.clearColor = MTLClearColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        mtkView.enableSetNeedsDisplay = true
        mtkView.isPaused = true
        return mtkView
    }
    
    public func updateNSView(_ nsView: MTKView, context: Context) {
        context.coordinator.image = image
        nsView.setNeedsDisplay(nsView.bounds)
    }
}
