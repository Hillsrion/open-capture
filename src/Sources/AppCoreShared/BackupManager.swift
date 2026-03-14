import Foundation
import Combine

/// Reconstructed Backup Management logic (BCK-001).
/// Responsible for catalog/session security copies.
/// Mimics _TtC13AppCoreShared13BackupManager.
public class BackupManager: ObservableObject {
    public static let shared = BackupManager()
    
    @Published public var lastBackupDate: Date?
    @Published public var isBackupInProgress: Bool = false
    
    private let kLastBackupKey = "COLastCatalogBackupDate"
    private let kBackupFrequencyKey = "COBackupReminderInterval" // In seconds
    
    private init() {
        self.lastBackupDate = UserDefaults.standard.object(forKey: kLastBackupKey) as? Date
    }
    
    /// Starts the backup process for the active document.
    /// Mimics the "Backup Catalog" workflow.
    public func performBackup(for session: SessionBase, to destinationURL: URL, completion: @escaping (Result<URL, Error>) -> Void) {
        print("[Backup] Starting backup for: \(session.name ?? "Untitled")")
        self.isBackupInProgress = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            // 1. Verify Catalog (ENG-015 Parity)
            if !self.verifyIntegrity(of: session) {
                DispatchQueue.main.async {
                    self.isBackupInProgress = false
                    completion(.failure(NSError(domain: "BackupManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Catalog integrity check failed."])))
                }
                return
            }
            
            // 2. Optimization (Simulated)
            self.optimizeCatalog(session)
            
            // 3. File Copying
            do {
                let backupURL = try self.createBackupCopy(session: session, targetFolder: destinationURL)
                
                DispatchQueue.main.async {
                    self.lastBackupDate = Date()
                    UserDefaults.standard.set(self.lastBackupDate, forKey: self.kLastBackupKey)
                    self.isBackupInProgress = false
                    print("[Backup] Success: \(backupURL.path)")
                    completion(.success(backupURL))
                }
            } catch {
                DispatchQueue.main.async {
                    self.isBackupInProgress = false
                    completion(.failure(error))
                }
            }
        }
    }
    
    /// Checks if a backup reminder should be shown.
    public func shouldRemindBackup() -> Bool {
        guard let last = lastBackupDate else { return true }
        let interval = UserDefaults.standard.double(forKey: kBackupFrequencyKey)
        let secondsSinceLast = Date().timeIntervalSince(last)
        return secondsSinceLast > interval
    }
    
    private func verifyIntegrity(of session: SessionBase) -> Bool {
        print("[Backup] Verifying database integrity...")
        // In original C1, runs "PRAGMA integrity_check" on the SQLite database
        Thread.sleep(forTimeInterval: 1.0)
        return true
    }
    
    private func optimizeCatalog(_ session: SessionBase) {
        print("[Backup] Optimizing database (Vacuum)...")
        // In original C1, runs "VACUUM" to shrink the file
        Thread.sleep(forTimeInterval: 0.5)
    }
    
    private func createBackupCopy(session: SessionBase, targetFolder: URL) throws -> URL {
        let fileManager = FileManager.default
        let dateString = ISO8601DateFormatter().string(from: Date()).replacingOccurrences(of: ":", with: "-")
        let backupName = "\(session.name ?? "Backup")_\(dateString).cocatalog" // or .cosession
        let destinationURL = targetFolder.appendingPathComponent(backupName)
        
        // Ensure destination folder exists
        try fileManager.createDirectory(at: targetFolder, withIntermediateDirectories: true)
        
        // In original, this copies the .cocatalog database file specifically
        // Here we simulate the file operation
        print("[Backup] Copying database to \(destinationURL.path)...")
        Thread.sleep(forTimeInterval: 2.0)
        
        return destinationURL
    }
}
