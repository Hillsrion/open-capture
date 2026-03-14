import Foundation
import Combine
import CoreGraphics
import ImageCore

/// Reconstructed Camera Device model (TETH-001).
/// Based on P1CaptureCore_Camera metadata.
public class CameraDevice: Identifiable, ObservableObject {
    public let id: String // Serial Number
    public let modelName: String
    public let manufacturer: String
    
    @Published public var iso: String = "100"
    @Published public var shutterSpeed: String = "1/125"
    @Published public var aperture: String = "8.0"
    @Published public var whiteBalance: String = "Auto"
    @Published public var batteryLevel: Double = 1.0
    @Published public var isLiveViewActive: Bool = false
    @Published public var isCapturing: Bool = false
    
    public init(id: String, model: String, manufacturer: String) {
        self.id = id
        self.modelName = model
        self.manufacturer = manufacturer
    }
    
    /// Triggers a capture on the physical device.
    /// Mimics P1CaptureCore_Camera::Capture.
    public func capture() {
        print("[Camera] Triggering capture on \(modelName) (\(id))")
        isCapturing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isCapturing = false
        }
    }
    
    public func autoFocus() {
        print("[Camera] Triggering AF motor on \(modelName)")
    }
}

/// Reconstructed Live View Stream handler (TETH-002).
/// Mimics IC_LiveViewStream logic from ImageCore.
public class LiveViewStream: ObservableObject {
    @Published public var currentFrame: CGImage?
    public var focusRect: CGRect = .zero
    
    public func start() {
        print("[LiveView] Starting stream...")
    }
    
    public func stop() {
        print("[LiveView] Stopping stream...")
    }
}

/// Reconstructed Tethering Manager (TETH-003).
/// Mimics P1CaptureCore_CaptureCore and CameraManager.
public class TetheringManager: ObservableObject {
    public static let shared = TetheringManager()
    
    @Published public var connectedCameras: [CameraDevice] = []
    @Published public var selectedCamera: CameraDevice?
    @Published public var isConnecting: Bool = false
    
    public let liveView = LiveViewStream()
    
    private init() {
        // Simulation of camera discovery
        simulateCameraConnection()
    }
    
    /// Starts scanning for USB/Network cameras.
    public func startScanning() {
        print("[Tethering] Scanning for cameras...")
    }
    
    public func discoverNetworkCameras() {
        isConnecting = true
        print("[Tethering] Discovering network cameras via PTP/IP...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isConnecting = false
            let mock = CameraDevice(id: "W-001", model: "Nikon Z9 (Wireless)", manufacturer: "Nikon")
            self.connectedCameras.append(mock)
        }
    }
    
    private func simulateCameraConnection() {
        // Mock a high-end camera for development
        let mockCamera = CameraDevice(id: "C1-RECON-001", model: "Phase One IQ4 150MP", manufacturer: "Phase One")
        self.connectedCameras = [mockCamera]
        self.selectedCamera = mockCamera
    }
}
