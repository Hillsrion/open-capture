import Foundation
import Metal

/// Tracks GPU memory pressure and trims tile caches accordingly.
internal final class VRAMMonitor {
    private let device: MTLDevice?
    private weak var displayCache: TileResultCache?
    private weak var renderCache: TileResultCache?
    private let queue = DispatchQueue(label: "ImageCore.VRAMMonitor")
    private var pressureSource: DispatchSourceMemoryPressure?
    private let onCritical: (() -> Void)?
    private let onWarning: (() -> Void)?
    
    init(device: MTLDevice?,
         displayCache: TileResultCache,
         renderCache: TileResultCache,
         onWarning: (() -> Void)? = nil,
         onCritical: (() -> Void)? = nil) {
        self.device = device
        self.displayCache = displayCache
        self.renderCache = renderCache
        self.onCritical = onCritical
        self.onWarning = onWarning
        setupPressureSource()
    }
    
    func enforceBudgets() {
        guard let device else { return }
        let recommended = Int(device.recommendedMaxWorkingSetSize)
        let budget = recommended > 0 ? Int(Double(recommended) * 0.6) : 512 * 1024 * 1024
        let allocated = Int(device.currentAllocatedSize)
        let displayBytes = displayCache?.usageBytes() ?? 0
        let renderBytes = renderCache?.usageBytes() ?? 0
        
        if allocated > budget {
            trimCaches(factor: 0.5)
        } else if allocated > Int(Double(budget) * 0.85) {
            trimCaches(factor: 0.75)
        } else if (displayBytes + renderBytes) > Int(Double(budget) * 0.35) {
            trimCaches(factor: 0.9)
        }
    }
    
    private func setupPressureSource() {
        let source = DispatchSource.makeMemoryPressureSource(eventMask: [.warning, .critical], queue: queue)
        source.setEventHandler { [weak self] in
            guard let self else { return }
            let event = source.data
            if event.contains(.critical) {
                self.displayCache?.removeAll()
                self.renderCache?.removeAll()
                self.onCritical?()
            } else if event.contains(.warning) {
                self.trimCaches(factor: 0.5)
                self.onWarning?()
            }
        }
        source.resume()
        pressureSource = source
    }
    
    private func trimCaches(factor: Double) {
        let displayTarget = Int(Double(displayCache?.usageBytes() ?? 0) * factor)
        let renderTarget = Int(Double(renderCache?.usageBytes() ?? 0) * factor)
        displayCache?.trim(toBytes: displayTarget)
        renderCache?.trim(toBytes: renderTarget)
    }
}
