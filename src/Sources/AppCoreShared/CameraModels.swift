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

/// Reconstructed Data Model for a Live View frame (TETH-002).
public class P1CaptureCore_LiveViewImage: Identifiable {
    public let id: String = UUID().uuidString
    public var imageData: Data?
    public var timestamp: TimeInterval
    public var focusStatus: Int // 0: unknown, 1: in focus, 2: out of focus
    
    public init(data: Data?, timestamp: TimeInterval, focus: Int = 0) {
        self.imageData = data
        self.timestamp = timestamp
        self.focusStatus = focus
    }
}

/// Reconstructed Base class for Camera control (INT-001).
/// Based on disassembly of P1CaptureCore_Camera.
public class P1CaptureCore_Camera: ObservableObject, Identifiable, Hashable {
    public let id: String
    public let name: String
    @Published public var isConnected: Bool = false
    @Published public var isCapturing: Bool = false
    
    // Status properties (GAP-406)
    @Published public var batteryLevel: Int = 85
    @Published public var isVirtualBattery: Bool = false
    @Published public var storageCapacity: String = "14.2 GB"
    @Published public var exposureEvaluation: Float = 0.0
    @Published public var focusMode: Int = 0 // 0: AF-S, 1: AF-C, 2: Manual
    
    // Live View Alignment (GAP-401)
    @Published public var supportsFocusMetering: Bool = true
    @Published public var focusMeterValue: Float = 0.0
    @Published public var isLiveViewDOFEnabled: Bool = true
    @Published public var isLiveViewDOFOn: Bool = false
    @Published public var isLiveViewColorOn: Bool = true
    @Published public var showsLiveViewGrid: Bool = false
    
    public enum LiveViewState {
        case off, starting, active, paused
    }
    @Published public var liveViewState: LiveViewState = .off
    @Published public var properties: [P1CaptureCore_Property] = []
    
    // MARK: - Next Capture Naming (TETH-003)
    @Published public var namingFormat: String = "[Camera]_[Counter]"
    @Published public var namingCounter: Int = 1
    
    public enum NextCaptureAdjustmentsOther: String, Codable {
        case copyFromLast = "Copy from Last"
        case copyFromPrimary = "Copy from Primary"
        case specificStyle = "Specific Style"
        case neutral = "Defaults"
    }
    @Published public var nextCaptureAdjustmentsOther: NextCaptureAdjustmentsOther = .copyFromLast

    // Next Capture Adjustments Additional Settings
    @Published public var nextCaptureAdjustmentsICCProfile: String = "Default"
    @Published public var nextCaptureAdjustmentsOrientation: String = "0"
    @Published public var nextCaptureAdjustmentsMetadata: Bool = false
    @Published public var nextCaptureAdjustmentsOtherStyleUUIDs: String = "None"

    // Auto-Sync Metadata
    @Published public var autoSyncIPTC: Bool = false
    @Published public var autoSyncKeywords: Bool = false
    @Published public var autoSyncRatings: Bool = false

    // Auto-Crop
    @Published public var autoCropEnabled: Bool = false

    // Next Capture Keywords
    @Published public var nextCaptureKeywords: String = ""

    public var nextCaptureName: String {        let tokens = CaptureNamingFormatter.parse(formatString: namingFormat)
        return CaptureNamingFormatter.format(tokens: tokens, cameraName: name, counter: namingCounter)
    }
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
        setupDefaultProperties()
    }
    
    public static func == (lhs: P1CaptureCore_Camera, rhs: P1CaptureCore_Camera) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    private func setupDefaultProperties() {
        properties = [
            P1CaptureCore_Property(id: "ISO", name: "ISO", current: "100", available: ["100", "200", "400", "800", "1600"]),
            P1CaptureCore_Property(id: "Shutter", name: "Shutter Speed", current: "1/125", available: ["1/60", "1/125", "1/250", "1/500"]),
            P1CaptureCore_Property(id: "Aperture", name: "Aperture", current: "f/5.6", available: ["f/2.8", "f/4", "f/5.6", "f/8", "f/11"]),
            P1CaptureCore_Property(id: "EVComp", name: "EV Comp", current: "0.0", available: ["-2.0", "-1.0", "0.0", "+1.0", "+2.0"]),
            P1CaptureCore_Property(id: "WB", name: "White Balance", current: "Auto", available: ["Auto", "Daylight", "Shade", "Cloudy", "Tungsten", "Fluorescent", "Flash", "Custom"])
        ]
    }
    
    /// Triggers the camera shutter.
    public func shutterRelease() {
        print("[Capture] Shutter release triggered for \(name)")
        
        // Auto-pause Live View during capture (ENG-002)
        let wasLiveViewActive = (liveViewState == .active)
        if wasLiveViewActive {
            pauseLiveView()
        }
        
        isCapturing = true
        
        // Simulate capture delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isCapturing = false
            let imageName = self.nextCaptureName
            print("[Capture] Image captured: \(imageName)")
            
            // Automation: Apply Next Capture Adjustments (GAP-401)
            self.applyNextCaptureAdjustments(for: imageName)
            
            // Increment naming counter (TETH-003)
            self.namingCounter += 1
            
            // Auto-resume Live View after capture (ENG-002)
            if wasLiveViewActive {
                self.resumeLiveView()
            }
        }
    }
    
    private func applyNextCaptureAdjustments(for imageName: String) {
        print("[Automation] Applying '\(nextCaptureAdjustmentsOther.rawValue)' logic to \(imageName)")
        // In original, this would look up the primary variant or last captured variant
        // and copy its settings to the new MOVariant created during import.
    }
    
    public func setPropertyValue(propertyID: String, value: String) {
        if let index = properties.firstIndex(where: { $0.id == propertyID }) {
            properties[index].currentValue = value
            print("[Capture] Sent PTP command to set \(properties[index].name) to \(value) for \(name)")
        }
    }

    public func nudgeFocus(step: Int) {
        print("[Capture] Sent PTP command to nudge focus by \(step) for \(name)")
    }
    
    public func open() { isConnected = true }
    public func close() { isConnected = false }
    
    // MARK: - Live View Management (TETH-002)
    
    public func startLiveView() {
        print("[Capture] Starting Live View for \(name)")
        liveViewState = .starting
        // Logic: Send PTP StartLiveView command
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.liveViewState = .active
        }
    }
    
    public func stopLiveView() {
        print("[Capture] Stopping Live View")
        liveViewState = .off
    }
    
    public func pauseLiveView() {
        if liveViewState == .active {
            liveViewState = .paused
        }
    }
    
    public func resumeLiveView() {
        if liveViewState == .paused {
            liveViewState = .active
        }
    }

    /// Reconstructed fetching logic for the next Live View frame (TETH-002).
    /// Based on disassembly of -[P1CaptureCore_Camera getNextLiveViewImage].
    public func getNextLiveViewImage() -> P1CaptureCore_LiveViewImage? {
        guard liveViewState == .active else { return nil }
        
        // Update mock focus meter
        DispatchQueue.main.async {
            self.focusMeterValue = Float.random(in: 0.1...0.9)
        }
        
        // Simulated: In the real framework, this pulls from a ring buffer
        return P1CaptureCore_LiveViewImage(
            data: nil,
            timestamp: Date().timeIntervalSince1970,
            focus: Int.random(in: 0...2)
        )
    }
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
