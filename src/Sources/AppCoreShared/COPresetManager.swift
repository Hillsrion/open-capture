import Foundation
import Combine

/// Reconstructed Preset Manager (Reference: 0xolTuhFkBk).
/// Presets are localized to a single tool (e.g., Exposure, Curves).
public class COPresetManager: ObservableObject {
    public static let shared = COPresetManager()
    
    @Published public var presetsByTool: [String: [COPreset]] = [:]
    
    private init() {
        loadBuiltinPresets()
    }
    
    public struct COPreset: Identifiable, Codable {
        public var id: String { name }
        public var name: String
        public var toolID: String
        public var adjustments: [String: AnyCodable]
    }
    
    public func loadBuiltinPresets() {
        // Mock built-in presets for various tools
        let exposurePresets = [
            COPreset(name: "Overexposed +1", toolID: "Exposure", adjustments: ["ZEXPOSURE": AnyCodable(1.0)]),
            COPreset(name: "Underexposed -1", toolID: "Exposure", adjustments: ["ZEXPOSURE": AnyCodable(-1.0)])
        ]
        
        let curvesPresets = [
            COPreset(name: "S-Curve", toolID: "Curves", adjustments: ["ZCURVE_POINTS_RGB": AnyCodable([CGPoint(x: 0, y: 0), CGPoint(x: 0.25, y: 0.15), CGPoint(x: 0.75, y: 0.85), CGPoint(x: 1, y: 1)])])
        ]
        
        let levelsPresets = [
            COPreset(name: "Auto Levels", toolID: "Levels", adjustments: ["ZLEVELS_AUTO": AnyCodable(true)])
        ]
        
        let hdrPresets = [
            COPreset(name: "High Dynamic Range", toolID: "HDR", adjustments: ["ZHIGHLIGHTS": AnyCodable(50.0), "ZSHADOWS": AnyCodable(50.0)])
        ]
        
        let wbPresets = [
            COPreset(name: "Daylight", toolID: "WhiteBalance", adjustments: ["ZKELVIN": AnyCodable(5500.0), "ZTINT": AnyCodable(0.0)]),
            COPreset(name: "Tungsten", toolID: "WhiteBalance", adjustments: ["ZKELVIN": AnyCodable(2800.0), "ZTINT": AnyCodable(0.0)])
        ]
        
        presetsByTool["Exposure"] = exposurePresets
        presetsByTool["Curves"] = curvesPresets
        presetsByTool["Levels"] = levelsPresets
        presetsByTool["HDR"] = hdrPresets
        presetsByTool["WhiteBalance"] = wbPresets
    }
    
    public func savePreset(name: String, toolID: String, adjustments: [String: AnyCodable]) {
        let newPreset = COPreset(name: name, toolID: toolID, adjustments: adjustments)
        var current = presetsByTool[toolID] ?? []
        current.append(newPreset)
        presetsByTool[toolID] = current
        print("[PresetManager] Saved preset '\(name)' for tool \(toolID)")
    }
    
    public func applyPreset(_ preset: COPreset, to variant: VariantBase) {
        print("[Preset] Applying preset: \(preset.name) to \(variant.variantUUID)")
        
        for (key, val) in preset.adjustments {
            variant.mcVariant?.setObject(val.value, forKey: key)
        }
        variant.objectWillChange.send()
    }
}
