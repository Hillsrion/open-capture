import Foundation
import Combine

/// Reconstructed Hover Preview Service (Reference: 0xolTuhFkBk).
/// Manages temporary application of a style to the current selection on mouse-over.
public class COStyleHoverPreviewService: ObservableObject {
    public static let shared = COStyleHoverPreviewService()
    
    @Published public var previewingStyle: COStyle?
    private var originalSettings: [String: Any]?
    
    private init() {}
    
    public func startPreviewing(_ style: COStyle, variant: VariantBase?) {
        guard let variant = variant, let mc = variant.mcVariant else { return }
        
        // 1. Capture original state if not already captured
        if originalSettings == nil {
            originalSettings = [:]
            // Capture all current adjustment keys from the style's potential changes
            for key in style.adjustments.keys {
                originalSettings?[key] = mc.objectForKey(key) ?? getDefaultValue(for: key)
            }
        }
        
        // 2. Apply style adjustments temporarily
        for (key, val) in style.adjustments {
            mc.setObject(val.value, forKey: key)
        }
        
        previewingStyle = style
        variant.isPreviewing = true
        variant.objectWillChange.send()
        print("[HoverPreview] Previewing style: \(style.name)")
    }
    
    public func stopPreviewing(variant: VariantBase?) {
        guard let variant = variant, let mc = variant.mcVariant else { return }
        
        // 3. Revert to original state
        if let original = originalSettings {
            for (key, val) in original {
                mc.setObject(val, forKey: key)
            }
            originalSettings = nil
        }
        
        previewingStyle = nil
        variant.isPreviewing = false
        variant.objectWillChange.send()
        print("[HoverPreview] Stopped preview.")
    }
    
    private func getDefaultValue(for key: String) -> Any {
        if key == "ZKELVIN" { return 5000.0 }
        return 0.0
    }
}
