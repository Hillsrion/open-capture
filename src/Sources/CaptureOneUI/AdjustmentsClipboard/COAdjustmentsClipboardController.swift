import Foundation
import AppCoreShared

public struct COToolCheckboxState {
    public var exposure: Bool = false
    public var color: Bool = false
    public var details: Bool = false
    public var layers: Bool = false
    public var crop: Bool = false
    
    public init() {}
}

public class COAdjustmentsClipboardController: ObservableObject {
    public static let shared = COAdjustmentsClipboardController()
    
    @Published public var autoSelectAdjusted: Bool = true
    @Published public var state = COToolCheckboxState()
    
    public private(set) var copiedVariant: VariantBase?
    
    public init() {}
    
    public func copy(from variant: VariantBase?) {
        guard let variant = variant else { return }
        self.copiedVariant = variant
        
        if autoSelectAdjusted {
            // Auto-select based on what is actually adjusted in the variant
            if let mc = variant.mcVariant {
                state.exposure = (mc.objectForKey("ZEXPOSURE") as? Double ?? 0.0) != 0.0 ||
                                 (mc.objectForKey("ZCONTRAST") as? Double ?? 0.0) != 0.0 ||
                                 (mc.objectForKey("ZBRIGHTNESS") as? Double ?? 0.0) != 0.0
                
                state.color = (mc.objectForKey("ZSATURATION") as? Double ?? 0.0) != 0.0 ||
                              (mc.objectForKey("ZKELVIN") as? Double ?? 0.0) != 0.0 ||
                              (mc.objectForKey("ZTINT") as? Double ?? 0.0) != 0.0
                
                // Assume details and layers are adjusted if something specific is set, here we just mock
                state.details = false
                state.layers = false
            } else {
                state.exposure = true
                state.color = true
                state.details = true
                state.layers = true
            }
            // Logic: Selective copy/apply. Exclude "Crop" by default.
            state.crop = false
        } else {
            // If not auto-selecting, keep current selection but ensure Crop is off by default if not set before?
            // Actually, if autoSelectAdjusted is false, we just use the user's manual checkmarks.
        }
    }
    
    public func selectAll() {
        state.exposure = true
        state.color = true
        state.details = true
        state.layers = true
        state.crop = true
    }
    
    public func selectNone() {
        state.exposure = false
        state.color = false
        state.details = false
        state.layers = false
        state.crop = false
    }
}
