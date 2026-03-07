import Foundation

/// Service to handle dynamic naming of exported files using tokens.
/// Based on _TtC12AppCoreShared12ExportNaming.
public class ExportNaming {
    
    public enum Token: String, CaseIterable {
        case imageName = "[Image Name]"
        case variantName = "[Variant Name]"
        case sequenceID = "[Sequence ID]"
        case jobName = "[Job Name]"
        case fileFormat = "[Format]"
    }
    
    public init() {}
    
    /// Evaluates a format string with tokens for a specific variant.
    public func evaluate(format: String, for variant: VariantBase, jobName: String = "Export", sequenceIndex: Int = 1) -> String {
        var result = format
        
        // [Image Name] -> Filename without extension
        let fileName = variant.image?.imageFileName ?? "Untitled"
        let baseName = (fileName as NSString).deletingPathExtension
        result = result.replacingOccurrences(of: Token.imageName.rawValue, with: baseName)
        
        // [Variant Name] -> Variant UUID or name if implemented
        let variantName = variant.variantUUID.prefix(8) // Fallback to UUID prefix
        result = result.replacingOccurrences(of: Token.variantName.rawValue, with: String(variantName))
        
        // [Job Name]
        result = result.replacingOccurrences(of: Token.jobName.rawValue, with: jobName)
        
        // [Sequence ID]
        let seqString = String(format: "%03d", sequenceIndex)
        result = result.replacingOccurrences(of: Token.sequenceID.rawValue, with: seqString)
        
        return result
    }
}
