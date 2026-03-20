import Foundation
import Combine
import CoreGraphics
import ImageCore

/// Manages a wireless connection to a camera (TETH-004).
public class COWirelessCameraConnection: ObservableObject {
    @Published public var signalStrength: Int = 0
    @Published public var ssid: String = ""
    @Published public var isConnected: Bool = false
    
    public init() {}
    
    public func connect(to ssid: String) {
        print("[Wireless] Connecting to \(ssid)...")
        self.ssid = ssid
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isConnected = true
            self.signalStrength = 4
        }
    }
}

/// Controller for camera settings synchronization (TETH-005).
public class COCameraSettingsController: ObservableObject {
    @Published public var camera: CameraDevice?
    
    public init(camera: CameraDevice?) {
        self.camera = camera
    }
    
    public func updateISO(_ iso: String) {
        camera?.iso = iso
        print("[Settings] Syncing ISO \(iso) to camera...")
    }
    
    public func updateAperture(_ aperture: String) {
        camera?.aperture = aperture
        print("[Settings] Syncing Aperture \(aperture) to camera...")
    }
    
    public func updateShutterSpeed(_ shutterSpeed: String) {
        camera?.shutterSpeed = shutterSpeed
        print("[Settings] Syncing Shutter Speed \(shutterSpeed) to camera...")
    }
    
    public func updateWhiteBalance(_ wb: String) {
        camera?.whiteBalance = wb
        print("[Settings] Syncing White Balance \(wb) to camera...")
    }
}

/// Service handling tethered capture and ingestion (TETH-006).
public class COTetherCaptureService: ObservableObject {
    public static let shared = COTetherCaptureService()
    
    @Published public var lastCapturedImage: CGImage?
    
    public var onVariantIngested: ((VariantBase) -> Void)?
    
    private init() {}
    
    public func triggerCapture(on camera: CameraDevice) {
        print("[Capture] Triggering capture on \(camera.modelName)...")
        camera.capture()
        
        // Simulate image ingestion
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            print("[Capture] Ingesting new image from \(camera.id)")
            // Simulate creation of a new variant
            let newImage = ImageBase(imageUUID: UUID().uuidString, path: "/simulated/capture.arw", context: nil)
            let newVariant = VariantBase(variantUUID: UUID().uuidString, image: newImage, context: nil)
            
            self.onVariantIngested?(newVariant)
        }
    }
}
