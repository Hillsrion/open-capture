import Foundation

/// Reconstructed central coordination context for AppCoreShared.
/// Acts similarly to NSManagedObjectContext, managing object lifecycle and persistence.
public class ObjectContext: NSObject {
    
    private let modelQueue = DispatchQueue(label: "com.captureone.ObjectContext.modelQueue")
    private let cacheQueue = DispatchQueue(label: "com.captureone.ObjectContext.cacheQueue")
    
    // MARK: - State Tracking
    private var insertedObjects = Set<BaseObject>()
    private var modifiedObjects = Set<BaseObject>()
    private var deletedObjects = Set<BaseObject>()
    
    // MARK: - Object Management
    
    public func addToInserted(_ object: BaseObject) {
        performOnModelQueue {
            self.insertedObjects.insert(object)
        }
    }
    
    public func addToModified(_ object: BaseObject) {
        performOnModelQueue {
            self.modifiedObjects.insert(object)
        }
    }
    
    public func addToDeleted(_ object: BaseObject) {
        performOnModelQueue {
            self.deletedObjects.insert(object)
        }
    }
    
    // MARK: - Private Helpers
    
    private func performOnModelQueue(_ block: @escaping () -> Void) {
        modelQueue.async(execute: block)
    }
    
    public func save() throws {
        // Logic recovery: 
        // 1. Pre-save checks
        // 2. Perform database write (DataCore)
        // 3. Post-save notifications
        NotificationCenter.default.post(name: .ObjectContextDidSave, object: self)
    }
}

// MARK: - Notifications
extension Notification.Name {
    public static let ObjectContextDidSave = Notification.Name("ObjectContextDidSaveNotification")
}
