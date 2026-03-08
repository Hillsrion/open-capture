import Foundation
import Accelerate

/// Reconstructed Procedural Film Grain Engine (ENG-008).
/// Based on disassembly of CImgOpFilmGrain.
public struct FilmGrainKernel {
    
    /// Reconstructed logic for applying procedural grain.
    public static func apply(to buffer: UnsafeMutablePointer<Float>,
                             count: Int,
                             settings: IC_FilmGrainSettings) {
        guard settings.amount > 0 else { return }
        
        let amount = Float(settings.amount / 100.0)
        
        // 1. Generate Procedural Noise Buffer
        var noise = [Float](repeating: 0, count: count)
        for i in 0..<count {
            noise[i] = (Float.random(in: -1...1) * amount)
        }
        
        // 2. Apply Luminance Masking
        // Grain is typically more visible in midtones than deep blacks/bright whites.
        for i in 0..<count {
            let pixel = buffer[i]
            // Simple midtone weighting: 1.0 at 0.5, 0.0 at 0.0 and 1.0
            let weight = 1.0 - abs(pixel - 0.5) * 2.0
            let weightedNoise = noise[i] * max(0, weight)
            
            buffer[i] = max(0, min(1.0, pixel + weightedNoise))
        }
    }
}
