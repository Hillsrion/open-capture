import CoreML

/// Reconstructed performance configuration logic.
/// Mimics IC_SetCoreMLComputeUnits and ResolveComputeUnits from Capture One.
public enum AIConfiguration {
    
    /// Returns an MLModelConfiguration optimized for the current hardware.
    /// Prefers Neural Engine (ANE) for masking and GPU for matching.
    public static var `default`: MLModelConfiguration {
        let config = MLModelConfiguration()
        #if targetEnvironment(simulator)
        config.computeUnits = .cpuOnly
        #else
        // Capture One 16.7 prefers .all to leverage Neural Engine on Apple Silicon
        config.computeUnits = .all
        #endif
        return config
    }
}

/// Helper to handle "Preheating" of AI models.
/// Mimics AiModelFactory::Preheat.
public class AIPreheatManager {
    public static let shared = AIPreheatManager()
    
    private init() {}
    
    /// Loads all critical AI models into memory/GPU in background.
    public func preheatAllModels() {
        print("[AI] Preheating models for instant access...")
        
        DispatchQueue.global(qos: .background).async {
            // Preheat Subject Masking
            _ = try? SubjectMaskingFP16(configuration: AIConfiguration.default)
            
            // Preheat Face Detection (640 variant is default for UI)
            _ = try? FaceDetectionFP16(variant: "640", configuration: AIConfiguration.default)
            
            // Preheat Exposure Match Look
            _ = try? MatchLookModel(variant: .exposure, configuration: AIConfiguration.default)
            
            print("[AI] Preheating complete. Neural Engine ready.")
        }
    }
}
