import Foundation
import Combine
import SwiftUI

/// Manager for Film Negative Conversion (Reference: Iin54oi8ojs).
/// Handles inversion logic, orange mask neutralization, and auto-levels coordination.
public class COFilmNegativeConversionManager: ObservableObject {
    public static let shared = COFilmNegativeConversionManager()
    
    private var cancellables = Set<AnyCancellable>()
    private let controller = AdjustmentToolController.shared
    
    public init() {
        setupObservers()
    }
    
    private func setupObservers() {
        // Observe when negative film mode is enabled to trigger auto-levels if needed
        controller.$negativeFilmEnabled
            .dropFirst()
            .sink { [weak self] enabled in
                if enabled {
                    self?.applyAutoLevels()
                }
            }
            .store(in: &cancellables)
    }
    
    /// Neutralizes the orange mask using a white balance picker on the unexposed film base.
    public func neutralizeOrangeMask(at point: CGPoint) {
        print("[FilmNegative] Neutralizing orange mask at: \(point)")
        
        // 1. Trigger WB Picker logic (simulated)
        // In a real app, this would sample the pixel at 'point' and set Kelvin/Tint
        // to make that pixel neutral (R=G=B).
        
        // For simulation, we set some plausible values for a typical orange mask neutralization
        controller.kelvin = 3200.0 // Cooler
        controller.tint = -15.0     // More magenta/green adjustment
        
        // 2. Trigger Auto Levels after neutralization
        applyAutoLevels()
    }
    
    /// Triggers automatic levels adjustment, specifically optimized for inverted negatives.
    public func applyAutoLevels() {
        print("[FilmNegative] Applying automatic levels adjustment for negative.")
        
        // Simulation of Auto Levels:
        // For negatives, we often want to stretch the histogram to the full range
        // after the inversion has taken place.
        
        controller.levelsBlackPointRGB = 0.02 // 2% clipping
        controller.levelsWhitePointRGB = 0.98 // 98% clipping
        controller.levelsMidtoneRGB = 1.2    // Slightly brighter midtones for better separation
        
        controller.commitChanges(to: controller.currentVariant)
    }
    
    /// Converts the current image state to/from Film Negative mode.
    public func toggleConversionMode(enabled: Bool) {
        controller.negativeFilmEnabled = enabled
        
        if enabled {
            // According to spec: Convert Negative mode in Base Characteristics
            // This might also involve changing the Tone Curve or ICC Profile
            controller.toneCurve = "Film Standard"
        }
    }
}
