import Foundation

/// Reconstructed Token model for dynamic naming (CORE-011 / CORE-007).
public struct NamingToken: Identifiable, Codable {
    public let id: String
    public let displayName: String
    public let exampleValue: String
    
    public init(id: String, displayName: String, exampleValue: String) {
        self.id = id
        self.displayName = displayName
        self.exampleValue = exampleValue
    }
}

/// Reconstructed evaluator for token-based strings.
public typealias COTokenEngine = TokenEvaluator
public class TokenEvaluator {
    
    public struct Context {
        public let imageName: String
        public let date: Date
        public let sequence: Int
        public let jobName: String
        public let camera: String
        
        public init(imageName: String, date: Date, sequence: Int, jobName: String, camera: String = "Unknown Camera") {
            self.imageName = imageName
            self.date = date
            self.sequence = sequence
            self.jobName = jobName
            self.camera = camera
        }
    }
    
    public init() {}
    
    /// Evaluates a format string (e.g. "[Image Name]_[Date]") into a literal string.
    public func evaluate(format: String, context: Context) -> String {
        var result = format
        
        let mappings: [String: String] = [
            "[Image Name]": context.imageName,
            "[Job Name]": context.jobName,
            "[Date]": formatDate(context.date),
            "[Sequence]": String(format: "%04d", context.sequence),
            "[Camera]": context.camera
        ]
        
        for (token, value) in mappings {
            result = result.replacingOccurrences(of: token, with: value)
        }
        
        return result
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // Updated to match example in prompt 2024-03-21
        return formatter.string(from: date)
    }
    
    public static let availableTokens: [NamingToken] = [
        NamingToken(id: "[Image Name]", displayName: "Image Name", exampleValue: "DSC001"),
        NamingToken(id: "[Job Name]", displayName: "Job Name", exampleValue: "Wedding_Session"),
        NamingToken(id: "[Date]", displayName: "Date (yyyy-MM-dd)", exampleValue: "2024-03-21"),
        NamingToken(id: "[Sequence]", displayName: "4-digit Sequence", exampleValue: "0001"),
        NamingToken(id: "[Camera]", displayName: "Camera Model", exampleValue: "NikonZ9")
    ]
}
