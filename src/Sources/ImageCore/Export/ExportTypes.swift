import Foundation

/// Reconstructed Export Format types (EXP-001).
public enum ExportFormat: String, Codable {
    case jpeg = "JPEG"
    case tiff = "TIFF"
    case psd = "PSD"
    case png = "PNG"
}

public enum ScalingMode: Int, Codable {
    case fixed = 0
    case width = 1
    case height = 2
    case longEdge = 3
    case shortEdge = 4
}

/// Reconstructed "Process Recipe" model (EXP-002).
/// Mimics ZENABLEDOUTPUTRECIPE from DataCore.
public struct ExportRecipe: Identifiable, Codable {
    public var id: UUID
    public var name: String
    public var format: ExportFormat
    public var quality: Int // 0-100
    public var scalingMode: ScalingMode
    public var scalingValue: Double
    public var outputNamingFormat: String // e.g. "[Image Name]-[Recipe Name]"
    public var outputDestinationPath: String
    
    public init(id: UUID = UUID(), 
                name: String = "Untitled Recipe", 
                format: ExportFormat = .jpeg, 
                quality: Int = 80, 
                scalingMode: ScalingMode = .fixed, 
                scalingValue: Double = 100.0,
                outputNamingFormat: String = "[Image Name]",
                outputDestinationPath: String = "~/Pictures/CaptureOne/Output") {
        self.id = id
        self.name = name
        self.format = format
        self.quality = quality
        self.scalingMode = scalingMode
        self.scalingValue = scalingValue
        self.outputNamingFormat = outputNamingFormat
        self.outputDestinationPath = outputDestinationPath
    }
}

/// Summary of an export operation.
public struct ExportJobSummary {
    public var jobId: UUID
    public var totalImages: Int
    public var completedImages: Int
    public var errorCount: Int
    public var startTime: Date
}
