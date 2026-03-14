import Foundation
import Metal

/// Reconstructed Metal-based GPU coordinator for ImageCore.
/// Based on mtlpp patterns and disassembly of GPUParameters.
public class ImageCoreGPU {
    
    public static let shared = ImageCoreGPU()
    
    @Published public var device: MTLDevice?
    public let commandQueue: MTLCommandQueue?
    private var library: MTLLibrary?
    private var pipelineCache: [String: MTLComputePipelineState] = [:]
    
    private init() {
        self.device = MTLCreateSystemDefaultDevice()
        self.commandQueue = self.device?.makeCommandQueue()
        loadCaptureOneLibrary()
    }
    
    private func loadCaptureOneLibrary() {
        guard let device = device else { return }
        let bundle = Bundle.module // In SPM, resources are accessed via Bundle.module
        if let url = bundle.url(forResource: "captureone", withExtension: "metallib") {
            do {
                self.library = try device.makeLibrary(URL: url)
                print("[ImageCoreGPU] Successfully loaded original C1 Metal library.")
            } catch {
                print("[ImageCoreGPU] Error loading C1 library: \(error)")
            }
        } else {
            print("[ImageCoreGPU] Warning: captureone.metallib not found. Falling back to default.")
            self.library = device.makeDefaultLibrary()
        }
    }
    
    /// Reconstructed kernel dispatching logic.
    public func dispatchKernel(name: String, inputs: [MTLBuffer], output: MTLBuffer, threads: MTLSize) {
        guard let device = device, 
              let commandQueue = commandQueue,
              let pipeline = getPipelineState(for: name) else { return }
        
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
              let encoder = commandBuffer.makeComputeCommandEncoder() else { return }
        
        encoder.setComputePipelineState(pipeline)
        
        for (index, buffer) in inputs.enumerated() {
            encoder.setBuffer(buffer, offset: 0, index: index)
        }
        encoder.setBuffer(output, offset: 0, index: inputs.count)
        
        let threadgroupSize = MTLSize(width: 16, height: 16, depth: 1)
        let threadgroups = MTLSize(width: (threads.width + threadgroupSize.width - 1) / threadgroupSize.width,
                                   height: (threads.height + threadgroupSize.height - 1) / threadgroupSize.height,
                                   depth: 1)
        
        encoder.dispatchThreadgroups(threadgroups, threadsPerThreadgroup: threadgroupSize)
        encoder.endEncoding()
        commandBuffer.commit()
    }
    
    private func getPipelineState(for kernelName: String) -> MTLComputePipelineState? {
        if let cached = pipelineCache[kernelName] {
            return cached
        }
        
        guard let device = device, let library = library else { return nil }
        
        // 1. Load function from original C1 library
        guard let function = library.makeFunction(name: kernelName) else {
            print("[ImageCoreGPU] Failed to find kernel: \(kernelName)")
            return nil
        }
        
        // 3. Create pipeline state
        do {
            let pipeline = try device.makeComputePipelineState(function: function)
            pipelineCache[kernelName] = pipeline
            return pipeline
        } catch {
            print("[ImageCoreGPU] Failed to create pipeline state for \(kernelName): \(error)")
            return nil
        }
    }
}

/// Reconstructed Image Buffer for GPU tasks.
public class CImageBuffer {
    public let buffer: MTLBuffer?
    public let size: CGSize
    public let pixelFormat: UInt32
    
    public init(device: MTLDevice, size: CGSize, format: UInt32) {
        self.size = size
        self.pixelFormat = format
        let length = Int(size.width * size.height) * 4 // Assuming 4 bytes per pixel for now
        self.buffer = device.makeBuffer(length: length, options: .storageModeShared)
    }
}
