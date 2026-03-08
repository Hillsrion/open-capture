import Foundation
import AppKit

/// Reconstructed AppleScript support for VariantBase (INT-004).
extension VariantBase {
    
    /// Scriptable: Return the name of the variant.
    @objc public var name: String {
        get { return "Variant - \(variantUUID.prefix(6))" }
        set { print("[Scripting] Set name to \(newValue) on \(variantUUID)") }
    }
    
    /// Scriptable: Return the star rating.
    @objc public var scriptingRating: Int {
        get { return rating }
        set {
            rating = max(0, min(5, newValue))
            print("[Scripting] Set rating to \(rating) on \(variantUUID)")
        }
    }
    
    /// Scriptable: Return the color tag index.
    @objc public var scriptingColorTag: Int {
        get { return colorTag.rawValue }
        set {
            if let tag = ColorTag(rawValue: newValue) {
                colorTag = tag
                print("[Scripting] Set color tag to \(tag) on \(variantUUID)")
            }
        }
    }
    
    /// Provides the object specifier required by NSScriptObjectSpecifier.
    @objc public override var objectSpecifier: NSScriptObjectSpecifier? {
        // Need to chain back to the document (session)
        // Since we are in AppCoreShared, we can't directly access CaptureOneUI window controllers.
        // We assume the NSApplication has been extended to provide orderedDocuments.
        guard let app = NSApplication.shared as? NSApplication,
              let doc = app.value(forKey: "orderedDocuments") as? [SessionBase],
              let session = doc.first else { return nil }
        
        let docSpecifier = session.objectSpecifier
        
        let specifier = NSUniqueIDSpecifier(
            containerClassDescription: session.classDescription as! NSScriptClassDescription,
            containerSpecifier: docSpecifier,
            key: "scriptingVariants",
            uniqueID: variantUUID as NSString
        )
        return specifier
    }
}
