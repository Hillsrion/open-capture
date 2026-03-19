import Foundation

/// Reconstructed Token Naming Manager (LOGIC-204).
/// Resolves strings like "[Image Name]_[Sequence ID]" based on variant metadata.
public class COTokenNamingManager {
    public static let shared = COTokenNamingManager()
    
    private init() {}
    
    public func resolve(format: String, variant: VariantBase, counter: Int, jobName: String = "") -> String {
        let tokens = CaptureNamingFormatter.parse(formatString: format)
        return resolve(tokens: tokens, variant: variant, counter: counter, jobName: jobName)
    }
    
    public func resolve(tokens: [CaptureNamingToken], variant: VariantBase, counter: Int, jobName: String = "") -> String {
        var result = ""
        
        for token in tokens {
            switch token.type {
            case .camera:
                result += variant.cameraName ?? "Unknown Camera"
            case .date:
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyyMMdd"
                result += formatter.string(from: Date())
            case .counter:
                result += String(format: "%04d", counter)
            case .sessionName:
                result += "CaptureSession" // Placeholder for real session name
            case .imageName:
                // Use the existing name of the variant/image
                result += variant.name ?? "Untitled"
            case .jobName:
                result += jobName.isEmpty ? "Job" : jobName
            case .subfolder:
                result += "Selects"
            case .delimiter:
                result += "_"
            case .customText:
                result += token.name
            }
        }
        
        // Handle the specific [Sequence ID] requested by the user if it's not handled by .counter
        // If the user literally typed [Sequence ID] and it wasn't parsed as a token:
        if result.contains("[Sequence ID]") {
            result = result.replacingOccurrences(of: "[Sequence ID]", with: String(format: "%03d", counter))
        }
        
        return result
    }
}

extension VariantBase {
    public var cameraName: String? {
        // Reconstructed from v16.5 metadata: ZCAMERA
        return (mcVariant?.objectForKey( "ZCAMERA") as? String)
    }
    
    public var renameName: String? {
        return (mcVariant?.objectForKey( "ZNAME") as? String)
    }
}
