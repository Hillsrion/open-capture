import Foundation

/// Reconstructed logic for scanning import sources.
public class ImportSourceScanner {
    
    public static let supportedExtensions: Set<String> = [
        "arw", "cr2", "cr3", "nef", "nrw", "orf", "raf", "rw2", "pef", "dng", // RAW
        "jpg", "jpeg", "tif", "tiff", "png" // Standard
    ]
    
    public init() {}
    
    /// Scans a directory for supportable image files.
    /// Based on disassembly of _ICP_ScanFolderForImages.
    public func scan(url: URL, includeSubfolders: Bool) -> [URL] {
        let fileManager = FileManager.default
        var results: [URL] = []
        
        let options: FileManager.DirectoryEnumerationOptions = includeSubfolders ? [] : [.skipsSubdirectoryDescendants]
        
        guard let enumerator = fileManager.enumerator(at: url,
                                                   includingPropertiesForKeys: [.isRegularFileKey],
                                                   options: options) else {
            return []
        }
        
        for case let fileURL as URL in enumerator {
            let pathExtension = fileURL.pathExtension.lowercased()
            if ImportSourceScanner.supportedExtensions.contains(pathExtension) {
                results.append(fileURL)
            }
        }
        
        return results
    }
}
