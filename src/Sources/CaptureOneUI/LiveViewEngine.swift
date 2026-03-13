import SwiftUI
import AppKit
import AppCoreShared

/// Reconstructed high-fidelity Live View engine (TETH-001).
/// Based on disassembly of startLiveView and getNextLiveViewImage.
public class LiveViewEngine: ObservableObject {
    public static let shared = LiveViewEngine()
    
    @Published public var currentFrame: NSImage?
    @Published public var isActive: Bool = false
    @Published public var currentCamera: P1CaptureCore_Camera?
    
    private var frameLoop: LiveViewFrameLoop?
    
    private init() {}
    
    public func start(for camera: P1CaptureCore_Camera) {
        print("[LiveView] Starting engine for \(camera.name)")
        self.currentCamera = camera
        isActive = true

        // Reconstructed Phase 2 Task: High-speed fetching loop
        frameLoop = LiveViewFrameLoop(camera: camera) { [weak self] frame in
            self?.currentFrame = frame
        }

        camera.startLiveView()
        frameLoop?.start()

        // Ensure Live View window opens
        DispatchQueue.main.async {
            AppCommandCenter.shared.openLivePreview()
        }
    }    
    public func stop() {
        print("[LiveView] Stopping engine")
        isActive = false
        frameLoop?.stop()
        frameLoop = nil
        currentFrame = nil
        currentCamera?.stopLiveView()
        currentCamera = nil
    }
}
