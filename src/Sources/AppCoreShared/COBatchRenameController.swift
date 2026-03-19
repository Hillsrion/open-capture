import Foundation
import Combine

/// Reconstructed Batch Rename Controller (LOGIC-204).
/// Manages state and execution for variant renaming.
public class COBatchRenameController: ObservableObject {
    @Published public var tokens: [CaptureNamingToken] = []
    @Published public var startCounter: Int = 1
    @Published public var counterStep: Int = 1
    @Published public var jobName: String = ""
    
    // Preview
    @Published public var previewNames: [String] = []
    
    public init() {
        // Default format: [Image Name]_[Sequence ID]
        self.tokens = CaptureNamingFormatter.parse(formatString: "[Image Name]_")
        // Note: [Sequence ID] is not a standard token yet, handled specially in COTokenNamingManager
        // For simplicity let's add a "Counter" token
        self.tokens.append(CaptureNamingToken(name: "Counter", type: .counter))
    }
    
    public func updatePreview(for variants: [VariantBase]) {
        var currentCounter = startCounter
        previewNames = variants.map { variant in
            let name = COTokenNamingManager.shared.resolve(tokens: tokens, variant: variant, counter: currentCounter, jobName: jobName)
            currentCounter += counterStep
            return name
        }
    }
    
    public func execute(on variants: [VariantBase]) {
        var currentCounter = startCounter
        for variant in variants {
            let newName = COTokenNamingManager.shared.resolve(tokens: tokens, variant: variant, counter: currentCounter, jobName: jobName)
            
            // Apply the rename
            CaptureNamingFormatter.renameVariant(variant, tokens: tokens, counter: currentCounter) // Existing logic
            // Note: renaming file on disk might be handled elsewhere or we should call it
            
            currentCounter += counterStep
        }
        
        print("[BatchRename] Processed \(variants.count) items.")
    }
}
