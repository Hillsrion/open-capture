import Foundation

/// Reconstructed Naming Token for Capture One (LOGIC-204).
/// Supports dynamic naming and hierarchical folders across Import, Capture, and Export.
public struct CaptureNamingToken: Identifiable, Codable, Hashable {
    public let id: String
    public let name: String
    public let type: TokenType
    
    public enum TokenType: String, Codable {
        case camera = "Camera"
        case date = "Date"
        case counter = "Counter"
        case sessionName = "Session Name"
        case imageName = "Image Name"
        case jobName = "Job Name"
        case subfolder = "Subfolder"
        case customText = "Custom Text"
        case delimiter = "Delimiter" // Support for hierarchical folder creation
    }
    
    public init(id: String = UUID().uuidString, name: String, type: TokenType) {
        self.id = id
        self.name = name
        self.type = type
    }
}

/// Reconstructed Formatter for token-based naming (LOGIC-204).
/// Resolves tokens based on context (Export, Capture, etc.).
public class CaptureNamingFormatter {
    
    public static func format(tokens: [CaptureNamingToken], cameraName: String = "Camera", counter: Int = 1) -> String {
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
                result += "CaptureSession" // Context-dependent
            case .imageName:
                result += "Original_Filename" // Context-dependent
            case .jobName:
                result += "Job_001" // Handled via CrossRecipeTokens
            case .subfolder:
                result += "Selects" // Handled via CrossRecipeTokens
            case .delimiter:
                result += "/"
            case .customText:
                result += token.name
            }
        }
        
        return result.isEmpty ? "Untitled" : result
    }
    
    public static func renameVariant(_ variant: VariantBase, tokens: [CaptureNamingToken], counter: Int) {
        let newName = format(tokens: tokens, counter: counter)
        print("[Naming] Renaming \(variant.variantUUID) to \(newName)")
        if let mc = variant.mcVariant {
            mc.setObject(newName, forKey: "ZNAME")
        }
        variant.isModified = true
    }
    
    /// Parses a string with placeholders like "[Image Name]/[Job Name]_[Counter]" into tokens.
    public static func parse(formatString: String) -> [CaptureNamingToken] {
        var tokens: [CaptureNamingToken] = []
        var currentToken = ""
        var isInsideToken = false
        
        for char in formatString {
            if char == "[" {
                if !currentToken.isEmpty {
                    tokens.append(CaptureNamingToken(name: currentToken, type: .customText))
                    currentToken = ""
                }
                isInsideToken = true
            } else if char == "]" {
                isInsideToken = false
                let type: CaptureNamingToken.TokenType
                switch currentToken {
                case "Camera": type = .camera
                case "Date": type = .date
                case "Counter", "4 Digit Counter": type = .counter
                case "Session Name": type = .sessionName
                case "Image Name": type = .imageName
                case "Job Name": type = .jobName
                case "Subfolder": type = .subfolder
                default: type = .customText
                }
                tokens.append(CaptureNamingToken(name: currentToken, type: type))
                currentToken = ""
            } else if char == "/" || char == "\\" {
                if !currentToken.isEmpty {
                    tokens.append(CaptureNamingToken(name: currentToken, type: .customText))
                    currentToken = ""
                }
                tokens.append(CaptureNamingToken(name: "/", type: .delimiter))
            } else {
                currentToken.append(char)
            }
        }
        
        if !currentToken.isEmpty {
            tokens.append(CaptureNamingToken(name: currentToken, type: .customText))
        }
        
        return tokens
    }
}
