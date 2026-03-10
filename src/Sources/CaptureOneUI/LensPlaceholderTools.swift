import SwiftUI
import AppCoreShared
import DataCore

// MARK: - Crop (UI-204)
public struct CropToolView: View {
    @ObservedObject var controller: AdjustmentToolController
    @State private var isMaskExpanded: Bool = false
    @State private var isAdvancedExpanded: Bool = false
    
    public init(controller: AdjustmentToolController) {
        self.controller = controller
    }
    
    public var body: some View {
        COToolSection("Crop", toolID: "Crop") {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Ratio")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    Spacer()
                    Picker("", selection: $controller.cropRatioIndex) {
                        Text("Unconstrained").tag(0)
                        Text("Original").tag(1)
                        Text("1x1 (Square)").tag(2)
                        Text("4x3").tag(3)
                        Text("16x9").tag(4)
                        Text("3x2").tag(5)
                        Text("5x4").tag(6)
                        Text("7x5").tag(7)
                        if !controller.customRatios.isEmpty {
                            Divider()
                            ForEach(controller.customRatios, id: \.self) { ratio in
                                Text(ratio).tag(ratio.hashValue)
                            }
                        }
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .frame(width: 120)
                }
                
                HStack(spacing: 8) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(Int(controller.cropRect.width))")
                            .font(.system(size: 11, design: .monospaced))
                            .padding(4)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .background(Color.black.opacity(0.3))
                        Text("Width")
                            .font(.system(size: 10))
                            .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    }
                    
                    Text("x")
                        .font(.system(size: 10))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                        .padding(.bottom, 16)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(Int(controller.cropRect.height))")
                            .font(.system(size: 11, design: .monospaced))
                            .padding(4)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .background(Color.black.opacity(0.3))
                        Text("Height")
                            .font(.system(size: 10))
                            .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    }
                }
                
                Divider().background(Color.white.opacity(0.05))
                
                VStack(spacing: 8) {
                    disclosureButton(title: "Mask Settings", isExpanded: $isMaskExpanded)
                    
                    if isMaskExpanded {
                        VStack(spacing: 8) {
                            Toggle("Show Mask", isOn: $controller.cropShowMask)
                                .font(.system(size: 11))
                            
                            sliderRow(label: "Opacity", value: $controller.cropMaskOpacity, range: 0...100)
                            sliderRow(label: "Brightness", value: $controller.cropMaskBrightness, range: -100...100)
                        }
                        .padding(.leading, 14)
                    }
                    
                    disclosureButton(title: "Advanced", isExpanded: $isAdvancedExpanded)
                    
                    if isAdvancedExpanded {
                        VStack(alignment: .leading, spacing: 10) {
                            Toggle("Respect Fujifilm In-Camera Crop", isOn: $controller.respectFujifilmInCameraCrop)
                                .font(.system(size: 11))
                            
                            Button(action: {
                                // Add custom ratio logic
                            }) {
                                Label("Add Custom Ratio...", systemImage: "plus.rectangle.on.rectangle")
                                    .font(.system(size: 10))
                            }
                            .buttonStyle(.plain)
                            .foregroundColor(CaptureOneTheme.Colors.activeHighlight)
                        }
                        .padding(.leading, 14)
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
    
    private func disclosureButton(title: String, isExpanded: Binding<Bool>) -> some View {
        Button(action: { withAnimation { isExpanded.wrappedValue.toggle() } }) {
            HStack {
                Image(systemName: isExpanded.wrappedValue ? "chevron.down" : "chevron.right")
                    .font(.system(size: 8, weight: .bold))
                Text(title)
                    .font(.system(size: 11, weight: .semibold))
                Spacer()
            }
        }
        .buttonStyle(.plain)
    }
    
    private func sliderRow(label: String, value: Binding<Double>, range: ClosedRange<Double>) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                .frame(width: 60, alignment: .leading)
            Slider(value: value, in: range)
                .accentColor(CaptureOneTheme.Colors.activeHighlight)
            Text("\(Int(value.wrappedValue))")
                .font(.system(size: 11, design: .monospaced))
                .frame(width: 30, alignment: .trailing)
        }
    }
}

// MARK: - AI Crop (UI-204)
public struct AICropToolView: View {
    @ObservedObject var controller: AdjustmentToolController
    
    public init(controller: AdjustmentToolController) {
        self.controller = controller
    }
    
    public var body: some View {
        COToolSection("AI Crop", toolID: "AICrop") {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Mode")
                        .font(.system(size: 11))
                    Spacer()
                    Picker("", selection: $controller.focusAIMode) {
                        Text("Auto").tag(0)
                        Text("Subject").tag(1)
                        Text("Face").tag(2)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 150)
                }
                
                HStack(spacing: 8) {
                    Button(action: {
                        // Set Reference logic
                    }) {
                        Label("Set Reference", systemImage: "pin.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    
                    Button(action: {
                        // Apply AI Crop logic
                    }) {
                        Label("Apply", systemImage: "magicmouse.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
                .controlSize(.small)
                
                Text("Align composition automatically using reference image.")
                    .font(.system(size: 9))
                    .foregroundColor(CaptureOneTheme.Colors.textSecondary)
            }
            .padding(.vertical, 4)
        }
    }
}

// MARK: - Rotation & Flip (UI-204)
public struct RotationToolView: View {
    @ObservedObject var controller: AdjustmentToolController
    
    public init(controller: AdjustmentToolController) {
        self.controller = controller
    }
    
    public var body: some View {
        COToolSection("Rotation & Flip", toolID: "Rotation") {
            VStack(spacing: 12) {
                HStack {
                    Text("Angle")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                        .frame(width: 40, alignment: .leading)
                    Slider(value: $controller.rotationAngle, in: -45...45)
                        .accentColor(CaptureOneTheme.Colors.activeHighlight)
                    Text(String(format: "%.1f°", controller.rotationAngle))
                        .font(.system(size: 11, design: .monospaced))
                        .frame(width: 40, alignment: .trailing)
                }
                
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Button(action: { controller.rotationAngle -= 90 }) {
                            Image(systemName: "rotate.left")
                                .frame(width: 24, height: 24)
                        }
                        Button(action: { controller.rotationAngle += 90 }) {
                            Image(systemName: "rotate.right")
                                .frame(width: 24, height: 24)
                        }
                    }
                    
                    Divider().frame(height: 16).background(Color.white.opacity(0.1))
                    
                    HStack(spacing: 4) {
                        Button(action: {
                            // Flip Horizontal
                        }) {
                            Image(systemName: "arrow.left.and.right.righttriangle.left.righttriangle.right")
                                .frame(width: 24, height: 24)
                        }
                        Button(action: {
                            // Flip Vertical
                        }) {
                            Image(systemName: "arrow.up.and.down.righttriangle.up.righttriangle.down")
                                .frame(width: 24, height: 24)
                        }
                    }
                }
                .buttonStyle(.plain)
                .imageScale(.medium)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.vertical, 4)
        }
    }
}

// MARK: - Grid (UI-204)
public struct GridToolView: View {
    @ObservedObject var controller: AdjustmentToolController
    @ObservedObject var commands = AppCommandCenter.shared
    
    public init(controller: AdjustmentToolController) {
        self.controller = controller
    }
    
    public var body: some View {
        COToolSection("Grid", toolID: "Grid") {
            VStack(spacing: 10) {
                HStack {
                    Toggle("Show Grid", isOn: $commands.showGridOverlay)
                        .font(.system(size: 11))
                    Spacer()
                    Toggle("Follow Crop", isOn: $controller.gridFollowCrop)
                        .font(.system(size: 11))
                }
                
                HStack {
                    Text("Type")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    Spacer()
                    Picker("", selection: $controller.gridTypeIndex) {
                        Text("Rectangular").tag(0)
                        Text("Golden Ratio").tag(1)
                        Text("Fibonacci Spiral").tag(2)
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .frame(width: 120)
                }
                
                if controller.gridTypeIndex == 2 { // Fibonacci Spiral
                    HStack(spacing: 12) {
                        Text("Spiral Controls")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                        Spacer()
                        
                        Button(action: { controller.gridFibonacciClockwise.toggle() }) {
                            Image(systemName: "arrow.clockwise")
                                .padding(4)
                                .background(controller.gridFibonacciClockwise ? CaptureOneTheme.Colors.activeHighlight : Color.white.opacity(0.1))
                                .cornerRadius(4)
                        }
                        
                        Button(action: { controller.gridFibonacciMirror.toggle() }) {
                            Image(systemName: "arrow.left.and.right")
                                .padding(4)
                                .background(controller.gridFibonacciMirror ? CaptureOneTheme.Colors.activeHighlight : Color.white.opacity(0.1))
                                .cornerRadius(4)
                        }
                    }
                    .buttonStyle(.plain)
                    .imageScale(.small)
                }
                
                HStack {
                    Text("Color")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    Spacer()
                    Picker("", selection: $controller.gridColorIndex) {
                        Text("White").tag(0)
                        Text("Gray").tag(1)
                        Text("Black").tag(2)
                        Text("Amber").tag(3)
                        Text("Red").tag(4)
                        Text("Cyan").tag(5)
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .frame(width: 120)
                }
            }
            .padding(.vertical, 4)
        }
    }
}

// MARK: - Guides (UI-204)
public struct GuidesToolView: View {
    @ObservedObject var controller: AdjustmentToolController
    
    public init(controller: AdjustmentToolController) {
        self.controller = controller
    }
    
    public var body: some View {
        COToolSection("Guides", toolID: "Guides") {
            VStack(spacing: 8) {
                HStack {
                    Menu {
                        Button("Vertical Guide") {
                            controller.guides.append(GuideItem(position: 0.5, isVertical: true))
                        }
                        Button("Horizontal Guide") {
                            controller.guides.append(GuideItem(position: 0.5, isVertical: false))
                        }
                    } label: {
                        Text("Add Guide")
                            .font(.system(size: 11))
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    
                    Spacer()
                    
                    Button("Clear All") {
                        controller.guides.removeAll()
                    }
                    .font(.system(size: 10))
                    .buttonStyle(.plain)
                    .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                }
                
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 1) {
                            if controller.guides.isEmpty {
                                Text("No guides added")
                                    .font(.system(size: 11))
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.vertical, 12)
                            } else {
                                ForEach(controller.guides) { guide in
                                    HStack {
                                        Image(systemName: guide.isVertical ? "line.3.crossed.swirl.circle" : "line.3.horizontal.circle")
                                            .font(.system(size: 10))
                                            .foregroundColor(.gray)
                                        Text(guide.isVertical ? "Vertical" : "Horizontal")
                                            .font(.system(size: 11) )
                                        Spacer()
                                        Text("\(Int(guide.position * 100))%")
                                            .font(.system(size: 10, design: .monospaced))
                                            .foregroundColor(.gray)
                                        
                                        Button(action: {
                                            controller.guides.removeAll(where: { $0.id == guide.id })
                                        }) {
                                            Image(systemName: "xmark")
                                                .font(.system(size: 8, weight: .bold))
                                                .foregroundColor(.gray)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                    .padding(.horizontal, 8)
                                    .frame(height: 24)
                                    .background(Color.white.opacity(0.02))
                                }
                            }
                        }
                    }
                    .frame(height: 80)
                    .background(Color.black.opacity(0.2))
                    .cornerRadius(4)
                }
            }
            .padding(.vertical, 4)
        }
    }
}
