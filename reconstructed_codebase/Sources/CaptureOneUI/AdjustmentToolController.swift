import SwiftUI
import AppCoreShared
import ImageCore
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
            $blacks.map { _ in }.eraseToAnyPublisher()
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
        
        // 2. Map to ImageCore settings
        var settings = IC_ProcessSettings()
        settings.exposure = Double(exposure)
        settings.contrast = Double(contrast)
        settings.brightness = Double(brightness)
        settings.saturation = Double(saturation)
        settings.whiteBalanceTemperature = Double(kelvin)
        settings.whiteBalanceTint = Double(tint)
        
        // 3. Trigger pipeline execution (Simulation for now)
        _ = ImageCorePipeline(mode: .cpu_simd)
        print("[Adjustment] Committing changes for \(variant.variantUUID)")
        
        // Mark variant as modified
        variant.isModified = true
    }
}
