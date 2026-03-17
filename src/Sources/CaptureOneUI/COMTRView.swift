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

            // Calculate aspect fit scale to avoid stretching (UI-015)
            let viewSize = view.drawableSize
            let imageSize = image.extent.size

            let scaleX = viewSize.width / imageSize.width
            let scaleY = viewSize.height / imageSize.height
            let scale = min(scaleX, scaleY)

            // Scaled size
            let scaledWidth = imageSize.width * scale
            let scaledHeight = imageSize.height * scale

            // Center in the drawable
            let xOffset = (viewSize.width - scaledWidth) / 2
            let yOffset = (viewSize.height - scaledHeight) / 2

            // Create a transform that centers and scales the image correctly
            let transform = CGAffineTransform(scaleX: scale, y: scale)
                .concatenating(CGAffineTransform(translationX: xOffset, y: yOffset))

            let centeredImage = image.transformed(by: transform)

            // Clear the background before rendering the image to avoid ghosting
            let clearColor = CIColor(red: 0.1, green: 0.1, blue: 0.1)
            let background = CIImage(color: clearColor).cropped(to: CGRect(origin: .zero, size: viewSize))
            let finalOutput = centeredImage.composited(over: background)

            // Render directly from CIImage to Metal Texture (Zero CPU readback)
            context.render(finalOutput,
                           to: drawable.texture,
                           commandBuffer: commandBuffer,
                           bounds: CGRect(origin: .zero, size: viewSize),
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
