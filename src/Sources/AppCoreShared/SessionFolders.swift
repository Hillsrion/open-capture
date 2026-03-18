import Foundation
import DataCore

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
    
    /// Ensures that all default session folders exist on disk.
    public func createDefaultFolders(at session: SessionBase) throws {
        guard let root = session.rootFolder else { return }
        let rootURL = URL(fileURLWithPath: root)
        
        for type in SessionFolderType.allCases {
            let folderURL = resolvePath(for: type, in: session) ?? rootURL.appendingPathComponent(type.defaultName)
            if !FileManager.default.fileExists(atPath: folderURL.path) {
                try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)
            }
        }
    }
    
    /// Resolves the physical path for a session system folder.
    public func resolvePath(for type: SessionFolderType, in session: SessionBase) -> URL? {
        // In original, the specific path is often stored in the Session record.
        // We fallback to default if not set.
        let path: String?
        switch type {
        case .capture: path = session.captureFolder
        case .selects: path = session.selectsFolder
        case .output: path = session.outputFolder
        case .trash: path = session.trashFolder
        }
        
        if let explicitPath = path {
            return URL(fileURLWithPath: explicitPath)
        }
        
        guard let root = session.rootFolder else { return nil }
        let rootURL = URL(fileURLWithPath: root)
        
        return rootURL.appendingPathComponent(type.defaultName)
    }
    
    /// Reconstructed routing logic: Physically move file and update DB.
    public func move(variant: VariantBase, to type: SessionFolderType, in session: SessionBase) throws {
        guard let image = variant.image else { return }
        guard let targetFolder = resolvePath(for: type, in: session) else { return }
        
        let sourceURL = URL(fileURLWithPath: image.path)
        let destinationURL = targetFolder.appendingPathComponent(sourceURL.lastPathComponent)
        
        // 1. Physical Move
        if !FileManager.default.fileExists(atPath: targetFolder.path) {
            try FileManager.default.createDirectory(at: targetFolder, withIntermediateDirectories: true)
        }
        
        if sourceURL != destinationURL {
            try FileManager.default.moveItem(at: sourceURL, to: destinationURL)
        }
        
        // 2. Update In-Memory Model
        image.path = destinationURL.path
        if type == .trash {
            image.isTrashed = true
        }
        
        // 3. Update Database
        let writer = DataCoreManager.shared.writer()
        try writer.updateImagePath(imageUUID: image.imageUUID, newPath: destinationURL.path)
        
        print("[SessionFolders] Moved \(sourceURL.lastPathComponent) to \(type)")
    }
    
    /// Reconstructed logic for changing a system folder (e.g. "Set as Capture Folder").
    public func setAsSystemFolder(url: URL, type: SessionFolderType, in session: SessionBase) {
        switch type {
        case .capture: session.captureFolder = url.path
        case .selects: session.selectsFolder = url.path
        case .output: session.outputFolder = url.path
        case .trash: session.trashFolder = url.path
        }
        
        session.isDirty = true
        print("[SessionFolders] \(type) folder set to: \(url.path)")
    }

    /// Adds a variant to a user album (GAP-402).
    public func addToAlbum(variant: VariantBase, album: CollectionBase) throws {
        let writer = DataCoreManager.shared.writer()
        try writer.addVariantToCollection(variantUUID: variant.variantUUID, collectionUUID: album.uuid)
        
        // Update in-memory count
        DispatchQueue.main.async {
            album.itemCount += 1
        }
        print("[SessionFolders] Added variant \(variant.variantUUID) to album \(album.name ?? "")")
    }

    /// Physically move an image to a favorite folder.
    public func moveToFavorite(variant: VariantBase, favorite: CollectionBase) throws {
        guard let image = variant.image, let targetPath = favorite.folderPath else { return }
        let targetFolder = URL(fileURLWithPath: targetPath)
        
        let sourceURL = URL(fileURLWithPath: image.path)
        let destinationURL = targetFolder.appendingPathComponent(sourceURL.lastPathComponent)
        
        if sourceURL != destinationURL {
            try FileManager.default.moveItem(at: sourceURL, to: destinationURL)
            
            // Update models
            image.path = destinationURL.path
            
            // Update database
            let writer = DataCoreManager.shared.writer()
            try writer.updateImagePath(imageUUID: image.imageUUID, newPath: destinationURL.path)
            
            print("[SessionFolders] Moved \(sourceURL.lastPathComponent) to favorite folder \(favorite.name ?? "")")
        }
    }
}
