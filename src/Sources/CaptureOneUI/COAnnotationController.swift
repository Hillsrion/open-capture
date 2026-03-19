import SwiftUI
import AppCoreShared

@MainActor
public final class COAnnotationController: ObservableObject {
    public static let shared = COAnnotationController()
    
    @Published public var brushSize: CGFloat = 5.0
    @Published public var eraserSize: CGFloat = 20.0
    @Published public var annotationColor: Color = .red
    
    private init() {}
    
    public var isEraserActive: Bool {
        AppCommandCenter.shared.selectedCursorToolID == "EraseAnnotation"
    }
    
    public func toggleDrawErase() {
        if AppCommandCenter.shared.selectedCursorToolID == "Annotate" {
            AppCommandCenter.shared.selectedCursorToolID = "EraseAnnotation"
        } else {
            AppCommandCenter.shared.selectedCursorToolID = "Annotate"
        }
    }
    
    public func selectDraw() {
        AppCommandCenter.shared.selectedCursorToolID = "Annotate"
    }
    
    public func selectErase() {
        AppCommandCenter.shared.selectedCursorToolID = "EraseAnnotation"
    }
    
    public var currentColorHex: String {
        return annotationColor.toHex() ?? "#FF0000"
    }
}

// MARK: - Color Hex Utility (UI-007 Parity)
extension Color {
    public func toHex() -> String? {
        #if canImport(AppKit)
        guard let components = NSColor(self).cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if a != 1.0 {
            return String(format: "#%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
        #else
        // Minimal fallback for non-AppKit platforms if needed
        return nil
        #endif
    }
}
