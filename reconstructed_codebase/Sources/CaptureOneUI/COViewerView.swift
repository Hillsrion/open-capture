import SwiftUI
import AppCoreShared
import ImageCore
import Combine

/// Reconstructed high-fidelity Viewer for Capture One.
/// Based on _TtC10CaptureOne25ViewerDisplayModeSettings and related metadata.
public struct COViewerView: View {
    
    public init(image: ImageBase?, adjustmentController: AdjustmentToolController? = nil) {
        self.image = image
        self.adjustmentController = adjustmentController
    }
    
    let image: ImageBase?
    let adjustmentController: AdjustmentToolController?
    @ObservedObject var liveView = LiveViewEngine.shared
    @State private var renderedImage: NSImage?
    @State private var maskImage: NSImage?
    @State private var zoomLevel: Double = 1.0 // Inferred from ViewerZoomViewController
    
    public var body: some View {
        VStack(spacing: 0) {
            // MARK: - Main Rendering Area
            ZStack {
                CaptureOneTheme.Colors.applicationBackground
                
                if liveView.isActive {
                    LiveViewOverlayView(camera: liveView.currentCamera)
                } else if let nsImage = renderedImage {
                    ZStack {
                        Image(nsImage: nsImage)
                            .resizable()
                            .scaleEffect(zoomLevel)
                            .aspectRatio(contentMode: .fit)
                        
                        // Mask Overlay (Red tint)
                        if let mask = maskImage {
                            Image(nsImage: mask)
                                .resizable()
                                .scaleEffect(zoomLevel)
                                .aspectRatio(contentMode: .fit)
                                .opacity(0.5)
                                .colorMultiply(.red)
                        }
                        
                        // Repair Arrows Overlay (UI-006)
                        if let active = adjustmentController?.currentVariant?.activeLayer {
                            ForEach(active.repairArrows) { arrow in
                                RepairArrowView(arrow: arrow)
                            }
                        }
                        
                        // Annotations Overlay (UI-007)
                        if let annotations = adjustmentController?.currentVariant?.annotations {
                            AnnotationsOverlayView(annotations: annotations)
                        }
                        
                        // Keystone Interactive Overlay (UI-006)
                        if let points = adjustmentController?.keystonePoints {
                            KeystoneOverlayView(points: points)
                        }
                    }
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gesture in
                                // Logic: If Magic Brush is active, call engine
                                print("[UI] Brushing at: \(gesture.location)")
                            }
                    )
                } else {
                    ProgressView().tint(.white)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // MARK: - COViewerBarView (Reconstructed from metadata)
            COViewerBarView(zoomLevel: $zoomLevel)
        }
        .onAppear {
            render()
        }
        .onChange(of: image?.imageUUID) { _ in
            render()
        }
        .onReceive(Just(adjustmentController).compactMap { $0?.objectWillChange }.flatMap { $0 }) { _ in
            render()
        }
    }
    
    private func render() {
        guard let image = image else { return }
        ThumbnailManager.shared.requestThumbnail(for: image.path, size: CGSize(width: 2000, height: 2000)) { thumb in
            guard let thumb = thumb, let controller = adjustmentController else {
                self.renderedImage = thumb
                return
            }
            
            // Simulation: Apply basic CI adjustments to the thumbnail
            let ciImage = CIImage(data: thumb.tiffRepresentation!)!
            var filtered = ciImage
                .applyingFilter("CIExposureAdjust", parameters: ["inputEV": controller.exposure])
                .applyingFilter("CIColorControls", parameters: [
                    "inputContrast": 1.0 + controller.contrast / 100.0,
                    "inputBrightness": controller.brightness / 100.0,
                    "inputSaturation": 1.0 + controller.saturation / 100.0
                ])
            
            // --- Lens Correction Simulation (ENG-006) ---
            if controller.lensDistortion != 0 {
                let radius = max(ciImage.extent.width, ciImage.extent.height)
                filtered = filtered.applyingFilter("CIBumpDistortion", parameters: [
                    "inputCenter": CIVector(x: ciImage.extent.midX, y: ciImage.extent.midY),
                    "inputRadius": radius,
                    "inputScale": controller.lensDistortion / 100.0
                ])
            }
            
            if controller.lensLightFalloff != 0 {
                filtered = filtered.applyingFilter("CIVignette", parameters: [
                    "inputIntensity": controller.lensLightFalloff / 100.0,
                    "inputRadius": 1.0
                ])
            }
            
            let rep = NSCIImageRep(ciImage: filtered)
            let finalImage = NSImage(size: rep.size)
            finalImage.addRepresentation(rep)
            
            self.renderedImage = finalImage
        }
    }
}

/// Reconstructed Bottom Bar for the Viewer.
/// Based on 'viewerBarView' and 'viewerZoomControl' properties.
struct COViewerBarView: View {
    @Binding var zoomLevel: Double
    
    var body: some View {
        HStack {
            // Zoom Control
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                Slider(value: $zoomLevel, in: 0.1...4.0)
                    .frame(width: 150)
                Text("\(Int(zoomLevel * 100))%")
                    .font(.system(size: 10, design: .monospaced))
            }
            
            Spacer()
            
            // Display Mode Toggle (Inferred from viewerDisplayMode)
            HStack(spacing: 15) {
                Button(action: {}) {
                    Image(systemName: "square.grid.2x2")
                }
                Button(action: {}) {
                    Image(systemName: "rectangle.split.3x1")
                }
            }
        }
        .padding(.horizontal, 15)
        .frame(height: 35)
        .background(CaptureOneTheme.Colors.mainWindowTitleAndToolbar)
        .foregroundColor(.white)
    }
}

/// Reconstructed Interactive Keystone UI (UI-006).
struct KeystoneOverlayView: View {
    let points: KeystonePoints
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Lines
                Path { path in
                    path.move(to: denormalize(points.p0, in: geo.size))
                    path.addLine(to: denormalize(points.p1, in: geo.size))
                    
                    path.move(to: denormalize(points.p2, in: geo.size))
                    path.addLine(to: denormalize(points.p3, in: geo.size))
                }
                .stroke(CaptureOneTheme.Colors.activeHighlight, lineWidth: 2)
                
                // Control Handles
                handle(at: points.p0, in: geo.size)
                handle(at: points.p1, in: geo.size)
                handle(at: points.p2, in: geo.size)
                handle(at: points.p3, in: geo.size)
            }
        }
    }
    
    private func handle(at point: CGPoint, in size: CGSize) -> some View {
        Circle()
            .fill(CaptureOneTheme.Colors.activeHighlight)
            .frame(width: 8, height: 8)
            .position(denormalize(point, in: size))
    }
    
    private func denormalize(_ point: CGPoint, in size: CGSize) -> CGPoint {
        return CGPoint(x: point.x * size.width, y: point.y * size.height)
    }
}
