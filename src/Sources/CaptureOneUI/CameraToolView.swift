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
                    // Shutter & Live View Row
                    HStack(spacing: 16) {
                        // Remote Shutter Button
                        Button(action: { camera.capture() }) {
                            ZStack {
                                Circle()
                                    .fill(camera.isCapturing ? Color.red : Color.gray.opacity(0.3))
                                    .frame(width: 44, height: 44)
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                                    .frame(width: 50, height: 50)
                            }
                        }
                        .buttonStyle(.plain)
                        .help("Remote Shutter")
                        
                        // Live View Toggle
                        Button(action: { camera.isLiveViewActive.toggle() }) {
                            Image(systemName: "video.fill")
                                .font(.system(size: 18))
                                .frame(width: 36, height: 36)
                                .background(camera.isLiveViewActive ? CaptureOneTheme.Colors.activeHighlight : Color.white.opacity(0.05))
                                .cornerRadius(18)
                        }
                        .buttonStyle(.plain)
                        .help("Live View")
                        
                        Spacer()
                        
                        // AF Button
                        Button(action: { camera.autoFocus() }) {
                            Text("AF")
                                .font(.system(size: 12, weight: .bold))
                                .frame(width: 36, height: 36)
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(18)
                        }
                        .buttonStyle(.plain)
                        .help("Auto Focus")
                    }
                    .padding(.vertical, 4)
                    
                    Divider().background(Color.white.opacity(0.05))
                    
                    // Control Grid
                    VStack(spacing: 8) {
                        cameraPropertyRow(label: "Aperture", value: $camera.aperture, options: ["2.8", "4.0", "5.6", "8.0", "11", "16"])
                        cameraPropertyRow(label: "Shutter", value: $camera.shutterSpeed, options: ["1/60", "1/125", "1/250", "1/500", "1/1000"])
                        cameraPropertyRow(label: "ISO", value: $camera.iso, options: ["100", "200", "400", "800", "1600", "3200"])
                        cameraPropertyRow(label: "WB", value: $camera.whiteBalance, options: ["Auto", "Daylight", "Cloudy", "Tungsten", "Fluorescent"])
                    }
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
