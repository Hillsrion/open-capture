import Foundation
import CoreVideo
import AppKit
import AppCoreShared

/// Reconstructed high-speed frame loop for Live View (TETH-002).
/// Uses CVDisplayLink for smooth rendering and high-priority fetching.
public class LiveViewFrameLoop {
    private var displayLink: CVDisplayLink?
    private let camera: P1CaptureCore_Camera
    private let frameHandler: (NSImage) -> Void
    
    private var isRunning: Bool = false
    
    public init(camera: P1CaptureCore_Camera, frameHandler: @escaping (NSImage) -> Void) {
        self.camera = camera
        self.frameHandler = frameHandler
        setupDisplayLink()
    }
    
    private func setupDisplayLink() {
        var link: CVDisplayLink?
        let result = CVDisplayLinkCreateWithActiveCGDisplays(&link)
        
        guard result == kCVReturnSuccess, let displayLink = link else {
            print("[LiveView] Failed to create CVDisplayLink")
            return
        }
        
        self.displayLink = displayLink
        
        let callback: CVDisplayLinkOutputCallback = { (displayLink, inNow, inOutputTime, flagsIn, flagsOut, displayLinkContext) -> CVReturn in
            let loop = Unmanaged<LiveViewFrameLoop>.fromOpaque(displayLinkContext!).takeUnretainedValue()
            loop.tick()
            return kCVReturnSuccess
        }
        
        CVDisplayLinkSetOutputCallback(displayLink, callback, Unmanaged.passUnretained(self).toOpaque())
    }
    
    public func start() {
        guard let displayLink = displayLink, !isRunning else { return }
        CVDisplayLinkStart(displayLink)
        isRunning = true
    }
    
    public func stop() {
        guard let displayLink = displayLink, isRunning else { return }
        CVDisplayLinkStop(displayLink)
        isRunning = false
    }
    
    private func tick() {
        // High-priority fetch
        guard camera.liveViewState == .active else { return }
        
        // Reconstructed logic: Pull the next image model
        if let liveImage = camera.getNextLiveViewImage() {
            // Reconstructed frame conversion (TETH-002)
            // In the real app, this converts the raw buffer from ILiveViewImage
            // to a displayable NSImage or CGImage.
            let displayImage: NSImage
            if let data = liveImage.imageData, let nsImage = NSImage(data: data) {
                displayImage = nsImage
            } else {
                displayImage = generateMockFrame(cameraName: camera.name, focusStatus: liveImage.focusStatus)
            }
            
            DispatchQueue.main.async {
                self.frameHandler(displayImage)
            }
        }
    }
    
    private func generateMockFrame(cameraName: String, focusStatus: Int) -> NSImage {
        let size = CGSize(width: 1280, height: 720)
        let image = NSImage(size: size)
        image.lockFocus()
        
        // Background
        NSColor.black.set()
        NSRect(origin: .zero, size: size).fill()
        
        // Info text
        let timestamp = ISO8601DateFormatter().string(from: Date())
        let text = "[LIVE] \(cameraName) | \(timestamp)"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: NSColor.white,
            .font: NSFont.monospacedSystemFont(ofSize: 24, weight: .bold)
        ]
        (text as NSString).draw(at: CGPoint(x: 50, y: size.height - 60), withAttributes: attributes)
        
        // Focus indicator
        switch focusStatus {
        case 1: NSColor.green.set()
        case 2: NSColor.red.set()
        default: NSColor.white.set()
        }
        let focusRect = NSRect(x: size.width/2 - 30, y: size.height/2 - 30, width: 60, height: 60)
        let path = NSBezierPath(rect: focusRect)
        path.lineWidth = 3.0
        path.stroke()
        
        image.unlockFocus()
        return image
    }
}
