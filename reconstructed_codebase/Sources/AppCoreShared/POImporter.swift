import Foundation
import DataCore

/// Reconstructed central coordinator for image ingestion (CORE-007).
/// Based on disassembly of POImporter.
public class POImporter: ObservableObject {
    
    public enum ImportStatus {
        case idle
        case scanning
        case importing(progress: Float)
        case completed(importedCount: Int)
        case failed(error: Error)
    }
    
    @Published public private(set) var status: ImportStatus = .idle
    @Published public var discoveredURLs: [URL] = []
    
    private let scanner = ImportSourceScanner()
    public var settings = ImportSettings()
    public let pickedState = ImporterPickedState()
    
    public init() {}
    
    /// Scans a source URL for supportable images.
    public func scanSource(url: URL) {
        status = .scanning
        
        // In original, this is done on a background queue.
        DispatchQueue.global(qos: .userInitiated).async {
            let urls = self.scanner.scan(url: url, includeSubfolders: self.settings.includeSubfolders)
            
            DispatchQueue.main.async {
                self.discoveredURLs = urls
                self.status = .idle
            }
        }
    }
    
    /// Starts the import process for picked items.
    public func startImport() {
        let itemsToImport = pickedState.pickedURLs
        guard !itemsToImport.isEmpty else { return }
        
        status = .importing(progress: 0.0)
        
        DispatchQueue.global(qos: .utility).async {
            var importedCount = 0
            let total = Float(itemsToImport.count)
            
            for url in itemsToImport {
                // Task 3: Implement file copying logic
                let destinationURL: URL
                if self.settings.destinationFolderType == .insideCatalog {
                    // Placeholder for catalog path resolution
                    destinationURL = url 
                } else {
                    let customPathURL = URL(fileURLWithPath: self.settings.destinationCustomPath)
                    destinationURL = customPathURL.appendingPathComponent(url.lastPathComponent)
                }
                
                do {
                    // In a real app, we would rename based on tokens here
                    if destinationURL != url {
                        if !FileManager.default.fileExists(atPath: destinationURL.deletingLastPathComponent().path) {
                            try FileManager.default.createDirectory(at: destinationURL.deletingLastPathComponent(), withIntermediateDirectories: true)
                        }
                        try FileManager.default.copyItem(at: url, to: destinationURL)
                    }
                    
                    // Task 4: Integrate DataCore registration
                    let writer = DataCoreManager.shared.writer()
                    let uuid = UUID().uuidString
                    try writer.registerImportedImage(uuid: uuid, path: destinationURL.path, fileName: destinationURL.lastPathComponent)
                    
                    print("[POImporter] Imported and Registered \(url.lastPathComponent)")
                    
                } catch {
                    print("[POImporter] Failed to import \(url.lastPathComponent): \(error)")
                }
                
                importedCount += 1
                let progress = Float(importedCount) / total
                
                DispatchQueue.main.async {
                    self.status = .importing(progress: progress)
                }
            }
            
            DispatchQueue.main.async {
                self.status = .completed(importedCount: importedCount)
            }
        }
    }
}
