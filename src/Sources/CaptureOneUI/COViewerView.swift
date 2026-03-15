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
    @StateObject private var renderCoalescer = RenderCoalescer()
    @State private var renderedImage: NSImage?
    @State private var sourceImage: NSImage?
    @State private var maskImage: NSImage?
    @State private var lastLoadedURL: URL? = nil
    
    @State private var dragStartOrigin: CGPoint? = nil
    @State private var activeCropZone: CropRectHitboxCalculator.InteractionZone = .none
    @State private var cropStartRect: CGRect = .zero
    @State private var isLongPressingBefore: Bool = false
    
    public var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                // MARK: - Main Rendering Area
                mainRenderingArea(size: geo.size)
                
                // MARK: - COViewerBarView (Reconstructed from metadata)
                COViewerBarView(zoomLevel: Binding(
                    get: { adjustmentController?.zoomLevel ?? 1.0 },
                    set: { adjustmentController?.zoomLevel = $0 }
                ))
            }
        }
        .onAppear { requestCoalescedRender(forceQuality: .render) }
        .onChange(of: image?.id) { _ in requestCoalescedRender(forceQuality: .render) }
        .onReceive(
            Just(adjustmentController)
                .compactMap { $0?.objectWillChange }
                .flatMap { $0 }
        ) { _ in
            requestCoalescedRender(forceQuality: nil)
        }
    }
    
    @ViewBuilder
    private func mainRenderingArea(size: CGSize) -> some View {
        ZStack {
            CaptureOneTheme.Colors.applicationBackground.ignoresSafeArea()
            
            if sourceImage != nil {
                imageContent(sourceNS: sourceImage!, renderedNS: renderedImage, renderedCI: renderedCIImage, size: size)
                overlays(size: size)
            } else {
                COViewerEmptyStateView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .simultaneousGesture(longPressGesture)
        .onHover(perform: handleHover)
        .contextMenu { viewerContextMenu }
        .onTapGesture(count: 2, perform: toggleZoom)
        .gesture(dragGesture(size: size))
        .overlay(alignment: .topLeading) {
            viewerStatusBadges.padding(12)
        }
        .overlay {
            if commands.showGridOverlay {
                ViewerGridOverlay()
            }
        }
    }
    
    @ViewBuilder
    private func imageContent(sourceNS: NSImage, renderedNS: NSImage?, renderedCI: CIImage?, size: CGSize) -> some View {
        if commands.beforeAfterEnabled && !isLongPressingBefore {
            if commands.beforeAfterMode == 1 {
                BeforeAfterSplitView(
                    beforeImage: sourceNS,
                    afterImage: renderedNS ?? sourceNS,
                    afterCIImage: renderedCI,
                    splitPosition: $commands.beforeAfterSplitPosition,
                    viewerSize: size
                )
            } else {
                HStack(spacing: 1) {
                    viewerImageView(nsImage: sourceNS, ciImage: nil, size: CGSize(width: size.width / 2, height: size.height))
                    viewerImageView(nsImage: renderedNS, ciImage: renderedCI, size: CGSize(width: size.width / 2, height: size.height))
                }
            }
        } else {
            if isLongPressingBefore {
                viewerImageView(nsImage: sourceNS, ciImage: nil, size: size)
            } else {
                viewerImageView(nsImage: renderedNS, ciImage: renderedCI, size: size)
            }
        }
    }
    
    @ViewBuilder
    private func overlays(size: CGSize) -> some View {
        Group {
            if commands.beforeAfterEnabled && !isLongPressingBefore {
                ViewerModeBadge(text: commands.beforeAfterMode == 1 ? "Split Screen" : "Before / After")
                    .padding(12)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            
            if commands.showExposureWarning {
                ExposureWarningOverlay(image: renderedImage ?? sourceImage ?? NSImage())
            }
            
            if commands.showFocusMask {
                FocusMaskOverlay(image: renderedImage ?? sourceImage ?? NSImage())
                    .blendMode(.screen)
                    .allowsHitTesting(false)
            }
            
            if let mask = maskImage {
                Image(nsImage: mask)
                    .resizable()
                    .scaleEffect(adjustmentController?.zoomLevel ?? 1.0)
                    .aspectRatio(contentMode: .fit)
                    .opacity(0.5)
                    .colorMultiply(.red)
            }
            
            if let active = adjustmentController?.currentVariant?.activeLayer {
                ForEach(active.repairArrows) { arrow in
                    RepairArrowView(arrow: arrow)
                }
            }
            
            if let annotations = adjustmentController?.currentVariant?.annotations {
                let tool = commands.selectedCursorToolID
                if tool == "Annotate" || tool == "EraseAnnotation" || tool == "Select" {
                    AnnotationsOverlayView(annotations: annotations)
                        .allowsHitTesting(tool == "Annotate" || tool == "EraseAnnotation")
                }
            }
            
            if commands.selectedCursorToolID == "DrawLinearGradient" || commands.selectedCursorToolID == "Select" {
                if let drawingGradient = adjustmentController?.currentLinearGradient {
                    LinearGradientMaskOverlay(gradient: drawingGradient, viewerSize: size)
                } else if let savedGradient = adjustmentController?.currentVariant?.activeLayer?.linearGradient {
                    LinearGradientMaskOverlay(gradient: savedGradient, viewerSize: size)
                }
            }
            
            if commands.selectedCursorToolID == "DrawRadialGradient" || commands.selectedCursorToolID == "Select" {
                if let drawingGradient = adjustmentController?.currentRadialGradient {
                    RadialGradientMaskOverlay(gradient: drawingGradient, viewerSize: size)
                } else if let savedGradient = adjustmentController?.currentVariant?.activeLayer?.radialGradient {
                    RadialGradientMaskOverlay(gradient: savedGradient, viewerSize: size)
                }
            }
            
            if let points = adjustmentController?.keystonePoints {
                KeystoneOverlayView(points: points)
            }
            
            if let controller = adjustmentController {
                CompositionOverlayView(controller: controller)
            }
            
            if let controller = adjustmentController, commands.selectedCursorToolID == "Crop" {
                CropOverlayView(controller: controller, viewerSize: size)
            }
        }
    }
    
    // MARK: - Gestures & Interactions
    
    private var longPressGesture: some Gesture {
        LongPressGesture(minimumDuration: 0.1)
            .onChanged { value in isLongPressingBefore = value }
            .onEnded { _ in isLongPressingBefore = false }
    }
    
    private func handleHover(inside: Bool) {
        if inside {
            let tool = commands.selectedCursorToolID
            if tool == "Pan" { NSCursor.openHand.push() }
            else if tool == "MoveOverlay" { NSCursor.resizeUpDown.push() }
            else if ["DrawLinearGradient", "DrawRadialGradient", "Annotate", "Crop", "Rotate"].contains(where: { tool.contains($0) }) || tool.contains("Picker") {
                NSCursor.crosshair.push()
            }
        } else {
            NSCursor.pop()
        }
    }
    
    @ViewBuilder
    private var viewerContextMenu: some View {
        if commands.selectedCursorToolID == "Heal" || commands.selectedCursorToolID == "Clone" {
            Button("Auto-Pick Source") {
                if let arrow = adjustmentController?.currentVariant?.activeLayer?.repairArrows.first, let image = image {
                    _ = RetouchEngine.shared.autoPickSource(for: arrow.destinationPoint, in: image)
                }
            }
            Button("Reset Retouching") { adjustmentController?.resetRetouching() }
            Divider()
            Button("Brush Settings...") { print("[UI] Show Brush Settings") }
        }
    }
    
    private func toggleZoom() {
        if let controller = adjustmentController {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                controller.zoomLevel = controller.zoomLevel > 1.0 ? 1.0 : 2.0
            }
        }
    }
    
    private func dragGesture(size: CGSize) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { gesture in
                let tool = commands.selectedCursorToolID
                if tool == "Pan" {
                    handlePanDrag(gesture: gesture, size: size)
                } else if tool == "MoveOverlay" {
                    handleMoveOverlayDrag(gesture: gesture)
                } else if tool == "Crop" {
                    handleCropDrag(gesture: gesture, size: size)
                } else if tool == "FocusPicker" {
                    adjustmentController?.focusPoint = CGPoint(x: max(0, min(1, gesture.location.x / size.width)), y: max(0, min(1, gesture.location.y / size.height)))
                } else if tool == "DehazePicker" {
                    adjustmentController?.dehazeColor = .cyan
                } else if tool == "DrawLinearGradient" {
                    handleLinearGradientDrag(gesture: gesture, size: size)
                } else if tool == "DrawRadialGradient" {
                    handleRadialGradientDrag(gesture: gesture, size: size)
                } else if tool == "Rotate" {
                    performRotation(gesture: gesture, in: size)
                }
            }
            .onEnded { gesture in
                let tool = commands.selectedCursorToolID
                if tool == "Pan" || tool == "MoveOverlay" {
                    dragStartOrigin = nil
                    if tool == "Pan" { NSCursor.pop() }
                }
                if tool == "Crop" { activeCropZone = .none; cropStartRect = .zero }
                if tool == "DrawLinearGradient" {
                    if let c = adjustmentController, let g = c.currentLinearGradient { c.commitLinearGradient(g) }
                }
                if tool == "DrawRadialGradient" {
                    if let c = adjustmentController, let g = c.currentRadialGradient { c.commitRadialGradient(g) }
                }
                if ["FocusPicker", "DehazePicker"].contains(tool) { commands.selectedCursorToolID = "Select" }
                if tool == "Heal" { adjustmentController?.addRepairArrow(at: gesture.location, type: .heal) }
                else if tool == "Clone" { adjustmentController?.addRepairArrow(at: gesture.location, type: .clone) }
            }
    }
    
    private func handlePanDrag(gesture: DragGesture.Value, size: CGSize) {
        if dragStartOrigin == nil {
            dragStartOrigin = adjustmentController?.viewportRect.origin
            NSCursor.closedHand.push()
        }
        guard let start = dragStartOrigin, let zoom = adjustmentController?.zoomLevel else { return }
        let deltaX = gesture.translation.width / size.width / zoom
        let deltaY = gesture.translation.height / size.height / zoom
        if zoom > 1.0 {
            let current = adjustmentController?.viewportRect ?? CGRect(x: 0, y: 0, width: 1, height: 1)
            let newX = max(0, min(1.0 - current.width, start.x - deltaX))
            let newY = max(0, min(1.0 - current.height, start.y - deltaY))
            if adjustmentController?.multiViewPanning == true {
                AdjustmentToolController.shared.viewportRect.origin = CGPoint(x: newX, y: newY)
            } else {
                adjustmentController?.viewportRect.origin = CGPoint(x: newX, y: newY)
            }
        }
    }
    
    private func handleMoveOverlayDrag(gesture: DragGesture.Value) {
        if dragStartOrigin == nil { dragStartOrigin = adjustmentController?.overlayOffset }
        guard let start = dragStartOrigin else { return }
        adjustmentController?.overlayOffset = CGPoint(x: start.x + gesture.translation.width, y: start.y + gesture.translation.height)
    }
    
    // ... remaining helper methods (handleCropDrag, handleLinearGradientDrag, handleRadialGradientDrag, render, performRotation, viewerImageView, viewerStatusBadges)
    // I'll re-include them in the full file.
    
    private func handleCropDrag(gesture: DragGesture.Value, size: CGSize) {
        let controller = adjustmentController ?? AdjustmentToolController.shared
        if activeCropZone == .none {
            let denormalized = CGRect(x: controller.cropRect.minX * size.width,
                                      y: controller.cropRect.minY * size.height,
                                      width: controller.cropRect.width * size.width,
                                      height: controller.cropRect.height * size.height)
            activeCropZone = CropRectHitboxCalculator.sharedInstance.interactionZone(at: gesture.startLocation, for: denormalized)
            cropStartRect = controller.cropRect
            if controller.cropRect == .zero {
                activeCropZone = .resizeBottomRight
                cropStartRect = CGRect(x: gesture.startLocation.x / size.width, y: gesture.startLocation.y / size.height, width: 0, height: 0)
            }
        }
        let dx = gesture.translation.width / size.width
        let dy = gesture.translation.height / size.height
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
        default:
            if controller.cropRect == .zero { newRect.size.width = dx; newRect.size.height = dy }
        }
        newRect.origin.x = max(0, min(1.0, newRect.origin.x))
        newRect.origin.y = max(0, min(1.0, newRect.origin.y))
        newRect.size.width = max(0, min(1.0 - newRect.origin.x, newRect.size.width))
        newRect.size.height = max(0, min(1.0 - newRect.origin.y, newRect.size.height))
        controller.cropRect = newRect
        if activeCropZone.isRotation { performRotation(gesture: gesture, in: size) }
    }
    
    private func handleLinearGradientDrag(gesture: DragGesture.Value, size: CGSize) {
        let controller = adjustmentController ?? AdjustmentToolController.shared
        var start = CGPoint(x: gesture.startLocation.x / size.width, y: gesture.startLocation.y / size.height)
        var end = CGPoint(x: gesture.location.x / size.width, y: gesture.location.y / size.height)
        let flags = NSEvent.modifierFlags
        if flags.contains(.shift) {
            let dx = end.x - start.x
            let dy = end.y - start.y
            let angle = atan2(dy, dx)
            let snappedAngle = round(angle / (.pi / 4)) * (.pi / 4)
            let dist = sqrt(dx*dx + dy*dy)
            end = CGPoint(x: start.x + cos(snappedAngle) * dist, y: start.y + sin(snappedAngle) * dist)
        }
        if flags.contains(.option) {
            let dx = end.x - start.x
            let dy = end.y - start.y
            start = CGPoint(x: start.x - dx, y: start.y - dy)
        }
        controller.currentLinearGradient = LinearGradientMask(start: start, end: end)
    }
    
    private func handleRadialGradientDrag(gesture: DragGesture.Value, size: CGSize) {
        let controller = adjustmentController ?? AdjustmentToolController.shared
        let start = CGPoint(x: gesture.startLocation.x / size.width, y: gesture.startLocation.y / size.height)
        let current = CGPoint(x: gesture.location.x / size.width, y: gesture.location.y / size.height)
        let flags = NSEvent.modifierFlags
        var center = start
        var width = abs(current.x - start.x) * 2
        var height = abs(current.y - start.y) * 2
        if flags.contains(.option) {
            width = abs(current.x - start.x) * 2
            height = abs(current.y - start.y) * 2
        } else {
            center = CGPoint(x: (start.x + current.x) / 2, y: (start.y + current.y) / 2)
            width = abs(current.x - start.x)
            height = abs(current.y - start.y)
        }
        if flags.contains(.shift) {
            let maxDim = max(width, height)
            width = maxDim; height = maxDim
        }
        controller.currentRadialGradient = RadialGradientMask(center: center, radius: CGSize(width: width, height: height), rotation: 0, feather: 0.2)
    }

    @State private var renderedCIImage: CIImage? = nil

    private func requestCoalescedRender(forceQuality: IC_ProcessQuality?) {
        guard let image = image else {
            renderedImage = nil; renderedCIImage = nil; sourceImage = nil; lastLoadedURL = nil; return
        }
        let url = URL(fileURLWithPath: image.path)
        let imagePath = image.path
        let viewport = adjustmentController?.viewportRect ?? CGRect(x: 0, y: 0, width: 1, height: 1)
        let isInteracting = dragStartOrigin != nil
            || activeCropZone != .none
            || (commands.selectedCursorToolID.contains("Draw") && adjustmentController?.currentLinearGradient != nil)
            || (adjustmentController?.isInteracting == true)
        let updatedSettings = adjustmentController?.toProcessSettings() ?? IC_ProcessSettings()
        
        let renderBlock: (IC_ProcessSettings, IC_ProcessQuality) -> Void = { settings, quality in
            self.performRender(url: url, imagePath: imagePath, settings: settings, quality: quality)
        }
        
        if let forced = forceQuality {
            renderBlock(updatedSettings, forced)
        } else {
            renderCoalescer.submit(settings: updatedSettings,
                                   viewport: viewport,
                                   isInteracting: isInteracting,
                                   render: renderBlock)
        }
    }
    
    private func performRender(url: URL, imagePath: String, settings: IC_ProcessSettings, quality: IC_ProcessQuality) {
        let isLiveDrag = quality == .display
        let supportsMetal = COMTRView.supportsMetal
        
        if sourceImage == nil || lastLoadedURL != url {
            ThumbnailManager.shared.requestThumbnail(for: imagePath, size: CGSize(width: 2000, height: 2000)) { thumb in
                guard let thumb = thumb else {
                    self.sourceImage = nil; self.renderedImage = nil; self.renderedCIImage = nil; return
                }
                self.sourceImage = thumb
                self.lastLoadedURL = url
                
                if let developedCIImage = RawImageEngine.shared.developImage(at: url, with: settings, isLiveDrag: isLiveDrag) {
                    if supportsMetal {
                        DispatchQueue.main.async { self.renderedCIImage = developedCIImage; self.renderedImage = nil }
                    } else {
                        let fallback = developedCIImage.toNSImage()
                        DispatchQueue.main.async { self.renderedImage = fallback ?? thumb; self.renderedCIImage = nil }
                    }
                } else {
                    // Fallback to NSImage if CIImage fails (though it shouldn't)
                    DispatchQueue.main.async { self.renderedImage = thumb; self.renderedCIImage = nil }
                }
            }
        } else {
            // Fast path: thumbnail already loaded, image is in proxy cache
            // objectWillChange fires before properties update. Delay by 1 tick to read new settings.
            DispatchQueue.main.async {
                if let developedCIImage = RawImageEngine.shared.developImage(at: url, with: settings, isLiveDrag: isLiveDrag) {
                    if supportsMetal {
                        self.renderedCIImage = developedCIImage
                        self.renderedImage = nil
                    } else {
                        self.renderedImage = developedCIImage.toNSImage() ?? self.sourceImage
                        self.renderedCIImage = nil
                    }
                }
            }
        }
    }

    private func performRotation(gesture: DragGesture.Value, in size: CGSize) {
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let startPoint = gesture.startLocation
        let currentPoint = gesture.location
        let angleStart = atan2(startPoint.y - center.y, startPoint.x - center.x)
        let angleCurrent = atan2(currentPoint.y - center.y, currentPoint.x - center.x)
        let deltaAngle = (angleCurrent - angleStart) * 180.0 / .pi
        if let controller = adjustmentController {
            controller.rotationAngle += Double(deltaAngle) * 0.1
        }
    }

    @ViewBuilder
    private func viewerImageView(nsImage: NSImage?, ciImage: CIImage?, size: CGSize) -> some View {
        let zoom = adjustmentController?.zoomLevel ?? 1.0
        let viewport = adjustmentController?.viewportRect ?? CGRect(x: 0, y: 0, width: 1, height: 1)
        let offsetX = (0.5 - (viewport.origin.x + viewport.width / 2)) * size.width * zoom
        let offsetY = (0.5 - (viewport.origin.y + viewport.height / 2)) * size.height * zoom
        
        Group {
            if let ciImage = ciImage, COMTRView.supportsMetal {
                COMTRView(image: ciImage)
            } else if let nsImage = nsImage {
                Image(nsImage: nsImage).resizable().aspectRatio(contentMode: .fit)
            } else if let ciImage = ciImage, let fallback = ciImage.toNSImage() {
                Image(nsImage: fallback).resizable().aspectRatio(contentMode: .fit)
            } else {
                Color.clear
            }
        }
        .scaleEffect(zoom).offset(x: offsetX, y: offsetY).clipped()
    }

    @ViewBuilder
    private var viewerStatusBadges: some View {
        VStack(alignment: .leading, spacing: 6) {
            if commands.showExposureWarning { ViewerModeBadge(text: "Exposure Warning") }
            if commands.showFocusMask { ViewerModeBadge(text: "Focus Mask") }
            if let controller = adjustmentController, controller.isSoftProofingEnabled {
                ViewerModeBadge(text: "Proofing: \(controller.proofingProfileID)")
            }
        }
    }
}

/// Reconstructed Bottom Bar for the Viewer.
struct COViewerBarView: View {
    @Binding var zoomLevel: Double
    @ObservedObject private var adjustmentController = AdjustmentToolController.shared

    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass").font(.system(size: 11)).foregroundColor(.gray)
                Slider(value: $zoomLevel, in: 0.1...4.0).frame(width: 100)
                Text("\(Int(zoomLevel * 100))%").font(.system(size: 10, design: .monospaced)).foregroundColor(.white).frame(width: 36, alignment: .trailing)
            }
            .padding(.horizontal, 8)
            Divider().frame(height: 16)
            HStack(spacing: 12) {
                if let variant = adjustmentController.currentVariant {
                    Text(variant.image?.path.split(separator: "/").last.map(String.init) ?? "—").font(.system(size: 10)).foregroundColor(.white).lineLimit(1)
                    Text("\(variant.image?.pixelWidth ?? 0) × \(variant.image?.pixelHeight ?? 0)").font(.system(size: 10, design: .monospaced)).foregroundColor(.gray)
                } else { Text("No selection").font(.system(size: 10)).foregroundColor(.gray) }
            }
            .padding(.horizontal, 8)
            Spacer()
            // Quick Ratings/Tags would go here...
        }
        .padding(.horizontal, 8).frame(height: 30).background(CaptureOneTheme.Colors.mainWindowTitleAndToolbar).foregroundColor(.white)
    }
}

public struct COViewerEmptyStateView: View {
    public init() {}
    public var body: some View {
        VStack(spacing: 14) {
            Image(systemName: "photo.on.rectangle.angled").font(.system(size: 64)).foregroundColor(CaptureOneTheme.Colors.textSecondary)
            Text("No image selected").font(.system(size: 20, weight: .semibold)).foregroundColor(.white)
            Text("Pick a variant from the browser or import new images.").font(.system(size: 13)).foregroundColor(CaptureOneTheme.Colors.textSecondary)
        }.padding(24)
    }
}

private struct ViewerGridOverlay: View {
    var body: some View {
        GeometryReader { proxy in
            Path { path in
                let w = proxy.size.width; let h = proxy.size.height
                path.move(to: CGPoint(x: w/3, y: 0)); path.addLine(to: CGPoint(x: w/3, y: h))
                path.move(to: CGPoint(x: w*2/3, y: 0)); path.addLine(to: CGPoint(x: w*2/3, y: h))
                path.move(to: CGPoint(x: 0, y: h/3)); path.addLine(to: CGPoint(x: w, y: h/3))
                path.move(to: CGPoint(x: 0, y: h*2/3)); path.addLine(to: CGPoint(x: w, y: h*2/3))
            }.stroke(Color.white.opacity(0.35), style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
        }
    }
}

private struct ViewerModeBadge: View {
    let text: String
    var body: some View {
        Text(text).font(.system(size: 10, weight: .bold)).padding(.horizontal, 8).padding(.vertical, 4)
            .background(Color.black.opacity(0.55)).foregroundColor(.white).clipShape(Capsule())
    }
}

/// Reconstructed Interactive Keystone UI (UI-006).
struct KeystoneOverlayView: View {
    let points: KeystonePoints
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Path { path in
                    path.move(to: denormalize(points.p0, in: geo.size)); path.addLine(to: denormalize(points.p1, in: geo.size))
                    path.move(to: denormalize(points.p2, in: geo.size)); path.addLine(to: denormalize(points.p3, in: geo.size))
                }.stroke(CaptureOneTheme.Colors.activeHighlight, lineWidth: 2)
                handle(at: points.p0, in: geo.size); handle(at: points.p1, in: geo.size)
                handle(at: points.p2, in: geo.size); handle(at: points.p3, in: geo.size)
            }
        }
    }
    private func handle(at point: CGPoint, in size: CGSize) -> some View {
        Circle().fill(CaptureOneTheme.Colors.activeHighlight).frame(width: 8, height: 8).position(denormalize(point, in: size))
    }
    private func denormalize(_ point: CGPoint, in size: CGSize) -> CGPoint {
        return CGPoint(x: point.x * size.width, y: point.y * size.height)
    }
}

struct BeforeAfterSplitView: View {
    let beforeImage: NSImage
    let afterImage: NSImage
    let afterCIImage: CIImage?
    @Binding var splitPosition: Double
    let viewerSize: CGSize
    var body: some View {
        ZStack {
            if let afterCIImage = afterCIImage, COMTRView.supportsMetal {
                COMTRView(image: afterCIImage)
                    .frame(width: viewerSize.width, height: viewerSize.height)
            } else {
                Image(nsImage: afterImage).resizable().aspectRatio(contentMode: .fit)
            }
            Image(nsImage: beforeImage).resizable().aspectRatio(contentMode: .fit)
                .mask(HStack(spacing: 0) {
                    Rectangle().frame(width: viewerSize.width * CGFloat(splitPosition))
                    Spacer(minLength: 0)
                })
            Rectangle().fill(Color.white).frame(width: 1)
                .overlay(Circle().fill(Color.white).frame(width: 24, height: 24).shadow(radius: 2)
                    .overlay(Image(systemName: "arrow.left.and.right").font(.system(size: 10)).foregroundColor(.black)))
                .position(x: viewerSize.width * CGFloat(splitPosition), y: viewerSize.height / 2)
                .gesture(DragGesture().onChanged { value in
                    splitPosition = Double(max(0, min(1, value.location.x / viewerSize.width)))
                })
        }
    }
}

extension CropRectHitboxCalculator.InteractionZone {
    var isRotation: Bool {
        return self == .rotateTopLeft || self == .rotateTopRight || self == .rotateBottomLeft || self == .rotateBottomRight
    }
}

private extension CIImage {
    func toNSImage() -> NSImage? {
        let context = CIContext()
        guard let cgImage = context.createCGImage(self, from: self.extent) else { return nil }
        return NSImage(cgImage: cgImage, size: NSSize(width: self.extent.width, height: self.extent.height))
    }
}
