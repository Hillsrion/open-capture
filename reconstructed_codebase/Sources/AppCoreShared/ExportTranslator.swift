import Foundation
import ImageCore

/// Translates AppCoreShared models into ImageCore settings for rendering.
/// Based on _TtC12AppCoreShared16ExportTranslator metadata.
public class ExportTranslator {
    
    public init() {}
    
    public func translate(variant: VariantBase, recipe: OutputRecipe) -> (IC_ProcessSettings, IC_ExportSettings) {
        var processSettings = IC_ProcessSettings()
        var exportSettings = IC_ExportSettings()
        
        // 1. Translate Basic Adjustments from Variant's MCVariant
        if let mc = variant.mcVariant {
            processSettings.exposure = (mc.objectForKey("ZEXPOSURE") as? Double) ?? 0.0
            processSettings.contrast = (mc.objectForKey("ZCONTRAST") as? Double) ?? 0.0
            processSettings.brightness = (mc.objectForKey("ZBRIGHTNESS") as? Double) ?? 0.0
            processSettings.saturation = (mc.objectForKey("ZSATURATION") as? Double) ?? 0.0
            
            processSettings.whiteBalanceTemperature = (mc.objectForKey("ZWB_TEMP") as? Double) ?? 5000.0
            processSettings.whiteBalanceTint = (mc.objectForKey("ZWB_TINT") as? Double) ?? 0.0
            processSettings.colorBalance = ColorBalanceStorage.settings(from: mc)
        }
        
        // 2. Translate Export specific settings from Recipe
        exportSettings.quality = Int32(recipe.jpegQuality)
        
        switch recipe.format {
        case .jpeg: exportSettings.format = 0
        case .tiff: exportSettings.format = 1
        case .png:  exportSettings.format = 2
        case .psd:  exportSettings.format = 3
        case .dng:  exportSettings.format = 4
        }
        
        exportSettings.iccProfilePath = recipe.iccProfile
        
        // 3. Translate Scale Type
        // We'll map recipe.scaleType to IC_ProcessSettings.cropRect or a specialized scale param
        // For now, let's keep it simple.
        
        return (processSettings, exportSettings)
    }
}
