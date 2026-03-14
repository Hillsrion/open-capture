import Foundation
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers

/// Reconstructed Export Engine (EXP-003).
/// Coordinates RAW development and file writing for final output.
public class ExportEngine {
    
    public static let shared = ExportEngine()
    
    private init() {}
    
    /// Exports a single RAW image using development settings and a recipe.
    /// Mimics CatalogWriter::WriteExportedImages from DataCore.
    public func exportImage(at url: URL, settings: IC_ProcessSettings, recipe: ExportRecipe, completion: @escaping (Result<URL, Error>) -> Void) {
        print("[Export] Starting export for \(url.lastPathComponent) using recipe: \(recipe.name)")
        
        // 1. Develop the RAW image to its final high-res state
        guard let developedImage = RawImageEngine.shared.developImage(at: url, with: settings) else {
            completion(.failure(NSError(domain: "ExportEngine", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to develop image for export."])))
            return
        }
        
        // 2. Prepare destination path
        let outputDir = URL(fileURLWithPath: (recipe.outputDestinationPath as NSString).expandingTildeInPath)
        try? FileManager.default.createDirectory(at: outputDir, withIntermediateDirectories: true)
        
        let fileName = formatFileName(originalName: url.deletingPathExtension().lastPathComponent, recipe: recipe)
        let fileExtension = recipe.format.rawValue.lowercased()
        let destinationURL = outputDir.appendingPathComponent(fileName).appendingPathExtension(fileExtension)
        
        // 3. Write file to disk
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try self.writeImage(developedImage, to: destinationURL, recipe: recipe)
                print("[Export] Successfully exported to \(destinationURL.path)")
                completion(.success(destinationURL))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    private func writeImage(_ image: CGImage, to url: URL, recipe: ExportRecipe) throws {
        let type: UTType
        switch recipe.format {
        case .jpeg: type = .jpeg
        case .tiff: type = .tiff
        case .png:  type = .png
        case .psd:  type = .psd // Note: PSD writing usually requires specialized libraries, here simplified
        }
        
        guard let destination = CGImageDestinationCreateWithURL(url as CFURL, type.identifier as CFString, 1, nil) else {
            throw NSError(domain: "ExportEngine", code: 2, userInfo: [NSLocalizedDescriptionKey: "Could not create image destination."])
        }
        
        let options: [CFString: Any] = [
            kCGImageDestinationLossyCompressionQuality: Double(recipe.quality) / 100.0
        ]
        
        CGImageDestinationAddImage(destination, image, options as CFDictionary)
        
        if !CGImageDestinationFinalize(destination) {
            throw NSError(domain: "ExportEngine", code: 3, userInfo: [NSLocalizedDescriptionKey: "Failed to finalize image destination."])
        }
    }
    
    private func formatFileName(originalName: String, recipe: ExportRecipe) -> String {
        // Simple token replacement logic [Image Name] -> originalName
        var result = recipe.outputNamingFormat
        result = result.replacingOccurrences(of: "[Image Name]", with: originalName)
        result = result.replacingOccurrences(of: "[Recipe Name]", with: recipe.name)
        return result
    }
}
