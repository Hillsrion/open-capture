import Foundation
import CoreGraphics

/// Reconstructed Low-level types for RAW Processing (IMG-001).
/// Based on ImageProcessing.framework v16.7 headers.

public struct IC_RGB32 {
    public var r: UInt32
    public var g: UInt32
    public var b: UInt32
    
    public init(r: UInt32 = 0, g: UInt32 = 0, b: UInt32 = 0) {
        self.r = r
        self.g = g
        self.b = b
    }
}

public struct IC_POINTF {
    public var x: Float
    public var y: Float
    
    public init(x: Float = 0.0, y: Float = 0.0) {
        self.x = x
        self.y = y
    }
}

public struct IC_GradationCurve {
    public var points: [IC_POINTF] // Original: [16{IC_POINTF=ff}]
    public var count: Int32
    public var min: IC_POINTF
    public var max: IC_POINTF
    
    public init() {
        self.points = Array(repeating: IC_POINTF(), count: 16)
        self.count = 0
        self.min = IC_POINTF(x: 0, y: 0)
        self.max = IC_POINTF(x: 1, y: 1)
    }
}

public struct IC_Denoise {
    public var method: Int32
    public var amount: Float
    public var reserved: [Int8] // Original: [1024c]
    public var luminance: Float = 0.0
    public var color: Float = 0.0
    public var singlePixel: Float = 0.0
    public var details: Float = 0.0
    
    public init() {
        self.method = 0
        self.amount = 0.0
        self.reserved = Array(repeating: 0, count: 1024)
    }
}

public struct IC_KeystoneRaw {
    public var horizontal: Float
    public var vertical: Float
    public var amount: Float
    public var aspect: Float
    public var reserved1: Float
    public var reserved2: Float
    public var flags: UInt32
    
    // Compatibility fields for pipeline
    public var keystoneTiltX: Float = 0.0
    public var keystoneTiltY: Float = 0.0
    public var keystoneAmount: Float = 0.0
    public var keystoneAspect: Float = 0.0
    public var keystoneSkew: Float = 0.0
    public var keystoneFocalLength: Float = 35.0
    public var rotation: Double = 0.0
    public var cropRect: CGRect = .zero
    
    public init() {
        self.horizontal = 0.0
        self.vertical = 0.0
        self.amount = 0.0
        self.aspect = 0.0
        self.reserved1 = 0.0
        self.reserved2 = 0.0
        self.flags = 0
    }
}

public struct IC_Clarity {
    public var amount: Float
    public var method: Float
    public var type: Int32
    
    // Compatibility for pipeline
    public var structureAmount: Float = 0.0
    public var clarityMethod: Int32 = 0
    
    public init(amount: Float = 0.0, method: Float = 0.0, type: Int32 = 0) {
        self.amount = amount
        self.method = method
        self.type = type
    }
}

public struct IC_Moire {
    public var amount: Float
    public var type: Int32
    
    public init(amount: Float = 0.0, type: Int32 = 0) {
        self.amount = amount
        self.type = type
    }
}

public struct IC_HDRSettings {
    public var highlights: Float = 0.0
    public var shadows: Float = 0.0
    public var whites: Float = 0.0
    public var blacks: Float = 0.0
    public var amount: Float = 0.0 // Added for filmGrain compatibility
    public init() {}
}

public struct IC_Sharpening {
    public var amount: Float = 0.0
    public var radius: Float = 0.0
    public var threshold: Float = 0.0
    public var haloControl: Float = 0.0
    public init() {}
}

public struct IC_NegativeFilmSettings {
    public var isEnabled: Bool = false
    public var filmType: Int32 = 0
    public init() {}
}

public struct IC_LensCorrectionSettings {
    public var distortion: Float = 0.0
    public var lightFalloff: Float = 0.0
    public var sharpnessFalloff: Float = 0.0
    public var chromaticAberration: Bool = false
    public var diffraction: Bool = false
    public var lccProfileUUID: String? = nil
    public var lccLightFalloffEnabled: Bool = true
    public var lccLightFalloffAmount: Float = 100.0
    public var lccDustRemovalEnabled: Bool = true
    public var lccUniformityEnabled: Bool = true
    public init() {}
}

public struct IC_FilmGrainSettings {
    public var amount: Float = 0.0
    public var size: Float = 0.0
    public var granularity: Float = 0.0
    public var type: Int32 = 0
    public init() {}
}

public struct ICGradationCurves {
    public var curveX = ICCurve()
    public var curveR = ICCurve()
    public var curveG = ICCurve()
    public var curveB = ICCurve()
    public var curveL = ICCurve()
    public init() {}
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

/// Settings specific to a Local Adjustment Layer.
public struct IC_LocalAdjustSettings {
    public var exposure: Float
    public var contrast: Float
    public var brightness: Float
    public var saturation: Float
    public var kelvin: Float
    
    public var clarity: IC_Clarity
    public var moire: IC_Moire
    
    public init() {
        self.exposure = 0.0
        self.contrast = 0.0
        self.brightness = 0.0
        self.saturation = 0.0
        self.kelvin = 0.0
        self.clarity = IC_Clarity()
        self.moire = IC_Moire()
    }
}

/// Configuration for a single Local Adjustment Layer.
public struct IC_LocalAdjustCfg {
    public var layerId: UInt32
    public var settings: IC_LocalAdjustSettings
    public var opacity: Float
    public var isVisible: Bool
    public var maskData: [Float]? // Reconstructed: Pointer/Buffer to the actual mask
    
    // Compatibility for pipeline
    public var exposure: Float { settings.exposure }
    public var colorBalance: ColorBalanceSettings { ColorBalanceSettings() }
    
    public init(layerId: UInt32 = 0) {
        self.layerId = layerId
        self.settings = IC_LocalAdjustSettings()
        self.opacity = 1.0
        self.isVisible = true
        self.maskData = nil
    }
}

/// The master structure for development settings.
/// Mimics the internal IC_ProcessSettings from ImageProcessing.framework.
public struct IC_Levels {
    public var shadow: Float = 0.0
    public var highlight: Float = 1.0
    public var midtone: Float = 1.0
    public var targetShadow: Float = 0.0
    public var targetHighlight: Float = 1.0
    public init() {}
}

public struct IC_LevelsSettings {
    public var levelsRGB = IC_Levels()
    public var levelsR = IC_Levels()
    public var levelsG = IC_Levels()
    public var levelsB = IC_Levels()
    public init() {}
}

/// Processing quality tiers used to build dynamic operation chains.
public enum IC_ProcessQuality: Int32 {
    case display = 0
    case render = 1
    case export = 2
}

/// Aggregates parameters used when building an operation chain.
public struct SImageOperationAllParameters {
    public var settings: IC_ProcessSettings
    public var quality: IC_ProcessQuality
    public var isInteractive: Bool
    public var viewport: CGRect?
    public var fullSize: CGSize?

    public init(settings: IC_ProcessSettings,
                quality: IC_ProcessQuality,
                isInteractive: Bool = false,
                viewport: CGRect? = nil,
                fullSize: CGSize? = nil) {
        self.settings = settings
        self.quality = quality
        self.isInteractive = isInteractive
        self.viewport = viewport
        self.fullSize = fullSize
    }
}
public struct IC_BlackAndWhiteSettings {
    public var enabled: Bool = false
    public var red: Float = 0.0
    public var orange: Float = 0.0
    public var yellow: Float = 0.0
    public var green: Float = 0.0
    public var blue: Float = 0.0
    public var magenta: Float = 0.0
    
    public var splitToneHighlightHue: Float = 0.0
    public var splitToneHighlightSaturation: Float = 0.0
    public var splitToneShadowHue: Float = 0.0
    public var splitToneShadowSaturation: Float = 0.0
    
    public init() {}
}

public struct IC_ProcessSettings {
    public var engineVersion: Int32 = 1600
    
    // Basic Development
    public var exposure: Float
    public var contrast: Float
    public var brightness: Float
    public var saturation: Float
    
    // White Balance
    public var kelvin: Float
    public var tint: Float
    
    // Compatibility fields for old pipeline
    public var whiteBalanceTemperature: Double {
        get { Double(kelvin) }
        set { kelvin = Float(newValue) }
    }
    public var whiteBalanceTint: Double {
        get { Double(tint) }
        set { tint = Float(newValue) }
    }
    
    // High Dynamic Range
    public var highlight: Float {
        get { hdr.highlights }
        set { hdr.highlights = newValue }
    }
    public var shadow: Float {
        get { hdr.shadows }
        set { hdr.shadows = newValue }
    }
    public var white: Float {
        get { hdr.whites }
        set { hdr.whites = newValue }
    }
    public var black: Float {
        get { hdr.blacks }
        set { hdr.blacks = newValue }
    }
    
    public var hdr = IC_HDRSettings()
    
    // Details
    public var sharpening = IC_Sharpening()
    public var noiseReduction = IC_Denoise()
    public var negativeFilm = IC_NegativeFilmSettings()
    public var lensCorrection = IC_LensCorrectionSettings()
    public var filmGrain = IC_FilmGrainSettings()
    public var blackAndWhite = IC_BlackAndWhiteSettings()
    public var gradationCurves = ICGradationCurves()
    public var dehazeAmount: Float = 0.0
    public var dehazeShadowHue: Float = 0.0
    public var levels = IC_LevelsSettings()
    public var clarity = IC_Clarity()
    public var colorCorrectionList = IC_ColorCorrectionList()
    
    // Levels (Compatibility)
    public var levelsShadow: Float {
        get { levels.levelsRGB.shadow }
        set { levels.levelsRGB.shadow = newValue }
    }
    public var levelsHighlight: Float {
        get { levels.levelsRGB.highlight }
        set { levels.levelsRGB.highlight = newValue }
    }
    public var levelsMidtone: Float {
        get { levels.levelsRGB.midtone }
        set { levels.levelsRGB.midtone = newValue }
    }
    public var levelsTargetShadow: Float {
        get { levels.levelsRGB.targetShadow }
        set { levels.levelsRGB.targetShadow = newValue }
    }
    public var levelsTargetHighlight: Float {
        get { levels.levelsRGB.targetHighlight }
        set { levels.levelsRGB.targetHighlight = newValue }
    }
    
    // Legacy support
    public var sharpeningAmount: Float {
        get { sharpening.amount }
        set { sharpening.amount = newValue }
    }
    public var denoise: IC_Denoise {
        get { noiseReduction }
        set { noiseReduction = newValue }
    }
    
    // Geometry
    public var keystone: IC_KeystoneRaw
    public var geometry: IC_KeystoneRaw {
        get { keystone }
        set { keystone = newValue }
    }
    
    public var flipHorizontal: Bool
    public var flipVertical: Bool
    
    // Color Grading (IMG-004)
    public var colorBalance: ColorBalanceSettings
    
    // Local Adjustments (v16.7 parity: array of 16 layers)
    public var localAdjustments: [IC_LocalAdjustCfg]
    
    // Color (v16.7 additions)
    public var colorBalanceShadows: IC_RGB32
    public var colorBalanceMidtones: IC_RGB32
    public var colorBalanceHighlights: IC_RGB32
    
    // Additional compatibility fields
    public var isSoftProofingEnabled: Bool = false
    public var proofingProfileID: String? = nil
    public var showGamutWarning: Bool = false
    
    // Color management
    public var inputProfileID: String? = nil
    public var outputProfileID: String? = nil
    public var toneCurveID: String = "Auto"
    
    public init() {
        self.exposure = 0.0
        self.contrast = 0.0
        self.brightness = 0.0
        self.saturation = 0.0
        self.kelvin = 5000.0
        self.tint = 0.0
        self.keystone = IC_KeystoneRaw()
        self.flipHorizontal = false
        self.flipVertical = false
        self.colorBalance = ColorBalanceSettings()
        self.localAdjustments = (0..<16).map { IC_LocalAdjustCfg(layerId: UInt32($0)) }
        self.colorBalanceShadows = IC_RGB32()
        self.colorBalanceMidtones = IC_RGB32()
        self.colorBalanceHighlights = IC_RGB32()
    }
}
