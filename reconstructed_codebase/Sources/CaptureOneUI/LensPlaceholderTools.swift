import SwiftUI
import AppCoreShared
import DataCore

// MARK: - Crop (UI-204)
public struct CropToolView: View {
    @ObservedObject var controller: AdjustmentToolController
    
    public init(controller: AdjustmentToolController) {
        self.controller = controller
    }
    
    public var body: some View {
        COToolSection("Crop") {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Ratio")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    Spacer()
                    Picker("", selection: .constant(0)) {
                        Text("Unconstrained").tag(0)
                        Text("Original").tag(1)
                        Text("1x1 (Square)").tag(2)
                        Text("4x3").tag(3)
                        Text("16x9").tag(4)
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .frame(width: 120)
                }
                
                HStack(spacing: 8) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("1")
                            .font(.system(size: 11, design: .monospaced))
                            .padding(4)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .background(Color.black.opacity(0.3))
                        Text("Size")
                            .font(.system(size: 10))
                            .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    }
                    
                    Text("x")
                        .font(.system(size: 10))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                        .padding(.bottom, 16)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("1.5")
                            .font(.system(size: 11, design: .monospaced))
                            .padding(4)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .background(Color.black.opacity(0.3))
                        Text("Ratio")
                            .font(.system(size: 10))
                            .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                            .opacity(0)
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
        COToolSection("AI Crop") {
            VStack(alignment: .leading, spacing: 8) {
                Text("Auto crop to subject or face.")
                    .font(.system(size: 10))
                    .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                
                Button(action: {
                    // Stub
                }) {
                    Text("Auto Crop")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
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
        COToolSection("Rotation & Flip") {
            VStack(spacing: 12) {
                HStack {
                    Text("Angle")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                        .frame(width: 40, alignment: .leading)
                    Slider(value: Binding(
                        get: { controller.rotationAngle },
                        set: { controller.rotationAngle = $0 }
                    ), in: -45...45)
                    Text(String(format: "%.1f°", controller.rotationAngle))
                        .font(.system(size: 11, design: .monospaced))
                        .frame(width: 40, alignment: .trailing)
                }
                
                HStack(spacing: 8) {
                    Button(action: {}) { Image(systemName: "rotate.left") }
                    Button(action: {}) { Image(systemName: "rotate.right") }
                    Divider().frame(height: 12).background(Color.white.opacity(0.1))
                    Button(action: {}) { Image(systemName: "arrow.left.and.right.righttriangle.left.righttriangle.right") }
                    Button(action: {}) { Image(systemName: "arrow.up.and.down.righttriangle.up.righttriangle.down") }
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.vertical, 4)
        }
    }
}

// MARK: - Grid (UI-204)
public struct GridToolView: View {
    public init() {}
    
    public var body: some View {
        COToolSection("Grid") {
            VStack(spacing: 8) {
                HStack {
                    Text("Type")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    Spacer()
                    Picker("", selection: .constant(0)) {
                        Text("Rectangular").tag(0)
                        Text("Golden Ratio").tag(1)
                        Text("Fibonacci Spiral").tag(2)
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
    public init() {}
    
    public var body: some View {
        COToolSection("Guides") {
            VStack(spacing: 8) {
                HStack {
                    Button(action: {}) { Text("Add Guide") }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                    Spacer()
                }
                
                List {
                    Text("No guides added")
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 8)
                }
                .frame(height: 60)
                .listStyle(.plain)
                .background(Color.black.opacity(0.2))
                .cornerRadius(4)
            }
            .padding(.vertical, 4)
        }
    }
}
