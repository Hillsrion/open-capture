import Foundation

/// Reconstructed Data Model for a captured image transfer (TETH-001).
public class P1CaptureCore_CaptureImage: Identifiable {
    public let id: String = UUID().uuidString
    public let fileName: String
    public var rawData: Data?
    public var metadata: [String: Any]
    
    public init(fileName: String, metadata: [String: Any] = [:]) {
        self.fileName = fileName
        self.metadata = metadata
    }
}

/// Reconstructed asynchronous queue for image ingestion.
/// Based on disassembly of getCaptureImageQueue.
public class CaptureImageQueue: ObservableObject {
    public static let shared = CaptureImageQueue()
    @Published public var pendingImages: [P1CaptureCore_CaptureImage] = []
    
    private init() {}
    
    /// Adds a newly captured image to the ingestion queue.
    public func enqueue(_ image: P1CaptureCore_CaptureImage) {
        pendingImages.append(image)
        print("[Capture] Enqueued image: \(image.fileName). Queue size: \(pendingImages.count)")
        
        // Simulate background ingestion
        DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + 1.0) {
            self.processNextImage()
        }
    }
    
    private func processNextImage() {
        guard !pendingImages.isEmpty else { return }
        let image = pendingImages.removeFirst()
        print("[Capture] Processing \(image.fileName)...")
        
        // Logic: Create ImageBase, save to Capture folder, add to session
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
}
