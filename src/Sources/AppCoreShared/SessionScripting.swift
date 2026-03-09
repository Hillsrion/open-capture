import Foundation
import AppKit

/// Reconstructed AppleScript support for SessionBase (INT-004).
extension SessionBase {
    
    // In order for a class to be scriptable and returned by AppleScript,
    // it typically needs to inherit from NSObject and implement objectSpecifier.
    // Assuming BaseObject inherits from NSObject or we provide @objc wrappers.
    
    /// Scriptable: Return the name of the document.
    @objc public var documentName: String {
        return "Session \(documentUUID.prefix(8))"
    }
    
    /// Scriptable: Return the path of the document.
    @objc public var documentPath: String {
        return rootFolder ?? "/Unknown/Path"
    }
    
    /// Scriptable: Return the variants within this document.
    @objc public var scriptingVariants: [VariantBase] {
        // Mock: In the real app, this would query the DataCore for all variants in the session.
        // For the reconstructed app, we might return a dummy variant for testing.
        return [VariantBase(variantUUID: "test-variant-scripting", image: nil, context: nil)]
    }
    
    /// Provides the object specifier required by NSScriptObjectSpecifier.
    @objc public override var objectSpecifier: NSScriptObjectSpecifier? {
        guard let app = NSApplication.shared as? NSApplication else { return nil }
        
        let specifier = NSUniqueIDSpecifier(
            containerClassDescription: app.classDescription as! NSScriptClassDescription,
            containerSpecifier: nil,
            key: "orderedDocuments",
            uniqueID: documentUUID as NSString
        )
        return specifier
    }
}
