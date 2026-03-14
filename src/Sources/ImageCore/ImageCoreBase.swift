import Foundation
import CoreGraphics

/// Reconstructed Base interfaces for ImageCore processing engine.
/// Translates C++ ABI patterns into idiomatic Swift.

public struct ICCurvePoint {
    public var x: Float
    public var y: Float
    public init(x: Float = 0, y: Float = 0) {
        self.x = x
        self.y = y
    }
}

public struct ICCurve {
    public var points: [ICCurvePoint] 
    public var count: Int32
    public var startPoint: ICCurvePoint
    public var endPoint: ICCurvePoint

    public init() {
        self.points = Array(repeating: ICCurvePoint(), count: 16)
        self.count = 0
        self.startPoint = ICCurvePoint(x: 0, y: 0)
        self.endPoint = ICCurvePoint(x: 1, y: 1)
    }
}

public struct IC_ColorCorrection: Codable, Identifiable {
    public let id: UUID
    public var hueRotation: Float
    public var saturationChange: Float
    public var lightnessChange: Float
    
    // Target device RGB
    public var red: Float
    public var green: Float
    public var blue: Float
    
    // Wedge bounds
    public var lowHue: Float
    public var lowSaturation: Float
    public var highHue: Float
    public var highSaturation: Float
    public var smoothness: Float
    
    // Homogeneity (Skin tone uniformity)
    public var homogeneityHue: Float
    public var homogeneitySaturation: Float
    public var homogeneityLightness: Float
    
    public var pieType: Int32
    public var isLocal: Bool
    public var isInverted: Bool
    
    public init() {
        self.id = UUID()
        hueRotation = 0.0
        saturationChange = 0.0
        lightnessChange = 0.0
        red = 0.0; green = 0.0; blue = 0.0
        lowHue = 0.0; lowSaturation = 0.0
        highHue = 0.0; highSaturation = 0.0
        smoothness = 0.0
        homogeneityHue = 0.0; homogeneitySaturation = 0.0; homogeneityLightness = 0.0
        pieType = 0
        isLocal = false
        isInverted = false
    }
}

public struct IC_ColorCorrectionList {
    public var count: UInt32
    public var corrections: [IC_ColorCorrection]
    
    public init() {
        self.count = 0
        self.corrections = Array(repeating: IC_ColorCorrection(), count: 35)
    }
}

public enum IC_FilmGrainType: Int32 {
    case fine = 0
    case silverRich = 1
    case soft = 2
    case cubic = 3
}

public struct IC_HDRMergeSettings: Codable {
    public var autoAlign: Bool = true
    public var deghosting: Double = 0.0 // 0.0 to 100.0
    public init() {}
}

public struct IC_PanoramaMergeSettings: Codable {
    public enum ProjectionType: Int, Codable {
        case spherical = 0
        case cylindrical = 1
        case perspective = 2
        case panini = 3
    }
    public var projection: ProjectionType = .cylindrical
    public var autoCrop: Bool = true
    public init() {}
}

/// Base protocol for all image processing operations.
public protocol ICImageOperation {
    var name: String { get }
    func setParameters(_ parameters: IC_ProcessSettings)
    func execute(input: Any, output: Any) // Placeholders for buffer management
}

/// Reconstructed Image Operation Factory logic.
public class ImageOperationFactory {
    public static let shared = ImageOperationFactory()
    private var registry: [String: () -> ICImageOperation] = [:]
    
    private init() {}
    
    public func register(name: String, creator: @escaping () -> ICImageOperation) {
        registry[name] = creator
    }
    
    public func create(name: String) -> ICImageOperation? {
        return registry[name]?()
    }
}
