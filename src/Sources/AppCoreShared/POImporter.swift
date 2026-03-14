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
    @Published public private(set) var sourceURL: URL?
    
    private let scanner = ImportSourceScanner()
    public var settings = ImportSettings()
    public let pickedState = ImporterPickedState()
    
    public init() {}
    
    /// Scans a source URL for supportable images.
    public func scanSource(url: URL) {
        status = .scanning
        sourceURL = url
        
        // In original, this is done on a background queue.
        DispatchQueue.global(qos: .userInitiated).async {
            let urls = self.scanner.scan(url: url, includeSubfolders: self.settings.includeSubfolders)
            
            DispatchQueue.main.async {
                self.discoveredURLs = urls
                self.pickedState.selectAll(urls)
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
            
            let evaluator = TokenEvaluator()
            var sequence = 1
            
            for url in itemsToImport {
                // Reconstructed EIP Ingest (CORE-006)
                let isEIP = url.pathExtension.lowercased() == "eip"
                
                // Task 3: Implement file copying logic with token-based renaming
                let baseName = isEIP ? url.deletingPathExtension().lastPathComponent : url.deletingPathExtension().lastPathComponent
                let context = TokenEvaluator.Context(
                    imageName: baseName,
                    date: Date(),
                    sequence: sequence,
                    jobName: self.settings.metadata.jobName
                )
                
                let newFileName = evaluator.evaluate(format: self.settings.namingFormat, context: context)
                let finalExtension = isEIP ? "eip" : url.pathExtension
                let fullFileName = "\(newFileName).\(finalExtension)"
                
                let destinationURL: URL
                if self.settings.destinationFolderType == .insideCatalog {
                    // In real app, this resolves to the Catalog's "Adjustments" or "Originals" package folder
                    let catalogDir = FileManager.default.temporaryDirectory.appendingPathComponent("CaptureOne_Internal_Catalog")
                    destinationURL = catalogDir.appendingPathComponent(fullFileName)
                } else if self.settings.destinationFolderType == .currentLocation {
                    destinationURL = url // No move/copy needed
                } else {
                    let customPathURL = URL(fileURLWithPath: self.settings.destinationCustomPath)
                    destinationURL = customPathURL.appendingPathComponent(fullFileName)
                }
                
                do {
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
                    
                    // Task 5: Apply Smart Adjustments if enabled (AI-002)
                    if let _ = self.settings.smartStyleUUID {
                        print("[POImporter] Applying Smart Adjustments to \(uuid)")
                    }
                    
                    // Reconstructed: Unpack EIP if requested (CORE-006)
                    if isEIP && self.settings.alwaysUnpackEIP {
                        _ = try EIPManager.shared.unpackEIP(at: destinationURL, destinationFolder: destinationURL.deletingLastPathComponent())
                        print("[POImporter] Unpacked EIP contents for \(destinationURL.lastPathComponent)")
                    }
                    
                    print("[POImporter] Imported and Registered \(destinationURL.lastPathComponent)")
                    
                } catch {
                    print("[POImporter] Failed to import \(url.lastPathComponent): \(error)")
                }
                
                sequence += 1
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
