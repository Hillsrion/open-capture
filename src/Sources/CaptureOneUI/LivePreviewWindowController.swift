import Cocoa
import SwiftUI
import AppCoreShared
import ImageCore
import DataCore
import UniformTypeIdentifiers

/// Standalone Window Controller for Live View Engine Restoration (GAP-401).
/// Hosts a live video stream area and a Workspace-driven sidebar for Live Preview tools.
public class LivePreviewWindowController: NSWindowController {
    
    private var session: SessionBase
    private var workspace: Workspace
    
    public init(session: SessionBase) {
        self.session = session
        // Request the specific live preview workspace preset
        self.workspace = WorkspaceManager.createWorkspace(windowKind: .livePreview, name: "Live Preview")
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1000, height: 750),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.title = "Live View - \(session.name ?? "Untitled")"
        window.center()
        window.titlebarAppearsTransparent = true
        window.backgroundColor = NSColor(calibratedWhite: 0.12, alpha: 1.0)
        
        super.init(window: window)
        
        let contentView = LivePreviewRootView(session: session, workspace: workspace)
        window.contentView = NSHostingView(rootView: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Root View

fileprivate struct LivePreviewRootView: View {
    let session: SessionBase
    @State var workspace: Workspace
    @StateObject private var adjustmentController = AdjustmentToolController.shared
    @StateObject private var liveView = LiveViewEngine.shared
    @StateObject private var browser = PtpDeviceBrowser.shared
    
    @State private var overlayImageURL: URL?
    @State private var overlayOpacity: Double = 0.5
    @State private var isOverlayEnabled: Bool = false
    @State private var isDropTarget: Bool = false
    
    var body: some View {
        HStack(spacing: 0) {
            // Main Live Stream Area
            VStack(spacing: 0) {
                // Live View Toolbar
                HStack(spacing: 12) {
                    Button(action: {}) { Image(systemName: "hand.draw") }.buttonStyle(.plain)
                    Button(action: {}) { Image(systemName: "eyedropper") }.buttonStyle(.plain)
                    
                    Divider().frame(height: 16)
                    
                    if let camera = browser.availableCameras.first {
                        // Pause/Play Live View
                        Button(action: {
                            if liveView.isActive {
                                liveView.stop()
                            } else {
                                liveView.start(for: camera)
                            }
                        }) {
                            Image(systemName: liveView.isActive ? "pause.fill" : "play.fill")
                        }
                        .buttonStyle(.plain)
                        .help("Pause/Play Live View")
                        
                        // Overlay Toggle
                        Button(action: { isOverlayEnabled.toggle() }) {
                            Image(systemName: isOverlayEnabled ? "square.3.layers.3d.down.right" : "square.grid.3x3.fill")
                                .foregroundColor(isOverlayEnabled ? CaptureOneTheme.Colors.activeHighlight : .white)
                        }
                        .buttonStyle(.plain)
                        .help("Overlay Toggle")
                        
                        // DOF Preview
                        Button(action: { camera.isLiveViewDOFOn.toggle() }) {
                            Image(systemName: camera.isLiveViewDOFOn ? "aperture" : "camera.aperture")
                                .foregroundColor(camera.isLiveViewDOFOn ? CaptureOneTheme.Colors.activeHighlight : .white)
                        }
                        .buttonStyle(.plain)
                        .disabled(!camera.isLiveViewDOFEnabled)
                        .help("Depth of Field Preview")
                        
                        Divider().frame(height: 16)
                        
                        // Focus Meter
                        HStack(spacing: 4) {
                            Image(systemName: "scope")
                            ProgressView(value: camera.focusMeterValue)
                                .progressViewStyle(LinearProgressViewStyle(tint: .green))
                                .frame(width: 100)
                        }
                        .opacity(camera.supportsFocusMetering ? 1.0 : 0.3)
                        .help(camera.supportsFocusMetering ? "Focus Meter" : "Focus Meter Not Supported")
                            
                        Spacer()
                        
                        Button("Capture") {
                            camera.shutterRelease()
                        }.buttonStyle(.borderedProminent)
                    } else {
                        Spacer()
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.black.opacity(0.8))
                
                // Stream Container
                ZStack {
                    CaptureOneTheme.Colors.applicationBackground
                    
                    if liveView.isActive {
                        LiveViewOverlayView(camera: liveView.currentCamera)
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "camera.viewfinder")
                                .font(.system(size: 64))
                                .foregroundColor(Color.white.opacity(0.2))
                            Text("Live View Stream Paused")
                                .font(.title3)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Overlay Composition Logic
                    if isOverlayEnabled {
                        Group {
                            if let url = overlayImageURL, let nsImage = NSImage(contentsOf: url) {
                                Image(nsImage: nsImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .opacity(overlayOpacity)
                                    .allowsHitTesting(false)
                            } else {
                                ZStack {
                                    Color.black.opacity(0.4)
                                    Text("Drop Reference Image Here")
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.black.opacity(0.7))
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                    
                    if isDropTarget {
                        Color.blue.opacity(0.2)
                            .border(Color.blue, width: 2)
                    }
                }
                .onDrop(of: [UTType.image], isTargeted: $isDropTarget) { providers in
                    if let provider = providers.first(where: { $0.canLoadObject(ofClass: URL.self) }) {
                        _ = provider.loadObject(ofClass: URL.self) { url, _ in
                            if let url = url {
                                DispatchQueue.main.async {
                                    self.overlayImageURL = url
                                    self.isOverlayEnabled = true
                                }
                            }
                        }
                        return true
                    }
                    return false
                }
                
                // Overlay Opacity slider (if enabled and image present)
                if isOverlayEnabled && overlayImageURL != nil {
                    HStack {
                        Text("Overlay Opacity")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Slider(value: $overlayOpacity, in: 0...1)
                    }
                    .padding(8)
                    .background(Color.black.opacity(0.8))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Divider().background(Color.black)
            
            // Reconstructed Tool Sidebar based on workspace preset
            VStack(spacing: 0) {
                // Tab Selection
                HStack(spacing: 0) {
                    ForEach(workspace.palettes) { palette in
                        Button(action: {
                            WorkspaceManager.shared.setSelectedPaletteID(palette.id, autosave: false)
                            workspace.chromeState.selectedToolPaletteID = palette.id
                        }) {
                            Image(systemName: palette.iconName)
                                .font(.system(size: 14))
                                .foregroundColor(workspace.selectedPaletteID == palette.id ? CaptureOneTheme.Colors.activeHighlight : .gray)
                                .frame(height: 36)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.plain)
                        .background(workspace.selectedPaletteID == palette.id ? Color.black.opacity(0.4) : Color.clear)
                    }
                }
                .background(Color(NSColor.windowBackgroundColor))
                
                Divider().background(Color.black)
                
                // Dedicated Camera Control Panel & Focus Controls
                ScrollView {
                    VStack(spacing: 1) {
                        if let camera = browser.availableCameras.first {
                            // Dedicated Live View Camera Control Panel
                            COToolSection("Live View Camera Controls", toolID: "LiveViewControls") {
                                VStack(spacing: 12) {
                                    // Exposure Settings
                                    VStack(spacing: 1) {
                                        ForEach(camera.properties.filter { ["Shutter", "Aperture", "ISO"].contains($0.id) }) { prop in
                                            LiveViewPropertyRow(property: prop, camera: camera)
                                        }
                                    }
                                    .background(Color.black.opacity(0.2))
                                    .cornerRadius(4)
                                    
                                    // White Balance Picker
                                    if let wbProp = camera.properties.first(where: { $0.id == "WB" }) {
                                        VStack(spacing: 1) {
                                            LiveViewPropertyRow(property: wbProp, camera: camera)
                                        }
                                        .background(Color.black.opacity(0.2))
                                        .cornerRadius(4)
                                    }
                                    
                                    // Focus Controls
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Focus Controls").font(.system(size: 11)).foregroundColor(.gray)
                                        HStack(spacing: 8) {
                                            Button(action: { camera.nudgeFocus(step: -2) }) {
                                                Image(systemName: "chevron.backward.2").frame(width: 28, height: 24).background(Color.white.opacity(0.1)).cornerRadius(4)
                                            }
                                            Button(action: { camera.nudgeFocus(step: -1) }) {
                                                Image(systemName: "chevron.backward").frame(width: 28, height: 24).background(Color.white.opacity(0.1)).cornerRadius(4)
                                            }
                                            Button(action: { camera.focusMode = 1 }) {
                                                Text("AF")
                                                    .font(.system(size: 11, weight: .bold))
                                                    .frame(maxWidth: .infinity, minHeight: 24)
                                                    .background(Color.white.opacity(0.1))
                                                    .cornerRadius(4)
                                            }
                                            Button(action: { camera.nudgeFocus(step: 1) }) {
                                                Image(systemName: "chevron.forward").frame(width: 28, height: 24).background(Color.white.opacity(0.1)).cornerRadius(4)
                                            }
                                            Button(action: { camera.nudgeFocus(step: 2) }) {
                                                Image(systemName: "chevron.forward.2").frame(width: 28, height: 24).background(Color.white.opacity(0.1)).cornerRadius(4)
                                            }
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                        }
                        
                        // Active Toolkit from workspace
                        if let activePalette = workspace.activePalette() {
                            ForEach(activePalette.allTools) { toolConfig in
                                ToolRegistry.view(for: toolConfig.id, context: ToolRegistryContext(
                                    config: toolConfig,
                                    adjustmentController: adjustmentController,
                                    session: session,
                                    recipeManager: OutputRecipeManager.shared,
                                    batchQueue: BatchQueue(),
                                    keywordCache: DocumentKeywordCache(session: session)
                                ))
                            }
                        }
                    }
                }
            }
            .frame(width: workspace.sidebarWidth)
            .background(CaptureOneTheme.Colors.applicationBackground)
        }
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            if browser.availableCameras.isEmpty {
                browser.startDiscovery()
            }
        }
    }
}

fileprivate struct LiveViewPropertyRow: View {
    let property: P1CaptureCore_Property
    let camera: P1CaptureCore_Camera
    
    var body: some View {
        HStack {
            Text(property.name)
                .font(.system(size: 11))
                .foregroundColor(.gray)
            Spacer()
            Menu(property.currentValue) {
                ForEach(property.availableValues, id: \.self) { val in
                    Button(val) { camera.setPropertyValue(propertyID: property.id, value: val) }
                }
            }
            .font(.system(size: 11, weight: .bold))
            .foregroundColor(.white)
            .frame(width: 100, alignment: .trailing)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
    }
}
