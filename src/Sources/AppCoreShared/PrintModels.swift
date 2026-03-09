import Foundation
import CoreGraphics

/// Reconstructed Data Model for Print Layout Settings (UI-012).
public struct PrintTemplate: Codable, Hashable {
    public var name: String
    
    // Paper Size (in millimeters)
    public var paperWidth: Double
    public var paperHeight: Double
    
    // Margins (in millimeters)
    public var marginTop: Double
    public var marginBottom: Double
    public var marginLeft: Double
    public var marginRight: Double
    
    // Grid Layout
    public var rows: Int
    public var columns: Int
    public var cellSpacing: Double // millimeters
    
    public init(name: String = "Custom", paperWidth: Double = 210, paperHeight: Double = 297) {
        self.name = name
        self.paperWidth = paperWidth
        self.paperHeight = paperHeight
        self.marginTop = 10
        self.marginBottom = 10
        self.marginLeft = 10
        self.marginRight = 10
        self.rows = 1
        self.columns = 1
        self.cellSpacing = 5
    }
    
    public static var a4: PrintTemplate {
        return PrintTemplate(name: "A4", paperWidth: 210, paperHeight: 297)
    }
    
    public static var letter: PrintTemplate {
        return PrintTemplate(name: "US Letter", paperWidth: 215.9, paperHeight: 279.4)
    }
}

/// Reconstructed Data Model for Print Settings (Color Management, Resolution).
public struct PrintSettings: Codable {
    public var resolution: Int // DPI
    public var iccProfileID: String
    public var renderingIntent: Int // 0: Perceptual, 1: Relative Colorimetric, etc.
    public var sharpness: Double
    
    public init() {
        self.resolution = 300
        self.iccProfileID = "Printer Managed"
        self.renderingIntent = 1
        self.sharpness = 25.0
    }
}

/// Manager for print templates.
public class PrintManager: ObservableObject {
    public static let shared = PrintManager()
    
    @Published public var templates: [PrintTemplate] = [.a4, .letter]
    @Published public var currentTemplate: PrintTemplate = .a4
    @Published public var currentSettings: PrintSettings = PrintSettings()
    
    public init() {}
}
