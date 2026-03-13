import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Camera Settings tool (GAP-406).
/// Matches Capture One 16.7.4 with summary bar and evaluation meter.

public struct CameraSettingsTool: View {
    @ObservedObject var browser = PtpDeviceBrowser.shared
    @ObservedObject var liveView = LiveViewEngine.shared
    @State private var selectedCamera: P1CaptureCore_Camera?
    
    public init() {}
    
    public var body: some View {
        COToolSection("Camera Settings", toolID: "CameraSettings") {
            VStack(spacing: 12) {
                // 1. Camera Selector & Summary
                VStack(spacing: 8) {
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
                        
                        Spacer()
                        
                        if let camera = selectedCamera, camera.isConnected {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 8, height: 8)
                                .help("Camera Connected")
                        }
                    }
                    
                    if let camera = selectedCamera {
                        CameraSummaryBar(camera: camera)
                    }
                }
                
                if let camera = selectedCamera {
                    // 2. Exposure Evaluation Meter
                    ExposureEvaluationMeter(value: camera.exposureEvaluation)
                    
                    // 3. Camera Properties (Aperture, Shutter, ISO)
                    VStack(spacing: 1) {
                        ForEach(camera.properties) { prop in
                            PropertyRow(property: prop, camera: camera)
                        }
                    }
                    .background(Color.black.opacity(0.2))
                    .cornerRadius(4)
                    
                    // 4. Focus Controls (GAP-401)
                    HStack(spacing: 8) {
                        Button(action: { camera.nudgeFocus(step: -2) }) {
                            Image(systemName: "chevron.backward.2").frame(width: 28, height: 24).background(Color.white.opacity(0.1)).cornerRadius(4)
                        }
                        Button(action: { camera.nudgeFocus(step: -1) }) {
                            Image(systemName: "chevron.backward").frame(width: 28, height: 24).background(Color.white.opacity(0.1)).cornerRadius(4)
                        }
                        Button(action: { }) {
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

                    // 5. Capture Controls
                    HStack(spacing: 8) {
                        // Capture Button
                        Button(action: { camera.shutterRelease() }) {
                            HStack {
                                Image(systemName: camera.isCapturing ? "stop.fill" : "record.circle.fill")
                                Text(camera.isCapturing ? "CAPTURING..." : "CAPTURE")
                                    .font(.system(size: 12, weight: .bold))
                            }
                            .frame(maxWidth: .infinity, maxHeight: 32)
                            .background(camera.isCapturing ? Color.red : CaptureOneTheme.Colors.activeHighlight)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                        }
                        .buttonStyle(.plain)
                        
                        // Live View Toggle
                        Button(action: {
                            if liveView.isActive { liveView.stop() }
                            else { liveView.start(for: camera) }
                        }) {
                            Image(systemName: "video.fill")
                                .font(.system(size: 12))
                                .frame(width: 40, height: 32)
                                .background(liveView.isActive ? Color.orange : Color.white.opacity(0.1))
                                .foregroundColor(.white)
                                .cornerRadius(4)
                        }
                        .buttonStyle(.plain)
                    }
                } else {
                    Text("Connect a camera to start tethering.")
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 20)
                }
            }
            .padding(.vertical, 4)
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

struct CameraSummaryBar: View {
    @ObservedObject var camera: P1CaptureCore_Camera
    
    var body: some View {
        HStack {
            if camera.isVirtualBattery {
                Label("AC Power", systemImage: "powerplug.fill")
            } else {
                Label("\(camera.batteryLevel)%", systemImage: batteryIcon)
            }
            Spacer()
            Label(camera.storageCapacity, systemImage: "externaldrive.fill")
        }
        .font(.system(size: 9))
        .foregroundColor(.gray)
        .padding(.horizontal, 4)
    }
    
    private var batteryIcon: String {
        if camera.batteryLevel > 80 { return "battery.100" }
        if camera.batteryLevel > 50 { return "battery.75" }
        if camera.batteryLevel > 20 { return "battery.25" }
        return "battery.0"
    }
}

struct ExposureEvaluationMeter: View {
    let value: Float // -4 to +4 EV
    
    var body: some View {
        VStack(spacing: 2) {
            ZStack {
                Rectangle().fill(Color.white.opacity(0.1)).frame(height: 4)
                
                // Scale ticks
                HStack(spacing: 0) {
                    ForEach(-4...4, id: \.self) { i in
                        Rectangle().fill(Color.gray).frame(width: 1, height: i == 0 ? 8 : 4)
                        if i < 4 { Spacer() }
                    }
                }
                
                // Indicator
                Circle()
                    .fill(CaptureOneTheme.Colors.activeHighlight)
                    .frame(width: 8, height: 8)
                    .offset(x: CGFloat(value / 4.0) * 60) // Simple mapping
            }
            .frame(height: 12)
            
            HStack {
                Text("-4").tag(-4)
                Spacer()
                Text("0").tag(0)
                Spacer()
                Text("+4").tag(4)
            }
            .font(.system(size: 8, design: .monospaced))
            .foregroundColor(.gray)
        }
    }
}

struct PropertyRow: View {
    let property: P1CaptureCore_Property
    let camera: P1CaptureCore_Camera
    
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        HStack {
            Text(property.name)
                .font(.system(size: 11))
                .foregroundColor(.gray)
            Spacer()
            
            HStack(spacing: 4) {
                Menu(property.currentValue) {
                    ForEach(property.availableValues, id: \.self) { val in
                        Button(val) { camera.setPropertyValue(propertyID: property.id, value: val) }
                    }
                }
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.white)
                .frame(minWidth: 60, alignment: .trailing)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            dragOffset = gesture.translation.width
                        }
                        .onEnded { gesture in
                            let threshold: CGFloat = 20
                            if gesture.translation.width > threshold {
                                cycleValue(direction: 1)
                            } else if gesture.translation.width < -threshold {
                                cycleValue(direction: -1)
                            }
                            dragOffset = 0
                        }
                )
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
    }
    
    private func cycleValue(direction: Int) {
        let values = property.availableValues
        guard let currentIndex = values.firstIndex(of: property.currentValue) else { return }
        
        var nextIndex = currentIndex + direction
        if nextIndex < 0 { nextIndex = 0 }
        if nextIndex >= values.count { nextIndex = values.count - 1 }
        
        if nextIndex != currentIndex {
            camera.setPropertyValue(propertyID: property.id, value: values[nextIndex])
        }
    }
}
