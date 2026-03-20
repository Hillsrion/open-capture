import Foundation
import AppCoreShared

public class COAdjustmentApplicationService {
    public static let shared = COAdjustmentApplicationService()
    
    public init() {}
    
    public func apply(from sourceVariant: VariantBase, to targetVariants: [VariantBase], state: COToolCheckboxState) {
        guard let sourceMc = sourceVariant.mcVariant else { return }
        
        for target in targetVariants {
            guard let targetMc = target.mcVariant else { continue }
            
            if state.exposure {
                if let exp = sourceMc.objectForKey("ZEXPOSURE") { targetMc.setObject(exp, forKey: "ZEXPOSURE") }
                if let con = sourceMc.objectForKey("ZCONTRAST") { targetMc.setObject(con, forKey: "ZCONTRAST") }
                if let bri = sourceMc.objectForKey("ZBRIGHTNESS") { targetMc.setObject(bri, forKey: "ZBRIGHTNESS") }
            }
            
            if state.color {
                if let sat = sourceMc.objectForKey("ZSATURATION") { targetMc.setObject(sat, forKey: "ZSATURATION") }
                if let kel = sourceMc.objectForKey("ZKELVIN") { targetMc.setObject(kel, forKey: "ZKELVIN") }
                if let tin = sourceMc.objectForKey("ZTINT") { targetMc.setObject(tin, forKey: "ZTINT") }
            }
            
            if state.crop {
                if let cropX = sourceMc.objectForKey("ZCROP_X") { targetMc.setObject(cropX, forKey: "ZCROP_X") }
                if let cropY = sourceMc.objectForKey("ZCROP_Y") { targetMc.setObject(cropY, forKey: "ZCROP_Y") }
                if let cropW = sourceMc.objectForKey("ZCROP_W") { targetMc.setObject(cropW, forKey: "ZCROP_W") }
                if let cropH = sourceMc.objectForKey("ZCROP_H") { targetMc.setObject(cropH, forKey: "ZCROP_H") }
            }
            
            // Not mocking details and layers fully, but this represents the architecture.
            
            // Mark as modified
            target.isModified = true
        }
    }
}
