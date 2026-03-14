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
    
    // Focus State (UI-203)
    @Published public var focusZoomLevel: Float = 1.0
    @Published public var focusPoint: CGPoint = CGPoint(x: 0.5, y: 0.5)
    @Published public var focusAIMode: Int = 0 // 0: None, 1: Eye, 2: Face
    
    // AI Crop Studio State (UI-204)
    @Published public var aiCropTopMargin: Double = 10.0
    @Published public var aiCropBottomMargin: Double = 10.0
    @Published public var aiCropLeftMargin: Double = 10.0
    @Published public var aiCropRightMargin: Double = 10.0
    @Published public var aiCropShowGuides: Bool = true
    @Published public var aiCropReferencePoint: Int = 0 // 0: Center, 1: Top, 2: Eyes
    @Published public var aiCropLockAspect: Bool = true
    
    // COStyles State (UI-204)
    @Published public var stackCOStyles: Bool = false
    @Published public var styleOpacity: Double = 100.0 // 0 to 100
    
    // Smart Adjustments State (AI-204)
    @Published public var smartExposureEnabled: Bool = true
    @Published public var smartWhiteBalanceEnabled: Bool = true
    @Published public var smartReference: SmartAdjustmentsReference? = nil
    
    // Spot Removal State (UI-203)
    @Published public var spots: [SpotItem] = []
    @Published public var selectedSpotID: UUID?
    
    // Levels State
    @Published public var levelsBlackPoint: Float = 0.0
    @Published public var levelsWhitePoint: Float = 1.0
    @Published public var levelsMidtone: Float = 1.0
    @Published public var levelsTargetBlack: Float = 0.0
    @Published public var levelsTargetWhite: Float = 1.0
    
    // Curves State
    @Published public var curvesPoints: [CGPoint] = [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0)]
    
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
    
    // Skin Tone Uniformity
    @Published public var skinHueUniformity: Float = 0.0
    @Published public var skinSatUniformity: Float = 0.0
    @Published public var skinLumaUniformity: Float = 0.0
    
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
    @Published public var bwYellow: Double = 0.0
    @Published public var bwGreen: Double = 0.0
    @Published public var bwCyan: Double = 0.0
    @Published public var bwBlue: Double = 0.0
    @Published public var bwMagenta: Double = 0.0
    @Published public var bwSplitToneHighlightHue: Double = 0.0
    @Published public var bwSplitToneHighlightSaturation: Double = 0.0
    @Published public var bwSplitToneShadowHue: Double = 0.0
    @Published public var bwSplitToneShadowSaturation: Double = 0.0
    
    // Dehaze & Vignetting (UI-202)
    @Published public var dehazeAmount: Double = 0.0
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
    
    private func setupNegativeFilmSync() {
        $negativeFilmEnabled
            .dropFirst()
            .sink { [weak self] enabled in
                guard let self = self else { return }
                // Automatically switch Curves to Negative preset (diagonal 1,1 to 0,0)
                // if they are currently at default (0,0 to 1,1)
                if enabled {
                    if self.curvesPoints == [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0)] {
                        self.curvesPoints = [CGPoint(x: 0.0, y: 1.0), CGPoint(x: 1.0, y: 0.0)]
                    }
                } else {
                    if self.curvesPoints == [CGPoint(x: 0.0, y: 1.0), CGPoint(x: 1.0, y: 0.0)] {
                        self.curvesPoints = [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0)]
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
        // Observe all published properties and commit changes when they change
        let publishers: [AnyPublisher<Void, Never>] = [
            $exposure.map { _ in }.eraseToAnyPublisher(),
            $contrast.map { _ in }.eraseToAnyPublisher(),
            $brightness.map { _ in }.eraseToAnyPublisher(),
            $saturation.map { _ in }.eraseToAnyPublisher(),
            $cbMaster.map { _ in }.eraseToAnyPublisher(),
            $cbShadow.map { _ in }.eraseToAnyPublisher(),
            $cbMidtone.map { _ in }.eraseToAnyPublisher(),
            $cbHighlight.map { _ in }.eraseToAnyPublisher(),
            $kelvin.map { _ in }.eraseToAnyPublisher(),
            $tint.map { _ in }.eraseToAnyPublisher(),
            $highlights.map { _ in }.eraseToAnyPublisher(),
            $shadows.map { _ in }.eraseToAnyPublisher(),
            $whites.map { _ in }.eraseToAnyPublisher(),
            $blacks.map { _ in }.eraseToAnyPublisher(),
            $levelsBlackPoint.map { _ in }.eraseToAnyPublisher(),
            $levelsWhitePoint.map { _ in }.eraseToAnyPublisher(),
            $levelsMidtone.map { _ in }.eraseToAnyPublisher(),
            $levelsTargetBlack.map { _ in }.eraseToAnyPublisher(),
            $levelsTargetWhite.map { _ in }.eraseToAnyPublisher(),
            $curvesPoints.map { _ in }.eraseToAnyPublisher(),
            $rating.map { _ in }.eraseToAnyPublisher(),
            $colorTag.map { _ in }.eraseToAnyPublisher(),
            $activePredicate.map { _ in }.eraseToAnyPublisher(),
            $clarityAmount.map { _ in }.eraseToAnyPublisher(),
            $structureAmount.map { _ in }.eraseToAnyPublisher(),
            $clarityMethod.map { _ in }.eraseToAnyPublisher(),
            $colorCorrections.map { _ in }.eraseToAnyPublisher(),
            $lensDistortion.map { _ in }.eraseToAnyPublisher(),
            $lensSharpnessFalloff.map { _ in }.eraseToAnyPublisher(),
            $lensLightFalloff.map { _ in }.eraseToAnyPublisher(),
            $lensShiftX.map { _ in }.eraseToAnyPublisher(),
            $lensShiftY.map { _ in }.eraseToAnyPublisher(),
            $clipDistortedEdges.map { _ in }.eraseToAnyPublisher(),
            $chromaticAberration.map { _ in }.eraseToAnyPublisher(),
            $diffraction.map { _ in }.eraseToAnyPublisher(),
            $isLCCActive.map { _ in }.eraseToAnyPublisher(),
            $lccProfileUUID.map { _ in }.eraseToAnyPublisher(),
            $lccLightFalloffEnabled.map { _ in }.eraseToAnyPublisher(),
            $lccLightFalloffAmount.map { _ in }.eraseToAnyPublisher(),
            $lccDustRemovalEnabled.map { _ in }.eraseToAnyPublisher(),
            $lccUniformityEnabled.map { _ in }.eraseToAnyPublisher(),
            $isSoftProofingEnabled.map { _ in }.eraseToAnyPublisher(),
            $proofingProfileID.map { _ in }.eraseToAnyPublisher(),
            $showGamutWarning.map { _ in }.eraseToAnyPublisher(),
            $maskVisibilityMode.map { _ in }.eraseToAnyPublisher(),
            $maskColorIndex.map { _ in }.eraseToAnyPublisher(),
            $maskRefineEdge.map { _ in }.eraseToAnyPublisher(),
            $maskFeather.map { _ in }.eraseToAnyPublisher(),
            $keystoneTiltX.map { _ in }.eraseToAnyPublisher(),
            $keystoneTiltY.map { _ in }.eraseToAnyPublisher(),
            $keystoneAmount.map { _ in }.eraseToAnyPublisher(),
            $keystoneAspect.map { _ in }.eraseToAnyPublisher(),
            $keystoneSkew.map { _ in }.eraseToAnyPublisher(),
            $keystoneFocalLength.map { _ in }.eraseToAnyPublisher(),
            $nrLuminance.map { _ in }.eraseToAnyPublisher(),
            $nrDetails.map { _ in }.eraseToAnyPublisher(),
            $nrColor.map { _ in }.eraseToAnyPublisher(),
            $nrSinglePixel.map { _ in }.eraseToAnyPublisher(),
            $sharpAmount.map { _ in }.eraseToAnyPublisher(),
            $sharpRadius.map { _ in }.eraseToAnyPublisher(),
            $sharpThreshold.map { _ in }.eraseToAnyPublisher(),
            $sharpHalo.map { _ in }.eraseToAnyPublisher(),
            $stackCOStyles.map { _ in }.eraseToAnyPublisher(),
            
            $blackAndWhiteEnabled.map { _ in }.eraseToAnyPublisher(),
            $bwRed.map { _ in }.eraseToAnyPublisher(),
            $bwYellow.map { _ in }.eraseToAnyPublisher(),
            $bwGreen.map { _ in }.eraseToAnyPublisher(),
            $bwCyan.map { _ in }.eraseToAnyPublisher(),
            $bwBlue.map { _ in }.eraseToAnyPublisher(),
            $bwMagenta.map { _ in }.eraseToAnyPublisher(),
            $bwSplitToneHighlightHue.map { _ in }.eraseToAnyPublisher(),
            $bwSplitToneHighlightSaturation.map { _ in }.eraseToAnyPublisher(),
            $bwSplitToneShadowHue.map { _ in }.eraseToAnyPublisher(),
            $bwSplitToneShadowSaturation.map { _ in }.eraseToAnyPublisher(),
            $dehazeAmount.map { _ in }.eraseToAnyPublisher(),
            $dehazeShadowToneHue.map { _ in }.eraseToAnyPublisher(),
            $vignettingAmount.map { _ in }.eraseToAnyPublisher(),
            $vignettingMethod.map { _ in }.eraseToAnyPublisher(),
            $matchLookImpact.map { _ in }.eraseToAnyPublisher(),
            $matchLookReferenceVariantID.map { _ in }.eraseToAnyPublisher(),
            $moireAmount.map { _ in }.eraseToAnyPublisher(),
            $moirePattern.map { _ in }.eraseToAnyPublisher(),
            $cropRect.map { _ in }.eraseToAnyPublisher(),
            $rotationAngle.map { _ in }.eraseToAnyPublisher(),
            $zoomLevel.map { _ in }.eraseToAnyPublisher(),
            $viewportRect.map { _ in }.eraseToAnyPublisher(),
            $focusZoomLevel.map { _ in }.eraseToAnyPublisher(),
            $focusPoint.map { _ in }.eraseToAnyPublisher(),
            $focusAIMode.map { _ in }.eraseToAnyPublisher(),
            $aiCropTopMargin.map { _ in }.eraseToAnyPublisher(),
            $aiCropBottomMargin.map { _ in }.eraseToAnyPublisher(),
            $aiCropLeftMargin.map { _ in }.eraseToAnyPublisher(),
            $aiCropRightMargin.map { _ in }.eraseToAnyPublisher(),
            $aiCropShowGuides.map { _ in }.eraseToAnyPublisher(),
            $aiCropReferencePoint.map { _ in }.eraseToAnyPublisher(),
            $aiCropLockAspect.map { _ in }.eraseToAnyPublisher(),
            $spots.map { _ in }.eraseToAnyPublisher(),
            $negativeFilmEnabled.map { _ in }.eraseToAnyPublisher(),
            $negativeFilmType.map { _ in }.eraseToAnyPublisher(),
            $cropRatioIndex.map { _ in }.eraseToAnyPublisher(),
            $cropGridIndex.map { _ in }.eraseToAnyPublisher(),
            $cropShowMask.map { _ in }.eraseToAnyPublisher(),
            $cropMaskOpacity.map { _ in }.eraseToAnyPublisher(),
            $cropMaskBrightness.map { _ in }.eraseToAnyPublisher(),
            $gridTypeIndex.map { _ in }.eraseToAnyPublisher(),
            $gridColorIndex.map { _ in }.eraseToAnyPublisher(),
            $guides.map { _ in }.eraseToAnyPublisher()
        ]
        
        Publishers.MergeMany(publishers)
            .debounce(for: .milliseconds(16), scheduler: RunLoop.main) // ~60fps
            .sink { [weak self] _ in
                guard let self = self, !self.isUpdatingFromModel else { return }
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
    
    public func resetToNeutral() {
        self.exposure = 0.0
        self.contrast = 0.0
        self.brightness = 0.0
        self.saturation = 0.0
        self.kelvin = 5000.0
        self.tint = 0.0
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
              let activeLayer = variant.activeLayer as? LayerBase,
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
                    localCfg.maskData = (layer as? LayerBase)?.mask // NEW: Pass the AI mask
                    
                    // Note: Here we would map layer-specific sliders to localCfg.settings
                    // localCfg.settings.exposure = ...
                    
                    settings.localAdjustments[index] = localCfg
                }
            }
        }
        
        return settings
    }
    
    public func refreshToolValues() {
        guard let variant = currentVariant, let mc = variant.mcVariant else { return }
        
        self.isUpdatingFromModel = true
        
        // 1. Determine active source (Layer or Global)
        let source: Any?
        if let activeLayer = variant.activeLayer, activeLayer.type != .background {
            source = activeLayer.mcLayer
        } else {
            source = mc
        }
        let colorBalanceSource = source as? ColorBalanceStorageContainer
        
        func getFloat(_ key: String, _ defaultVal: Float) -> Float {
            if let mcSource = source as? MCVariant {
                return (mcSource.objectForKey(key) as? Float) ?? defaultVal
            } else if let mcLayerSource = source as? MCAdjLayer {
                return (mcLayerSource.objectForKey(key) as? Float) ?? defaultVal
            }
            return defaultVal
        }
        
        func getDouble(_ key: String, _ defaultVal: Double) -> Double {
            if let mcSource = source as? MCVariant {
                return (mcSource.objectForKey(key) as? Double) ?? defaultVal
            } else if let mcLayerSource = source as? MCAdjLayer {
                return (mcLayerSource.objectForKey(key) as? Double) ?? defaultVal
            }
            return defaultVal
        }
        
        // 2. Map properties back to published floats
        self.exposure = getFloat("ZEXPOSURE", 0.0)
        self.contrast = getFloat("ZCONTRAST", 0.0)
        self.brightness = getFloat("ZBRIGHTNESS", 0.0)
        self.saturation = getFloat("ZSATURATION", 0.0)
        
        self.clarityAmount = getFloat("ZCLARITY_AMOUNT", 0.0)
        self.structureAmount = getFloat("ZSTRUCTURE_AMOUNT", 0.0)
        self.clarityMethod = Int(getFloat("ZCLARITY_METHOD", 0.0))
        let colorBalanceSettings = ColorBalanceStorage.settings(from: colorBalanceSource)
        self.cbMaster = colorBalanceSettings.master
        self.cbShadow = colorBalanceSettings.shadow
        self.cbMidtone = colorBalanceSettings.midtone
        self.cbHighlight = colorBalanceSettings.highlight
        
        // WB and other tools are usually global or per-layer depending on tool
        self.kelvin = (mc.objectForKey("ZKELVIN") as? Float) ?? 5000.0
        self.tint = (mc.objectForKey("ZTINT") as? Float) ?? 0.0
        
        self.highlights = (mc.objectForKey("ZHIGHLIGHTS") as? Float) ?? 0.0
        self.shadows = (mc.objectForKey("ZSHADOWS") as? Float) ?? 0.0
        self.whites = (mc.objectForKey("ZWHITES") as? Float) ?? 0.0
        self.blacks = (mc.objectForKey("ZBLACKS") as? Float) ?? 0.0
        
        self.blackAndWhiteEnabled = (mc.objectForKey("ZBW_ENABLED") as? Bool) ?? false
        self.bwRed = getDouble("ZBW_RED", 0.0)
        self.bwYellow = getDouble("ZBW_YELLOW", 0.0)
        self.bwGreen = getDouble("ZBW_GREEN", 0.0)
        self.bwCyan = getDouble("ZBW_CYAN", 0.0)
        self.bwBlue = getDouble("ZBW_BLUE", 0.0)
        self.bwMagenta = getDouble("ZBW_MAGENTA", 0.0)
        self.bwSplitToneHighlightHue = getDouble("ZBW_ST_HL_HUE", 0.0)
        self.bwSplitToneHighlightSaturation = getDouble("ZBW_ST_HL_SAT", 0.0)
        self.bwSplitToneShadowHue = getDouble("ZBW_ST_SH_HUE", 0.0)
        self.bwSplitToneShadowSaturation = getDouble("ZBW_ST_SH_SAT", 0.0)
        
        self.dehazeAmount = getDouble("ZDEHAZE_AMOUNT", 0.0)
        self.dehazeShadowToneHue = getDouble("ZDEHAZE_SHADOW_HUE", 0.0)
        self.vignettingAmount = getDouble("ZVIGNETTING_AMOUNT", 0.0)
        self.vignettingMethod = Int(getDouble("ZVIGNETTING_METHOD", 0.0))
        
        self.matchLookImpact = Float(getDouble("ZMATCH_LOOK_IMPACT", 100.0))
        self.matchLookReferenceVariantID = mc.objectForKey("ZMATCH_LOOK_REF_ID") as? String
        
        self.moireAmount = getDouble("ZMOIRE_AMOUNT", 0.0)
        self.moirePattern = getDouble("ZMOIRE_PATTERN", 0.0)
        
        if let rect = mc.objectForKey("ZCROP_RECT") as? CGRect {
            self.cropRect = rect
        }
        self.rotationAngle = getDouble("ZROTATION_ANGLE", 0.0)
        
        // Lens Correction
        self.lensDistortion = getDouble("ZLENS_DISTORTION", 0.0)
        self.lensSharpnessFalloff = getDouble("ZLENS_SHARPNESS_FALLOFF", 0.0)
        self.lensLightFalloff = getDouble("ZLENS_LIGHT_FALLOFF", 0.0)
        self.lensShiftX = getFloat("ZLENS_SHIFT_X", 0.0)
        self.lensShiftY = getFloat("ZLENS_SHIFT_Y", 0.0)
        self.clipDistortedEdges = (mc.objectForKey("ZCLIP_DISTORTED_EDGES") as? Bool) ?? false
        self.chromaticAberration = (mc.objectForKey("ZCHROMATIC_ABERRATION") as? Bool) ?? false
        self.diffraction = (mc.objectForKey("ZDIFFRACTION") as? Bool) ?? false
        self.isLCCActive = (mc.objectForKey("ZLCC_ACTIVE") as? Bool) ?? false
        self.lccProfileUUID = mc.objectForKey("ZLCC_PROFILE_UUID") as? String
        self.lccLightFalloffEnabled = (mc.objectForKey("ZLCC_LIGHTFALLOFF_ENABLED") as? Bool) ?? true
        self.lccLightFalloffAmount = (mc.objectForKey("ZLCC_LIGHTFALLOFF_AMOUNT") as? Double) ?? 100.0
        self.lccDustRemovalEnabled = (mc.objectForKey("ZLCC_DUSTREMOVAL_ENABLED") as? Bool) ?? true
        self.lccUniformityEnabled = (mc.objectForKey("ZLCC_UNIFORMITY_ENABLED") as? Bool) ?? true
        
        // Keystone
        self.keystoneTiltX = getDouble("ZKEYSTONE_TILTX", 0.0)
        self.keystoneTiltY = getDouble("ZKEYSTONE_TILTY", 0.0)
        self.keystoneAmount = getDouble("ZKEYSTONE_AMOUNT", 0.0)
        self.keystoneAspect = getDouble("ZKEYSTONE_ASPECT", 0.0)
        self.keystoneSkew = getDouble("ZKEYSTONE_SKEW", 0.0)
        self.keystoneFocalLength = getDouble("ZKEYSTONE_FOCALLENGTH", 35.0)
        
        // Noise Reduction
        self.nrLuminance = getDouble("ZNR_LUMINANCE", 50.0)
        self.nrDetails = getDouble("ZNR_DETAILS", 50.0)
        self.nrColor = getDouble("ZNR_COLOR", 50.0)
        self.nrSinglePixel = getDouble("ZNR_SINGLE_PIXEL", 0.0)
        
        // Sharpening
        self.sharpAmount = getDouble("ZSHARP_AMOUNT", 100.0)
        self.sharpRadius = getDouble("ZSHARP_RADIUS", 0.8)
        self.sharpThreshold = getDouble("ZSHARP_THRESHOLD", 1.0)
        self.sharpHalo = getDouble("ZSHARP_HALO", 0.0)
        
        self.levelsBlackPoint = (mc.objectForKey("ZLEVELS_BLACK") as? Float) ?? 0.0
        self.levelsWhitePoint = (mc.objectForKey("ZLEVELS_WHITE") as? Float) ?? 1.0
        self.levelsMidtone = (mc.objectForKey("ZLEVELS_MIDTONE") as? Float) ?? 1.0
        self.levelsTargetBlack = (mc.objectForKey("ZLEVELS_TARGET_BLACK") as? Float) ?? 0.0
        self.levelsTargetWhite = (mc.objectForKey("ZLEVELS_TARGET_WHITE") as? Float) ?? 1.0
        
        if let curvePts = mc.objectForKey("ZCURVE_POINTS") as? [CGPoint] {
            self.curvesPoints = curvePts
        } else {
            self.curvesPoints = [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0)]
        }
        
        if let data = mc.objectForKey("ZSPOTS") as? Data,
           let decoded = try? JSONDecoder().decode([SpotItem].self, from: data) {
            self.spots = decoded
        } else {
            self.spots = []
        }
        
        if let zoom = mc.objectForKey("ZZOOM_LEVEL") as? Double {
            self.zoomLevel = zoom
        } else if let zoomFloat = mc.objectForKey("ZZOOM_LEVEL") as? Float {
            self.zoomLevel = Double(zoomFloat)
        } else {
            self.zoomLevel = 1.0
        }
        if let vRect = mc.objectForKey("ZVIEWPORT_RECT") as? CGRect {
            self.viewportRect = vRect
        }
        
        self.focusZoomLevel = (mc.objectForKey("ZFOCUS_ZOOM") as? Float) ?? 1.0
        if let fPoint = mc.objectForKey("ZFOCUS_POINT") as? CGPoint {
            self.focusPoint = fPoint
        }
        self.focusAIMode = (mc.objectForKey("ZFOCUS_AI_MODE") as? Int) ?? 0
        
        self.aiCropTopMargin = (mc.objectForKey("ZAI_CROP_TOP") as? Double) ?? 10.0
        self.aiCropBottomMargin = (mc.objectForKey("ZAI_CROP_BOTTOM") as? Double) ?? 10.0
        self.aiCropLeftMargin = (mc.objectForKey("ZAI_CROP_LEFT") as? Double) ?? 10.0
        self.aiCropRightMargin = (mc.objectForKey("ZAI_CROP_RIGHT") as? Double) ?? 10.0
        self.aiCropShowGuides = (mc.objectForKey("ZAI_CROP_SHOW_GUIDES") as? Bool) ?? true
        self.aiCropReferencePoint = (mc.objectForKey("ZAI_CROP_REF_POINT") as? Int) ?? 0
        self.aiCropLockAspect = (mc.objectForKey("ZAI_CROP_LOCK_ASPECT") as? Bool) ?? true
        
        self.stackCOStyles = (mc.objectForKey("ZSTACK_STYLES") as? Bool) ?? false
        self.styleOpacity = (mc.objectForKey("ZSTYLE_OPACITY") as? Double) ?? 100.0

        self.cropRatioIndex = (mc.objectForKey("ZCROP_RATIO") as? Int) ?? 0
        self.cropGridIndex = (mc.objectForKey("ZCROP_GRID") as? Int) ?? 0
        self.cropShowMask = (mc.objectForKey("ZCROP_SHOW_MASK") as? Bool) ?? true
        self.cropMaskOpacity = (mc.objectForKey("ZCROP_MASK_OPACITY") as? Double) ?? 50.0
        self.cropMaskBrightness = (mc.objectForKey("ZCROP_MASK_BRIGHTNESS") as? Double) ?? 0.0
        
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
        guard let variant = variant, let mc = variant.mcVariant else { return }
        let colorBalanceSettings = ColorBalanceStorage.normalizedSettings(
            ColorBalanceSettings(
                master: cbMaster,
                shadow: cbShadow,
                midtone: cbMidtone,
                highlight: cbHighlight
            )
        )
        cbMaster = colorBalanceSettings.master
        
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
        mc.setObject(bwYellow, forKey: "ZBW_YELLOW")
        mc.setObject(bwGreen, forKey: "ZBW_GREEN")
        mc.setObject(bwCyan, forKey: "ZBW_CYAN")
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
        
        mc.setObject(levelsBlackPoint, forKey: "ZLEVELS_BLACK")
        mc.setObject(levelsWhitePoint, forKey: "ZLEVELS_WHITE")
        mc.setObject(levelsMidtone, forKey: "ZLEVELS_MIDTONE")
        mc.setObject(levelsTargetBlack, forKey: "ZLEVELS_TARGET_BLACK")
        mc.setObject(levelsTargetWhite, forKey: "ZLEVELS_TARGET_WHITE")
        mc.setObject(curvesPoints, forKey: "ZCURVE_POINTS")
        
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
        
        mc.setObject(rating, forKey: "ZRATING")
        mc.setObject(colorTag.rawValue, forKey: "ZCOLOR_TAG")
        
        // 3. Map to ImageCore settings
        var settings = IC_ProcessSettings()
        settings.exposure = Float((mc.objectForKey("ZEXPOSURE") as? Double) ?? 0.0)
        settings.contrast = Float((mc.objectForKey("ZCONTRAST") as? Double) ?? 0.0)
        settings.brightness = Float((mc.objectForKey("ZBRIGHTNESS") as? Double) ?? 0.0)
        settings.saturation = Float((mc.objectForKey("ZSATURATION") as? Double) ?? 0.0)
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
        
        settings.geometry.cropRect = cropRect // Use the state variable since it's published now
        settings.geometry.rotation = rotationAngle
        settings.geometry.keystoneTiltX = Float(keystoneTiltX)
        settings.geometry.keystoneTiltY = Float(keystoneTiltY)
        settings.geometry.keystoneAmount = Float(keystoneAmount)
        settings.geometry.keystoneAspect = Float(keystoneAspect)
        settings.geometry.keystoneSkew = Float(keystoneSkew)
        settings.geometry.keystoneFocalLength = Float(keystoneFocalLength)
        
        settings.levelsShadow = Float(levelsBlackPoint)
        settings.levelsHighlight = Float(levelsWhitePoint)
        settings.levelsMidtone = Float(levelsMidtone)
        settings.levelsTargetShadow = Float(levelsTargetBlack)
        settings.levelsTargetHighlight = Float(levelsTargetWhite)
        
        var curveX = ICCurve()
        curveX.count = Int32(min(curvesPoints.count, 16))
        for i in 0..<Int(curveX.count) {
            curveX.points[i] = ICCurvePoint(x: Float(curvesPoints[i].x), y: Float(curvesPoints[i].y))
        }
        settings.gradationCurves.curveX = curveX
        
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
            
            if let mcLayer = layer.mcLayer {
                localCfg.settings.exposure = (mcLayer.objectForKey("ZEXPOSURE") as? Float) ?? 0.0
                localCfg.settings.contrast = (mcLayer.objectForKey("ZCONTRAST") as? Float) ?? 0.0
                localCfg.settings.brightness = (mcLayer.objectForKey("ZBRIGHTNESS") as? Float) ?? 0.0
                localCfg.settings.saturation = (mcLayer.objectForKey("ZSATURATION") as? Float) ?? 0.0
                // localCfg.settings.colorBalance = ColorBalanceStorage.settings(from: mcLayer)
                localCfg.settings.clarity.amount = (mcLayer.objectForKey("ZCLARITY_AMOUNT") as? Float) ?? 0.0
                localCfg.settings.clarity.structureAmount = (mcLayer.objectForKey("ZSTRUCTURE_AMOUNT") as? Float) ?? 0.0
                localCfg.settings.clarity.clarityMethod = Int32((mcLayer.objectForKey("ZCLARITY_METHOD") as? Int) ?? 0)
            }
            if index < 16 {
                settings.localAdjustments[index] = localCfg
            }
        }
        
        // 5. Trigger pipeline execution
        _ = ImageCorePipeline(mode: .cpu_simd)
        print("[Adjustment] Committing changes for \(variant.variantUUID)")
        
        variant.isModified = true
    }
    
    // MARK: - Smart Adjustments (AI-002)
    
    public func setSmartReference() {
        guard let variant = currentVariant else { return }
        print("[Smart] Setting reference for \(variant.variantUUID)")
        self.smartReference = SmartAdjustmentsHelper.analyzeVariant(variant)
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
        // Also reset ratio index to Unconstrained if needed, or keep it. 
        // Capture One usually keeps the ratio but clears the box.
        self.commitChanges(to: currentVariant)
    }

    public func invertCrop() {
        let current = self.cropRect
        guard current != .zero else { return }
        
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

    public func commitLinearGradient(_ gradient: LinearGradientMask) {
        guard let variant = currentVariant, let activeLayer = variant.activeLayer else { return }
        activeLayer.linearGradient = gradient
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
