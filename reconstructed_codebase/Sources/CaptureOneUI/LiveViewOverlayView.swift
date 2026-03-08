import SwiftUI
import AppKit
import AppCoreShared

/// Reconstructed Overlay for Live View rendering (TETH-003).
/// Based on _TtC10CaptureOne18LiveViewOverlayView and disassembly.
public struct LiveViewOverlayView: View {
    @ObservedObject var liveView = LiveViewEngine.shared
    let camera: P1CaptureCore_Camera?
    @State private var showFocusMask: Bool = true // TETH-004
    
    public init(camera: P1CaptureCore_Camera?) {
        self.camera = camera
    }
    
    public var body: some View {
        ZStack {
            if let frame = liveView.currentFrame {
                ZStack {
                    Image(nsImage: frame)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    // Focus Mask Overlay (TETH-004)
                    if showFocusMask {
                        FocusMaskOverlay(image: frame)
                            .blendMode(.screen)
                    }
                }
                .overlay(
                    GeometryReader { geo in
                        ZStack {
                            // Reconstructed Aspect Ratio Overlay (TETH-003)
                            // Based on cropMatchesCurrentCameraCrop
                            if let cam = camera, !cropMatches(for: frame, camera: cam) {
                                Color.black.opacity(0.4)
                                    .mask(
                                        Rectangle()
                                            .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.8)
                                            .background(Color.white)
                                            .compositingGroup()
                                            .luminanceToAlpha()
                                    )
                            }
                            
                            // Focus Indicators
                            // In the real app, these are driven by focusStatus and focusMeter
                            focusIndicator(in: geo.size)
                            
                            // Grid Lines (Inferred from metadata)
                            GridOverlayView()
                            
                            // Focus Mask Toggle (UI hint)
                            focusMaskToggle
                        }
                    }
                )
            } else {
                VStack {
                    ProgressView()
                        .tint(.white)
                    Text("Connecting to stream...")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    private func cropMatches(for frame: NSImage, camera: P1CaptureCore_Camera) -> Bool {
        // Reconstructed logic for cropMatchesCurrentCameraCrop
        // In the real app, this compares the frame's metadata aspect ratio
        // with the camera's current sensor crop setting.
        return true // Simplified for now
    }
    
    @ViewBuilder
    private func focusIndicator(in size: CGSize) -> some View {
        // Simplified focus indicator
        Rectangle()
            .stroke(Color.green, lineWidth: 1)
            .frame(width: 100, height: 100)
            .position(x: size.width / 2, y: size.height / 2)
    }
    
    private var focusMaskToggle: some View {
        Button(action: { showFocusMask.toggle() }) {
            Image(systemName: showFocusMask ? "eye.fill" : "eye.slash.fill")
                .foregroundColor(.white)
                .padding(8)
                .background(Color.black.opacity(0.5))
                .clipShape(Circle())
        }
        .position(x: 30, y: 30)
    }
}

/// Reconstructed Focus Mask engine (TETH-004).
/// Simulates high-frequency edge detection.
struct FocusMaskOverlay: View {
    let image: NSImage
    
    var body: some View {
        // In a real app, this would be a Metal shader or CoreImage filter
        // detecting high-frequency content (Sobel/Laplacian).
        // Here we simulate it by overlaying a tinted version of the focus area.
        GeometryReader { geo in
            Canvas { context, size in
                // Mock: Draw "sharp" areas in green
                // This is a placeholder for the actual GPU-based focus mask.
                context.fill(Path(CGRect(x: size.width/2 - 50, y: size.height/2 - 50, width: 100, height: 100)), with: .color(.green.opacity(0.4)))
                
                // Add some "noise" to simulate real-time mask jitter
                for _ in 0...10 {
                    let rect = CGRect(
                        x: CGFloat.random(in: 0...size.width),
                        y: CGFloat.random(in: 0...size.height),
                        width: 10,
                        height: 10
                    )
                    context.fill(Path(rect), with: .color(.green.opacity(0.3)))
                }
            }
        }
    }
}

/// Simple Grid Overlay based on Capture One's 'Guides' feature.
struct GridOverlayView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Rule of Thirds
                Path { path in
                    let w = geo.size.width
                    let h = geo.size.height
                    
                    path.move(to: CGPoint(x: w/3, y: 0))
                    path.addLine(to: CGPoint(x: w/3, y: h))
                    
                    path.move(to: CGPoint(x: 2*w/3, y: 0))
                    path.addLine(to: CGPoint(x: 2*w/3, y: h))
                    
                    path.move(to: CGPoint(x: 0, y: h/3))
                    path.addLine(to: CGPoint(x: w, y: h/3))
                    
                    path.move(to: CGPoint(x: 0, y: 2*h/3))
                    path.addLine(to: CGPoint(x: w, y: 2*h/3))
                }
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
            }
        }
    }
}
