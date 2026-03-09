import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Overlay tool (GAP-406).
public struct OverlayToolView: View {
    @State private var showOverlay: Bool = false
    @State private var opacity: Double = 50.0
    @State private var scale: Double = 100.0
    @State private var followCrop: Bool = true
    @State private var imagePath: String = ""
    
    public init(config: ToolConfiguration) {}
    public init() {}
    
    public var body: some View {
        COToolSection("Overlay", toolID: "Overlay") {
            VStack(spacing: 10) {
                HStack {
                    Toggle("Show Overlay", isOn: $showOverlay)
                        .font(.system(size: 11))
                    Spacer()
                    Button("Choose...") { }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                }
                
                VStack(spacing: 8) {
                    overlaySlider(label: "Opacity", value: $opacity, range: 0...100)
                    overlaySlider(label: "Scale", value: $scale, range: 1...200)
                    Toggle("Follow Crop", isOn: $followCrop)
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.top, 4)
            }
            .padding(.vertical, 4)
        }
    }
    
    private func overlaySlider(label: String, value: Binding<Double>, range: ClosedRange<Double>) -> some View {
        HStack {
            Text(label).font(.system(size: 11)).foregroundColor(CaptureOneTheme.Colors.textSecondary).frame(width: 50, alignment: .leading)
            Slider(value: value, in: range).accentColor(CaptureOneTheme.Colors.activeHighlight)
            Text("\(Int(value.wrappedValue))%").font(.system(size: 10, design: .monospaced)).frame(width: 35, alignment: .trailing)
        }
    }
}

/// Reconstructed Live for Studio tool (GAP-406).
public struct LiveForStudioToolView: View {
    @State private var compensationEnabled: Bool = false
    @State private var intensity: Double = 0.0
    
    public init(config: ToolConfiguration) {}
    public init() {}
    
    public var body: some View {
        COToolSection("Live for Studio", toolID: "LiveForStudio") {
            VStack(alignment: .leading, spacing: 10) {
                Toggle("Enable Compensation", isOn: $compensationEnabled).font(.system(size: 11))
                if compensationEnabled {
                    HStack {
                        Text("Intensity").font(.system(size: 11)).foregroundColor(CaptureOneTheme.Colors.textSecondary)
                        Slider(value: $intensity, in: -2...2).accentColor(CaptureOneTheme.Colors.activeHighlight)
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
}

/// Reconstructed Next Capture Naming tool (GAP-406).
public struct NextCaptureNamingToolView: View {
    @ObservedObject var browser = PtpDeviceBrowser.shared
    public init() {}
    public var body: some View {
        COToolSection("Next Capture Naming", toolID: "NextCaptureNaming") {
            VStack(alignment: .leading, spacing: 10) {
                if let camera = browser.availableCameras.first {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Format").font(.system(size: 10)).foregroundColor(.gray)
                        HStack {
                            TextField("", text: Binding(get: { camera.namingFormat }, set: { camera.namingFormat = $0 }))
                                .textFieldStyle(RoundedBorderTextFieldStyle()).font(.system(size: 11, design: .monospaced))
                            Button(action: {}) { Image(systemName: "ellipsis") }.buttonStyle(.bordered)
                        }
                    }
                    HStack {
                        Text("Sample:").font(.system(size: 10)).foregroundColor(.gray)
                        Text(camera.nextCaptureName).font(.system(size: 10, weight: .bold)).foregroundColor(.white)
                    }
                    Divider().background(Color.white.opacity(0.05))
                    HStack {
                        Text("Counter").font(.system(size: 11))
                        Spacer()
                        TextField("", value: Binding(get: { camera.namingCounter }, set: { camera.namingCounter = $0 }), formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle()).frame(width: 60).font(.system(size: 11, design: .monospaced))
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
}

/// Reconstructed Next Capture Adjustments (GAP-406).
public struct NextCaptureAdjustmentsToolView: View {
    @ObservedObject var browser = PtpDeviceBrowser.shared
    public init() {}
    public var body: some View {
        COToolSection("Next Capture Adjustments", toolID: "NextCaptureAdjustments") {
            if let camera = browser.availableCameras.first {
                Picker("", selection: Binding(get: { camera.nextCaptureAdjustments }, set: { camera.nextCaptureAdjustments = $0 })) {
                    Text("Copy from Last").tag(P1CaptureCore_Camera.NextCaptureAdjustments.copyFromLast)
                    Text("Copy from Primary").tag(P1CaptureCore_Camera.NextCaptureAdjustments.copyFromPrimary)
                    Text("Neutral").tag(P1CaptureCore_Camera.NextCaptureAdjustments.neutral)
                }
                .pickerStyle(MenuPickerStyle()).font(.system(size: 11))
            }
        }
    }
}

/// Reconstructed Exposure Evaluation Tool (GAP-406).
public struct ExposureEvaluationToolView: View {
    @ObservedObject var browser = PtpDeviceBrowser.shared
    public init(adjustmentController: AdjustmentToolController, config: ToolConfiguration) {}
    public var body: some View {
        COToolSection("Exposure Evaluation", toolID: "ExposureEvaluation") {
            VStack(spacing: 8) {
                if let camera = browser.availableCameras.first {
                    ExposureEvaluationMeter(value: camera.exposureEvaluation)
                }
            }
            .padding(.vertical, 4)
        }
    }
}

/// Reconstructed Normalize tool (ui-205).
public struct NormalizeToolView: View {
    public init() {}
    public var body: some View {
        COToolSection("Normalize", toolID: "Normalize") {
            VStack(alignment: .leading, spacing: 8) {
                Text("Pick an area to define baseline exposure/color.").font(.system(size: 10)).foregroundColor(.gray)
                Button(action: {}) {
                    Text("Apply Normalization").frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            .padding(.vertical, 4)
        }
    }
}

/// Reconstructed Next Capture Location (GAP-406).
public struct NextCaptureLocationToolView: View {
    @State private var location: String = "Capture Folder"
    public init(config: ToolConfiguration) {}
    public var body: some View {
        COToolSection("Next Capture Location", toolID: "NextCaptureLocation") {
            HStack {
                Text("Destination").font(.system(size: 11)).foregroundColor(.gray)
                Spacer()
                Menu(location) {
                    Button("Capture Folder") { location = "Capture Folder" }
                    Button("Choose Folder...") { }
                }
                .font(.system(size: 11, weight: .bold))
            }
        }
    }
}

/// Reconstructed Next Capture Metadata (GAP-406).
public struct NextCaptureMetadataToolView: View {
    public init(config: ToolConfiguration) {}
    public var body: some View {
        COToolSection("Next Capture Metadata", toolID: "NextCaptureMetadata") {
            Text("Metadata will be applied to the next capture.").font(.system(size: 10)).foregroundColor(.gray)
        }
    }
}

/// Reconstructed Next Capture Keywords (GAP-406).
public struct NextCaptureKeywordsToolView: View {
    public init(config: ToolConfiguration) {}
    public var body: some View {
        COToolSection("Next Capture Keywords", toolID: "NextCaptureKeywords") {
            Text("Keywords for next capture.").font(.system(size: 10)).foregroundColor(.gray)
        }
    }
}

/// Reconstructed Next Capture Backup (GAP-406).
public struct NextCaptureBackupToolView: View {
    @State private var enabled: Bool = false
    public init(config: ToolConfiguration) {}
    public var body: some View {
        COToolSection("Next Capture Backup", toolID: "NextCaptureBackup") {
            Toggle("Queue Backup", isOn: $enabled).font(.system(size: 11))
        }
    }
}
