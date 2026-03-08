import Foundation

// MARK: - Constants (Discovered from AppCoreShared symbols)
public let kDefaultCaptureFolderName = "Capture"
public let kDefaultMoveToFolderName = "Selects"
public let kDefaultOutputFolderName = "Output"
public let kDefaultTrashFolderName = "Trash"

/// Reconstructed enum for Session System Folder types.
public enum SessionFolderType: Int, CaseIterable {
    case capture = 0
    case selects = 1
    case output = 2
    case trash = 3
    
    public var defaultName: String {
        switch self {
        case .capture: return kDefaultCaptureFolderName
        case .selects: return kDefaultMoveToFolderName
        case .output: return kDefaultOutputFolderName
        case .trash: return kDefaultTrashFolderName
        }
    }
}

/// Reconstructed logic for managing Session System Folders (CORE-008).
public class SessionFolderManager {
    public static let shared = SessionFolderManager()
    
    public init() {}
    
    /// Resolves the physical path for a session system folder.
    public func resolvePath(for type: SessionFolderType, in sessionRoot: URL) -> URL {
        // In a real session, these paths might be customized and stored in the DB.
        // For now, we use the default names relative to the session root.
        return sessionRoot.appendingPathComponent(type.defaultName)
    }
    
    /// Ensures that all default session folders exist on disk.
    public func createDefaultFolders(at sessionRoot: URL) throws {
        for type in SessionFolderType.allCases {
            let folderURL = resolvePath(for: type, in: sessionRoot)
            if !FileManager.default.fileExists(atPath: folderURL.path) {
                try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)
            }
        }
    }
}
