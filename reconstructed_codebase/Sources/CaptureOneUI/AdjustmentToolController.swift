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
            $activePredicate.map { _ in }.eraseToAnyPublisher()
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
        guard let variant = variant, let mc = variant.mcVariant else { return }
        
        self.isUpdatingFromModel = true
        
        // Logic recovery: Map MCVariant dictionary properties back to published floats
        self.exposure = (mc.objectForKey("ZEXPOSURE") as? Float) ?? 0.0
        self.contrast = (mc.objectForKey("ZCONTRAST") as? Float) ?? 0.0
        self.brightness = (mc.objectForKey("ZBRIGHTNESS") as? Float) ?? 0.0
        self.saturation = (mc.objectForKey("ZSATURATION") as? Float) ?? 0.0
        
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
        
        // Reconstruct curves from array or string if needed. Simplifying here.
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
        
        // 1. Update MCVariant properties
        mc.setObject(exposure, forKey: "ZEXPOSURE")
        mc.setObject(contrast, forKey: "ZCONTRAST")
        mc.setObject(brightness, forKey: "ZBRIGHTNESS")
        mc.setObject(saturation, forKey: "ZSATURATION")
        
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
        
        // 2. Map to ImageCore settings
        var settings = IC_ProcessSettings()
        settings.exposure = Double(exposure)
        settings.contrast = Double(contrast)
        settings.brightness = Double(brightness)
        settings.saturation = Double(saturation)
        settings.whiteBalanceTemperature = Double(kelvin)
        settings.whiteBalanceTint = Double(tint)
        
        // Levels & Curves bindings (High Fidelity)
        settings.levelsShadow = levelsBlackPoint
        settings.levelsHighlight = levelsWhitePoint
        settings.levelsMidtone = levelsMidtone
        settings.levelsTargetShadow = levelsTargetBlack
        settings.levelsTargetHighlight = levelsTargetWhite
        
        // Map UI points to ICCurve (curveX for RGB)
        var curveX = ICCurve()
        curveX.count = Int32(min(curvesPoints.count, 16))
        for i in 0..<Int(curveX.count) {
            curveX.points[i] = ICCurvePoint(x: Float(curvesPoints[i].x), y: Float(curvesPoints[i].y))
        }
        settings.gradationCurves.curveX = curveX
        
        // 3. Trigger pipeline execution (Simulation for now)
        _ = ImageCorePipeline(mode: .cpu_simd)
        print("[Adjustment] Committing changes for \(variant.variantUUID)")
        
        // Mark variant as modified
        variant.isModified = true
    }
}
