import Foundation

/// Reconstructed Data Model for EIP Package Information (CORE-006).
/// Based on _EIP_GetPackageInfo disassembly.
public struct EIPPackageInfo: Codable, Hashable {
    public let version: Int
    public let originalExtension: String
    public let creationDate: Date
    public var contents: [String]
    
    public init(version: Int = 1, originalExtension: String, creationDate: Date = Date(), contents: [String] = []) {
        self.version = version
        self.originalExtension = originalExtension
        self.creationDate = creationDate
        self.contents = contents
    }
}

/// Reconstructed Wrapper for EIP Archive management.
/// Mimics the behavior of the internal EIP framework.
public class EIPArchive {
    public let path: URL
    
    public init(path: URL) {
        self.path = path
    }
    
    /// Reconstructed logic for _EIP_Create.
    /// In the real app, this creates a ZIP-based archive containing the RAW and adjustments.
    public static func create(at archiveURL: URL, rawURL: URL, sidecars: [URL]) throws {
        print("[EIP] Creating archive at \(archiveURL.lastPathComponent)")
        // Simulation: In a real reconstruction, we'd use a ZIP library.
        // For this high-fidelity mock, we ensure the directory exists.
        let fm = FileManager.default
        let tempDir = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try fm.createDirectory(at: tempDir, withIntermediateDirectories: true)
        
        // 1. Copy RAW
        try fm.copyItem(at: rawURL, to: tempDir.appendingPathComponent(rawURL.lastPathComponent))
        
        // 2. Copy Sidecars (Settings, Masks, etc.)
        for sidecar in sidecars {
            let dest = tempDir.appendingPathComponent(sidecar.lastPathComponent)
            if fm.fileExists(atPath: dest.path) { try fm.removeItem(at: dest) }
            try fm.copyItem(at: sidecar, to: dest)
        }
        
        // 3. Create Package Info
        let info = EIPPackageInfo(originalExtension: rawURL.pathExtension, contents: sidecars.map { $0.lastPathComponent })
        let infoData = try JSONEncoder().encode(info)
        try infoData.write(to: tempDir.appendingPathComponent("EIPPackage.json"))
        
        // Mock ZIP: move tempDir to final path
        if fm.fileExists(atPath: archiveURL.path) { try fm.removeItem(at: archiveURL) }
        try fm.moveItem(at: tempDir, to: archiveURL)
    }
    
    /// Reconstructed logic for _EIP_Extract.
    public func extract(to destinationURL: URL) throws {
        print("[EIP] Extracting archive to \(destinationURL.path)")
        let fm = FileManager.default
        if !fm.fileExists(atPath: destinationURL.path) {
            try fm.createDirectory(at: destinationURL, withIntermediateDirectories: true)
        }
        
        let contents = try fm.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
        for item in contents {
            if item.lastPathComponent == "EIPPackage.json" { continue }
            let destItem = destinationURL.appendingPathComponent(item.lastPathComponent)
            if fm.fileExists(atPath: destItem.path) { try fm.removeItem(at: destItem) }
            try fm.copyItem(at: item, to: destItem)
        }
    }
    
    public func getPackageInfo() throws -> EIPPackageInfo {
        let infoURL = path.appendingPathComponent("EIPPackage.json")
        let data = try Data(contentsOf: infoURL)
        return try JSONDecoder().decode(EIPPackageInfo.self, from: data)
    }
}
