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
    @ObservedObject var commands = AppCommandCenter.shared
    @State private var renderedImage: NSImage?
    @State private var sourceImage: NSImage?
    @State private var maskImage: NSImage?
    
    @State private var dragStartOrigin: CGPoint? = nil
    @State private var activeCropZone: CropRectHitboxCalculator.InteractionZone = .none
    @State private var cropStartRect: CGRect = .zero
    @State private var isLongPressingBefore: Bool = false
    
    public var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                // MARK: - Main Rendering Area
                ZStack {
                    CaptureOneTheme.Colors.applicationBackground
                    
                    if let sourceImage, let renderedImage {
                        if commands.beforeAfterEnabled && !isLongPressingBefore {
                            if commands.beforeAfterMode == 1 {
                                // Split Screen Mode
                                BeforeAfterSplitView(
                                    beforeImage: sourceImage,
                                    afterImage: renderedImage,
                                    splitPosition: $commands.beforeAfterSplitPosition,
                                    viewerSize: geo.size
                                )
                            } else {
                                // Side-by-side (Legacy/Multi-view support)
                                HStack(spacing: 1) {
                                    viewerImageView(sourceImage, size: CGSize(width: geo.size.width / 2, height: geo.size.height))
                                    viewerImageView(renderedImage, size: CGSize(width: geo.size.width / 2, height: geo.size.height))
                                }
                            }
                        } else {
                            // Single View (Standard or Temporary Before via Long Press)
                            let imageToShow = (isLongPressingBefore) ? sourceImage : renderedImage
                            viewerImageView(imageToShow, size: geo.size)
                        }
                    }
                    
                    // --- Overlays ---
                    Group {
                        if commands.beforeAfterEnabled && !isLongPressingBefore {
                            ViewerModeBadge(text: commands.beforeAfterMode == 1 ? "Split Screen" : "Before / After")
                                .padding(12)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        }
                        
                        if commands.showGridOverlay {
                            ViewerGridOverlay()
                        }
                        
                        // Exposure Warning Overlay (UI-204)
                        if commands.showExposureWarning, let nsImage = renderedImage {
                            ExposureWarningOverlay(image: nsImage)
                        }
                        
                        // Focus Mask Overlay (TETH-004)
                        if commands.showFocusMask, let nsImage = renderedImage {
                            FocusMaskOverlay(image: nsImage)
                                .blendMode(.screen)
                                .allowsHitTesting(false)
                        }
                        
                        // Mask Overlay (Red tint)
                        if let mask = maskImage {
                            Image(nsImage: mask)
                                .resizable()
                                .scaleEffect(adjustmentController?.zoomLevel ?? 1.0)
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
                        
                        // Linear Gradient Overlay (UI-204)
                        if commands.selectedCursorToolID == "DrawLinearGradient" || commands.selectedCursorToolID == "Select" {
                            if let drawingGradient = adjustmentController?.currentLinearGradient {
                                LinearGradientMaskOverlay(gradient: drawingGradient, viewerSize: geo.size)
                            } else if let savedGradient = adjustmentController?.currentVariant?.activeLayer?.linearGradient {
                                LinearGradientMaskOverlay(gradient: savedGradient, viewerSize: geo.size)
                            }
                        }
                        
                        // Radial Gradient Overlay (UI-204)
                        if commands.selectedCursorToolID == "DrawRadialGradient" || commands.selectedCursorToolID == "Select" {
                            if let drawingGradient = adjustmentController?.currentRadialGradient {
                                RadialGradientMaskOverlay(gradient: drawingGradient, viewerSize: geo.size)
                            } else if let savedGradient = adjustmentController?.currentVariant?.activeLayer?.radialGradient {
                                RadialGradientMaskOverlay(gradient: savedGradient, viewerSize: geo.size)
                            }
                        }
                        
                        // Keystone Interactive Overlay (UI-006)
                        if let points = adjustmentController?.keystonePoints {
                            KeystoneOverlayView(points: points)
                        }
                        
                        // Composition Overlay (GAP-406)
                        if let controller = adjustmentController {
                            CompositionOverlayView(controller: controller)
                        }
                        
                        // Crop Overlay (UI-204)
                        if let controller = adjustmentController, commands.selectedCursorToolID == "Crop" {
                            CropOverlayView(controller: controller, viewerSize: geo.size)
                        }
                    }
                }
                .contentShape(Rectangle())
                .simultaneousGesture(
                    LongPressGesture(minimumDuration: 0.1)
                        .onChanged { value in
                            isLongPressingBefore = value
                        }
                        .onEnded { _ in
                            isLongPressingBefore = false
                        }
                )
                .onHover { inside in
                            if inside {
                                let tool = commands.selectedCursorToolID
                                if tool == "Pan" {
                                    NSCursor.openHand.push()
                                } else if tool == "MoveOverlay" {
                                    NSCursor.resizeUpDown.push() // closest to move icon in std cursors
                                } else if tool == "DrawLinearGradient" {
                                    NSCursor.crosshair.push()
                                } else if tool == "DrawRadialGradient" {
                                    NSCursor.crosshair.push()
                                } else if tool == "Crop" {
                                    // Logic for dynamic cursor based on crop zones could be added here
                                    NSCursor.crosshair.push()
                                } else if tool == "Rotate" {
                                    // Simulation of rotateFreehandCursor
                                    NSCursor.crosshair.push() 
                                } else if tool == "PickWhitebalanceFilmNegative" {
                                    NSCursor.crosshair.push() // closest to eyedropper in standard cursors
                                }
                            } else {
                                NSCursor.pop()
                            }
                        }
                        .contextMenu {
                            if commands.selectedCursorToolID == "Heal" || commands.selectedCursorToolID == "Clone" {
                                Button("Auto-Pick Source") {
                                    // Simulate Auto-pick target point
                                    if let arrow = adjustmentController?.currentVariant?.activeLayer?.repairArrows.first, let image = image {
                                        _ = RetouchEngine.shared.autoPickSource(for: arrow.destinationPoint, in: image)
                                    }
                                }
                                Button("Reset Retouching") {
                                    adjustmentController?.resetRetouching()
                                }
                                Divider()
                                Button("Brush Settings...") {
                                    // Normally this would spawn a popover at cursor location, for now placeholder
                                    print("[CaptureOneUI] Show Brush Settings popover")
                                }
                            }
                        }
                        .onTapGesture(count: 2) {
                            if let controller = adjustmentController {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    if controller.zoomLevel > 1.0 {
                                        controller.zoomLevel = 1.0 // Fit to screen
                                    } else {
                                        controller.zoomLevel = 2.0 // 100% Zoom (assuming 1.0 is Fit and 2.0 is roughly 100% depending on image size)
                                    }
                                }
                            }
                        }
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { gesture in
                                    if commands.selectedCursorToolID == "Pan" {
                                        if dragStartOrigin == nil {
                                            dragStartOrigin = adjustmentController?.viewportRect.origin
                                            NSCursor.closedHand.push()
                                        }
                                        
                                        guard let start = dragStartOrigin, let zoom = adjustmentController?.zoomLevel else { return }
                                        
                                        // Panning logic: modify viewportRect
                                        // Normalized delta = pixel delta / viewer size / zoom
                                        let deltaX = gesture.translation.width / geo.size.width / zoom
                                        let deltaY = gesture.translation.height / geo.size.height / zoom
                                        
                                        if zoom > 1.0 {
                                            let currentViewport = adjustmentController?.viewportRect ?? CGRect(x: 0, y: 0, width: 1, height: 1)
                                            let newX = max(0, min(1.0 - currentViewport.width, start.x - deltaX))
                                            let newY = max(0, min(1.0 - currentViewport.height, start.y - deltaY))
                                            
                                            if adjustmentController?.multiViewPanning == true {
                                                // Sync across all instances via singleton
                                                AdjustmentToolController.shared.viewportRect.origin = CGPoint(x: newX, y: newY)
                                            } else {
                                                adjustmentController?.viewportRect.origin = CGPoint(x: newX, y: newY)
                                            }
                                        }
                                    } else if commands.selectedCursorToolID == "MoveOverlay" {
                                        if dragStartOrigin == nil {
                                            dragStartOrigin = adjustmentController?.overlayOffset
                                        }
                                        guard let start = dragStartOrigin else { return }
                                        
                                        adjustmentController?.overlayOffset = CGPoint(
                                            x: start.x + gesture.translation.width,
                                            y: start.y + gesture.translation.height
                                        )
                                    } else if commands.selectedCursorToolID == "Crop" {
                                        let controller = adjustmentController ?? AdjustmentToolController.shared
                                        
                                        if activeCropZone == .none {
                                            // Initialize interaction
                                            let denormalized = CGRect(x: controller.cropRect.minX * geo.size.width,
                                                                      y: controller.cropRect.minY * geo.size.height,
                                                                      width: controller.cropRect.width * geo.size.width,
                                                                      height: controller.cropRect.height * geo.size.height)
                                            activeCropZone = CropRectHitboxCalculator.sharedInstance.interactionZone(at: gesture.startLocation, for: denormalized)
                                            cropStartRect = controller.cropRect
                                            
                                            if controller.cropRect == .zero {
                                                activeCropZone = .resizeBottomRight
                                                cropStartRect = CGRect(x: gesture.startLocation.x / geo.size.width,
                                                                       y: gesture.startLocation.y / geo.size.height,
                                                                       width: 0, height: 0)
                                            }
                                        }
                                        
                                        let dx = gesture.translation.width / geo.size.width
                                        let dy = gesture.translation.height / geo.size.height
                                        
                                        var newRect = cropStartRect
                                        switch activeCropZone {
                                        case .move:
                                            newRect.origin.x += dx
                                            newRect.origin.y += dy
                                        case .resizeBottomRight:
                                            newRect.size.width += dx
                                            newRect.size.height += dy
                                        case .resizeTopLeft:
                                            newRect.origin.x += dx
                                            newRect.origin.y += dy
                                            newRect.size.width -= dx
                                            newRect.size.height -= dy
                                        // ... other zones could be implemented here
                                        default:
                                            // Fallback for simple implementation: update size from start
                                            if controller.cropRect == .zero || activeCropZone == .none {
                                                newRect.size.width = dx
                                                newRect.size.height = dy
                                            }
                                        }
                                        
                                        // Constrain to image bounds (0...1)
                                        newRect.origin.x = max(0, min(1.0, newRect.origin.x))
                                        newRect.origin.y = max(0, min(1.0, newRect.origin.y))
                                        newRect.size.width = max(0, min(1.0 - newRect.origin.x, newRect.size.width))
                                        newRect.size.height = max(0, min(1.0 - newRect.origin.y, newRect.size.height))
                                        
                                        controller.cropRect = newRect
                                        
                                        // Handle rotation if in rotate zone
                                        if activeCropZone == .rotateTopLeft || activeCropZone == .rotateTopRight ||
                                           activeCropZone == .rotateBottomLeft || activeCropZone == .rotateBottomRight {
                                            performRotation(gesture: gesture, in: geo.size)
                                        }
                                        
                                    } else if commands.selectedCursorToolID == "FocusPicker" {
                                        let controller = adjustmentController ?? AdjustmentToolController.shared
                                        controller.focusPoint = CGPoint(
                                            x: max(0, min(1, gesture.location.x / geo.size.width)),
                                            y: max(0, min(1, gesture.location.y / geo.size.height))
                                        )
                                    } else if commands.selectedCursorToolID == "DehazePicker" {
                                        let controller = adjustmentController ?? AdjustmentToolController.shared
                                        // Simplified color picking: Use a dummy color or logic to simulate picking
                                        controller.dehazeColor = .cyan // Simulated picked color
                                    } else if commands.selectedCursorToolID == "DrawLinearGradient" {
                                        let controller = adjustmentController ?? AdjustmentToolController.shared
                                        
                                        var start = CGPoint(x: gesture.startLocation.x / geo.size.width, y: gesture.startLocation.y / geo.size.height)
                                        var end = CGPoint(x: gesture.location.x / geo.size.width, y: gesture.location.y / geo.size.height)
                                        
                                        // Modifiers
                                        let flags = NSEvent.modifierFlags
                                        
                                        if flags.contains(.shift) {
                                            // Snap to 45 degrees
                                            let dx = end.x - start.x
                                            let dy = end.y - start.y
                                            let angle = atan2(dy, dx)
                                            let snappedAngle = round(angle / (.pi / 4)) * (.pi / 4)
                                            let dist = sqrt(dx*dx + dy*dy)
                                            end = CGPoint(x: start.x + cos(snappedAngle) * dist, y: start.y + sin(snappedAngle) * dist)
                                        }
                                        
                                        if flags.contains(.option) { // Alt key
                                            // Symmetrical from center (start is center)
                                            let dx = end.x - start.x
                                            let dy = end.y - start.y
                                            start = CGPoint(x: start.x - dx, y: start.y - dy)
                                        }
                                        
                                        controller.currentLinearGradient = LinearGradientMask(start: start, end: end)
                                    } else if commands.selectedCursorToolID == "DrawRadialGradient" {
                                        let controller = adjustmentController ?? AdjustmentToolController.shared
                                        
                                        let start = CGPoint(x: gesture.startLocation.x / geo.size.width, y: gesture.startLocation.y / geo.size.height)
                                        let current = CGPoint(x: gesture.location.x / geo.size.width, y: gesture.location.y / geo.size.height)
                                        
                                        let flags = NSEvent.modifierFlags
                                        
                                        var center = start
                                        var width = abs(current.x - start.x) * 2
                                        var height = abs(current.y - start.y) * 2
                                        
                                        if flags.contains(.option) {
                                            // Scale from center (start is center)
                                            width = abs(current.x - start.x) * 2
                                            height = abs(current.y - start.y) * 2
                                        } else {
                                            // Start is edge, current is opposite edge
                                            center = CGPoint(x: (start.x + current.x) / 2, y: (start.y + current.y) / 2)
                                            width = abs(current.x - start.x)
                                            height = abs(current.y - start.y)
                                        }
                                        
                                        if flags.contains(.shift) {
                                            // Perfect circle
                                            let maxDim = max(width, height)
                                            width = maxDim
                                            height = maxDim
                                        }
                                        
                                        // Simplified rotation: 0 degrees for basic draw
                                        controller.currentRadialGradient = RadialGradientMask(
                                            center: center,
                                            radius: CGSize(width: width, height: height),
                                            rotation: 0,
                                            feather: 0.2 // Default feather
                                        )
                                    } else if commands.selectedCursorToolID == "Rotate" {
                                        performRotation(gesture: gesture, in: geo.size)
                                    }
                                }
                                .onEnded { gesture in
                                    if commands.selectedCursorToolID == "Pan" || commands.selectedCursorToolID == "MoveOverlay" {
                                        dragStartOrigin = nil
                                        if commands.selectedCursorToolID == "Pan" {
                                            NSCursor.pop()
                                        }
                                    }
                                    
                                    if commands.selectedCursorToolID == "Crop" {
                                        activeCropZone = .none
                                        cropStartRect = .zero
                                    }
                                    
                                    if commands.selectedCursorToolID == "DrawLinearGradient" {
                                        if let controller = adjustmentController, let gradient = controller.currentLinearGradient {
                                            controller.commitLinearGradient(gradient)
                                        }
                                    }
                                    
                                    if commands.selectedCursorToolID == "DrawRadialGradient" {
                                        if let controller = adjustmentController, let gradient = controller.currentRadialGradient {
                                            controller.commitRadialGradient(gradient)
                                        }
                                    }
                                    
                                    if commands.selectedCursorToolID == "FocusPicker" || commands.selectedCursorToolID == "DehazePicker" {
                                        commands.selectedCursorToolID = "Select"
                                    }
                                    
                                    let toolID = commands.selectedCursorToolID
                                    if toolID == "Heal" {
                                        adjustmentController?.addRepairArrow(at: gesture.location, type: .heal)
                                    } else if toolID == "Clone" {
                                        adjustmentController?.addRepairArrow(at: gesture.location, type: .clone)
                                    } else if toolID == "PickWhitebalanceFilmNegative" {
                                        // Specific logic for film edge WB
                                        print("[UI] Picking Film Edge WB at \(gesture.location)")
                                        adjustmentController?.kelvin = 3200 // Mock neutralization
                                        adjustmentController?.tint = 10
                                        commands.selectedCursorToolID = "Select"
                                    } else {
                                        // Tool not handled by viewer root
                                        return
                                    }
                                    print("[UI] Clicked at: \(gesture.location) with tool \(toolID)")
                                }
                        )
                        .overlay(alignment: .topLeading) {
                            viewerStatusBadges
                                .padding(12)
                        }
                        .overlay {
                            if commands.showGridOverlay {
                                ViewerGridOverlay()
                            }
                        }
                    } else {
                        COViewerEmptyStateView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // MARK: - COViewerBarView (Reconstructed from metadata)
                COViewerBarView(zoomLevel: Binding(
                    get: { adjustmentController?.zoomLevel ?? 1.0 },
                    set: { adjustmentController?.zoomLevel = $0 }
                ))
            }
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
        guard let image = image else {
            sourceImage = nil
            renderedImage = nil
            return
        }
        let url = URL(fileURLWithPath: image.path)
        
        ThumbnailManager.shared.requestThumbnail(for: image.path, size: CGSize(width: 2000, height: 2000)) { thumb in
            guard let thumb = thumb, let controller = adjustmentController else {
                self.sourceImage = thumb
                self.renderedImage = thumb
                return
            }
            self.sourceImage = thumb
            
            // --- NEW: Using Reconstructed RAW Engine (IMG-003) ---
            
            // 1. Get process settings from UI state
            let settings = controller.toProcessSettings()
            
            // 2. Perform development via shared engine
            // In a real scenario, we would pass the actual RAW URL. 
            // For the lab, developImage handles fallback if URL is just a path.
            if let developedCGImage = RawImageEngine.shared.developImage(at: url, with: settings) {
                let finalNSImage = NSImage(cgImage: developedCGImage, size: NSSize(width: developedCGImage.width, height: developedCGImage.height))
                
                DispatchQueue.main.async {
                    self.renderedImage = finalNSImage
                }
            }
        }
    }

    private func performRotation(gesture: DragGesture.Value, in size: CGSize) {
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let startPoint = gesture.startLocation
        let currentPoint = gesture.location
        
        // Calculate angles relative to center
        let angleStart = atan2(startPoint.y - center.y, startPoint.x - center.x)
        let angleCurrent = atan2(currentPoint.y - center.y, currentPoint.x - center.x)
        
        let deltaAngle = (angleCurrent - angleStart) * 180.0 / .pi
        
        // Update controller (incremental update)
        if let controller = adjustmentController {
            controller.rotationAngle += Double(deltaAngle) * 0.1 // Scaled for smoother control
        }
    }

    @ViewBuilder
    private func viewerImageView(_ nsImage: NSImage, size: CGSize) -> some View {
        let zoom = adjustmentController?.zoomLevel ?? 1.0
        let viewport = adjustmentController?.viewportRect ?? CGRect(x: 0, y: 0, width: 1, height: 1)
        
        // Offset logic:
        // viewport.origin is the normalized top-left of the visible area.
        // We want to shift the image so that this point is at the top-left of the viewer.
        // Since scaleEffect scales from the center, we calculate the shift from center.
        
        let offsetX = (0.5 - (viewport.origin.x + viewport.width / 2)) * size.width * zoom
        let offsetY = (0.5 - (viewport.origin.y + viewport.height / 2)) * size.height * zoom

        Image(nsImage: nsImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .scaleEffect(zoom)
            .offset(x: offsetX, y: offsetY)
            .clipped()
    }

    @ViewBuilder
    private var viewerStatusBadges: some View {
        VStack(alignment: .leading, spacing: 6) {
            if commands.showExposureWarning {
                ViewerModeBadge(text: "Exposure Warning")
            }
            if commands.showFocusMask {
                ViewerModeBadge(text: "Focus Mask")
            }
            if let controller = adjustmentController, controller.isSoftProofingEnabled {
                ViewerModeBadge(text: "Proofing: \(controller.proofingProfileID)")
            }
        }
    }
}

/// Reconstructed Bottom Bar for the Viewer.
/// Based on 'viewerBarView', 'viewerZoomControl', and 'colorReadoutsMenuItem' properties.
struct COViewerBarView: View {
    @Binding var zoomLevel: Double
    @ObservedObject private var commands = AppCommandCenter.shared
    @ObservedObject private var adjustmentController = AdjustmentToolController.shared

    var body: some View {
        HStack(spacing: 0) {
            // Zoom Control
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
                Slider(value: $zoomLevel, in: 0.1...4.0)
                    .frame(width: 100)
                Text("\(Int(zoomLevel * 100))%")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(.white)
                    .frame(width: 36, alignment: .trailing)
            }
            .padding(.horizontal, 8)

            Divider().frame(height: 16)

            // Image info readout
            HStack(spacing: 12) {
                if let variant = adjustmentController.currentVariant {
                    Text(variant.image?.path.split(separator: "/").last.map(String.init) ?? "—")
                        .font(.system(size: 10))
                        .foregroundColor(.white)
                        .lineLimit(1)

                    Text(imageDimensions(for: variant.image))
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(.gray)

                    Text(colorSpace(for: variant.image))
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                } else {
                    Text("No selection")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 8)

            Spacer()

            // Color Tag quick buttons
            HStack(spacing: 4) {
                ForEach(colorTags, id: \.0) { tag, color in
                    Circle()
                        .fill(color)
                        .frame(width: 10, height: 10)
                        .overlay(
                            Circle().stroke(Color.white.opacity(0.3), lineWidth: 0.5)
                        )
                        .onTapGesture {
                            if let ct = VariantBase.ColorTag(rawValue: tag) {
                                adjustmentController.currentVariant?.colorTag = ct
                            }
                        }
                }
            }
            .padding(.horizontal, 6)

            Divider().frame(height: 16)

            // Rating stars
            HStack(spacing: 2) {
                ForEach(0..<5) { index in
                    Image(systemName: index < currentRating ? "star.fill" : "star")
                        .font(.system(size: 10))
                        .foregroundColor(index < currentRating ? CaptureOneTheme.Colors.activeHighlight : .gray)
                        .onTapGesture {
                            adjustmentController.currentVariant?.rating = index + 1
                        }
                }
            }
            .padding(.horizontal, 8)

            Divider().frame(height: 16)

            // Display Mode Toggle
            HStack(spacing: 10) {
                Button(action: {}) {
                    Image(systemName: "square.grid.2x2")
                        .font(.system(size: 12))
                }
                .buttonStyle(.plain)
                Button(action: {}) {
                    Image(systemName: "rectangle.split.3x1")
                        .font(.system(size: 12))
                }
                .buttonStyle(.plain)
            }
            .foregroundColor(.gray)
            .padding(.horizontal, 8)
        }
        .padding(.horizontal, 8)
        .frame(height: 30)
        .background(CaptureOneTheme.Colors.mainWindowTitleAndToolbar)
        .foregroundColor(.white)
    }

    private var currentRating: Int {
        adjustmentController.currentVariant?.rating ?? 0
    }

    private var colorTags: [(Int, Color)] {
        [
            (0, Color.gray.opacity(0.4)),
            (1, Color.red),
            (2, Color.orange),
            (3, Color.yellow),
            (4, Color.green),
            (5, Color.blue),
            (6, Color.purple)
        ]
    }

    private func imageDimensions(for image: ImageBase?) -> String {
        guard let image = image else { return "" }
        let w = image.pixelWidth > 0 ? image.pixelWidth : 6000
        let h = image.pixelHeight > 0 ? image.pixelHeight : 4000
        return "\(w) × \(h)"
    }

    private func colorSpace(for image: ImageBase?) -> String {
        guard image != nil else { return "" }
        return "sRGB" // Placeholder — actual color space from ICC profile
    }
}

public struct COViewerEmptyStateView: View {
    public init() {}
    @ObservedObject private var commands = AppCommandCenter.shared

    public var body: some View {
        VStack(spacing: 14) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 64))
                .foregroundColor(CaptureOneTheme.Colors.textSecondary)

            Text("No image selected")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)

            Text("Pick a variant from the browser or import new images.")
                .font(.system(size: 13))
                .foregroundColor(CaptureOneTheme.Colors.textSecondary)
        }
        .padding(24)
    }
}

private struct ViewerGridOverlay: View {
    var body: some View {
        GeometryReader { proxy in
            Path { path in
                let width = proxy.size.width
                let height = proxy.size.height
                path.move(to: CGPoint(x: width / 3, y: 0))
                path.addLine(to: CGPoint(x: width / 3, y: height))
                path.move(to: CGPoint(x: width * 2 / 3, y: 0))
                path.addLine(to: CGPoint(x: width * 2 / 3, y: height))
                path.move(to: CGPoint(x: 0, y: height / 3))
                path.addLine(to: CGPoint(x: width, y: height / 3))
                path.move(to: CGPoint(x: 0, y: height * 2 / 3))
                path.addLine(to: CGPoint(x: width, y: height * 2 / 3))
            }
            .stroke(Color.white.opacity(0.35), style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
        }
    }
}

private struct ViewerModeBadge: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 10, weight: .semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.black.opacity(0.55))
            .foregroundColor(.white)
            .clipShape(Capsule())
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

struct BeforeAfterSplitView: View {
    let beforeImage: NSImage
    let afterImage: NSImage
    @Binding var splitPosition: Double
    let viewerSize: CGSize
    
    var body: some View {
        ZStack {
            // After Image (Full background)
            Image(nsImage: afterImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            // Before Image (Clipped)
            Image(nsImage: beforeImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .mask(
                    HStack(spacing: 0) {
                        Rectangle()
                            .frame(width: viewerSize.width * CGFloat(splitPosition))
                        Spacer(minLength: 0)
                    }
                )
            
            // Draggable Divider
            Rectangle()
                .fill(Color.white)
                .frame(width: 1)
                .overlay(
                    Circle()
                        .fill(Color.white)
                        .frame(width: 24, height: 24)
                        .shadow(radius: 2)
                        .overlay(Image(systemName: "arrow.left.and.right").font(.system(size: 10)).foregroundColor(.black))
                )
                .position(x: viewerSize.width * CGFloat(splitPosition), y: viewerSize.height / 2)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            splitPosition = Double(max(0, min(1, value.location.x / viewerSize.width)))
                        }
                )
        }
    }
}
