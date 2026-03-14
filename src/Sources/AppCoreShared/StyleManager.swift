import Foundation
import Combine

/// Reconstructed Style Manager (STY-002).
/// Mimics _TtC13AppCoreShared13StylesManager protocol implementations.
public class StyleManager: ObservableObject {
    public static let shared = StyleManager()
    
    @Published public var stylePacks: [StylePack] = []
    
    private init() {
        loadBuiltinStyles()
    }
    
    /// Scans the application bundle or user folder for .costyle files.
    public func loadStyles(from url: URL) {
        let fileManager = FileManager.default
        guard let files = try? fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil) else { return }
        
        var styles: [COStyle] = []
        for file in files where file.pathExtension == "costyle" {
            if let style = parseStyle(at: file) {
                styles.append(style)
            }
        }
        
        if !styles.isEmpty {
            let pack = StylePack(name: url.lastPathComponent, styles: styles)
            stylePacks.append(pack)
        }
    }
    
    /// Applies a style's adjustments to a variant.
    /// This bridges STY-001 to the variant's metadata properties.
    public func applyStyle(_ style: COStyle, to variant: VariantBase) {
        print("[Style] Applying style: \(style.name) to \(variant.image?.displayName ?? "Unknown")")
        
        // In original C1, this updates the internal ZADJUSTMENT database table
        for (key, value) in style.adjustments {
            // Map common keys to DB properties (simplified for lab)
            let dbKey = mapToDatabaseKey(key)
            variant.mcVariant?.setObject(value, forKey: dbKey)
        }
        
        // Update local object state if needed
        variant.objectWillChange.send()
    }
    
    private func parseStyle(at url: URL) -> COStyle? {
        // Capture One .costyle files are XML. 
        // For our reconstruction, we use a simplified XML/Plist parser.
        guard let data = try? Data(contentsOf: url) else { return nil }
        
        // Simulation of pugixml parsing
        // In a real scenario, we'd use XMLParser or a custom wrapper
        return COStyle(name: url.deletingPathExtension().lastPathComponent, adjustments: [:])
    }
    
    private func mapToDatabaseKey(_ key: String) -> String {
        switch key.lowercased() {
        case "exposure": return "ZEXPOSURE"
        case "contrast": return "ZCONTRAST"
        case "brightness": return "ZBRIGHTNESS"
        case "saturation": return "ZSATURATION"
        case "kelvin": return "ZKELVIN"
        case "tint": return "ZTINT"
        default: return "Z\(key.uppercased())"
        }
    }
    
    private func loadBuiltinStyles() {
        // Simulation of factory styles
        let b&w = COStyle(name: "B&W High Contrast", category: "Built-in", adjustments: [
            "Exposure": "0.2",
            "Contrast": "20",
            "Saturation": "-100"
        ])
        
        let landscape = COStyle(name: "Landscape Vivid", category: "Built-in", adjustments: [
            "Contrast": "10",
            "Saturation": "15"
        ])
        
        self.stylePacks = [
            StylePack(name: "Factory Styles", styles: [b&w, landscape])
        ]
    }
}
