import SwiftUI
import AppCoreShared
import ImageCore
import DataCore
import Combine

// Spot Removal State (UI-203)
public struct SpotItem: Identifiable, Codable {
    public let id: UUID
    public var type: Int // 0: Dust, 1: Spot
    public var center: CGPoint
    public var radius: Double
    
    public init(id: UUID = UUID(), type: Int = 0, center: CGPoint = CGPoint(x: 0.5, y: 0.5), radius: Double = 10.0) {
        self.id = id
        self.type = type
        self.center = center
        self.radius = radius
    }
}

// Composition State (UI-204)
public struct GuideItem: Identifiable, Codable {
    public let id: UUID
    public var position: Double // 0.0 to 1.0
    public var isVertical: Bool
    
    public init(id: UUID = UUID(), position: Double, isVertical: Bool) {
        self.id = id
        self.position = position
        self.isVertical = isVertical
    }
}

/// Reconstructed controller for managing adjustment tool states.
/// Bridges the UI sliders to the underlying MCVariant settings.
public class AdjustmentToolController: ObservableObject, HardwareActionDelegate {
    public static let shared = AdjustmentToolController()
    
    @Published public var currentVariant: VariantBase? {
        didSet { refreshToolValues() }
    }
    private var cancellables = Set<AnyCancellable>()
    private var isUpdatingFromModel = false
    
    // MARK: - Published State
    @Published public var exposure: Float = 0.0
    @Published public var contrast: Float = 0.0
    @Published public var brightness: Float = 0.0
    @Published public var saturation: Float = 0.0
    
    @Published public var kelvin: Float = 5000.0
    @Published public var tint: Float = 0.0
    
    @Published public var highlights: Float = 0.0
    @Published public var shadows: Float = 0.0
    @Published public var whites: Float = 0.0
    @Published public var blacks: Float = 0.0
    
    // Navigator State (UI-203)
    @Published public var zoomLevel: Double = 1.0
    @Published public var viewportRect: CGRect = CGRect(x: 0.25, y: 0.25, width: 0.5, height: 0.5)
    
    // Multi-view sync (Pan Cursor Tool spec)
    @Published public var multiViewPanning: Bool = false
    
    // AI Crop Studio State (UI-204)
    @Published public var aiCropTopMargin: Double = 10.0 {
        didSet { AICropSettingsController.shared.margins.top = aiCropTopMargin }
    }
    @Published public var aiCropBottomMargin: Double = 10.0 {
        didSet { AICropSettingsController.shared.margins.bottom = aiCropBottomMargin }
    }
    @Published public var aiCropLeftMargin: Double = 10.0 {
        didSet { AICropSettingsController.shared.margins.left = aiCropLeftMargin }
    }
    @Published public var aiCropRightMargin: Double = 10.0 {
        didSet { AICropSettingsController.shared.margins.right = aiCropRightMargin }
    }
    @Published public var aiCropShowGuides: Bool = true {
        didSet { AICropSettingsController.shared.showGuides = aiCropShowGuides }
    }
    @Published public var aiCropReferencePoint: Int = 0 { // 0: Center, 1: Top, 2: Eyes
        didSet { AICropSettingsController.shared.referencePoint = aiCropReferencePoint }
    }
    @Published public var aiCropLockAspect: Bool = true {
        didSet { AICropSettingsController.shared.lockAspect = aiCropLockAspect }
    }
    
    // COStyles State (UI-204)
    @Published public var stackCOStyles: Bool = false
    @Published public var styleOpacity: Double = 100.0 // 0 to 100
    
    // Smart Adjustments State (AI-204)
    @Published public var smartExposureEnabled: Bool = true
    @Published public var smartWhiteBalanceEnabled: Bool = true
    @Published public var smartReference: SmartAdjustmentsReference? = nil
    @Published public var smartReferenceVariantID: String? = nil
    
    // Spot Removal State (UI-203)
    @Published public var spots: [SpotItem] = []
    @Published public var selectedSpotID: UUID?
    
    // Levels State (RGB)
    @Published public var levelsBlackPointRGB: Float = 0.0
    @Published public var levelsWhitePointRGB: Float = 1.0
    @Published public var levelsMidtoneRGB: Float = 1.0
    @Published public var levelsTargetBlackRGB: Float = 0.0
    @Published public var levelsTargetWhiteRGB: Float = 1.0
    
    // Levels State (Red)
    @Published public var levelsBlackPointR: Float = 0.0
    @Published public var levelsWhitePointR: Float = 1.0
    @Published public var levelsMidtoneR: Float = 1.0
    @Published public var levelsTargetBlackR: Float = 0.0
    @Published public var levelsTargetWhiteR: Float = 1.0
    
    // Levels State (Green)
    @Published public var levelsBlackPointG: Float = 0.0
    @Published public var levelsWhitePointG: Float = 1.0
    @Published public var levelsMidtoneG: Float = 1.0
    @Published public var levelsTargetBlackG: Float = 0.0
    @Published public var levelsTargetWhiteG: Float = 1.0
    
    // Levels State (Blue)
    @Published public var levelsBlackPointB: Float = 0.0
    @Published public var levelsWhitePointB: Float = 1.0
    @Published public var levelsMidtoneB: Float = 1.0
    @Published public var levelsTargetBlackB: Float = 0.0
    @Published public var levelsTargetWhiteB: Float = 1.0
    
    // Histogram State
    @Published public var currentHistogram: POHistogram = .empty()
    
    // Curves State
    @Published public var curvesPointsRGB: [CGPoint] = [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0)]
    @Published public var curvesPointsLuma: [CGPoint] = [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0)]
    @Published public var curvesPointsRed: [CGPoint] = [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0)]
    @Published public var curvesPointsGreen: [CGPoint] = [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0)]
    @Published public var curvesPointsBlue: [CGPoint] = [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0)]
    @Published public var curvesSelectedChannel: Int = 0 // 0: RGB, 1: Luma, 2: Red, 3: Green, 4: Blue
    
    // Base Characteristics (UI-204)
    @Published public var iccProfile: String = "Generic RGB"
    @Published public var toneCurve: String = "Auto"
    @Published public var engineVersion: String = "Capture One 16"
    @Published public var isProStandard: Bool = false
    
    // Color Editor (UI-204)
    @Published public var colorEditorMode: Int = 0 // 0: Basic, 1: Advanced, 2: Skin Tone
    @Published public var directColorEditorEnabled: Bool = false
    
    // Negative Film (UI-202)
    @Published public var negativeFilmEnabled: Bool = false
    @Published public var negativeFilmType: Int = 0 // 0: B&W, 1: Color
    
    // Ratings & Color Tag
    @Published public var rating: Int = 0
    @Published public var colorTag: VariantBase.ColorTag = .none
    
    // Clarity & Structure
    @Published public var clarityAmount: Float = 0.0
    @Published public var structureAmount: Float = 0.0
    @Published public var clarityMethod: Int = 0 // 0: Classic, 1: Punch, 2: Neutral, 3: Natural
    
    // Advanced Color Editor
    @Published public var colorCorrections: [IC_ColorCorrection] = []
    
    // Basic Color Editor (UI-204)
    @Published public var basicColorHue: [Double] = Array(repeating: 0.0, count: 8)
    @Published public var basicColorSat: [Double] = Array(repeating: 0.0, count: 8)
    @Published public var basicColorLum: [Double] = Array(repeating: 0.0, count: 8)
    
    // Skin Tone Uniformity & Amount
    @Published public var skinHueUniformity: Float = 0.0
    @Published public var skinSatUniformity: Float = 0.0
    @Published public var skinLumaUniformity: Float = 0.0
    @Published public var skinHueAmount: Float = 0.0
    @Published public var skinSatAmount: Float = 0.0
    @Published public var skinLumaAmount: Float = 0.0
    
    // Lens Correction (ENG-006)
    @Published public var lensDistortion: Double = 0.0
    @Published public var lensSharpnessFalloff: Double = 0.0
    @Published public var lensLightFalloff: Double = 0.0
    @Published public var lensShiftX: Float = 0.0
    @Published public var lensShiftY: Float = 0.0
    @Published public var clipDistortedEdges: Bool = false
    
    // Black & White (UI-202)
    @Published public var blackAndWhiteEnabled: Bool = false
    @Published public var bwRed: Double = 0.0
    @Published public var bwOrange: Double = 0.0
    @Published public var bwYellow: Double = 0.0
    @Published public var bwGreen: Double = 0.0
    @Published public var bwBlue: Double = 0.0
    @Published public var bwMagenta: Double = 0.0
    @Published public var bwSplitToneHighlightHue: Double = 0.0
    @Published public var bwSplitToneHighlightSaturation: Double = 0.0
    @Published public var bwSplitToneShadowHue: Double = 0.0
    @Published public var bwSplitToneShadowSaturation: Double = 0.0
    
    // Dehaze & Vignetting (UI-202)
    @Published public var dehazeAmount: Double = 0.0
    @Published public var dehazeShadowToneHue: Double = 0.0
    @Published public var dehazeColor: Color = .gray
    @Published public var vignettingAmount: Double = 0.0
    @Published public var vignettingMethod: Int = 0
    
    // Match Look (TOOL-301)
    @Published public var matchLookImpact: Float = 100.0
    @Published public var matchLookReferenceVariantID: String? = nil
    
    // Moire (UI-203)
    @Published public var moireAmount: Double = 0.0
    @Published public var moirePattern: Double = 0.0
    
    // Crop & Rotation (UI-204)
    @Published public var cropRect: CGRect = .zero
    @Published public var rotationAngle: Double = 0.0
    @Published public var isCropOrientationSwapped: Bool = false
    @Published public var flipHorizontal: Bool = false
    @Published public var flipVertical: Bool = false
    @Published public var keystoneVertical: Double = 0.0
    @Published public var keystoneHorizontal: Double = 0.0
    @Published public var cropRatioIndex: Int = 0
    @Published public var cropGridIndex: Int = 0 // 0: 3x3, 1: Golden Ratio, etc.
    @Published public var cropShowMask: Bool = true
    @Published public var cropMaskOpacity: Double = 50.0
    @Published public var cropMaskBrightness: Double = 0.0
    @Published public var respectFujifilmInCameraCrop: Bool = true
    @Published public var customRatios: [String] = []
    
    // Grid & Guides (UI-204)
    @Published public var gridTypeIndex: Int = 0
    @Published public var gridColorIndex: Int = 0 // 0: White, 1: Gray, 2: Black, 3: Amber
    @Published public var gridFollowCrop: Bool = true
    @Published public var gridFibonacciClockwise: Bool = false
    @Published public var gridFibonacciMirror: Bool = false
    @Published public var guides: [GuideItem] = []
    
    private func updateIfChanged<T: Equatable>(_ property: inout T, _ newValue: T) {
        if property != newValue {
            property = newValue
        }
    }
    
    // Keystone State (AI-003)
    @Published public var keystoneTiltX: Double = 0.0
    @Published public var keystoneTiltY: Double = 0.0
    @Published public var keystoneAmount: Double = 0.0
    @Published public var keystoneAspect: Double = 0.0
    @Published public var keystoneSkew: Double = 0.0
    @Published public var keystoneFocalLength: Double = 35.0
    @Published public var keystonePoints: KeystonePoints? = nil // TETH-004
    
    // Overlay Tool State (GAP-406)
    @Published public var showOverlay: Bool = false
    @Published public var overlayOpacity: Double = 50.0
    @Published public var overlayScale: Double = 100.0
    @Published public var overlayPath: String = ""
    @Published public var overlayOffset: CGPoint = .zero
    
    // Focus Tool State (UI-203)
    @Published public var focusPoint: CGPoint = CGPoint(x: 0.5, y: 0.5)
    @Published public var focusZoomIndex: Int = 0 // 0: 100%, 1: 200%, 2: 400%
    @Published public var focusAIMode: Int = 0 // 0: Manual, 1: Eye, 2: Face
    @Published public var focusZoomLevel: Double = 1.0 // Legacy/Flexible support
    
    // Exposure Warning Preferences (UI-204)
    @Published public var exposureHighlightThreshold: Double = 250.0
    @Published public var exposureShadowThreshold: Double = 0.0
    @Published public var exposureHighlightColor: Color = .red
    @Published public var exposureShadowColor: Color = .blue
    
    // Masking State (UI-204)
    @Published public var currentLinearGradient: LinearGradientMask? = nil
    @Published public var currentRadialGradient: RadialGradientMask? = nil
    
    // Luma Range State (UI-204)
    @Published public var lumaRangeRadius: Double = 5.0
    @Published public var lumaRangeSensitivity: Double = 50.0
    
    // Smart Adjustments (AI-002)
    
    // Soft Proofing (ENG-011)
    @Published public var isSoftProofingEnabled: Bool = false
    @Published public var proofingProfileID: String = "sRGB"
    @Published public var showGamutWarning: Bool = false
    
    // Masking Preferences (GAP-404)
    @Published public var maskVisibilityMode: Int = 2 // 0: Never, 1: Always, 2: Only When Brushing, 3: Grayscale
    @Published public var maskColorIndex: Int = 0 // 0: Red, 1: Green, 2: Blue
    @Published public var maskRefineEdge: Double = 0.0
    @Published public var maskFeather: Double = 0.0
    
    @Published public var chromaticAberration: Bool = false
    @Published public var diffraction: Bool = false
    @Published public var isLCCActive: Bool = false
    @Published public var lccProfileUUID: String? = nil
    @Published public var lccLightFalloffEnabled: Bool = true
    @Published public var lccLightFalloffAmount: Double = 100.0
    @Published public var lccDustRemovalEnabled: Bool = true
    @Published public var lccUniformityEnabled: Bool = true

    // Noise Reduction (ENG-007)
    @Published public var nrLuminance: Double = 50.0
    @Published public var nrDetails: Double = 50.0
    @Published public var nrColor: Double = 50.0
    @Published public var nrSinglePixel: Double = 0.0
    
    // Sharpening (ENG-007)
    @Published public var sharpAmount: Double = 100.0
    @Published public var sharpRadius: Double = 0.8
    @Published public var sharpThreshold: Double = 1.0
    @Published public var sharpHalo: Double = 0.0

    // Film Grain (ENG-008)
    @Published public var filmGrainAmount: Double = 0.0
    @Published public var filmGrainDensity: Double = 50.0
    @Published public var filmGrainGranularity: Double = 50.0
    @Published public var filmGrainType: IC_FilmGrainType = .fine

    // Color Balance (UI-003)
    @Published public var cbShadow: ColorBalanceValue = .neutral
    @Published public var cbMidtone: ColorBalanceValue = .neutral
    @Published public var cbHighlight: ColorBalanceValue = .neutral
    @Published public var cbMaster: ColorBalanceValue = .neutral

    // AI Retouching (AI-204)
    @Published public var blemishAmount: Double = 0.0
    @Published public var evenSkinAmount: Double = 0.0
    @Published public var evenSkinTexture: Double = 0.0
    @Published public var retouchFaceSmoothing: Double = 0.0
    @Published public var retouchFaceRedness: Double = 0.0
    @Published public var retouchFaceUniformity: Double = 0.0
    @Published public var retouchTeethImpact: Double = 0.0
    @Published public var retouchEyesLeftImpact: Double = 0.0
    @Published public var retouchEyesRightImpact: Double = 0.0

    @Published public var isInteracting: Bool = false
    
    public lazy var blackAndWhiteController: COBlackAndWhiteToolController = {
        COBlackAndWhiteToolController(adjustmentController: self)
    }()
    
    // Live Preview State (UI-010)
    private var originalSettings: [String: Any]?
    @Published public var previewingCOStyle: COStyle?

    // Filtering State
    @Published public var activePredicate: COFilterPredicate = COFilterPredicate()
    
    public init() {
        setupChangeObservers()
        setupRecipeSync()
        setupNegativeFilmSync()
        setupZoomViewportSync()
    }
    
    private func setupZoomViewportSync() {
        $zoomLevel
            .sink { [weak self] zoom in
                guard let self = self else { return }
                let size = 1.0 / max(0.1, zoom)
                let current = self.viewportRect
                // Keep the center of the viewport same if possible
                let centerX = current.origin.x + current.width / 2
                let centerY = current.origin.y + current.height / 2
                let newOriginX = max(0, min(1.0 - size, centerX - size / 2))
                let newOriginY = max(0, min(1.0 - size, centerY - size / 2))
                self.viewportRect = CGRect(x: newOriginX, y: newOriginY, width: size, height: size)
            }
            .store(in: &cancellables)
    }
    
    private func mapLevels(black: Float, white: Float, midtone: Float, tBlack: Float, tWhite: Float) -> IC_Levels {
        var l = IC_Levels()
        l.shadow = black
        l.highlight = white
        l.midtone = midtone
        l.targetShadow = tBlack
        l.targetHighlight = tWhite
        return l
    }
    
    private func mapCurve(_ pts: [CGPoint]) -> ICCurve {
        var curve = ICCurve()
        curve.count = Int32(min(pts.count, 16))
        for i in 0..<Int(curve.count) {
            curve.points[i] = ICCurvePoint(x: Float(pts[i].x), y: Float(pts[i].y))
        }
        return curve
    }
    
    private func setupNegativeFilmSync() {
        $negativeFilmEnabled
            .dropFirst()
            .sink { [weak self] enabled in
                guard let self = self else { return }
                // Automatically switch Curves to Negative preset (diagonal 1,1 to 0,0)
                // if they are currently at default (0,0 to 1,1)
                if enabled {
                    if self.curvesPointsRGB == [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0)] {
                        self.curvesPointsRGB = [CGPoint(x: 0.0, y: 1.0), CGPoint(x: 1.0, y: 0.0)]
                    }
                } else {
                    if self.curvesPointsRGB == [CGPoint(x: 0.0, y: 1.0), CGPoint(x: 1.0, y: 0.0)] {
                        self.curvesPointsRGB = [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0)]
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupRecipeSync() {
        // Automatically update proofing profile when primary recipe changes
        OutputRecipeManager.shared.$primaryRecipe
            .sink { [weak self] recipe in
                if let recipe = recipe {
                    // Map recipe profile string to internal ID
                    // This is a simplification: in reality it might need mapping
                    self?.isUpdatingFromModel = true
                    self?.proofingProfileID = recipe.iccProfile
                    self?.isUpdatingFromModel = false
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupChangeObservers() {
        // Evaluate the 'isUpdatingFromModel' flag synchronously at the moment the value changes,
        // BEFORE the debounce delays the execution. This mimics Capture One's 'ChangeOrigin' (User vs Internal).
        let observe = { [weak self] (publisher: AnyPublisher<Void, Never>) -> AnyPublisher<Void, Never> in
            publisher
                .filter { _ in self?.isUpdatingFromModel == false }
                .eraseToAnyPublisher()
        }
        
        // Observe all published properties and commit changes when they change
        let publishers: [AnyPublisher<Void, Never>] = [
            observe($exposure.map { _ in }.eraseToAnyPublisher()),
            observe($contrast.map { _ in }.eraseToAnyPublisher()),
            observe($brightness.map { _ in }.eraseToAnyPublisher()),
            observe($saturation.map { _ in }.eraseToAnyPublisher()),
            observe($cbMaster.map { _ in }.eraseToAnyPublisher()),
            observe($cbShadow.map { _ in }.eraseToAnyPublisher()),
            observe($cbMidtone.map { _ in }.eraseToAnyPublisher()),
            observe($cbHighlight.map { _ in }.eraseToAnyPublisher()),
            observe($kelvin.map { _ in }.eraseToAnyPublisher()),
            observe($tint.map { _ in }.eraseToAnyPublisher()),
            observe($highlights.map { _ in }.eraseToAnyPublisher()),
            observe($shadows.map { _ in }.eraseToAnyPublisher()),
            observe($whites.map { _ in }.eraseToAnyPublisher()),
            observe($blacks.map { _ in }.eraseToAnyPublisher()),
            observe($levelsBlackPointRGB.map { _ in }.eraseToAnyPublisher()),
            observe($levelsWhitePointRGB.map { _ in }.eraseToAnyPublisher()),
            observe($levelsMidtoneRGB.map { _ in }.eraseToAnyPublisher()),
            observe($levelsTargetBlackRGB.map { _ in }.eraseToAnyPublisher()),
            observe($levelsTargetWhiteRGB.map { _ in }.eraseToAnyPublisher()),
            observe($levelsBlackPointR.map { _ in }.eraseToAnyPublisher()),
            observe($levelsWhitePointR.map { _ in }.eraseToAnyPublisher()),
            observe($levelsMidtoneR.map { _ in }.eraseToAnyPublisher()),
            observe($levelsTargetBlackR.map { _ in }.eraseToAnyPublisher()),
            observe($levelsTargetWhiteR.map { _ in }.eraseToAnyPublisher()),
            observe($levelsBlackPointG.map { _ in }.eraseToAnyPublisher()),
            observe($levelsWhitePointG.map { _ in }.eraseToAnyPublisher()),
            observe($levelsMidtoneG.map { _ in }.eraseToAnyPublisher()),
            observe($levelsTargetBlackG.map { _ in }.eraseToAnyPublisher()),
            observe($levelsTargetWhiteG.map { _ in }.eraseToAnyPublisher()),
            observe($levelsBlackPointB.map { _ in }.eraseToAnyPublisher()),
            observe($levelsWhitePointB.map { _ in }.eraseToAnyPublisher()),
            observe($levelsMidtoneB.map { _ in }.eraseToAnyPublisher()),
            observe($levelsTargetBlackB.map { _ in }.eraseToAnyPublisher()),
            observe($levelsTargetWhiteB.map { _ in }.eraseToAnyPublisher()),
            observe($curvesPointsRGB.map { _ in }.eraseToAnyPublisher()),
            observe($curvesPointsLuma.map { _ in }.eraseToAnyPublisher()),
            observe($curvesPointsRed.map { _ in }.eraseToAnyPublisher()),
            observe($curvesPointsGreen.map { _ in }.eraseToAnyPublisher()),
            observe($curvesPointsBlue.map { _ in }.eraseToAnyPublisher()),
            observe($curvesSelectedChannel.map { _ in }.eraseToAnyPublisher()),
            observe($rating.map { _ in }.eraseToAnyPublisher()),
            observe($colorTag.map { _ in }.eraseToAnyPublisher()),
            observe($activePredicate.map { _ in }.eraseToAnyPublisher()),
            observe($clarityAmount.map { _ in }.eraseToAnyPublisher()),
            observe($structureAmount.map { _ in }.eraseToAnyPublisher()),
            observe($clarityMethod.map { _ in }.eraseToAnyPublisher()),
            observe($colorCorrections.map { _ in }.eraseToAnyPublisher()),
            observe($basicColorHue.map { _ in }.eraseToAnyPublisher()),
            observe($basicColorSat.map { _ in }.eraseToAnyPublisher()),
            observe($basicColorLum.map { _ in }.eraseToAnyPublisher()),
            observe($skinHueUniformity.map { _ in }.eraseToAnyPublisher()),
            observe($skinSatUniformity.map { _ in }.eraseToAnyPublisher()),
            observe($skinLumaUniformity.map { _ in }.eraseToAnyPublisher()),
            observe($skinHueAmount.map { _ in }.eraseToAnyPublisher()),
            observe($skinSatAmount.map { _ in }.eraseToAnyPublisher()),
            observe($skinLumaAmount.map { _ in }.eraseToAnyPublisher()),
            observe($lensDistortion.map { _ in }.eraseToAnyPublisher()),
            observe($lensSharpnessFalloff.map { _ in }.eraseToAnyPublisher()),
            observe($lensLightFalloff.map { _ in }.eraseToAnyPublisher()),
            observe($lensShiftX.map { _ in }.eraseToAnyPublisher()),
            observe($lensShiftY.map { _ in }.eraseToAnyPublisher()),
            observe($clipDistortedEdges.map { _ in }.eraseToAnyPublisher()),
            observe($chromaticAberration.map { _ in }.eraseToAnyPublisher()),
            observe($diffraction.map { _ in }.eraseToAnyPublisher()),
            observe($isLCCActive.map { _ in }.eraseToAnyPublisher()),
            observe($lccProfileUUID.map { _ in }.eraseToAnyPublisher()),
            observe($lccLightFalloffEnabled.map { _ in }.eraseToAnyPublisher()),
            observe($lccLightFalloffAmount.map { _ in }.eraseToAnyPublisher()),
            observe($lccDustRemovalEnabled.map { _ in }.eraseToAnyPublisher()),
            observe($lccUniformityEnabled.map { _ in }.eraseToAnyPublisher()),
            observe($isSoftProofingEnabled.map { _ in }.eraseToAnyPublisher()),
            observe($proofingProfileID.map { _ in }.eraseToAnyPublisher()),
            observe($showGamutWarning.map { _ in }.eraseToAnyPublisher()),
            observe($maskVisibilityMode.map { _ in }.eraseToAnyPublisher()),
            observe($maskColorIndex.map { _ in }.eraseToAnyPublisher()),
            observe($maskRefineEdge.map { _ in }.eraseToAnyPublisher()),
            observe($maskFeather.map { _ in }.eraseToAnyPublisher()),
            observe($keystoneTiltX.map { _ in }.eraseToAnyPublisher()),
            observe($keystoneTiltY.map { _ in }.eraseToAnyPublisher()),
            observe($keystoneAmount.map { _ in }.eraseToAnyPublisher()),
            observe($keystoneAspect.map { _ in }.eraseToAnyPublisher()),
            observe($keystoneSkew.map { _ in }.eraseToAnyPublisher()),
            observe($keystoneFocalLength.map { _ in }.eraseToAnyPublisher()),
            observe($nrLuminance.map { _ in }.eraseToAnyPublisher()),
            observe($nrDetails.map { _ in }.eraseToAnyPublisher()),
            observe($nrColor.map { _ in }.eraseToAnyPublisher()),
            observe($nrSinglePixel.map { _ in }.eraseToAnyPublisher()),
            observe($sharpAmount.map { _ in }.eraseToAnyPublisher()),
            observe($sharpRadius.map { _ in }.eraseToAnyPublisher()),
            observe($sharpThreshold.map { _ in }.eraseToAnyPublisher()),
            observe($sharpHalo.map { _ in }.eraseToAnyPublisher()),
            observe($stackCOStyles.map { _ in }.eraseToAnyPublisher()),
            observe($blackAndWhiteEnabled.map { _ in }.eraseToAnyPublisher()),
            observe($bwRed.map { _ in }.eraseToAnyPublisher()),
            observe($bwOrange.map { _ in }.eraseToAnyPublisher()),
            observe($bwYellow.map { _ in }.eraseToAnyPublisher()),
            observe($bwGreen.map { _ in }.eraseToAnyPublisher()),
            observe($bwBlue.map { _ in }.eraseToAnyPublisher()),
            observe($bwMagenta.map { _ in }.eraseToAnyPublisher()),
            observe($bwSplitToneHighlightHue.map { _ in }.eraseToAnyPublisher()),
            observe($bwSplitToneHighlightSaturation.map { _ in }.eraseToAnyPublisher()),
            observe($bwSplitToneShadowHue.map { _ in }.eraseToAnyPublisher()),
            observe($bwSplitToneShadowSaturation.map { _ in }.eraseToAnyPublisher()),
            observe($dehazeAmount.map { _ in }.eraseToAnyPublisher()),
            observe($dehazeColor.map { _ in }.eraseToAnyPublisher()),
            observe($vignettingAmount.map { _ in }.eraseToAnyPublisher()),
            observe($vignettingMethod.map { _ in }.eraseToAnyPublisher()),
            observe($matchLookImpact.map { _ in }.eraseToAnyPublisher()),
            observe($matchLookReferenceVariantID.map { _ in }.eraseToAnyPublisher()),
            observe($moireAmount.map { _ in }.eraseToAnyPublisher()),
            observe($moirePattern.map { _ in }.eraseToAnyPublisher()),
            observe($cropRect.map { _ in }.eraseToAnyPublisher()),
            observe($rotationAngle.map { _ in }.eraseToAnyPublisher()),
            observe($zoomLevel.map { _ in }.eraseToAnyPublisher()),
            observe($viewportRect.map { _ in }.eraseToAnyPublisher()),
            observe($focusZoomLevel.map { _ in }.eraseToAnyPublisher()),
            observe($focusPoint.map { _ in }.eraseToAnyPublisher()),
            observe($focusAIMode.map { _ in }.eraseToAnyPublisher()),
            observe($lumaRangeRadius.map { _ in }.eraseToAnyPublisher()),
            observe($lumaRangeSensitivity.map { _ in }.eraseToAnyPublisher()),
            observe($showOverlay.map { _ in }.eraseToAnyPublisher()),
            observe($overlayOpacity.map { _ in }.eraseToAnyPublisher()),
            observe($overlayScale.map { _ in }.eraseToAnyPublisher()),
            observe($aiCropTopMargin.map { _ in }.eraseToAnyPublisher()),
            observe($aiCropBottomMargin.map { _ in }.eraseToAnyPublisher()),
            observe($aiCropLeftMargin.map { _ in }.eraseToAnyPublisher()),
            observe($aiCropRightMargin.map { _ in }.eraseToAnyPublisher()),
            observe($aiCropShowGuides.map { _ in }.eraseToAnyPublisher()),
            observe($aiCropReferencePoint.map { _ in }.eraseToAnyPublisher()),
            observe($aiCropLockAspect.map { _ in }.eraseToAnyPublisher()),
            observe($spots.map { _ in }.eraseToAnyPublisher()),
            observe($negativeFilmEnabled.map { _ in }.eraseToAnyPublisher()),
            observe($negativeFilmType.map { _ in }.eraseToAnyPublisher()),
            observe($cropRatioIndex.map { _ in }.eraseToAnyPublisher()),
            observe($cropGridIndex.map { _ in }.eraseToAnyPublisher()),
            observe($cropShowMask.map { _ in }.eraseToAnyPublisher()),
            observe($cropMaskOpacity.map { _ in }.eraseToAnyPublisher()),
            observe($cropMaskBrightness.map { _ in }.eraseToAnyPublisher()),
            observe($gridTypeIndex.map { _ in }.eraseToAnyPublisher()),
            observe($gridColorIndex.map { _ in }.eraseToAnyPublisher()),
            observe($guides.map { _ in }.eraseToAnyPublisher()),
            observe($blemishAmount.map { _ in }.eraseToAnyPublisher()),
            observe($evenSkinAmount.map { _ in }.eraseToAnyPublisher()),
            observe($evenSkinTexture.map { _ in }.eraseToAnyPublisher()),
            observe($retouchFaceSmoothing.map { _ in }.eraseToAnyPublisher()),
            observe($retouchFaceRedness.map { _ in }.eraseToAnyPublisher()),
            observe($retouchFaceUniformity.map { _ in }.eraseToAnyPublisher()),
            observe($retouchTeethImpact.map { _ in }.eraseToAnyPublisher()),
            observe($retouchEyesLeftImpact.map { _ in }.eraseToAnyPublisher()),
            observe($retouchEyesRightImpact.map { _ in }.eraseToAnyPublisher())
        ]
        
        let mergedPublishers = Publishers.MergeMany(publishers).share()
        
        // Track interacting state: set true on any change
        mergedPublishers
            .sink { [weak self] _ in
                guard let self = self else { return }
                if !self.isInteracting {
                    self.isInteracting = true
                }
            }
            .store(in: &cancellables)
            
        // Track interacting state: set false after 100ms of no changes (Snappy/Nervous transition)
        mergedPublishers
            .debounce(for: .milliseconds(100), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.isInteracting = false
            }
            .store(in: &cancellables)
            
        // Commit changes to the model (16ms throttle/debounce for 60fps)
        mergedPublishers
            .debounce(for: .milliseconds(16), scheduler: RunLoop.main) // ~60fps
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.commitChanges(to: self.currentVariant)
            }
            .store(in: &cancellables)
    }
    
    /// Temporarily applies a style for live preview (hover).
    public func temporarilyApplyCOStyle(_ style: COStyle?) {
        guard let variant = currentVariant, let mc = variant.mcVariant else { return }
        
        if let style = style {
            // 1. Capture original state if not already captured
            if originalSettings == nil {
                originalSettings = [:]
                // Simplified: Capture key adjustment values
                let keys = ["ZEXPOSURE", "ZCONTRAST", "ZBRIGHTNESS", "ZSATURATION", "ZKELVIN", "ZTINT"]
                for key in keys {
                    originalSettings?[key] = mc.objectForKey(key) ?? getDefaultValue(for: key)
                }
            }
            
            // 2. Apply style adjustments
            isUpdatingFromModel = true
            for (key, val) in style.adjustments {
                applyAdjustmentValue(val, forKey: key)
            }
            isUpdatingFromModel = false
            
            previewingCOStyle = style
            commitChanges(to: variant)
        } else {
            // 3. Revert to original state
            if let original = originalSettings {
                isUpdatingFromModel = true
                for (key, val) in original {
                    applyAdjustmentValue(val, forKey: key)
                }
                isUpdatingFromModel = false
                originalSettings = nil
            }
            previewingCOStyle = nil
            commitChanges(to: variant)
        }
    }
    
    /// Feature: COStyles in Layers
    public func applyCOStyleToNewLayer(_ style: COStyle) {
        guard let variant = currentVariant else { return }
        print("[AdjustmentToolController] Applying COStyle \(style.name) to New Layer")
        
        let newLayer = LayerBase(
            uuid: UUID().uuidString,
            name: style.name,
            type: .adjustment,
            context: variant.managedObjectContext
        )
        variant.layers.append(newLayer)
        variant.activeLayerIndex = variant.layers.count - 1
        variant.isModified = true
        
        // In original, this creates an IC_ColorCorrection layer or sets adjustment values on the layer
    }
    
    /// Permanently applies a style to the current variant.
    public func applyCOStyle(_ style: COStyle) {
        guard let variant = currentVariant else { return }
        
        // 1. If not stacking, reset to neutral first (simulated)
        if !stackCOStyles {
            resetToNeutral()
        }
        
        // 2. Apply style adjustments permanently
        isUpdatingFromModel = true
        for (key, val) in style.adjustments {
            applyAdjustmentValue(val.value, forKey: key)
        }
        isUpdatingFromModel = false
        
        // 3. Clear preview state since it's now permanent
        originalSettings = nil
        previewingCOStyle = nil
        
        commitChanges(to: variant)
        print("[Adjustment] COStyle applied: \(style.name)")
    }
    
    public func resetToNeutral(includeComposition: Bool = true) {
        self.exposure = 0.0
        self.contrast = 0.0
        self.brightness = 0.0
        self.saturation = 0.0
        self.kelvin = 5000.0
        self.tint = 0.0
        
        self.highlights = 0.0
        self.shadows = 0.0
        self.whites = 0.0
        self.blacks = 0.0
        
        self.clarityAmount = 0.0
        self.structureAmount = 0.0
        
        self.sharpAmount = 100.0
        self.sharpRadius = 0.8
        self.sharpThreshold = 1.0
        
        self.nrLuminance = 50.0
        self.nrDetails = 50.0
        self.nrColor = 50.0
        
        self.vignettingAmount = 0.0
        self.dehazeAmount = 0.0
        
        if includeComposition {
            self.cropRect = .zero
            self.rotationAngle = 0.0
        }
        
        self.commitChanges(to: currentVariant)
    }
    
    private func applyAdjustmentValue(_ value: Any?, forKey key: String) {
        // Map dictionary keys to published properties
        switch key {
        case "ZEXPOSURE": exposure = (value as? Float) ?? Float(value as? Double ?? 0.0)
        case "ZCONTRAST": contrast = (value as? Float) ?? Float(value as? Double ?? 0.0)
        case "ZBRIGHTNESS": brightness = (value as? Float) ?? Float(value as? Double ?? 0.0)
        case "ZSATURATION": saturation = (value as? Float) ?? Float(value as? Double ?? 0.0)
        case "ZKELVIN": kelvin = (value as? Float) ?? Float(value as? Double ?? 5000.0)
        case "ZTINT": tint = (value as? Float) ?? Float(value as? Double ?? 0.0)
        default: break
        }
    }
    
    private func getDefaultValue(for key: String) -> Any {
        switch key {
        case "ZKELVIN": return 5000.0
        default: return 0.0
        }
    }
    
    /// Binds the controller to a specific variant.
    public func bind(to variant: VariantBase?) {
        self.currentVariant = variant
        refreshToolValues()
    }
    
    // MARK: - AI Masking Actions (AI-001)
    
    /// Triggers the AI Subject Masking for the currently active layer.
    public func runSubjectMasking() {
        guard let variant = currentVariant, 
              let activeLayer = variant.activeLayer,
              let image = variant.image else { return }
        
        print("[AI] Requesting Subject Mask for layer: \(activeLayer.name)")
        
        SubjectMaskingEngine.shared.selectSubject(for: image) { [weak self] mask in
            guard let self = self, let mask = mask else { return }
            
            // 1. Store the mask in the layer
            activeLayer.mask = mask
            
            // 2. Trigger UI Refresh
            DispatchQueue.main.async {
                self.objectWillChange.send()
                self.refreshToolValues() // Re-develop with new mask
                print("[AI] Subject Mask applied to layer: \(activeLayer.name)")
            }
        }
    }
    
    // MARK: - RAW Engine Bridge (IMG-003)
    
    /// Converts the current UI adjustment state into a low-level IC_ProcessSettings object.
    /// This is the "Bridge" between the UI and the RAW rendering engine.
    public func toProcessSettings() -> IC_ProcessSettings {
        var settings = IC_ProcessSettings()
        
        // Global Adjustments
        settings.exposure = self.exposure
        settings.contrast = self.contrast
        settings.brightness = self.brightness
        settings.saturation = self.saturation
        settings.kelvin = self.kelvin
        settings.tint = self.tint
        settings.highlight = self.highlights
        settings.shadow = self.shadows
        settings.white = self.whites
        settings.black = self.blacks
        
        // Color Balance (IMG-004)
        settings.colorBalance = ColorBalanceStorage.settings(from: currentVariant?.mcVariant)
        
        // Geometry
        settings.keystone.vertical = Float(self.keystoneVertical)
        settings.keystone.horizontal = Float(self.keystoneHorizontal)
        settings.flipHorizontal = self.flipHorizontal
        settings.flipVertical = self.flipVertical
        
        // Color management
        settings.outputProfileID = self.iccProfile
        settings.toneCurveID = self.toneCurve
        
        // Black & White (UI-202)
        settings.blackAndWhite.enabled = self.blackAndWhiteEnabled
        settings.blackAndWhite.red = Float(self.bwRed)
        settings.blackAndWhite.orange = Float(self.bwOrange)
        settings.blackAndWhite.yellow = Float(self.bwYellow)
        settings.blackAndWhite.green = Float(self.bwGreen)
        settings.blackAndWhite.blue = Float(self.bwBlue)
        settings.blackAndWhite.magenta = Float(self.bwMagenta)
        settings.blackAndWhite.splitToneHighlightHue = Float(self.bwSplitToneHighlightHue)
        settings.blackAndWhite.splitToneHighlightSaturation = Float(self.bwSplitToneHighlightSaturation)
        settings.blackAndWhite.splitToneShadowHue = Float(self.bwSplitToneShadowHue)
        settings.blackAndWhite.splitToneShadowSaturation = Float(self.bwSplitToneShadowSaturation)
        
        // Details
        settings.sharpeningAmount = 100.0 // Default
        settings.denoise.amount = 50.0 // Default
        
        // Layers (Local Adjustments)
        if let variant = currentVariant {
            for (index, layer) in variant.layers.enumerated() {
                if index < 16 {
                    var localCfg = IC_LocalAdjustCfg(layerId: UInt32(index))
                    localCfg.opacity = Float(layer.opacity / 100.0)
                    localCfg.isVisible = true // In original, checked via ZVISIBLE
                    localCfg.maskData = layer.mask // NEW: Pass the AI mask
                    
                    if let mcLayer = layer.mcLayer {
                        localCfg.settings.exposure = (mcLayer.objectForKey("ZEXPOSURE") as? Float) ?? 0.0
                        localCfg.settings.contrast = (mcLayer.objectForKey("ZCONTRAST") as? Float) ?? 0.0
                        localCfg.settings.brightness = (mcLayer.objectForKey("ZBRIGHTNESS") as? Float) ?? 0.0
                        localCfg.settings.saturation = (mcLayer.objectForKey("ZSATURATION") as? Float) ?? 0.0
                        localCfg.settings.clarity.amount = (mcLayer.objectForKey("ZCLARITY_AMOUNT") as? Float) ?? 0.0
                        localCfg.settings.clarity.structureAmount = (mcLayer.objectForKey("ZSTRUCTURE_AMOUNT") as? Float) ?? 0.0
                        localCfg.settings.clarity.clarityMethod = Int32((mcLayer.objectForKey("ZCLARITY_METHOD") as? Int) ?? 0)
                    }
                    
                    settings.localAdjustments[index] = localCfg
                }
            }
        }
        
        return settings
    }
    
    public func refreshToolValues() {
        guard let variant = currentVariant, let mc = variant.mcVariant else { return }
        
        self.isUpdatingFromModel = true
        
        // Update Histogram from current variant
        self.currentHistogram = HistogramKernels.generatePOHistogram(fromImage: variant)
        
        // 1. Determine active source (Layer or Global)
        let source: Any?
        if let activeLayer = variant.activeLayer, activeLayer.type != .background {
            source = activeLayer.mcLayer
        } else {
            source = mc
        }
        let colorBalanceSource = source as? ColorBalanceStorageContainer
        
        func getFloat(_ key: String, _ defaultVal: Float) -> Float {
            let val = (source as? MCVariant)?.objectForKey(key) ?? (source as? MCAdjLayer)?.objectForKey(key)
            if let f = val as? Float { return f }
            if let d = val as? Double { return Float(d) }
            return defaultVal
        }
        
        func getDouble(_ key: String, _ defaultVal: Double) -> Double {
            let val = (source as? MCVariant)?.objectForKey(key) ?? (source as? MCAdjLayer)?.objectForKey(key)
            if let d = val as? Double { return d }
            if let f = val as? Float { return Double(f) }
            return defaultVal
        }
        
        // 2. Map properties back to published floats
        updateIfChanged(&exposure, getFloat("ZEXPOSURE", 0.0))
        updateIfChanged(&contrast, getFloat("ZCONTRAST", 0.0))
        updateIfChanged(&brightness, getFloat("ZBRIGHTNESS", 0.0))
        updateIfChanged(&saturation, getFloat("ZSATURATION", 0.0))
        
        updateIfChanged(&clarityAmount, getFloat("ZCLARITY_AMOUNT", 0.0))
        updateIfChanged(&structureAmount, getFloat("ZSTRUCTURE_AMOUNT", 0.0))
        updateIfChanged(&clarityMethod, Int(getFloat("ZCLARITY_METHOD", 0.0)))
        
        let colorBalanceSettings = ColorBalanceStorage.settings(from: colorBalanceSource)
        updateIfChanged(&cbMaster, colorBalanceSettings.master)
        updateIfChanged(&cbShadow, colorBalanceSettings.shadow)
        updateIfChanged(&cbMidtone, colorBalanceSettings.midtone)
        updateIfChanged(&cbHighlight, colorBalanceSettings.highlight)
        
        // WB and other tools are usually global or per-layer depending on tool
        updateIfChanged(&kelvin, getFloat("ZKELVIN", 5000.0))
        updateIfChanged(&tint, getFloat("ZTINT", 0.0))
        
        updateIfChanged(&highlights, getFloat("ZHIGHLIGHTS", 0.0))
        updateIfChanged(&shadows, getFloat("ZSHADOWS", 0.0))
        updateIfChanged(&whites, getFloat("ZWHITES", 0.0))
        updateIfChanged(&blacks, getFloat("ZBLACKS", 0.0))
        
        updateIfChanged(&blackAndWhiteEnabled, (mc.objectForKey("ZBW_ENABLED") as? Bool) ?? false)
        updateIfChanged(&bwRed, getDouble("ZBW_RED", 0.0))
        updateIfChanged(&bwOrange, getDouble("ZBW_ORANGE", 0.0))
        updateIfChanged(&bwYellow, getDouble("ZBW_YELLOW", 0.0))
        updateIfChanged(&bwGreen, getDouble("ZBW_GREEN", 0.0))
        updateIfChanged(&bwBlue, getDouble("ZBW_BLUE", 0.0))
        updateIfChanged(&bwMagenta, getDouble("ZBW_MAGENTA", 0.0))
        updateIfChanged(&bwSplitToneHighlightHue, getDouble("ZBW_ST_HL_HUE", 0.0))
        updateIfChanged(&bwSplitToneHighlightSaturation, getDouble("ZBW_ST_HL_SAT", 0.0))
        updateIfChanged(&bwSplitToneShadowHue, getDouble("ZBW_ST_SH_HUE", 0.0))
        updateIfChanged(&bwSplitToneShadowSaturation, getDouble("ZBW_ST_SH_SAT", 0.0))
        
        updateIfChanged(&blemishAmount, getDouble("ZBLEMISH_AMOUNT", 0.0))
        updateIfChanged(&evenSkinAmount, getDouble("ZEVEN_SKIN_AMOUNT", 0.0))
        updateIfChanged(&evenSkinTexture, getDouble("ZEVEN_SKIN_TEXTURE", 0.0))
        updateIfChanged(&retouchFaceSmoothing, getDouble("ZRETOUCH_FACE_SMOOTHING", 0.0))
        updateIfChanged(&retouchFaceRedness, getDouble("ZRETOUCH_FACE_REDNESS", 0.0))
        updateIfChanged(&retouchFaceUniformity, getDouble("ZRETOUCH_FACE_UNIFORMITY", 0.0))
        updateIfChanged(&retouchTeethImpact, getDouble("ZRETOUCH_TEETH_IMPACT", 0.0))
        updateIfChanged(&retouchEyesLeftImpact, getDouble("ZRETOUCH_EYES_L_IMPACT", 0.0))
        updateIfChanged(&retouchEyesRightImpact, getDouble("ZRETOUCH_EYES_R_IMPACT", 0.0))
        
        updateIfChanged(&dehazeAmount, getDouble("ZDEHAZE_AMOUNT", 0.0))
        let loadedHue = getDouble("ZDEHAZE_SHADOW_HUE", 0.0)
        updateIfChanged(&dehazeShadowToneHue, loadedHue)
        if dehazeColor.hueComponent != loadedHue {
            dehazeColor = Color(hue: loadedHue, saturation: 0.5, brightness: 0.5)
        }
        updateIfChanged(&vignettingAmount, getDouble("ZVIGNETTING_AMOUNT", 0.0))
        updateIfChanged(&vignettingMethod, Int(getDouble("ZVIGNETTING_METHOD", 0.0)))
        
        updateIfChanged(&matchLookImpact, Float(getDouble("ZMATCH_LOOK_IMPACT", 100.0)))
        updateIfChanged(&matchLookReferenceVariantID, mc.objectForKey("ZMATCH_LOOK_REF_ID") as? String)
        
        updateIfChanged(&moireAmount, getDouble("ZMOIRE_AMOUNT", 0.0))
        updateIfChanged(&moirePattern, getDouble("ZMOIRE_PATTERN", 0.0))
        
        if let rect = mc.objectForKey("ZCROP_RECT") as? CGRect {
            updateIfChanged(&cropRect, rect)
        }
        updateIfChanged(&rotationAngle, getDouble("ZROTATION_ANGLE", 0.0))
        
        // Lens Correction
        updateIfChanged(&lensDistortion, getDouble("ZLENS_DISTORTION", 0.0))
        updateIfChanged(&lensSharpnessFalloff, getDouble("ZLENS_SHARPNESS_FALLOFF", 0.0))
        updateIfChanged(&lensLightFalloff, getDouble("ZLENS_LIGHT_FALLOFF", 0.0))
        updateIfChanged(&lensShiftX, getFloat("ZLENS_SHIFT_X", 0.0))
        updateIfChanged(&lensShiftY, getFloat("ZLENS_SHIFT_Y", 0.0))
        updateIfChanged(&clipDistortedEdges, (mc.objectForKey("ZCLIP_DISTORTED_EDGES") as? Bool) ?? false)
        updateIfChanged(&chromaticAberration, (mc.objectForKey("ZCHROMATIC_ABERRATION") as? Bool) ?? false)
        updateIfChanged(&diffraction, (mc.objectForKey("ZDIFFRACTION") as? Bool) ?? false)
        updateIfChanged(&isLCCActive, (mc.objectForKey("ZLCC_ACTIVE") as? Bool) ?? false)
        updateIfChanged(&lccProfileUUID, mc.objectForKey("ZLCC_PROFILE_UUID") as? String)
        updateIfChanged(&lccLightFalloffEnabled, (mc.objectForKey("ZLCC_LIGHTFALLOFF_ENABLED") as? Bool) ?? true)
        updateIfChanged(&lccLightFalloffAmount, (mc.objectForKey("ZLCC_LIGHTFALLOFF_AMOUNT") as? Double) ?? 100.0)
        updateIfChanged(&lccDustRemovalEnabled, (mc.objectForKey("ZLCC_DUSTREMOVAL_ENABLED") as? Bool) ?? true)
        updateIfChanged(&lccUniformityEnabled, (mc.objectForKey("ZLCC_UNIFORMITY_ENABLED") as? Bool) ?? true)
        
        // Keystone
        updateIfChanged(&keystoneTiltX, getDouble("ZKEYSTONE_TILTX", 0.0))
        updateIfChanged(&keystoneTiltY, getDouble("ZKEYSTONE_TILTY", 0.0))
        updateIfChanged(&keystoneAmount, getDouble("ZKEYSTONE_AMOUNT", 0.0))
        updateIfChanged(&keystoneAspect, getDouble("ZKEYSTONE_ASPECT", 0.0))
        updateIfChanged(&keystoneSkew, getDouble("ZKEYSTONE_SKEW", 0.0))
        updateIfChanged(&keystoneFocalLength, getDouble("ZKEYSTONE_FOCALLENGTH", 35.0))
        
        // Noise Reduction
        updateIfChanged(&nrLuminance, getDouble("ZNR_LUMINANCE", 50.0))
        updateIfChanged(&nrDetails, getDouble("ZNR_DETAILS", 50.0))
        updateIfChanged(&nrColor, getDouble("ZNR_COLOR", 50.0))
        updateIfChanged(&nrSinglePixel, getDouble("ZNR_SINGLE_PIXEL", 0.0))
        
        // Sharpening
        updateIfChanged(&sharpAmount, getDouble("ZSHARP_AMOUNT", 100.0))
        updateIfChanged(&sharpRadius, getDouble("ZSHARP_RADIUS", 0.8))
        updateIfChanged(&sharpThreshold, getDouble("ZSHARP_THRESHOLD", 1.0))
        updateIfChanged(&sharpHalo, getDouble("ZSHARP_HALO", 0.0))
        
        // Levels (RGB)
        updateIfChanged(&levelsBlackPointRGB, getFloat("ZLEVELS_BLACK_RGB", 0.0))
        updateIfChanged(&levelsWhitePointRGB, getFloat("ZLEVELS_WHITE_RGB", 1.0))
        updateIfChanged(&levelsMidtoneRGB, getFloat("ZLEVELS_MIDTONE_RGB", 1.0))
        updateIfChanged(&levelsTargetBlackRGB, getFloat("ZLEVELS_TBLACK_RGB", 0.0))
        updateIfChanged(&levelsTargetWhiteRGB, getFloat("ZLEVELS_TWHITE_RGB", 1.0))
        
        // Levels (Red)
        updateIfChanged(&levelsBlackPointR, getFloat("ZLEVELS_BLACK_R", 0.0))
        updateIfChanged(&levelsWhitePointR, getFloat("ZLEVELS_WHITE_R", 1.0))
        updateIfChanged(&levelsMidtoneR, getFloat("ZLEVELS_MIDTONE_R", 1.0))
        updateIfChanged(&levelsTargetBlackR, getFloat("ZLEVELS_TBLACK_R", 0.0))
        updateIfChanged(&levelsTargetWhiteR, getFloat("ZLEVELS_TWHITE_R", 1.0))
        
        // Levels (Green)
        updateIfChanged(&levelsBlackPointG, getFloat("ZLEVELS_BLACK_G", 0.0))
        updateIfChanged(&levelsWhitePointG, getFloat("ZLEVELS_WHITE_G", 1.0))
        updateIfChanged(&levelsMidtoneG, getFloat("ZLEVELS_MIDTONE_G", 1.0))
        updateIfChanged(&levelsTargetBlackG, getFloat("ZLEVELS_TBLACK_G", 0.0))
        updateIfChanged(&levelsTargetWhiteG, getFloat("ZLEVELS_TWHITE_G", 1.0))
        
        // Levels (Blue)
        updateIfChanged(&levelsBlackPointB, getFloat("ZLEVELS_BLACK_B", 0.0))
        updateIfChanged(&levelsWhitePointB, getFloat("ZLEVELS_WHITE_B", 1.0))
        updateIfChanged(&levelsMidtoneB, getFloat("ZLEVELS_MIDTONE_B", 1.0))
        updateIfChanged(&levelsTargetBlackB, getFloat("ZLEVELS_TBLACK_B", 0.0))
        updateIfChanged(&levelsTargetWhiteB, getFloat("ZLEVELS_TWHITE_B", 1.0))
        
        updateIfChanged(&curvesPointsRGB, (mc.objectForKey("ZCURVE_POINTS_RGB") as? [CGPoint]) ?? [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0)])
        updateIfChanged(&curvesPointsLuma, (mc.objectForKey("ZCURVE_POINTS_LUMA") as? [CGPoint]) ?? [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0)])
        updateIfChanged(&curvesPointsRed, (mc.objectForKey("ZCURVE_POINTS_RED") as? [CGPoint]) ?? [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0)])
        updateIfChanged(&curvesPointsGreen, (mc.objectForKey("ZCURVE_POINTS_GREEN") as? [CGPoint]) ?? [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0)])
        updateIfChanged(&curvesPointsBlue, (mc.objectForKey("ZCURVE_POINTS_BLUE") as? [CGPoint]) ?? [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0)])
        updateIfChanged(&curvesSelectedChannel, (mc.objectForKey("ZCURVE_SELECTED_CHANNEL") as? Int) ?? 0)
        
        if let data = mc.objectForKey("ZSPOTS") as? Data,
           let decoded = try? JSONDecoder().decode([SpotItem].self, from: data) {
            self.spots = decoded
        } else {
            self.spots = []
        }
        
        self.zoomLevel = getDouble("ZZOOM_LEVEL", 1.0)
        if let vRect = mc.objectForKey("ZVIEWPORT_RECT") as? CGRect {
            self.viewportRect = vRect
        }
        
        self.focusZoomLevel = getDouble("ZFOCUS_ZOOM", 1.0)
        if let fPoint = mc.objectForKey("ZFOCUS_POINT") as? CGPoint {
            self.focusPoint = fPoint
        }
        self.focusAIMode = (mc.objectForKey("ZFOCUS_AI_MODE") as? Int) ?? 0
        
        self.aiCropTopMargin = getDouble("ZAI_CROP_TOP", 10.0)
        self.aiCropBottomMargin = getDouble("ZAI_CROP_BOTTOM", 10.0)
        self.aiCropLeftMargin = getDouble("ZAI_CROP_LEFT", 10.0)
        self.aiCropRightMargin = getDouble("ZAI_CROP_RIGHT", 10.0)
        self.aiCropShowGuides = (mc.objectForKey("ZAI_CROP_SHOW_GUIDES") as? Bool) ?? true
        self.aiCropReferencePoint = (mc.objectForKey("ZAI_CROP_REF_POINT") as? Int) ?? 0
        self.aiCropLockAspect = (mc.objectForKey("ZAI_CROP_LOCK_ASPECT") as? Bool) ?? true
        
        self.stackCOStyles = (mc.objectForKey("ZSTACK_STYLES") as? Bool) ?? false
        self.styleOpacity = getDouble("ZSTYLE_OPACITY", 100.0)

        self.cropRatioIndex = (mc.objectForKey("ZCROP_RATIO") as? Int) ?? 0
        self.cropGridIndex = (mc.objectForKey("ZCROP_GRID") as? Int) ?? 0
        self.cropShowMask = (mc.objectForKey("ZCROP_SHOW_MASK") as? Bool) ?? true
        self.cropMaskOpacity = getDouble("ZCROP_MASK_OPACITY", 50.0)
        self.cropMaskBrightness = getDouble("ZCROP_MASK_BRIGHTNESS", 0.0)
        
        self.gridTypeIndex = (mc.objectForKey("ZGRID_TYPE") as? Int) ?? 0
        self.gridColorIndex = (mc.objectForKey("ZGRID_COLOR") as? Int) ?? 0
        
        if let data = mc.objectForKey("ZGUIDES") as? Data,
           let decoded = try? JSONDecoder().decode([GuideItem].self, from: data) {
            self.guides = decoded
        } else {
            self.guides = []
        }

        if let data = mc.objectForKey("ZCOLOR_CORRECTIONS") as? Data,
           let decoded = try? JSONDecoder().decode([IC_ColorCorrection].self, from: data) {
            self.colorCorrections = decoded
        } else {
            self.colorCorrections = []
        }
        
        self.basicColorHue = (mc.objectForKey("ZBASIC_COLOR_HUE") as? [Double]) ?? Array(repeating: 0.0, count: 8)
        self.basicColorSat = (mc.objectForKey("ZBASIC_COLOR_SAT") as? [Double]) ?? Array(repeating: 0.0, count: 8)
        self.basicColorLum = (mc.objectForKey("ZBASIC_COLOR_LUM") as? [Double]) ?? Array(repeating: 0.0, count: 8)
        
        updateIfChanged(&skinHueUniformity, getFloat("ZSKIN_HUE_UNI", 0.0))
        updateIfChanged(&skinSatUniformity, getFloat("ZSKIN_SAT_UNI", 0.0))
        updateIfChanged(&skinLumaUniformity, getFloat("ZSKIN_LUMA_UNI", 0.0))
        updateIfChanged(&skinHueAmount, getFloat("ZSKIN_HUE_AMT", 0.0))
        updateIfChanged(&skinSatAmount, getFloat("ZSKIN_SAT_AMT", 0.0))
        updateIfChanged(&skinLumaAmount, getFloat("ZSKIN_LUMA_AMT", 0.0))
        
        self.rating = (mc.objectForKey("ZRATING") as? Int) ?? 0
        self.colorTag = VariantBase.ColorTag(rawValue: (mc.objectForKey("ZCOLOR_TAG") as? Int) ?? 0) ?? .none
        
        // Masking Preferences (GAP-404)
        self.maskVisibilityMode = (mc.objectForKey("ZMASK_VISIBILITY_MODE") as? Int) ?? 2
        self.maskColorIndex = (mc.objectForKey("ZMASK_COLOR_INDEX") as? Int) ?? 0
        self.maskRefineEdge = getDouble("ZMASK_REFINE_EDGE", 0.0)
        self.maskFeather = getDouble("ZMASK_FEATHER", 0.0)
        
        self.isUpdatingFromModel = false
    }
    
    /// Triggers a re-render via ImageCorePipeline when adjustments change.
    public func commitChanges(to variant: VariantBase?) {
        guard let variant = variant, let mc = variant.mcVariant, !isUpdatingFromModel else { return }
        
        self.isUpdatingFromModel = true
        defer { self.isUpdatingFromModel = false }
        
        let colorBalanceSettings = ColorBalanceStorage.normalizedSettings(
            ColorBalanceSettings(
                master: cbMaster,
                shadow: cbShadow,
                midtone: cbMidtone,
                highlight: cbHighlight
            )
        )
        updateIfChanged(&cbMaster, colorBalanceSettings.master)
        
        // 1. Update active layer/global properties
        if let activeLayer = variant.activeLayer, activeLayer.type != .background {
            if activeLayer.mcLayer == nil { activeLayer.mcLayer = MCAdjLayer(dictionary: [:]) }
            activeLayer.mcLayer?.setObject(exposure, forKey: "ZEXPOSURE")
            activeLayer.mcLayer?.setObject(contrast, forKey: "ZCONTRAST")
            activeLayer.mcLayer?.setObject(brightness, forKey: "ZBRIGHTNESS")
            activeLayer.mcLayer?.setObject(saturation, forKey: "ZSATURATION")
            activeLayer.mcLayer?.setObject(clarityAmount, forKey: "ZCLARITY_AMOUNT")
            activeLayer.mcLayer?.setObject(structureAmount, forKey: "ZSTRUCTURE_AMOUNT")
            activeLayer.mcLayer?.setObject(clarityMethod, forKey: "ZCLARITY_METHOD")
            
            // Per-layer Lens Correction (if supported by Engine)
            activeLayer.mcLayer?.setObject(lensDistortion, forKey: "ZLENS_DISTORTION")
            activeLayer.mcLayer?.setObject(lensSharpnessFalloff, forKey: "ZLENS_SHARPNESS_FALLOFF")
            activeLayer.mcLayer?.setObject(lensLightFalloff, forKey: "ZLENS_LIGHT_FALLOFF")
            
            // Per-layer NR/Sharpening
            activeLayer.mcLayer?.setObject(nrLuminance, forKey: "ZNR_LUMINANCE")
            activeLayer.mcLayer?.setObject(nrDetails, forKey: "ZNR_DETAILS")
            activeLayer.mcLayer?.setObject(nrColor, forKey: "ZNR_COLOR")
            activeLayer.mcLayer?.setObject(sharpAmount, forKey: "ZSHARP_AMOUNT")
            activeLayer.mcLayer?.setObject(sharpRadius, forKey: "ZSHARP_RADIUS")
            activeLayer.mcLayer?.setObject(sharpThreshold, forKey: "ZSHARP_THRESHOLD")
            activeLayer.mcLayer?.setObject(sharpHalo, forKey: "ZSHARP_HALO")
            
            activeLayer.mcLayer?.setObject(blemishAmount, forKey: "ZBLEMISH_AMOUNT")
            activeLayer.mcLayer?.setObject(evenSkinAmount, forKey: "ZEVEN_SKIN_AMOUNT")
            activeLayer.mcLayer?.setObject(evenSkinTexture, forKey: "ZEVEN_SKIN_TEXTURE")
            activeLayer.mcLayer?.setObject(retouchFaceSmoothing, forKey: "ZRETOUCH_FACE_SMOOTHING")
            activeLayer.mcLayer?.setObject(retouchFaceRedness, forKey: "ZRETOUCH_FACE_REDNESS")
            activeLayer.mcLayer?.setObject(retouchFaceUniformity, forKey: "ZRETOUCH_FACE_UNIFORMITY")
            activeLayer.mcLayer?.setObject(retouchTeethImpact, forKey: "ZRETOUCH_TEETH_IMPACT")
            activeLayer.mcLayer?.setObject(retouchEyesLeftImpact, forKey: "ZRETOUCH_EYES_L_IMPACT")
            activeLayer.mcLayer?.setObject(retouchEyesRightImpact, forKey: "ZRETOUCH_EYES_R_IMPACT")
            
            ColorBalanceStorage.apply(colorBalanceSettings, to: activeLayer.mcLayer)
        } else {
            mc.setObject(exposure, forKey: "ZEXPOSURE")
            mc.setObject(contrast, forKey: "ZCONTRAST")
            mc.setObject(brightness, forKey: "ZBRIGHTNESS")
            mc.setObject(saturation, forKey: "ZSATURATION")
            mc.setObject(clarityAmount, forKey: "ZCLARITY_AMOUNT")
            mc.setObject(structureAmount, forKey: "ZSTRUCTURE_AMOUNT")
            mc.setObject(clarityMethod, forKey: "ZCLARITY_METHOD")
            
            mc.setObject(lensDistortion, forKey: "ZLENS_DISTORTION")
            mc.setObject(lensSharpnessFalloff, forKey: "ZLENS_SHARPNESS_FALLOFF")
            mc.setObject(lensLightFalloff, forKey: "ZLENS_LIGHT_FALLOFF")
            
            mc.setObject(nrLuminance, forKey: "ZNR_LUMINANCE")
            mc.setObject(nrDetails, forKey: "ZNR_DETAILS")
            mc.setObject(nrColor, forKey: "ZNR_COLOR")
            mc.setObject(nrSinglePixel, forKey: "ZNR_SINGLE_PIXEL")
            
            mc.setObject(sharpAmount, forKey: "ZSHARP_AMOUNT")
            mc.setObject(sharpRadius, forKey: "ZSHARP_RADIUS")
            mc.setObject(sharpThreshold, forKey: "ZSHARP_THRESHOLD")
            mc.setObject(sharpHalo, forKey: "ZSHARP_HALO")
            
            mc.setObject(blemishAmount, forKey: "ZBLEMISH_AMOUNT")
            mc.setObject(evenSkinAmount, forKey: "ZEVEN_SKIN_AMOUNT")
            mc.setObject(evenSkinTexture, forKey: "ZEVEN_SKIN_TEXTURE")
            mc.setObject(retouchFaceSmoothing, forKey: "ZRETOUCH_FACE_SMOOTHING")
            mc.setObject(retouchFaceRedness, forKey: "ZRETOUCH_FACE_REDNESS")
            mc.setObject(retouchFaceUniformity, forKey: "ZRETOUCH_FACE_UNIFORMITY")
            mc.setObject(retouchTeethImpact, forKey: "ZRETOUCH_TEETH_IMPACT")
            mc.setObject(retouchEyesLeftImpact, forKey: "ZRETOUCH_EYES_L_IMPACT")
            mc.setObject(retouchEyesRightImpact, forKey: "ZRETOUCH_EYES_R_IMPACT")
            
            ColorBalanceStorage.apply(colorBalanceSettings, to: mc)
        }
        
        // 2. Global updates
        mc.setObject(kelvin, forKey: "ZKELVIN")
        mc.setObject(tint, forKey: "ZTINT")
        mc.setObject(highlights, forKey: "ZHIGHLIGHTS")
        mc.setObject(shadows, forKey: "ZSHADOWS")
        mc.setObject(whites, forKey: "ZWHITES")
        mc.setObject(blacks, forKey: "ZBLACKS")
        
        mc.setObject(blackAndWhiteEnabled, forKey: "ZBW_ENABLED")
        mc.setObject(bwRed, forKey: "ZBW_RED")
        mc.setObject(bwOrange, forKey: "ZBW_ORANGE")
        mc.setObject(bwYellow, forKey: "ZBW_YELLOW")
        mc.setObject(bwGreen, forKey: "ZBW_GREEN")
        mc.setObject(bwBlue, forKey: "ZBW_BLUE")
        mc.setObject(bwMagenta, forKey: "ZBW_MAGENTA")
        mc.setObject(bwSplitToneHighlightHue, forKey: "ZBW_ST_HL_HUE")
        mc.setObject(bwSplitToneHighlightSaturation, forKey: "ZBW_ST_HL_SAT")
        mc.setObject(bwSplitToneShadowHue, forKey: "ZBW_ST_SH_HUE")
        mc.setObject(bwSplitToneShadowSaturation, forKey: "ZBW_ST_SH_SAT")
        
        mc.setObject(dehazeAmount, forKey: "ZDEHAZE_AMOUNT")
        mc.setObject(dehazeShadowToneHue, forKey: "ZDEHAZE_SHADOW_HUE")
        mc.setObject(vignettingAmount, forKey: "ZVIGNETTING_AMOUNT")
        mc.setObject(vignettingMethod, forKey: "ZVIGNETTING_METHOD")
        
        mc.setObject(Double(matchLookImpact), forKey: "ZMATCH_LOOK_IMPACT")
        if let refID = matchLookReferenceVariantID {
            mc.setObject(refID, forKey: "ZMATCH_LOOK_REF_ID")
        }
        
        mc.setObject(moireAmount, forKey: "ZMOIRE_AMOUNT")
        mc.setObject(moirePattern, forKey: "ZMOIRE_PATTERN")
        
        mc.setObject(cropRect, forKey: "ZCROP_RECT")
        mc.setObject(rotationAngle, forKey: "ZROTATION_ANGLE")
        
        mc.setObject(lensShiftX, forKey: "ZLENS_SHIFT_X")
        mc.setObject(lensShiftY, forKey: "ZLENS_SHIFT_Y")
        mc.setObject(clipDistortedEdges, forKey: "ZCLIP_DISTORTED_EDGES")
        mc.setObject(chromaticAberration, forKey: "ZCHROMATIC_ABERRATION")
        mc.setObject(diffraction, forKey: "ZDIFFRACTION")
        mc.setObject(isLCCActive, forKey: "ZLCC_ACTIVE")
        mc.setObject(lccProfileUUID, forKey: "ZLCC_PROFILE_UUID")
        mc.setObject(lccLightFalloffEnabled, forKey: "ZLCC_LIGHTFALLOFF_ENABLED")
        mc.setObject(lccLightFalloffAmount, forKey: "ZLCC_LIGHTFALLOFF_AMOUNT")
        mc.setObject(lccDustRemovalEnabled, forKey: "ZLCC_DUSTREMOVAL_ENABLED")
        mc.setObject(lccUniformityEnabled, forKey: "ZLCC_UNIFORMITY_ENABLED")
        
        mc.setObject(keystoneTiltX, forKey: "ZKEYSTONE_TILTX")
        mc.setObject(keystoneTiltY, forKey: "ZKEYSTONE_TILTY")
        mc.setObject(keystoneAmount, forKey: "ZKEYSTONE_AMOUNT")
        mc.setObject(keystoneAspect, forKey: "ZKEYSTONE_ASPECT")
        mc.setObject(keystoneSkew, forKey: "ZKEYSTONE_SKEW")
        mc.setObject(keystoneFocalLength, forKey: "ZKEYSTONE_FOCALLENGTH")
        
        // Levels RGB
        mc.setObject(levelsBlackPointRGB, forKey: "ZLEVELS_BLACK_RGB")
        mc.setObject(levelsWhitePointRGB, forKey: "ZLEVELS_WHITE_RGB")
        mc.setObject(levelsMidtoneRGB, forKey: "ZLEVELS_MIDTONE_RGB")
        mc.setObject(levelsTargetBlackRGB, forKey: "ZLEVELS_TBLACK_RGB")
        mc.setObject(levelsTargetWhiteRGB, forKey: "ZLEVELS_TWHITE_RGB")
        
        // Levels Red
        mc.setObject(levelsBlackPointR, forKey: "ZLEVELS_BLACK_R")
        mc.setObject(levelsWhitePointR, forKey: "ZLEVELS_WHITE_R")
        mc.setObject(levelsMidtoneR, forKey: "ZLEVELS_MIDTONE_R")
        mc.setObject(levelsTargetBlackR, forKey: "ZLEVELS_TBLACK_R")
        mc.setObject(levelsTargetWhiteR, forKey: "ZLEVELS_TWHITE_R")
        
        // Levels Green
        mc.setObject(levelsBlackPointG, forKey: "ZLEVELS_BLACK_G")
        mc.setObject(levelsWhitePointG, forKey: "ZLEVELS_WHITE_G")
        mc.setObject(levelsMidtoneG, forKey: "ZLEVELS_MIDTONE_G")
        mc.setObject(levelsTargetBlackG, forKey: "ZLEVELS_TBLACK_G")
        mc.setObject(levelsTargetWhiteG, forKey: "ZLEVELS_TWHITE_G")
        
        // Levels Blue
        mc.setObject(levelsBlackPointB, forKey: "ZLEVELS_BLACK_B")
        mc.setObject(levelsWhitePointB, forKey: "ZLEVELS_WHITE_B")
        mc.setObject(levelsMidtoneB, forKey: "ZLEVELS_MIDTONE_B")
        mc.setObject(levelsTargetBlackB, forKey: "ZLEVELS_TBLACK_B")
        mc.setObject(levelsTargetWhiteB, forKey: "ZLEVELS_TWHITE_B")
        
        mc.setObject(curvesPointsRGB, forKey: "ZCURVE_POINTS_RGB")
        mc.setObject(curvesPointsLuma, forKey: "ZCURVE_POINTS_LUMA")
        mc.setObject(curvesPointsRed, forKey: "ZCURVE_POINTS_RED")
        mc.setObject(curvesPointsGreen, forKey: "ZCURVE_POINTS_GREEN")
        mc.setObject(curvesPointsBlue, forKey: "ZCURVE_POINTS_BLUE")
        mc.setObject(curvesSelectedChannel, forKey: "ZCURVE_SELECTED_CHANNEL")
        
        mc.setObject(zoomLevel, forKey: "ZZOOM_LEVEL")
        mc.setObject(viewportRect, forKey: "ZVIEWPORT_RECT")
        mc.setObject(focusZoomLevel, forKey: "ZFOCUS_ZOOM")
        mc.setObject(focusPoint, forKey: "ZFOCUS_POINT")
        mc.setObject(focusAIMode, forKey: "ZFOCUS_AI_MODE")
        
        mc.setObject(aiCropTopMargin, forKey: "ZAI_CROP_TOP")
        mc.setObject(aiCropBottomMargin, forKey: "ZAI_CROP_BOTTOM")
        mc.setObject(aiCropLeftMargin, forKey: "ZAI_CROP_LEFT")
        mc.setObject(aiCropRightMargin, forKey: "ZAI_CROP_RIGHT")
        mc.setObject(aiCropShowGuides, forKey: "ZAI_CROP_SHOW_GUIDES")
        mc.setObject(aiCropReferencePoint, forKey: "ZAI_CROP_REF_POINT")
        mc.setObject(aiCropLockAspect, forKey: "ZAI_CROP_LOCK_ASPECT")

        mc.setObject(stackCOStyles, forKey: "ZSTACK_STYLES")
        mc.setObject(styleOpacity, forKey: "ZSTYLE_OPACITY")

        if let encodedSpots = try? JSONEncoder().encode(spots) {
            mc.setObject(encodedSpots, forKey: "ZSPOTS")
        }
        
        mc.setObject(cropRatioIndex, forKey: "ZCROP_RATIO")
        mc.setObject(cropGridIndex, forKey: "ZCROP_GRID")
        mc.setObject(cropShowMask, forKey: "ZCROP_SHOW_MASK")
        mc.setObject(cropMaskOpacity, forKey: "ZCROP_MASK_OPACITY")
        mc.setObject(cropMaskBrightness, forKey: "ZCROP_MASK_BRIGHTNESS")
        mc.setObject(gridTypeIndex, forKey: "ZGRID_TYPE")
        mc.setObject(gridColorIndex, forKey: "ZGRID_COLOR")
        if let encodedGuides = try? JSONEncoder().encode(guides) {
            mc.setObject(encodedGuides, forKey: "ZGUIDES")
        }
        
        mc.setObject(maskVisibilityMode, forKey: "ZMASK_VISIBILITY_MODE")
        mc.setObject(maskColorIndex, forKey: "ZMASK_COLOR_INDEX")
        mc.setObject(maskRefineEdge, forKey: "ZMASK_REFINE_EDGE")
        mc.setObject(maskFeather, forKey: "ZMASK_FEATHER")
        
        if let encoded = try? JSONEncoder().encode(colorCorrections) {
            mc.setObject(encoded, forKey: "ZCOLOR_CORRECTIONS")
        }
        
        mc.setObject(basicColorHue, forKey: "ZBASIC_COLOR_HUE")
        mc.setObject(basicColorSat, forKey: "ZBASIC_COLOR_SAT")
        mc.setObject(basicColorLum, forKey: "ZBASIC_COLOR_LUM")
        
        mc.setObject(skinHueUniformity, forKey: "ZSKIN_HUE_UNI")
        mc.setObject(skinSatUniformity, forKey: "ZSKIN_SAT_UNI")
        mc.setObject(skinLumaUniformity, forKey: "ZSKIN_LUMA_UNI")
        mc.setObject(skinHueAmount, forKey: "ZSKIN_HUE_AMT")
        mc.setObject(skinSatAmount, forKey: "ZSKIN_SAT_AMT")
        mc.setObject(skinLumaAmount, forKey: "ZSKIN_LUMA_AMT")
        
        mc.setObject(rating, forKey: "ZRATING")
        mc.setObject(colorTag.rawValue, forKey: "ZCOLOR_TAG")
        
        // 3. Map to ImageCore settings
        var settings = IC_ProcessSettings()
        settings.exposure = self.exposure
        settings.contrast = self.contrast
        settings.brightness = self.brightness
        settings.saturation = self.saturation
        settings.highlight = self.highlights
        settings.shadow = self.shadows
        settings.white = self.whites
        settings.black = self.blacks
        settings.whiteBalanceTemperature = Double(kelvin)
        settings.whiteBalanceTint = Double(tint)
        settings.colorBalance = ColorBalanceStorage.settings(from: mc)
        
        settings.lensCorrection.distortion = Float(lensDistortion)
        settings.lensCorrection.lightFalloff = Float(lensLightFalloff)
        settings.lensCorrection.sharpnessFalloff = Float(lensSharpnessFalloff)
        settings.lensCorrection.chromaticAberration = chromaticAberration
        settings.lensCorrection.diffraction = diffraction
        settings.lensCorrection.lccProfileUUID = lccProfileUUID
        settings.lensCorrection.lccLightFalloffEnabled = lccLightFalloffEnabled
        settings.lensCorrection.lccLightFalloffAmount = Float(lccLightFalloffAmount)
        settings.lensCorrection.lccDustRemovalEnabled = lccDustRemovalEnabled
        settings.lensCorrection.lccUniformityEnabled = lccUniformityEnabled
        
        settings.noiseReduction.luminance = Float(nrLuminance)
        settings.noiseReduction.details = Float(nrDetails)
        settings.noiseReduction.color = Float(nrColor)
        settings.noiseReduction.singlePixel = Float(nrSinglePixel)
        
        settings.sharpening.amount = Float(sharpAmount)
        settings.sharpening.radius = Float(sharpRadius)
        settings.sharpening.threshold = Float(sharpThreshold)
        settings.sharpening.haloControl = Float(sharpHalo)
        
        settings.geometry.cropRect = self.cropRect
        settings.geometry.rotation = self.rotationAngle
        settings.geometry.keystoneTiltX = Float(keystoneTiltX)
        settings.geometry.keystoneTiltY = Float(keystoneTiltY)
        settings.geometry.keystoneAmount = Float(keystoneAmount)
        settings.geometry.keystoneAspect = Float(keystoneAspect)
        settings.geometry.keystoneSkew = Float(keystoneSkew)
        settings.geometry.keystoneFocalLength = Float(keystoneFocalLength)
        
        // Map all 4 levels channels
        settings.levels.levelsRGB = mapLevels(black: levelsBlackPointRGB, white: levelsWhitePointRGB, midtone: levelsMidtoneRGB, tBlack: levelsTargetBlackRGB, tWhite: levelsTargetWhiteRGB)
        settings.levels.levelsR = mapLevels(black: levelsBlackPointR, white: levelsWhitePointR, midtone: levelsMidtoneR, tBlack: levelsTargetBlackR, tWhite: levelsTargetWhiteR)
        settings.levels.levelsG = mapLevels(black: levelsBlackPointG, white: levelsWhitePointG, midtone: levelsMidtoneG, tBlack: levelsTargetBlackG, tWhite: levelsTargetWhiteG)
        settings.levels.levelsB = mapLevels(black: levelsBlackPointB, white: levelsWhitePointB, midtone: levelsMidtoneB, tBlack: levelsTargetBlackB, tWhite: levelsTargetWhiteB)
        
        // Map all 5 curves
        settings.gradationCurves.curveX = mapCurve(curvesPointsRGB)
        settings.gradationCurves.curveL = mapCurve(curvesPointsLuma)
        settings.gradationCurves.curveR = mapCurve(curvesPointsRed)
        settings.gradationCurves.curveG = mapCurve(curvesPointsGreen)
        settings.gradationCurves.curveB = mapCurve(curvesPointsBlue)
        
        settings.clarity.amount = clarityAmount
        settings.clarity.structureAmount = structureAmount
        settings.clarity.clarityMethod = Int32(clarityMethod)
        
        settings.colorCorrectionList.count = UInt32(colorCorrections.count)
        for (index, cc) in colorCorrections.enumerated() {
            if index < 35 {
                settings.colorCorrectionList.corrections[index] = cc
            }
        }
        
        // Soft Proofing
        settings.isSoftProofingEnabled = isSoftProofingEnabled
        settings.proofingProfileID = proofingProfileID
        settings.showGamutWarning = showGamutWarning
        
        // 4. Map Local Adjustments (Layers)
        for (index, layer) in variant.layers.enumerated() where layer.type != .background {
            var localCfg = IC_LocalAdjustCfg(layerId: UInt32(index))
            localCfg.opacity = Float(layer.opacity / 100.0)
            localCfg.isVisible = true
            
            localCfg.settings.exposure = (layer.mcLayer?.objectForKey("ZEXPOSURE") as? Float) ?? 0.0
            localCfg.settings.contrast = (layer.mcLayer?.objectForKey("ZCONTRAST") as? Float) ?? 0.0
            localCfg.settings.brightness = (layer.mcLayer?.objectForKey("ZBRIGHTNESS") as? Float) ?? 0.0
            localCfg.settings.saturation = (layer.mcLayer?.objectForKey("ZSATURATION") as? Float) ?? 0.0
            localCfg.settings.clarity.amount = (layer.mcLayer?.objectForKey("ZCLARITY_AMOUNT") as? Float) ?? 0.0
            localCfg.settings.clarity.structureAmount = (layer.mcLayer?.objectForKey("ZSTRUCTURE_AMOUNT") as? Float) ?? 0.0
            localCfg.settings.clarity.clarityMethod = Int32((layer.mcLayer?.objectForKey("ZCLARITY_METHOD") as? Int) ?? 0)
            
            if index < 16 {
                settings.localAdjustments[index] = localCfg
            }
        }
        
        // 5. Trigger pipeline execution (Simulation)
        if let image = variant.image {
            _ = ImageCorePipeline(mode: .cpu_simd)
            // Note: In a real app, we'd render to a persistent preview buffer
            // For now, we simulate the trigger.
            print("[Adjustment] Triggering render for \(variant.variantUUID) at path \(image.path) with exposure: \(settings.exposure)")
        }

        print("[Adjustment] Committing changes for \(variant.variantUUID)")
        
        variant.isModified = true
    }
    
    // MARK: - Smart Adjustments (AI-002)
    
    public func setSmartReference() {
        guard let variant = currentVariant else { return }
        print("[Smart] Setting reference for \(variant.variantUUID)")
        self.smartReference = SmartAdjustmentsHelper.analyzeVariant(variant)
        self.smartReferenceVariantID = variant.variantUUID
    }
    
    // MARK: - AI Crop (Consistency)
    
    public func setAICropReference() {
        AICropSettingsController.shared.setReference(from: currentVariant)
    }
    
    public func applyAICrop() {
        // Apply to current variant (or selection in real app)
        if let variant = currentVariant {
            AICropSettingsController.shared.applyToVariants([variant])
        }
    }
    
    public func applySmartAdjustments(to variants: [VariantBase]) {
        guard let reference = smartReference else { return }
        
        for variant in variants {
            let targetRef = SmartAdjustmentsHelper.analyzeVariant(variant)
            let deltas = SmartAdjustmentsEngine.calculateDeltas(reference: reference, target: targetRef)
            
            if let mc = variant.mcVariant {
                if smartExposureEnabled {
                    let currentExp = (mc.objectForKey("ZEXPOSURE") as? Double) ?? 0.0
                    mc.setObject(currentExp + deltas.exposureDelta, forKey: "ZEXPOSURE")
                }
                
                if smartWhiteBalanceEnabled {
                    let currentKelvin = (mc.objectForKey("ZKELVIN") as? Double) ?? 5000.0
                    let currentTint = (mc.objectForKey("ZTINT") as? Double) ?? 0.0
                    mc.setObject(currentKelvin + deltas.kelvinDelta, forKey: "ZKELVIN")
                    mc.setObject(currentTint + deltas.tintDelta, forKey: "ZTINT")
                }
                
                variant.isModified = true
            }
        }
        
        refreshToolValues()
    }
    
    // MARK: - AI Masking (GAP-401)
    
    public func computeLumaRange(start: Double, end: Double, falloffStart: Double, falloffEnd: Double) {
        guard let variant = currentVariant else { return }
        print("[AdjustmentToolController] Requesting Luma Range mask for \(variant.variantUUID)")
        // ImageCorePipeline will handle the actual pixel-level generation during the next render cycle
    }
    
    public func applyMagicBrush(at point: CGPoint, tolerance: Double) {
        guard let variant = currentVariant else { return }
        print("[AdjustmentToolController] Requesting Magic Brush at \(point) with tolerance \(tolerance) for \(variant.variantUUID)")
    }

    public func autoKeystone() {
        guard let variant = currentVariant, let image = variant.image else { return }
        print("[AdjustmentToolController] Running Auto-Keystone for \(variant.variantUUID)")
        
        let lines = KeystoneEngine.detectGuidelines(in: image)
        
        // Mocking settings update since we don't have a full IC_ProcessSettings object here easily,
        // but we can simulate the result of calculateTransform.
        withAnimation {
            if !lines.vertical.isEmpty {
                self.keystoneTiltX = 15.0
            }
            if !lines.horizontal.isEmpty {
                self.keystoneTiltY = -5.0
            }
            self.keystoneAmount = 100.0
        }
    }

    public func applyKeystone() {
        guard let variant = currentVariant else { return }
        print("[AdjustmentToolController] Applying manual keystone correction.")
        // Finalize warp based on current guidelines/points
        self.commitChanges(to: variant)
    }

    public func createLCCProfile() {
        guard let variant = currentVariant else { return }
        print("[AdjustmentToolController] Creating LCC Profile for \(variant.variantUUID)")
        
        // Simulate engine analysis
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.lccProfileUUID = UUID().uuidString
            self.isLCCActive = true
            self.commitChanges(to: variant)
            print("[AdjustmentToolController] LCC Profile Created and Applied.")
        }
    }

    // MARK: - Retouching (ENG-005)
    
    public func addRepairArrow(at destination: CGPoint, type: RepairArrow.ArrowType) {
        guard let variant = currentVariant, let image = variant.image else { return }
        guard let activeLayer = variant.activeLayer, (activeLayer.type == .heal || activeLayer.type == .clone) else {
            print("[AdjustmentToolController] Cannot add repair arrow to non-retouch layer")
            return
        }
        
        let source = RetouchEngine.shared.autoPickSource(for: destination, in: image)
        let arrow = RepairArrow(source: source, destination: destination, type: type)
        activeLayer.repairArrows.append(arrow)
        variant.isModified = true
        print("[AdjustmentToolController] Added \(type) repair arrow to \(activeLayer.name)")
    }
    
    public func resetRetouching() {
        guard let variant = currentVariant, let activeLayer = variant.activeLayer else { return }
        activeLayer.repairArrows.removeAll()
        variant.isModified = true
        print("[AdjustmentToolController] Reset retouching for \(activeLayer.name)")
    }

    public func resetCrop() {
        self.cropRect = .zero
        self.isCropOrientationSwapped = false
        // Also reset ratio index to Unconstrained if needed, or keep it. 
        // Capture One usually keeps the ratio but clears the box.
        self.commitChanges(to: currentVariant)
    }

    public func invertCrop() {
        let current = self.cropRect
        guard current != .zero else { return }
        
        self.isCropOrientationSwapped.toggle()
        
        // Swap width and height
        self.cropRect = CGRect(x: current.minX, y: current.minY, width: current.height, height: current.width)
        self.commitChanges(to: currentVariant)
    }

    public func centerOverlay() {
        self.overlayOffset = .zero
    }

    public func syncFocusPoint() {
        print("[AdjustmentToolController] Syncing focus point across selected images.")
        // In a real implementation, this would iterate through selected variants 
        // and copy the focusPoint property.
    }

    public func resetVignetting() {
        self.vignettingAmount = 0.0
        self.vignettingMethod = 0
        self.commitChanges(to: currentVariant)
    }

    public func resetDehaze() {
        self.dehazeAmount = 0.0
        self.dehazeColor = .gray
        self.commitChanges(to: currentVariant)
    }

    public func autoLevels() {
        print("[AdjustmentToolController] Auto Levels triggered.")
        // Simulation: adjust points to standard 0-255 range if needed
        self.commitChanges(to: currentVariant)
    }

    public func commitLinearGradient(_ gradient: LinearGradientMask) {
        guard let variant = currentVariant, let activeLayer = variant.activeLayer else { return }
        activeLayer.linearGradient = gradient
        variant.isModified = true
        self.commitChanges(to: variant)
    }

    public func commitRadialGradient(_ gradient: RadialGradientMask) {
        guard let variant = currentVariant, let activeLayer = variant.activeLayer else { return }
        activeLayer.radialGradient = gradient
        variant.isModified = true
        self.commitChanges(to: variant)
    }

    // MARK: - Hardware Controllers (INT-005)
    
    public func handleHardwareAction(actionID: String, delta: Double) {
        // Ensure we execute on the main thread since we are mutating @Published properties
        DispatchQueue.main.async {
            switch actionID {
            case "adjustExposure":
                self.exposure = max(-4.0, min(4.0, self.exposure + Float(delta)))
            case "adjustContrast":
                self.contrast = max(-50.0, min(50.0, self.contrast + Float(delta)))
            case "adjustKelvin":
                self.kelvin = max(800.0, min(14000.0, self.kelvin + Float(delta)))
            default:
                print("[AdjustmentToolController] Unhandled hardware action: \(actionID)")
            }
            // The @Published state change will automatically trigger `commitChanges()`
            // because of the Combine observers setup in `init()`.
        }
    }
}
