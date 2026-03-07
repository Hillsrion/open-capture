import Foundation

/// Reconstructed Base interfaces for ImageCore processing engine.
/// Translates C++ ABI patterns into idiomatic Swift.

/// Represents the comprehensive settings for image processing.
public struct IC_ProcessSettings {
    public var engineVersion: Int32
    public var exposure: Double
    public var contrast: Double
    public var saturation: Double
    public var brightness: Double
    
    // White Balance
    public var whiteBalanceTemperature: Double
    public var whiteBalanceTint: Double
    
    // Levels
    public var levelsBlackPoint: Double
    public var levelsWhitePoint: Double
    public var levelsMidtone: Double
    public var levelsTargetBlack: Double
    public var levelsTargetWhite: Double
    
    // Curves
    public var curvesPoints: [CurvePoint]
    
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
        self.levelsBlackPoint = 0.0
        self.levelsWhitePoint = 1.0
        self.levelsMidtone = 1.0
        self.levelsTargetBlack = 0.0
        self.levelsTargetWhite = 1.0
        self.curvesPoints = []
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
