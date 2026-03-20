import Foundation

/// Service responsible for physical disk operations when creating a session.
public class COFileSystemScaffolder {
    
    public init() {}
    
    /// Creates the session directory structure and necessary files.
    /// - Parameters:
    ///   - rootURL: The base directory where the session folder will be created.
    ///   - sessionName: The name of the session.
    ///   - subfolders: A list of relative paths to create within the session folder.
    /// - Returns: The URL to the created .cosession file.
    @discardableResult
    public func createSessionScaffold(at rootURL: URL, sessionName: String, subfolders: [String]) throws -> URL {
        let fm = FileManager.default
        let sessionRoot = rootURL.appendingPathComponent(sessionName)
        
        // 1. Create session root
        if !fm.fileExists(atPath: sessionRoot.path) {
            try fm.createDirectory(at: sessionRoot, withIntermediateDirectories: true)
        }
        
        // 2. Create subfolders
        for subfolder in subfolders {
            let folderURL = sessionRoot.appendingPathComponent(subfolder)
            if !fm.fileExists(atPath: folderURL.path) {
                try fm.createDirectory(at: folderURL, withIntermediateDirectories: true)
            }
        }
        
        // 3. Create .cosessiondb (SQLite database)
        let dbURL = sessionRoot.appendingPathComponent("\(sessionName).cosessiondb")
        if !fm.fileExists(atPath: dbURL.path) {
            // Create an empty file for now. 
            // In a real app, we'd initialize the SQLite schema.
            try "".write(to: dbURL, atomically: true, encoding: .utf8)
        }
        
        // 4. Create .cosession (Wrapper/Project file)
        let sessionFile = sessionRoot.appendingPathComponent("\(sessionName).cosession")
        if !fm.fileExists(atPath: sessionFile.path) {
            let content = "Capture One Session: \(sessionName)"
            try content.write(to: sessionFile, atomically: true, encoding: .utf8)
        }
        
        return sessionFile
    }
}
