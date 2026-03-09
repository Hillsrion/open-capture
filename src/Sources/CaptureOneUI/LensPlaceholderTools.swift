import SwiftUI
import AppCoreShared
import DataCore

// MARK: - Crop (UI-204)
public struct CropToolView: View {
    @ObservedObject var controller: AdjustmentToolController
    @State private var isMaskExpanded: Bool = false
    
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
                    Button(action: { withAnimation { isMaskExpanded.toggle() } }) {
                        HStack {
                            Image(systemName: isMaskExpanded ? "chevron.down" : "chevron.right")
                                .font(.system(size: 8, weight: .bold))
                            Text("Mask Settings")
                                .font(.system(size: 11, weight: .semibold))
                            Spacer()
                        }
                    }
                    .buttonStyle(.plain)
                    
                    if isMaskExpanded {
                        VStack(spacing: 8) {
                            Toggle("Show Mask", isOn: $controller.cropShowMask)
                                .font(.system(size: 11))
                            
                            HStack {
                                Text("Opacity")
                                    .font(.system(size: 11))
                                    .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                                    .frame(width: 60, alignment: .leading)
                                Slider(value: $controller.cropMaskOpacity, in: 0...100)
                                    .accentColor(CaptureOneTheme.Colors.activeHighlight)
                                Text("\(Int(controller.cropMaskOpacity))")
                                    .font(.system(size: 11, design: .monospaced))
                                    .frame(width: 30, alignment: .trailing)
                            }
                            
                            HStack {
                                Text("Brightness")
                                    .font(.system(size: 11))
                                    .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                                    .frame(width: 60, alignment: .leading)
                                Slider(value: $controller.cropMaskBrightness, in: -100...100)
                                    .accentColor(CaptureOneTheme.Colors.activeHighlight)
                                Text("\(Int(controller.cropMaskBrightness))")
                                    .font(.system(size: 11, design: .monospaced))
                                    .frame(width: 30, alignment: .trailing)
                            }
                        }
                        .padding(.leading, 14)
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
}

// MARK: - AI Crop (UI-204)
public struct AICropToolView: View {
    public init() {}
    
    public var body: some View {
        COToolSection("AI Crop", toolID: "AICrop") {
            VStack(alignment: .leading, spacing: 10) {
                Text("Auto crop to subject or face.")
                    .font(.system(size: 10))
                    .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                
                HStack(spacing: 8) {
                    Button(action: {
                        // AI Subject Crop Stub
                    }) {
                        Label("Subject", systemName: "person.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    
                    Button(action: {
                        // AI Face Crop Stub
                    }) {
                        Label("Face", systemName: "face.smiling")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
                .controlSize(.small)
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
                            // Flip Horizontal logic stub
                        }) {
                            Image(systemName: "arrow.left.and.right.righttriangle.left.righttriangle.right")
                                .frame(width: 24, height: 24)
                        }
                        Button(action: {
                            // Flip Vertical logic stub
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
                Toggle("Show Grid", isOn: $commands.showGridOverlay)
                    .font(.system(size: 11))
                
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
                                            .font(.system(size: 11))
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
