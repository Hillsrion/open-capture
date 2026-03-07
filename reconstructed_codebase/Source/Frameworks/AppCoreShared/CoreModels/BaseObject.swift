import Foundation

/// Reconstructed root class for managed objects in AppCoreShared.
/// Provides integration with ObjectContext and KVO-based change tracking.
public class BaseObject: NSObject {
    
    public weak var managedObjectContext: ObjectContext?
    
    public init(managedObjectContext context: ObjectContext?) {
        self.managedObjectContext = context
        super.init()
    }
    
    // MARK: - Change Tracking
    
    public override func willChangeValue(forKey key: String) {
        super.willChangeValue(forKey: key)
    }
    
    public override func didChangeValue(forKey key: String) {
        super.didChangeValue(forKey: key)
        // Notify context of modification
        managedObjectContext?.addToModified(self)
    }
}
