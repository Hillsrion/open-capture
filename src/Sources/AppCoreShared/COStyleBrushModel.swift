import Foundation

/// Model representing a Style Brush preset (C1-034).
/// A Style Brush combines adjustment settings with specific brush properties.
public struct COStyleBrushModel: Identifiable, Hashable {
    public let id: String
    public let name: String
    public let category: String
    
    // Brush Properties (Cumulative Build-up)
    public let flow: Float
    public let opacity: Float
    public let hardness: Float
    
    // Adjustment Data (Typically mapped to existing tools)
    public let adjustments: [String: Any]
    
    public init(id: String, name: String, category: String, flow: Float = 20.0, opacity: Float = 100.0, hardness: Float = 0.0, adjustments: [String: Any] = [:]) {
        self.id = id
        self.name = name
        self.category = category
        self.flow = flow
        self.opacity = opacity
        self.hardness = hardness
        self.adjustments = adjustments
    }

    public static func == (lhs: COStyleBrushModel, rhs: COStyleBrushModel) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension COStyleBrushModel {
    public static let defaults: [COStyleBrushModel] = [
        // Color Category
        COStyleBrushModel(id: "deep-sky", name: "Deep Sky", category: "Color", flow: 15.0, adjustments: ["Saturation": 20.0, "Exposure": -0.5]),
        COStyleBrushModel(id: "warm-sunshine", name: "Warm Sunshine", category: "Color", flow: 10.0, adjustments: ["Kelvin": 500.0, "Tint": 2.0]),
        COStyleBrushModel(id: "cool-shadow", name: "Cool Shadow", category: "Color", flow: 10.0, adjustments: ["Kelvin": -500.0]),
        
        // Exposure Category
        COStyleBrushModel(id: "dodge", name: "Dodge (Brighten)", category: "Exposure", flow: 10.0, adjustments: ["Exposure": 0.5]),
        COStyleBrushModel(id: "burn", name: "Burn (Darken)", category: "Exposure", flow: 10.0, adjustments: ["Exposure": -0.5]),
        COStyleBrushModel(id: "high-contrast", name: "High Contrast", category: "Exposure", flow: 15.0, adjustments: ["Contrast": 15.0]),
        
        // Enhancements Category
        COStyleBrushModel(id: "teeth-whitening", name: "Teeth Whitening", category: "Enhancements", flow: 25.0, adjustments: ["Saturation": -40.0, "Exposure": 0.3]),
        COStyleBrushModel(id: "iris-brighten", name: "Iris Brighten", category: "Enhancements", flow: 15.0, adjustments: ["Exposure": 0.5, "Clarity": 20.0]),
        COStyleBrushModel(id: "skin-smoothing", name: "Skin Smoothing", category: "Enhancements", flow: 10.0, adjustments: ["Clarity": -30.0, "Structure": -20.0])
    ]
}
