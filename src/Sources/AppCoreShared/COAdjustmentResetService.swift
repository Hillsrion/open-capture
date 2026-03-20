import Foundation
import AppKit

/// Service for selective adjustment resets on MCVariant (UI-013).
public class COAdjustmentResetService {
    public static let shared = COAdjustmentResetService()
    
    public enum ResetMode {
        case all
        case crop
        case exceptGeometry
        case tool(String)
    }
    
    private init() {}
    
    public func reset(_ variant: VariantBase, mode: ResetMode) {
        guard let mc = variant.mcVariant else { return }
        
        // Push state to undo manager BEFORE reset
        COUndoRedoManager.shared.pushState(for: variant, actionName: "Reset")
        
        switch mode {
        case .all:
            resetAll(mc)
        case .crop:
            resetCrop(mc)
        case .exceptGeometry:
            resetExceptGeometry(mc)
        case .tool(let id):
            resetTool(mc, toolID: id)
        }
        
        variant.isModified = true
        
        // Notify of changes
        NotificationCenter.default.post(name: .COVariantAdjustmentsDidReset, object: variant)
    }
    
    private func resetAll(_ mc: MCVariant) {
        mc.properties.removeAll()
        // Reset layers too?
        mc.layers.removeAll()
    }
    
    private func resetCrop(_ mc: MCVariant) {
        mc.setObject(nil, forKey: "ZCROP_RECT")
        mc.setObject(nil, forKey: "ZCROP_RATIO")
        mc.setObject(nil, forKey: "ZROTATION_ANGLE")
        mc.setObject(nil, forKey: "ZAI_CROP_TOP")
        mc.setObject(nil, forKey: "ZAI_CROP_BOTTOM")
        mc.setObject(nil, forKey: "ZAI_CROP_LEFT")
        mc.setObject(nil, forKey: "ZAI_CROP_RIGHT")
    }
    
    private func resetExceptGeometry(_ mc: MCVariant) {
        let cropRect = mc.objectForKey("ZCROP_RECT")
        let rotation = mc.objectForKey("ZROTATION_ANGLE")
        let keystone = [
            "ZKEYSTONE_TILTX": mc.objectForKey("ZKEYSTONE_TILTX"),
            "ZKEYSTONE_TILTY": mc.objectForKey("ZKEYSTONE_TILTY"),
            "ZKEYSTONE_AMOUNT": mc.objectForKey("ZKEYSTONE_AMOUNT")
        ]
        
        mc.properties.removeAll()
        
        mc.setObject(cropRect, forKey: "ZCROP_RECT")
        mc.setObject(rotation, forKey: "ZROTATION_ANGLE")
        for (k, v) in keystone {
            mc.setObject(v, forKey: k)
        }
    }
    
    private func resetTool(_ mc: MCVariant, toolID: String) {
        // Map toolID to properties keys
        let keys: [String]
        switch toolID {
        case "Exposure":
            keys = ["ZEXPOSURE", "ZCONTRAST", "ZBRIGHTNESS", "ZSATURATION"]
        case "White Balance":
            keys = ["ZKELVIN", "ZTINT"]
        case "High Dynamic Range", "HDR":
            keys = ["ZHIGHLIGHTS", "ZSHADOWS", "ZWHITES", "ZBLACKS"]
        case "Clarity":
            keys = ["ZCLARITY_AMOUNT", "ZSTRUCTURE_AMOUNT", "ZCLARITY_METHOD"]
        case "Sharpening":
            keys = ["ZSHARP_AMOUNT", "ZSHARP_RADIUS", "ZSHARP_THRESHOLD", "ZSHARP_HALO"]
        case "Noise Reduction", "Noise":
            keys = ["ZNR_LUMINANCE", "ZNR_DETAILS", "ZNR_COLOR", "ZNR_SINGLE_PIXEL"]
        case "Vignetting":
            keys = ["ZVIGNETTING_AMOUNT", "ZVIGNETTING_METHOD"]
        case "Dehaze":
            keys = ["ZDEHAZE_AMOUNT", "ZDEHAZE_SHADOW_HUE"]
        case "Crop":
            keys = ["ZCROP_RECT", "ZCROP_RATIO", "ZCROP_GRID"]
        case "Rotation":
            keys = ["ZROTATION_ANGLE"]
        case "Keystone":
            keys = ["ZKEYSTONE_TILTX", "ZKEYSTONE_TILTY", "ZKEYSTONE_AMOUNT", "ZKEYSTONE_ASPECT", "ZKEYSTONE_SKEW"]
        default:
            keys = []
        }
        
        for key in keys {
            mc.setObject(nil, forKey: key)
        }
    }
}

extension Notification.Name {
    public static let COVariantAdjustmentsDidReset = Notification.Name("COVariantAdjustmentsDidReset")
}
