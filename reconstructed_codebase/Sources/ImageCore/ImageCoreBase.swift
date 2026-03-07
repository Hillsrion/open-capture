import Foundation

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
    public var points: [ICCurvePoint] // Fixed size of 16 in original, we use array for Swift ease
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

public struct ICGradationCurves {
    public var curveX: ICCurve // RGB / Combined
    public var curveR: ICCurve
    public var curveG: ICCurve
    public var curveB: ICCurve
    public var curveL: ICCurve // Luma

    public init() {
        self.curveX = ICCurve()
        self.curveR = ICCurve()
        self.curveG = ICCurve()
        self.curveB = ICCurve()
        self.curveL = ICCurve()
    }
}

/// Represents the comprehensive settings for image processing.
public struct IC_ProcessSettings {
    public var engineVersion: Int32

    // Core Adjustments
    public var exposure: Double
    public var contrast: Double
    public var saturation: Double
    public var brightness: Double

    // White Balance
    public var whiteBalanceTemperature: Double
    public var whiteBalanceTint: Double

    // Levels (Reconstructed from shadow/highlight/midtone fields)
    public var levelsShadow: Float
    public var levelsHighlight: Float
    public var levelsMidtone: Float
    public var levelsTargetShadow: Float
    public var levelsTargetHighlight: Float

    // Gradation Curves (High-Fidelity)
    public var gradationCurves: ICGradationCurves

    // Geometry
    public var cropRect: CGRect
    public var rotation: Double

    public init(version: Int32 = 1600) {
        self.engineVersion = version
        self.exposure = 0.0
        self.contrast = 0.0
        self.saturation = 0.0
        self.brightness = 0.0
        self.whiteBalanceTemperature = 5000.0
        self.whiteBalanceTint = 0.0
        self.levelsShadow = 0.0
        self.levelsHighlight = 1.0
        self.levelsMidtone = 1.0
        self.levelsTargetShadow = 0.0
        self.levelsTargetHighlight = 1.0
        self.gradationCurves = ICGradationCurves()
        self.cropRect = .zero
        self.rotation = 0.0
    }
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
