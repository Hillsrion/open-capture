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

public struct IC_ClaritySettings {
    public var amount: Float
    public var structureAmount: Float
    public var clarityMethod: Int32 // 0: Classic, 1: Punch, 2: Neutral, 3: Natural
    
    public init() {
        self.amount = 0.0
        self.structureAmount = 0.0
        self.clarityMethod = 0
    }
}

public struct IC_ColorCorrection: Codable {
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
    public var corrections: [IC_ColorCorrection] // Up to 35 based on binary dump
    
    public init() {
        self.count = 0
        self.corrections = Array(repeating: IC_ColorCorrection(), count: 35)
    }
}

public struct IC_LocalAdjustmentSettings {
    public var opacity: Float
    public var exposure: Float
    public var contrast: Float
    public var brightness: Float
    public var saturation: Float
    public var clarity: IC_ClaritySettings
    public var maskUUID: String?
    
    public init() {
        self.opacity = 1.0
        self.exposure = 0.0
        self.contrast = 0.0
        self.brightness = 0.0
        self.saturation = 0.0
        self.clarity = IC_ClaritySettings()
    }
}

public struct IC_LensCorrectionSettings {
    public var distortion: Double
    public var lightFalloff: Double
    public var sharpnessFalloff: Double
    public var chromaticAberration: Bool
    public var diffraction: Bool
    public var lccProfileUUID: String?
    
    public init() {
        self.distortion = 0.0
        self.lightFalloff = 0.0
        self.sharpnessFalloff = 0.0
        self.chromaticAberration = false
        self.diffraction = false
        self.lccProfileUUID = nil
    }
}

public struct IC_ExportSettings {
    public var format: Int32 // 0: JPEG, 1: TIFF, 2: PNG, 3: PSD, 4: DNG
    public var quality: Int32
    public var iccProfilePath: String?
    public var bitsPerChannel: Int32
    public var compression: Int32
    
    public init() {
        self.format = 0
        self.quality = 80
        self.iccProfilePath = nil
        self.bitsPerChannel = 8
        self.compression = 0
    }
}

public struct IC_GeometryAdjustments {
    public var cropRect: CGRect
    public var rotation: Double
    public var keystoneX: Double
    public var keystoneY: Double
    
    public init() {
        self.cropRect = .zero
        self.rotation = 0.0
        self.keystoneX = 0.0
        self.keystoneY = 0.0
    }
}

public struct IC_VignettingAdjustments {
    public var amount: Double
    public var midpoint: Double
    public var roundness: Double
    
    public init() {
        self.amount = 0.0
        self.midpoint = 50.0
        self.roundness = 0.0
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
    
    // Clarity & Structure (ENG-003)
    public var clarity: IC_ClaritySettings
    
    // Advanced Color Editor (ENG-004)
    public var colorCorrectionList: IC_ColorCorrectionList
    
    // Local Adjustments (Layers)
    public var localAdjustments: [IC_LocalAdjustmentSettings]

    // Lens Correction (ENG-006)
    public var lensCorrection: IC_LensCorrectionSettings

    // Geometry (Inferred from ConvertToFromGeometryAdjustments)
    public var geometry: IC_GeometryAdjustments
    
    // Vignetting (Inferred from ConvertToFromVignettingAdjustments)
    public var vignetting: IC_VignettingAdjustments

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
        self.clarity = IC_ClaritySettings()
        self.colorCorrectionList = IC_ColorCorrectionList()
        self.localAdjustments = []
        self.lensCorrection = IC_LensCorrectionSettings()
        self.geometry = IC_GeometryAdjustments()
        self.vignetting = IC_VignettingAdjustments()
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
