import Foundation

/// Reconstructed Keyword Hierarchy Parser (WF-204).
/// Handles complex string parsing (e.g., `Place|Europe|Denmark`) into tree structures.
public class KeywordHierarchyParser {
    
    /// Parses a raw input string from the 'Enter Keywords' field into hierarchical segments.
    public static func parse(input: String) -> [String] {
        // Supported delimiters in Capture One: '>', '<', '|'
        let delimiters = CharacterSet(charactersIn: "><|")
        
        let components = input.components(separatedBy: delimiters)
        return components.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
    }
    
    /// Builds an XMP-compatible `lr:hierarchicalSubject` string from a list of keywords.
    public static func buildXMPSubject(from hierarchy: [String]) -> String {
        return hierarchy.joined(separator: "|")
    }
    
    /// Simulated synchronization between the internal Keyword Library and physical XMP sidecars.
    public static func syncWithXMPSidecar(variant: VariantBase, keywords: [String]) {
        // 1. Resolve variant physical path
        // 2. Locate or create corresponding .xmp sidecar
        // 3. Inject <dc:subject> for flat keywords and <lr:hierarchicalSubject> for trees
        print("Synced \(keywords.count) keywords to XMP sidecar for \(variant.image?.displayName ?? "Unknown")")
    }
}
