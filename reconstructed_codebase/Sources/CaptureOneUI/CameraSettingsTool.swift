import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Camera Settings tool (TETH-001).
public struct CameraSettingsTool: View {
    @ObservedObject var browser = PtpDeviceBrowser.shared
    @State private var selectedCamera: P1CaptureCore_Camera?
    
    public init() {}
    
    public var body: some View {
        COToolSection("Camera Settings") {
            VStack(spacing: 12) {
                // 1. Camera Selector
                HStack {
                    Image(systemName: "camera.fill").font(.system(size: 10))
                    Picker("", selection: $selectedCamera) {
                        Text("No Camera").tag(nil as P1CaptureCore_Camera?)
                        ForEach(browser.availableCameras) { cam in
                            Text(cam.name).tag(cam as P1CaptureCore_Camera?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .font(.system(size: 11))
                }
                
                if let camera = selectedCamera {
                    // 2. Camera Properties
                    VStack(spacing: 8) {
                        ForEach(camera.properties) { prop in
                            HStack {
                                Text(prop.name).font(.system(size: 11)).foregroundColor(.gray)
                                Spacer()
                                Menu(prop.currentValue) {
                                    ForEach(prop.availableValues, id: \.self) { val in
                                        Button(val) {
                                            // Logic: Update camera property
                                        }
                                    }
                                }
                                .font(.system(size: 11, weight: .bold))
                            }
                        }
                    }
                    .padding(8)
                    .background(Color.black.opacity(0.2))
                    .cornerRadius(4)
                    
                    // 3. Capture Button
                    Button(action: { camera.shutterRelease() }) {
                        HStack {
                            Image(systemName: camera.isCapturing ? "stop.fill" : "record.circle.fill")
                            Text(camera.isCapturing ? "CAPTURING..." : "CAPTURE")
                                .font(.system(size: 12, weight: .bold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(camera.isCapturing ? Color.red : CaptureOneTheme.Colors.activeHighlight)
                        .foregroundColor(.white)
                        .cornerRadius(6)
                    }
                    .buttonStyle(PlainButtonStyle())
                } else {
                    Text("Connect a camera to start tethering.")
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 20)
                }
            }
        }
        .onAppear { 
            browser.startDiscovery() 
            if let first = browser.availableCameras.first {
                selectedCamera = first
                first.open()
            }
        }
    }
}
