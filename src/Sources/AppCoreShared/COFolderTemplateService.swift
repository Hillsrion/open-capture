import Foundation

/// Service responsible for parsing delimited lists into a hierarchical folder structure.
public class COFolderTemplateService {
    
    public init() {}
    
    /// Parses a delimited string into a list of relative paths.
    /// Supports hierarchy using `/` and common delimiters like `,`, `;`, or newlines.
    public func parseDelimitedList(_ input: String) -> [String] {
        let delimiters = CharacterSet(charactersIn: ",;\n")
        let components = input.components(separatedBy: delimiters)
        
        return components
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }
    
    /// Expands a list of relative paths into a full hierarchy.
    /// Example: ["Capture", "Selects", "Output", "Trash/JPG", "Trash/TIF"]
    /// returns all unique paths including parents.
    public func expandHierarchy(_ paths: [String]) -> [String] {
        var allPaths = Set<String>()
        
        for path in paths {
            let components = path.components(separatedBy: "/")
            var currentPath = ""
            for component in components {
                if currentPath.isEmpty {
                    currentPath = component
                } else {
                    currentPath += "/" + component
                }
                allPaths.insert(currentPath)
            }
        }
        
        return Array(allPaths).sorted()
    }
    
    /// Evaluates tokens in the paths using the provided TokenEvaluator.
    public func evaluatePaths(_ paths: [String], evaluator: TokenEvaluator, context: TokenEvaluator.Context) -> [String] {
        return paths.map { evaluator.evaluate(format: $0, context: context) }
    }
}
