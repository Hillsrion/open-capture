import Foundation

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
public struct IC_ProcessSettings {
    // Basic Development
    public var exposure: Float
    public var contrast: Float
    public var brightness: Float
    public var saturation: Float
    
    // White Balance
    public var kelvin: Float
    public var tint: Float
    
    // High Dynamic Range
    public var highlight: Float
    public var shadow: Float
    public var white: Float
    public var black: Float
    
    // Details
    public var sharpeningAmount: Float
    public var denoise: IC_Denoise
    
    // Geometry
    public var keystone: IC_KeystoneRaw
    
    // Color Grading (IMG-004)
    public var colorBalance: ColorBalanceSettings
    
    // Local Adjustments (v16.7 parity: array of 16 layers)
    public var localAdjustments: [IC_LocalAdjustCfg]
    
    // Color (v16.7 additions)
    public var colorBalanceShadows: IC_RGB32
    public var colorBalanceMidtones: IC_RGB32
    public var colorBalanceHighlights: IC_RGB32
    
    public init() {
        self.exposure = 0.0
        self.contrast = 0.0
        self.brightness = 0.0
        self.saturation = 0.0
        self.kelvin = 5000.0
        self.tint = 0.0
        self.highlight = 0.0
        self.shadow = 0.0
        self.white = 0.0
        self.black = 0.0
        self.sharpeningAmount = 100.0
        self.denoise = IC_Denoise()
        self.keystone = IC_KeystoneRaw()
        self.colorBalance = ColorBalanceSettings()
        self.localAdjustments = (0..<16).map { IC_LocalAdjustCfg(layerId: UInt32($0)) }
        self.colorBalanceShadows = IC_RGB32()
        self.colorBalanceMidtones = IC_RGB32()
        self.colorBalanceHighlights = IC_RGB32()
    }
}
