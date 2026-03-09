import Foundation

/// Reconstructed Naming Token for Capture One (TETH-003).
/// Based on _TtC10CaptureOne18CaptureNamingToken and metadata.
public struct CaptureNamingToken: Identifiable, Codable, Hashable {
    public let id: String
    public let name: String
    public let type: TokenType
    
    public enum TokenType: String, Codable {
        case camera = "Camera"
        case date = "Date"
        case counter = "Counter"
        case sessionName = "Session Name"
        case customText = "Custom Text"
    }
    
    public init(id: String = UUID().uuidString, name: String, type: TokenType) {
        self.id = id
        self.name = name
        self.type = type
    }
}

/// Reconstructed Formatter for token-based naming (TETH-003).
/// Based on ProcessNamingTokenFormatter disassembly.
public class CaptureNamingFormatter {
    
    public static func format(tokens: [CaptureNamingToken], cameraName: String, counter: Int) -> String {
        var result = ""
        
        for token in tokens {
            switch token.type {
            case .camera:
                result += cameraName
            case .date:
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyyMMdd"
                result += formatter.string(from: Date())
            case .counter:
                result += String(format: "%04d", counter)
            case .sessionName:
                result += "CaptureSession" // Simplified
            case .customText:
                result += token.name
            }
        }
        
        return result.isEmpty ? "Untitled" : result
    }
    
    /// Parses a string with placeholders like "[Camera]_[Counter]" into tokens.
    public static func parse(formatString: String) -> [CaptureNamingToken] {
        // Simplified parser
        var tokens: [CaptureNamingToken] = []
        let parts = formatString.components(separatedBy: "_")
        
        for part in parts {
            if part == "[Camera]" {
                tokens.append(CaptureNamingToken(name: "Camera", type: .camera))
            } else if part == "[Date]" {
                tokens.append(CaptureNamingToken(name: "Date", type: .date))
            } else if part == "[Counter]" {
                tokens.append(CaptureNamingToken(name: "Counter", type: .counter))
            } else {
                tokens.append(CaptureNamingToken(name: part, type: .customText))
            }
        }
        
        return tokens
    }
}
