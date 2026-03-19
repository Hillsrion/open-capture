import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Camera Control tool (GAP-406).
/// Provides remote shutter, live view, and property management.
public struct CameraToolView: View {
    @ObservedObject var manager = TetheringManager.shared
    
    public init() {}
    
    public var body: some View {
        COToolSection("Camera", toolID: "Camera") {
            VStack(spacing: 12) {
                if let camera = manager.selectedCamera {
                    CameraActiveControlsView(camera: camera)
                } else {
                    VStack(spacing: 8) {
                        Text("No Camera Connected")
                            .font(.system(size: 11))
                            .foregroundColor(.gray)
                        
                        Button("Scan for Cameras") {
                            manager.discoverNetworkCameras()
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                        
                        if manager.isConnecting {
                            ProgressView()
                                .scaleEffect(0.5)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                }
            }
            .padding(.vertical, 4)
        }
    }
}

private struct CameraActiveControlsView: View {
    @ObservedObject var camera: CameraDevice
    @ObservedObject var manager = TetheringManager.shared
    @ObservedObject var captureService = COTetherCaptureService.shared
    @ObservedObject var wireless = TetheringManager.shared.wirelessConnection
    
    var body: some View {
        VStack(spacing: 12) {
            // Camera Name & Wireless Indicator
            HStack {
                Text(camera.modelName)
                    .font(.system(size: 12, weight: .semibold))
                
                if wireless.isConnected {
                    Image(systemName: "wifi")
                        .font(.system(size: 10))
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "battery.75")
                        .font(.system(size: 10))
                    Text("\(Int(camera.batteryLevel * 100))%")
                        .font(.system(size: 10))
                }
                .foregroundColor(CaptureOneTheme.Colors.textSecondary)
            }
            .padding(.horizontal, 4)

            // Shutter & Live View Row
            HStack(spacing: 16) {
                // Remote Shutter Button (Large round button)
                Button(action: { captureService.triggerCapture(on: camera) }) {
                    ZStack {
                        Circle()
                            .fill(camera.isCapturing ? Color.red : Color.gray.opacity(0.3))
                            .frame(width: 54, height: 54)
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                            .frame(width: 60, height: 60)
                        
                        if camera.isCapturing {
                            Circle()
                                .stroke(Color.red, lineWidth: 2)
                                .scaleEffect(1.2)
                                .opacity(0)
                        }
                    }
                }
                .buttonStyle(.plain)
                .help("Remote Shutter")
                
                VStack(spacing: 8) {
                    // Live View Toggle
                    Button(action: { camera.isLiveViewActive.toggle() }) {
                        Image(systemName: "video.fill")
                            .font(.system(size: 16))
                            .frame(width: 32, height: 32)
                            .background(camera.isLiveViewActive ? CaptureOneTheme.Colors.activeHighlight : Color.white.opacity(0.05))
                            .cornerRadius(16)
                    }
                    .buttonStyle(.plain)
                    .help("Live View")
                    
                    // AF Button
                    Button(action: { camera.autoFocus() }) {
                        Text("AF")
                            .font(.system(size: 10, weight: .bold))
                            .frame(width: 32, height: 32)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(16)
                    }
                    .buttonStyle(.plain)
                    .help("Auto Focus")
                }
                
                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 8)
            
            Divider().background(Color.white.opacity(0.05))
            
            // Control Grid (Synced via COCameraSettingsController)
            VStack(spacing: 8) {
                cameraPropertyRow(label: "Aperture", value: Binding(
                    get: { camera.aperture },
                    set: { manager.settingsController.updateAperture($0) }
                ), options: ["2.8", "4.0", "5.6", "8.0", "11", "16"])
                
                cameraPropertyRow(label: "Shutter", value: Binding(
                    get: { camera.shutterSpeed },
                    set: { manager.settingsController.updateShutterSpeed($0) }
                ), options: ["1/60", "1/125", "1/250", "1/500", "1/1000"])
                
                cameraPropertyRow(label: "ISO", value: Binding(
                    get: { camera.iso },
                    set: { manager.settingsController.updateISO($0) }
                ), options: ["100", "200", "400", "800", "1600", "3200"])
                
                cameraPropertyRow(label: "WB", value: Binding(
                    get: { camera.whiteBalance },
                    set: { manager.settingsController.updateWhiteBalance($0) }
                ), options: ["Auto", "Daylight", "Cloudy", "Tungsten", "Fluorescent"])
            }
        }
    }
    
    private func cameraPropertyRow(label: String, value: Binding<String>, options: [String]) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                .frame(width: 60, alignment: .leading)
            
            Spacer()
            
            Picker("", selection: value) {
                ForEach(options, id: \.self) { opt in
                    Text(opt).tag(opt)
                }
            }
            .pickerStyle(.menu)
            .labelsHidden()
            .frame(width: 100)
        }
    }
}
