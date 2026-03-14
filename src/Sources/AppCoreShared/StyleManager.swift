import Foundation
import Combine

/// Reconstructed Style Manager (STY-002).
/// Mimics _TtC13AppCoreShared13StylesManager protocol implementations.
public class COStyleManager: ObservableObject {
    public static let shared = COStyleManager()
    
    @Published public var stylePacks: [StylePack] = []
    @Published public var userCOStyles: StylePack = StylePack(name: "User Styles", styles: [])
    
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
    
    /// Returns a hierarchical tree representation of styles for UI display.
    public func getStyleTree() -> [StyleTreeItem] {
        var items: [StyleTreeItem] = []
        
        for pack in stylePacks {
            let styleItems = pack.styles.map { StyleTreeItem(name: $0.name, isFolder: false) }
            items.append(StyleTreeItem(name: pack.name, isFolder: true, children: styleItems))
        }
        
        return items
    }
    
    /// Applies a style's adjustments to a variant.
    /// This bridges STY-001 to the variant's metadata properties.
    public func applyStyle(_ style: COStyle, to variant: VariantBase) {
        print("[Style] Applying style: \(style.name) to \(variant.image?.displayName ?? "Unknown")")
        
        // In original C1, this updates the internal ZADJUSTMENT database table
        for (key, val) in style.adjustments {
            variant.mcVariant?.setObject(val.value, forKey: key)
        }
        
        // Update local object state if needed
        variant.objectWillChange.send()
    }
    
    private func parseStyle(at url: URL) -> COStyle? {
        // Capture One .costyle files are XML. 
        guard (try? Data(contentsOf: url)) != nil else { return nil }
        return COStyle(name: url.deletingPathExtension().lastPathComponent, adjustments: [:])
    }
    
    private func loadBuiltinStyles() {
        // Simulation of factory styles
        let bw = COStyle(name: "B&W High Contrast", category: "Built-in", adjustments: [
            "ZEXPOSURE": AnyCodable(0.2),
            "ZCONTRAST": AnyCodable(20.0),
            "ZSATURATION": AnyCodable(-100.0)
        ])
        
        let landscape = COStyle(name: "Landscape Vivid", category: "Built-in", adjustments: [
            "ZCONTRAST": AnyCodable(10.0),
            "ZSATURATION": AnyCodable(15.0)
        ])
        
        self.stylePacks = [
            StylePack(name: "Factory Styles", styles: [bw, landscape])
        ]
    }
}
