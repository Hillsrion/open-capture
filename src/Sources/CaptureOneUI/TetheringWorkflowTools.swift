import SwiftUI
import AppCoreShared

/// Reconstructed Live for Studio tool (GAP-406, ENG-012).
/// High-performance local peer-to-peer sharing for the iPad app.
public struct LiveForStudioToolView: View {
    @ObservedObject var hostController = COLiveForStudioHostController.shared
    @State private var sessionName: String = "My Local Studio"
    
    public init(config: ToolConfiguration) {}
    public init() {}
    
    public var body: some View {
        COToolSection("Live for Studio", toolID: "LiveForStudio") {
            VStack(alignment: .leading, spacing: 10) {
                if !hostController.isStudioSharingActive {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Share your session on the local network for zero-latency iPad viewing.")
                            .font(.system(size: 10))
                            .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                        
                        TextField("Session Name", text: $hostController.currentSessionName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.system(size: 11))
                        
                        Button(action: { hostController.startSharing() }) {
                            Text("Start Local Studio Sharing")
                                .font(.system(size: 11, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(CaptureOneTheme.Colors.activeHighlight)
                                .foregroundColor(.black)
                                .cornerRadius(4)
                        }
                        .buttonStyle(.plain)
                    }
                } else {
                    activeStudioView
                }
            }
            .padding(.vertical, 4)
        }
    }
    
    private var activeStudioView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle().fill(Color.blue).frame(width: 8, height: 8)
                Text("Studio Sharing Active").font(.system(size: 11, weight: .bold))
                Spacer()
                Button("Stop") { hostController.stopSharing() }
                    .font(.system(size: 10))
                    .foregroundColor(.red)
            }
            
            Text("Broadcasting as: \(hostController.currentSessionName)")
                .font(.system(size: 10))
                .foregroundColor(.gray)
            
            HStack {
                Image(systemName: "ipad.landscape")
                    .font(.system(size: 10))
                Text("\(hostController.connectedPeerCount) Peers Connected")
                    .font(.system(size: 11))
            }
            .padding(.top, 4)
            
            Divider().background(Color.white.opacity(0.1))
            
            Button(action: {
                // In a real app, this would get the current selection
                hostController.broadcastFollowSelection(imageId: "IMAGE-001")
            }) {
                HStack {
                    Image(systemName: "arrow.right.to.line.alt")
                    Text("Trigger Follow Selection")
                }
                .font(.system(size: 11, weight: .bold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.1))
                .cornerRadius(4)
            }
            .buttonStyle(.plain)
            .help("Forces all connected iPad peers to switch to your current selection.")
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
    @ObservedObject var controller = CONextCaptureAdjustmentsController.shared
    
    public init() {}
    public var body: some View {
        COToolSection("Next Capture Adjustments", toolID: "NextCaptureAdjustments") {
            VStack(alignment: .leading, spacing: 8) {
                // All Other Dropdown
                HStack {
                    Text("All Other").font(.system(size: 11)).foregroundColor(.gray)
                    Spacer()
                    Picker("", selection: $controller.allOtherAdjustmentMode) {
                        ForEach(NextCaptureAdjustmentMode.allCases) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(MenuPickerStyle()).font(.system(size: 11))
                }
                
                // Specific Style Dropdown (Conditional)
                if controller.allOtherAdjustmentMode == .specificStyle {
                    HStack {
                        Text("Style").font(.system(size: 11)).foregroundColor(.gray)
                        Spacer()
                        Picker("", selection: $controller.specificStyleName) {
                            Text("None").tag("None")
                            Text("Cinematic").tag("Cinematic")
                            Text("B&W High Contrast").tag("B&W High Contrast")
                            Text("Landscape Vivid").tag("Landscape Vivid")
                        }
                        .pickerStyle(MenuPickerStyle()).font(.system(size: 11))
                    }
                }
                
                // ICC Profile Dropdown
                HStack {
                    Text("ICC Profile").font(.system(size: 11)).foregroundColor(.gray)
                    Spacer()
                    Picker("", selection: $controller.iccProfileMode) {
                        ForEach(NextCaptureSubAdjustmentMode.allCases) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(MenuPickerStyle()).font(.system(size: 11))
                }
                
                // Orientation Dropdown
                HStack {
                    Text("Orientation").font(.system(size: 11)).foregroundColor(.gray)
                    Spacer()
                    Picker("", selection: $controller.orientationMode) {
                        ForEach(NextCaptureSubAdjustmentMode.allCases) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(MenuPickerStyle()).font(.system(size: 11))
                }
                
                // Metadata Dropdown
                HStack {
                    Text("Metadata").font(.system(size: 11)).foregroundColor(.gray)
                    Spacer()
                    Picker("", selection: $controller.metadataMode) {
                        ForEach(NextCaptureSubAdjustmentMode.allCases) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(MenuPickerStyle()).font(.system(size: 11))
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
