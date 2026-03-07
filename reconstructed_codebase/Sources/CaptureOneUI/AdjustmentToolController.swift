import SwiftUI
import AppCoreShared
import ImageCore
import DataCore
import Combine

/// Reconstructed controller for managing adjustment tool states.
/// Bridges the UI sliders to the underlying MCVariant settings.
public class AdjustmentToolController: ObservableObject {
    
    private var currentVariant: VariantBase?
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
    
    // Levels State
    @Published public var levelsBlackPoint: Float = 0.0
    @Published public var levelsWhitePoint: Float = 1.0
    @Published public var levelsMidtone: Float = 1.0
    @Published public var levelsTargetBlack: Float = 0.0
    @Published public var levelsTargetWhite: Float = 1.0
    
    // Curves State
    @Published public var curvesPoints: [CGPoint] = [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0)]
    
    // Rating & Color Tag
    @Published public var rating: Int = 0
    @Published public var colorTag: VariantBase.ColorTag = .none
    
    // Clarity & Structure
    @Published public var clarityAmount: Float = 0.0
    @Published public var structureAmount: Float = 0.0
    @Published public var clarityMethod: Int = 0 // 0: Classic, 1: Punch, 2: Neutral, 3: Natural
    
    // Filtering State
    @Published public var activePredicate: COFilterPredicate = COFilterPredicate()
    
    public init() {
        setupChangeObservers()
    }
    
    private func setupChangeObservers() {
        // Observe all published properties and commit changes when they change
        let publishers: [AnyPublisher<Void, Never>] = [
            $exposure.map { _ in }.eraseToAnyPublisher(),
            $contrast.map { _ in }.eraseToAnyPublisher(),
            $brightness.map { _ in }.eraseToAnyPublisher(),
            $saturation.map { _ in }.eraseToAnyPublisher(),
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
            $clarityMethod.map { _ in }.eraseToAnyPublisher()
        ]
        
        Publishers.MergeMany(publishers)
            .debounce(for: .milliseconds(16), scheduler: RunLoop.main) // ~60fps
            .sink { [weak self] _ in
                guard let self = self, !self.isUpdatingFromModel else { return }
                self.commitChanges(to: self.currentVariant)
            }
            .store(in: &cancellables)
    }
    
    /// Binds the controller to a specific variant.
    public func bind(to variant: VariantBase?) {
        self.currentVariant = variant
        refreshToolValues()
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
        
        func getFloat(_ key: String, _ defaultVal: Float) -> Float {
            if let mcSource = source as? MCVariant {
                return (mcSource.objectForKey(key) as? Float) ?? defaultVal
            } else if let mcLayerSource = source as? MCAdjLayer {
                return (mcLayerSource.objectForKey(key) as? Float) ?? defaultVal
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
        
        // WB and other tools are usually global or per-layer depending on tool
        self.kelvin = (mc.objectForKey("ZKELVIN") as? Float) ?? 5000.0
        self.tint = (mc.objectForKey("ZTINT") as? Float) ?? 0.0
        
        self.highlights = (mc.objectForKey("ZHIGHLIGHTS") as? Float) ?? 0.0
        self.shadows = (mc.objectForKey("ZSHADOWS") as? Float) ?? 0.0
        self.whites = (mc.objectForKey("ZWHITES") as? Float) ?? 0.0
        self.blacks = (mc.objectForKey("ZBLACKS") as? Float) ?? 0.0
        
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
        
        self.rating = (mc.objectForKey("ZRATING") as? Int) ?? 0
        self.colorTag = VariantBase.ColorTag(rawValue: (mc.objectForKey("ZCOLOR_TAG") as? Int) ?? 0) ?? .none
        
        self.isUpdatingFromModel = false
    }
    
    /// Triggers a re-render via ImageCorePipeline when adjustments change.
    public func commitChanges(to variant: VariantBase?) {
        guard let variant = variant, let mc = variant.mcVariant else { return }
        
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
        } else {
            mc.setObject(exposure, forKey: "ZEXPOSURE")
            mc.setObject(contrast, forKey: "ZCONTRAST")
            mc.setObject(brightness, forKey: "ZBRIGHTNESS")
            mc.setObject(saturation, forKey: "ZSATURATION")
            mc.setObject(clarityAmount, forKey: "ZCLARITY_AMOUNT")
            mc.setObject(structureAmount, forKey: "ZSTRUCTURE_AMOUNT")
            mc.setObject(clarityMethod, forKey: "ZCLARITY_METHOD")
        }
        
        // 2. Global updates
        mc.setObject(kelvin, forKey: "ZKELVIN")
        mc.setObject(tint, forKey: "ZTINT")
        mc.setObject(highlights, forKey: "ZHIGHLIGHTS")
        mc.setObject(shadows, forKey: "ZSHADOWS")
        mc.setObject(whites, forKey: "ZWHITES")
        mc.setObject(blacks, forKey: "ZBLACKS")
        mc.setObject(levelsBlackPoint, forKey: "ZLEVELS_BLACK")
        mc.setObject(levelsWhitePoint, forKey: "ZLEVELS_WHITE")
        mc.setObject(levelsMidtone, forKey: "ZLEVELS_MIDTONE")
        mc.setObject(levelsTargetBlack, forKey: "ZLEVELS_TARGET_BLACK")
        mc.setObject(levelsTargetWhite, forKey: "ZLEVELS_TARGET_WHITE")
        mc.setObject(curvesPoints, forKey: "ZCURVE_POINTS")
        mc.setObject(rating, forKey: "ZRATING")
        mc.setObject(colorTag.rawValue, forKey: "ZCOLOR_TAG")
        
        // 3. Map to ImageCore settings
        var settings = IC_ProcessSettings()
        settings.exposure = (mc.objectForKey("ZEXPOSURE") as? Double) ?? 0.0
        settings.contrast = (mc.objectForKey("ZCONTRAST") as? Double) ?? 0.0
        settings.brightness = (mc.objectForKey("ZBRIGHTNESS") as? Double) ?? 0.0
        settings.saturation = (mc.objectForKey("ZSATURATION") as? Double) ?? 0.0
        settings.whiteBalanceTemperature = Double(kelvin)
        settings.whiteBalanceTint = Double(tint)
        
        settings.levelsShadow = levelsBlackPoint
        settings.levelsHighlight = levelsWhitePoint
        settings.levelsMidtone = levelsMidtone
        settings.levelsTargetShadow = levelsTargetBlack
        settings.levelsTargetHighlight = levelsTargetWhite
        
        var curveX = ICCurve()
        curveX.count = Int32(min(curvesPoints.count, 16))
        for i in 0..<Int(curveX.count) {
            curveX.points[i] = ICCurvePoint(x: Float(curvesPoints[i].x), y: Float(curvesPoints[i].y))
        }
        settings.gradationCurves.curveX = curveX
        
        settings.clarity.amount = clarityAmount
        settings.clarity.structureAmount = structureAmount
        settings.clarity.clarityMethod = Int32(clarityMethod)
        
        // 4. Map Local Adjustments (Layers)
        for layer in variant.layers where layer.type != .background {
            var localAdj = IC_LocalAdjustmentSettings()
            localAdj.opacity = layer.opacity
            if let mcLayer = layer.mcLayer {
                localAdj.exposure = (mcLayer.objectForKey("ZEXPOSURE") as? Float) ?? 0.0
                localAdj.contrast = (mcLayer.objectForKey("ZCONTRAST") as? Float) ?? 0.0
                localAdj.brightness = (mcLayer.objectForKey("ZBRIGHTNESS") as? Float) ?? 0.0
                localAdj.saturation = (mcLayer.objectForKey("ZSATURATION") as? Float) ?? 0.0
                localAdj.clarity.amount = (mcLayer.objectForKey("ZCLARITY_AMOUNT") as? Float) ?? 0.0
                localAdj.clarity.structureAmount = (mcLayer.objectForKey("ZSTRUCTURE_AMOUNT") as? Float) ?? 0.0
                localAdj.clarity.clarityMethod = Int32((mcLayer.objectForKey("ZCLARITY_METHOD") as? Int) ?? 0)
            }
            settings.localAdjustments.append(localAdj)
        }
        
        // 5. Trigger pipeline execution
        _ = ImageCorePipeline(mode: .cpu_simd)
        print("[Adjustment] Committing changes for \(variant.variantUUID)")
        
        variant.isModified = true
    }
}
