import SwiftUI
import AppCoreShared
import DataCore

// MARK: - Navigator (UI-203)
public struct NavigatorToolView: View {
    @ObservedObject var controller = AdjustmentToolController.shared

    public init() {}

    public var body: some View {
        COToolSection("Navigator", toolID: "Navigator") {
            VStack(spacing: 4) {
                GeometryReader { geo in
                    ZStack(alignment: .topLeading) {
                        // Simulated Thumbnail
                        Rectangle()
                            .fill(Color.black.opacity(0.3))

                        // Viewport rectangle
                        Rectangle()
                            .stroke(Color.red, lineWidth: 1)
                            .background(Color.red.opacity(0.1))
                            .frame(
                                width: geo.size.width * controller.viewportRect.width,
                                height: geo.size.height * controller.viewportRect.height
                            )
                            .offset(
                                x: geo.size.width * controller.viewportRect.origin.x,
                                y: geo.size.height * controller.viewportRect.origin.y
                            )
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        let newX = max(0, min(1.0 - controller.viewportRect.width, Double(value.location.x / geo.size.width) - Double(controller.viewportRect.width / 2)))
                                        let newY = max(0, min(1.0 - controller.viewportRect.height, Double(value.location.y / geo.size.height) - Double(controller.viewportRect.height / 2)))
                                        controller.viewportRect.origin = CGPoint(x: newX, y: newY)
                                    }
                            )
                    }
                }
                .aspectRatio(1.5, contentMode: .fit)
                .cornerRadius(2)

                HStack {
                    Button("Fit") {
                        controller.zoomLevel = 0.0 // Simulated "Fit"
                        controller.viewportRect = CGRect(x: 0, y: 0, width: 1, height: 1)
                    }
                    .font(.system(size: 10))
                    .buttonStyle(.plain)
                    .foregroundColor(controller.zoomLevel == 0 ? CaptureOneTheme.Colors.activeHighlight : CaptureOneTheme.Colors.textSecondary)

                    Spacer()

                    Text("\(Int(controller.zoomLevel * 100))%")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                }
                .padding(.horizontal, 2)
            }
        }
    }
}

// MARK: - Focus (UI-203)
public struct FocusToolView: View {
    @ObservedObject var controller = COFocusToolController.shared
    @ObservedObject var commands = AppCommandCenter.shared
    @ObservedObject var adjustments = AdjustmentToolController.shared
    
    public init() {}
    
    public var body: some View {
        COToolSection("Focus", toolID: "Focus") {
            VStack(spacing: 8) {
                HStack {
                    // Focus Mask Toggle
                    Button(action: { commands.showFocusMask.toggle() }) {
                        Image(systemName: "scope")
                            .font(.system(size: 14))
                            .foregroundColor(commands.showFocusMask ? CaptureOneTheme.Colors.activeHighlight : .white)
                    }
                    .buttonStyle(.plain)
                    .help("Toggle Focus Mask")
                    
                    Spacer()
                    
                    // Action Menu
                    Menu {
                        Button("Center to eye") {
                            controller.centerToEye()
                        }
                        Button("Sync Focus Point") {
                            controller.syncFocusPoint()
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.system(size: 14))
                    }
                    .menuStyle(.borderlessButton)
                    .frame(width: 20)
                }

                // Interactive Focus Preview Area (100% Zoom)
                ZStack {
                    Rectangle()
                        .fill(Color.black.opacity(0.3))
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(maxWidth: .infinity)
                    
                    if let variant = adjustments.currentVariant, let image = variant.image {
                        // Simulated Zoomed Preview
                        // In the real app, this renders a specific tile from the RAW engine
                        ZStack {
                            Image(nsImage: image.previewImage ?? NSImage())
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .scaleEffect(Double(1 << (controller.zoomIndex + 1))) // 1x, 2x, 4x from base
                                .offset(
                                    x: CGFloat(0.5 - controller.focusPoint.x) * 200.0 * CGFloat(1 << (controller.zoomIndex + 1)),
                                    y: CGFloat(0.5 - controller.focusPoint.y) * 200.0 * CGFloat(1 << (controller.zoomIndex + 1))
                                )
                                .clipped()
                            
                            if controller.isDetecting {
                                ProgressView()
                                    .scaleEffect(0.5)
                                    .background(Color.black.opacity(0.3).cornerRadius(4))
                            }
                        }
                        .frame(width: 200, height: 200)
                        
                        VStack {
                            Spacer()
                            HStack {
                                Text("\(controller.zoomIndex == 0 ? "100" : (controller.zoomIndex == 1 ? "200" : "400"))%")
                                    .font(.system(size: 9, weight: .bold))
                                    .padding(2)
                                    .background(Color.black.opacity(0.5))
                                    .cornerRadius(2)
                                Spacer()
                            }
                            .padding(4)
                        }
                    } else {
                        VStack {
                            Image(systemName: "viewfinder")
                                .font(.system(size: 32))
                                .foregroundColor(.white.opacity(0.2))
                        }
                    }
                }
                .cornerRadius(4)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            // Logic: Move focus point (normalized)
                            let newX = max(0, min(1, value.location.x / 200))
                            let newY = max(0, min(1, value.location.y / 200))
                            controller.focusPoint = CGPoint(x: newX, y: newY)
                        }
                )
                
                HStack {
                    Picker("", selection: $controller.aiMode) {
                        Text("Manual").tag(0)
                        Text("Center to Eye").tag(1)
                        Text("Center to Face").tag(2)
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .font(.system(size: 11))
                    .onChange(of: controller.aiMode) { mode in
                        if mode == 1 { controller.centerToEye() }
                    }
                    
                    Spacer()
                    
                    // Pick Focus Point (Eyedropper)
                    Button(action: {
                        commands.selectedCursorToolID = commands.selectedCursorToolID == "FocusPicker" ? "Select" : "FocusPicker"
                    }) {
                        Image(systemName: "eyedropper.halffull")
                            .font(.system(size: 14))
                            .foregroundColor(commands.selectedCursorToolID == "FocusPicker" ? CaptureOneTheme.Colors.activeHighlight : .white)
                    }
                    .buttonStyle(.plain)
                    .help("Pick Focus Point")
                }
                
                HStack {
                    Text("Zoom")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    
                    Spacer()
                    
                    Picker("", selection: $controller.zoomIndex) {
                        Text("100%").tag(0)
                        Text("200%").tag(1)
                        Text("400%").tag(2)
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .frame(width: 80)
                }
            }
            .padding(.vertical, 4)
        }
    }
}

// MARK: - Spot Removal (UI-204)
public struct SpotRemovalToolView: View {
    @ObservedObject var controller = AdjustmentToolController.shared

    public init() {}

    public var body: some View {
        COToolSection("Spot Removal", toolID: "SpotRemoval") {
            VStack(alignment: .leading, spacing: 8) {
                // Global Controls
                HStack(spacing: 8) {
                    Button(action: {
                        // AI Auto Dust Removal logic
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 14))
                            Text("Auto Dust")
                                .font(.system(size: 9))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(CaptureOneTheme.Colors.activeHighlight)
                        .foregroundColor(.black)
                        .cornerRadius(4)
                    }
                    .buttonStyle(.plain)

                    Button(action: {
                        controller.spots.removeAll()
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: "trash")
                                .font(.system(size: 14))
                            Text("Clear All")
                                .font(.system(size: 9))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(4)
                    }
                    .buttonStyle(.plain)
                }

                Divider().background(Color.white.opacity(0.1))

                if let selectedID = controller.selectedSpotID,
                   let index = controller.spots.firstIndex(where: { $0.id == selectedID }) {

                    VStack(spacing: 8) {
                        HStack {
                            Text("Type")
                                .font(.system(size: 11))
                                .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                            Spacer()
                            Picker("", selection: Binding(
                                get: { controller.spots[index].type },
                                set: { controller.spots[index].type = $0 }
                            )) {
                                Text("Dust").tag(0)
                                Text("Spot").tag(1)
                            }
                            .pickerStyle(.segmented)
                            .labelsHidden()
                            .frame(width: 100)
                        }

                        HStack {
                            Text("Radius")
                                .font(.system(size: 11))
                                .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                                .frame(width: 40, alignment: .leading)
                            Slider(value: Binding(
                                get: { controller.spots[index].radius },
                                set: { controller.spots[index].radius = $0 }
                            ), in: 1...100)
                            .accentColor(CaptureOneTheme.Colors.activeHighlight)
                            Text("\(Int(controller.spots[index].radius))")
                                .font(.system(size: 10, design: .monospaced))
                                .frame(width: 30, alignment: .trailing)
                        }
                    }
                    .padding(6)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(4)
                }

                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 1) {
                            if controller.spots.isEmpty {                                Text("No spots added")
                                    .font(.system(size: 11))
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.vertical, 8)
                            } else {
                                ForEach(controller.spots) { spot in
                                    HStack {
                                        Text(spot.type == 0 ? "Dust" : "Spot")
                                            .font(.system(size: 11))
                                        Spacer()
                                        Text("\(Int(spot.radius))px")
                                            .font(.system(size: 10, design: .monospaced))
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.horizontal, 8)
                                    .frame(height: 24)
                                    .background(controller.selectedSpotID == spot.id ? CaptureOneTheme.Colors.activeHighlight.opacity(0.3) : Color.clear)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        controller.selectedSpotID = spot.id
                                    }
                                }
                            }
                        }
                    }
                    .frame(height: 80)
                    .background(Color.black.opacity(0.2))
                    .cornerRadius(4)
                    
                    HStack(spacing: 0) {
                        Button(action: {
                            let newSpot = SpotItem()
                            controller.spots.append(newSpot)
                            controller.selectedSpotID = newSpot.id
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 10, weight: .bold))
                                .frame(width: 24, height: 20)
                        }
                        .buttonStyle(.plain)
                        .background(Color.white.opacity(0.05))
                        
                        Divider().frame(height: 20)
                        
                        Button(action: {
                            if let selectedID = controller.selectedSpotID {
                                controller.spots.removeAll(where: { $0.id == selectedID })
                                controller.selectedSpotID = controller.spots.last?.id
                            }
                        }) {
                            Image(systemName: "minus")
                                .font(.system(size: 10, weight: .bold))
                                .frame(width: 24, height: 20)
                        }
                        .buttonStyle(.plain)
                        .background(Color.white.opacity(0.05))
                        .disabled(controller.selectedSpotID == nil)
                        
                        Spacer()
                    }
                    .background(Color.white.opacity(0.02))
                }
            }
            .padding(.vertical, 4)
        }
    }
}

// MARK: - Lens Color Corrections (UI-203)
public struct LensColorCorrectionsToolView: View {
    public init() {}
    
    public var body: some View {
        COToolSection("Lens Correction", toolID: "LensColorCorrections") {
            VStack(spacing: 8) {
                HStack {
                    Text("Purple Fringing")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                        .frame(width: 100, alignment: .leading)
                    Slider(value: .constant(0), in: 0...100)
                    Text("0")
                        .font(.system(size: 11, design: .monospaced))
                        .frame(width: 24, alignment: .trailing)
                }
            }
            .padding(.vertical, 4)
        }
    }
}

// MARK: - Moire (UI-203)
public struct MoireToolView: View {
    @ObservedObject var controller: AdjustmentToolController
    
    public init(controller: AdjustmentToolController) {
        self.controller = controller
    }
    
    public var body: some View {
        COToolSection("Moiré", toolID: "Moire") {
            VStack(spacing: 8) {
                HStack {
                    Text("Amount")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                        .frame(width: 60, alignment: .leading)
                    Slider(value: Binding(
                        get: { controller.moireAmount },
                        set: { controller.moireAmount = $0 }
                    ), in: 0...100)
                    Text("\(Int(controller.moireAmount))")
                        .font(.system(size: 11, design: .monospaced))
                        .frame(width: 30, alignment: .trailing)
                }
                
                HStack {
                    Text("Pattern")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                        .frame(width: 60, alignment: .leading)
                    Slider(value: Binding(
                        get: { controller.moirePattern },
                        set: { controller.moirePattern = $0 }
                    ), in: 0...100)
                    Text("\(Int(controller.moirePattern))")
                        .font(.system(size: 11, design: .monospaced))
                        .frame(width: 30, alignment: .trailing)
                }
            }
            .padding(.vertical, 4)
        }
    }
}
