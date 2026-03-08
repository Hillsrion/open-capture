import Foundation
import Combine

/// Reconstructed Data Model for a Camera Property (INT-001).
public struct P1CaptureCore_Property: Identifiable, Codable {
    public let id: String
    public var name: String
    public var currentValue: String
    public var availableValues: [String]
    
    public init(id: String, name: String, current: String, available: [String]) {
        self.id = id
        self.name = name
        self.currentValue = current
        self.availableValues = available
    }
}

/// Reconstructed Base class for Camera control (INT-001).
/// Based on disassembly of P1CaptureCore_Camera.
public class P1CaptureCore_Camera: ObservableObject, Identifiable {
    public let id: String
    public let name: String
    @Published public var isConnected: Bool = false
    @Published public var isCapturing: Bool = false
    @Published public var properties: [P1CaptureCore_Property] = []
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
        setupDefaultProperties()
    }
    
    private func setupDefaultProperties() {
        properties = [
            P1CaptureCore_Property(id: "ISO", name: "ISO", current: "100", available: ["100", "200", "400", "800", "1600"]),
            P1CaptureCore_Property(id: "Shutter", name: "Shutter Speed", current: "1/125", available: ["1/60", "1/125", "1/250", "1/500"]),
            P1CaptureCore_Property(id: "Aperture", name: "Aperture", current: "f/5.6", available: ["f/2.8", "f/4", "f/5.6", "f/8", "f/11"])
        ]
    }
    
    /// Triggers the camera shutter.
    public func shutterRelease() {
        print("[Capture] Shutter release triggered for \(name)")
        isCapturing = true
        
        // Simulate capture delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isCapturing = false
            print("[Capture] Image captured.")
        }
    }
    
    public func open() { isConnected = true }
    public func close() { isConnected = false }
}

/// Reconstructed discovery service for PTP devices.
public class PtpDeviceBrowser: ObservableObject {
    public static let shared = PtpDeviceBrowser()
    @Published public var availableCameras: [P1CaptureCore_Camera] = []
    
    private init() {}
    
    public func startDiscovery() {
        print("[PTP] Starting camera discovery...")
        // Simulated discovery
        availableCameras = [
            P1CaptureCore_Camera(id: "CAM-001", name: "Sony Alpha 7 IV"),
            P1CaptureCore_Camera(id: "CAM-002", name: "Canon EOS R5")
        ]
    }
}
