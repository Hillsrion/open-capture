import Foundation

/// Reconstructed Data Model for Import Metadata (CORE-007).
public struct ImportMetadata {
    public var jobName: String = ""
    public var description: String = ""
    public var copyright: String = ""
    public var caption: String = ""
    
    public init() {}
}

/// Reconstructed Data Model for Import Settings.
public struct ImportSettings {
    public enum DestinationFolderType: Int {
        case currentLocation = 0
        case insideCatalog = 1
        case customFolder = 2
    }
    
    public enum BackupType: Int {
        case none = 0
        case customPath = 1
    }
    
    public var destinationFolderType: DestinationFolderType = .insideCatalog
    public var destinationCustomPath: String = ""
    public var destinationSubfolderTokens: String = ""
    
    public var backupType: BackupType = .none
    public var backupCustomPath: String = ""
    
    public var namingFormat: String = "[Image Name]"
    public var includeSubfolders: Bool = true
    public var excludeDuplicates: Bool = true
    
    public var styleUUIDs: [String] = []
    
    // Smart Adjustments (AI-002)
    public var smartStyleUUID: String? = nil
    public var smartReferenceVariantUUID: String? = nil
    
    // EIP Settings (CORE-006)
    public var alwaysUnpackEIP: Bool = false
    public var alwaysPackAsEIP: Bool = false
    
    public var metadata: ImportMetadata = ImportMetadata()
    
    public init() {}
}

/// Reconstructed state tracker for items selected for import.
/// Based on ImporterPickedState metadata in AppCoreShared.
public class ImporterPickedState: ObservableObject {
    @Published public var pickedURLs: Set<URL> = []
    
    public init() {}
    
    public func isPicked(_ url: URL) -> Bool {
        return pickedURLs.contains(url)
    }
    
    public func setPicked(_ picked: Bool, for url: URL) {
        if picked {
            pickedURLs.insert(url)
        } else {
            pickedURLs.remove(url)
        }
    }
    
    public func togglePicked(for url: URL) {
        setPicked(!isPicked(url), for: url)
    }
    
    public func clear() {
        pickedURLs.removeAll()
    }
    
    public var count: Int {
        return pickedURLs.count
    }
}
