import Foundation
import CoreGraphics
import ImageCore

/// Coalesces render requests into display (throttled) and final (debounced) passes.
final class RenderCoalescer: ObservableObject {
    private let throttleInterval: TimeInterval
    private let debounceInterval: TimeInterval
    private var lastDisplayTime: TimeInterval = 0
    private var pendingFinal: DispatchWorkItem?
    private var lastViewport: CGRect = .zero
    
    init(throttleInterval: TimeInterval = 0.033, debounceInterval: TimeInterval = 0.1) {
        self.throttleInterval = throttleInterval
        self.debounceInterval = debounceInterval
    }
    
    func submit(settings: IC_ProcessSettings,
                viewport: CGRect,
                isInteracting: Bool,
                render: @escaping (IC_ProcessSettings, IC_ProcessQuality) -> Void) {
        let now = Date().timeIntervalSinceReferenceDate
        let viewportChanged = viewport != lastViewport
        lastViewport = viewport
        
        let needsDisplay = isInteracting || viewportChanged
        if needsDisplay {
            if now - lastDisplayTime >= throttleInterval {
                lastDisplayTime = now
                render(settings, .display)
            }
            
            pendingFinal?.cancel()
            let work = DispatchWorkItem {
                render(settings, .render)
            }
            pendingFinal = work
            DispatchQueue.main.asyncAfter(deadline: .now() + debounceInterval, execute: work)
        } else {
            pendingFinal?.cancel()
            render(settings, .render)
        }
    }
}
