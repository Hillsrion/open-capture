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
                VStack(alignment: .leading, spacing: 8) {
                    // All Other Dropdown
                    HStack {
                        Text("All Other").font(.system(size: 11)).foregroundColor(.gray)
                        Spacer()
                        Picker("", selection: Binding(get: { camera.nextCaptureAdjustmentsOther }, set: { camera.nextCaptureAdjustmentsOther = $0 })) {
                            Text("Copy from Last").tag(P1CaptureCore_Camera.NextCaptureAdjustmentsOther.copyFromLast)
                            Text("Copy from Primary").tag(P1CaptureCore_Camera.NextCaptureAdjustmentsOther.copyFromPrimary)
                            Text("Defaults").tag(P1CaptureCore_Camera.NextCaptureAdjustmentsOther.neutral)
                        }
                        .pickerStyle(MenuPickerStyle()).font(.system(size: 11))
                    }
                    
                    // ICC Profile Dropdown
                    HStack {
                        Text("ICC Profile").font(.system(size: 11)).foregroundColor(.gray)
                        Spacer()
                        Picker("", selection: Binding(get: { camera.nextCaptureAdjustmentsICCProfile }, set: { camera.nextCaptureAdjustmentsICCProfile = $0 })) {
                            Text("Default").tag("Default")
                            Text("sRGB").tag("sRGB")
                            Text("Adobe RGB").tag("Adobe RGB")
                        }
                        .pickerStyle(MenuPickerStyle()).font(.system(size: 11))
                    }
                    
                    // Orientation Dropdown
                    HStack {
                        Text("Orientation").font(.system(size: 11)).foregroundColor(.gray)
                        Spacer()
                        Picker("", selection: Binding(get: { camera.nextCaptureAdjustmentsOrientation }, set: { camera.nextCaptureAdjustmentsOrientation = $0 })) {
                            Text("0").tag("0")
                            Text("90").tag("90")
                            Text("180").tag("180")
                            Text("270").tag("270")
                        }
                        .pickerStyle(MenuPickerStyle()).font(.system(size: 11))
                    }
                    
                    // Style Dropdown
                    HStack {
                        Text("Style").font(.system(size: 11)).foregroundColor(.gray)
                        Spacer()
                        Picker("", selection: Binding(get: { camera.nextCaptureAdjustmentsOtherStyleUUIDs }, set: { camera.nextCaptureAdjustmentsOtherStyleUUIDs = $0 })) {
                            Text("None").tag("None")
                            Text("Cinematic").tag("Cinematic")
                            Text("B&W High Contrast").tag("B&W High Contrast")
                        }
                        .pickerStyle(MenuPickerStyle()).font(.system(size: 11))
                    }

                    // Metadata Checkbox
                    Toggle("Metadata", isOn: Binding(get: { camera.nextCaptureAdjustmentsMetadata }, set: { camera.nextCaptureAdjustmentsMetadata = $0 }))
                        .font(.system(size: 11))
                        
                    // Auto-Crop Checkbox
                    Toggle("Auto-Crop", isOn: Binding(get: { camera.autoCropEnabled }, set: { camera.autoCropEnabled = $0 }))
                        .font(.system(size: 11))
                }
            }
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
                    Button("Choose Folder...") {
                        let panel = NSOpenPanel()
                        panel.canChooseFiles = false
                        panel.canChooseDirectories = true
                        panel.allowsMultipleSelection = false
                        if panel.runModal() == .OK {
                            location = panel.url?.path ?? location
                        }
                    }
                }
                .font(.system(size: 11, weight: .bold))
            }
        }
    }
}

/// Reconstructed Next Capture Metadata (GAP-406).
public struct NextCaptureMetadataToolView: View {
    @ObservedObject var browser = PtpDeviceBrowser.shared
    public init(config: ToolConfiguration) {}
    public var body: some View {
        COToolSection("Next Capture Metadata", toolID: "NextCaptureMetadata") {
            if let camera = browser.availableCameras.first {
                VStack(alignment: .leading, spacing: 6) {
                    Toggle("IPTC", isOn: Binding(get: { camera.autoSyncIPTC }, set: { camera.autoSyncIPTC = $0 }))
                        .font(.system(size: 11))
                    Toggle("Keywords", isOn: Binding(get: { camera.autoSyncKeywords }, set: { camera.autoSyncKeywords = $0 }))
                        .font(.system(size: 11))
                    Toggle("Ratings & Color Tags", isOn: Binding(get: { camera.autoSyncRatings }, set: { camera.autoSyncRatings = $0 }))
                        .font(.system(size: 11))
                }
                .padding(.vertical, 4)
            } else {
                Text("Metadata will be applied to the next capture.").font(.system(size: 10)).foregroundColor(.gray)
            }
        }
    }
}

/// Reconstructed Next Capture Keywords (GAP-406).
public struct NextCaptureKeywordsToolView: View {
    @ObservedObject var browser = PtpDeviceBrowser.shared
    public init(config: ToolConfiguration) {}
    public var body: some View {
        COToolSection("Next Capture Keywords", toolID: "NextCaptureKeywords") {
            if let camera = browser.availableCameras.first {
                VStack(alignment: .leading, spacing: 8) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Keywords").font(.system(size: 10)).foregroundColor(.gray)
                        TextField("Enter keywords...", text: Binding(get: { camera.nextCaptureKeywords }, set: { camera.nextCaptureKeywords = $0 }))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.system(size: 11))
                    }
                    
                    HStack {
                        Text("Apply to next").font(.system(size: 11))
                        TextField("", value: Binding(get: { camera.nextCaptureKeywordsRemaining }, set: { camera.nextCaptureKeywordsRemaining = $0 }), formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 40)
                            .font(.system(size: 11, design: .monospaced))
                        Text("images").font(.system(size: 11))
                        Spacer()
                    }
                }
                .padding(.vertical, 4)
            } else {
                Text("Keywords for next capture.").font(.system(size: 10)).foregroundColor(.gray)
            }
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
