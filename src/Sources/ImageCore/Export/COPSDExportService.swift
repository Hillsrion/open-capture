import CoreGraphics
import Foundation

/// Reconstructed service for handling PSD export with layered metadata (IMG-008).
/// Based on _TtC9ImageCore18COPSDExportService.
public class COPSDExportService {
    public static let shared = COPSDExportService()
    
    private init() {}
    
    /// Entry point for PSD rendering with layer configuration.
    public func renderLayeredPSD(for recipe: ExportRecipeInfo, image: CGImage, annotations: MCAnnotations?) {
        print("[PSDExport] Starting export for \(recipe.name)")
        
        // 1. Base Image Layer
        print("[PSDExport] Encoding base image layer...")
        
        // 2. Annotations Layer (UI-204)
        if recipe.includeAnnotations && recipe.annotationsAsLayer {
            if let ann = annotations, !ann.isEmpty {
                print("[PSDExport] Rendering Annotations as a transparent layer...")
                renderAnnotationsLayer(ann, size: CGSize(width: image.width, height: image.height))
            } else {
                print("[PSDExport] Skip: Annotations are empty or missing.")
            }
        } else if recipe.includeAnnotations {
            print("[PSDExport] Flattening annotations onto base layer...")
        }
        
        // 3. Finalize PSD
        print("[PSDExport] Writing PSD file to disk...")
    }
    
    private func renderAnnotationsLayer(_ annotations: MCAnnotations, size: CGSize) {
        // This would use CoreGraphics to render the strokes into a transparent context
        // and then encode it as a PSD layer.
        print("[PSDExport]   - Processing \(annotations.lines.count) strokes...")
        print("[PSDExport]   - Processing \(annotations.notes.count) text notes...")
    }
}
