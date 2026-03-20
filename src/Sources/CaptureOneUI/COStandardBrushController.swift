import SwiftUI
import AppCoreShared
import DataCore

/// Controller for the Standard Masking Brush (Reference: 2-HZ7HSYXUQ).
@MainActor
public class COStandardBrushController: ObservableObject {
    public static let shared = COStandardBrushController()
    
    public struct BrushSettings: Codable {
        public var size: Double = 50.0
        public var hardness: Double = 50.0
        public var opacity: Double = 100.0
        public var flow: Double = 100.0
        public var autoMask: Bool = false
        public var linkBrushAndEraser: Bool = true
        
        public static let `default` = BrushSettings()
    }
    
    @Published var brush: BrushSettings = .default
    @Published var eraser: BrushSettings = .default
    
    public var activeSettings: BrushSettings {
        get {
            let tool = AppCommandCenter.shared.selectedCursorToolID
            if tool == "EraseMask" {
                return eraser
            }
            return brush
        }
        set {
            let tool = AppCommandCenter.shared.selectedCursorToolID
            if tool == "EraseMask" {
                eraser = newValue
            } else {
                brush = newValue
            }
            if brush.linkBrushAndEraser {
                if tool == "EraseMask" {
                    brush.size = newValue.size
                } else {
                    eraser.size = newValue.size
                }
            }
        }
    }
    
    private init() {}
    
    public func handleMouseDown(at point: CGPoint, in image: ImageBase, mode: BrushMode) {
        guard let variant = AdjustmentToolController.shared.currentVariant else { return }
        
        // Ensure we have an active adjustment layer
        if variant.activeLayer == nil || variant.activeLayer?.type == .background {
            let newLayer = LayerBase(
                uuid: UUID().uuidString,
                name: "Adjustment Layer",
                type: .adjustment,
                context: variant.managedObjectContext
            )
            variant.layers.append(newLayer)
            variant.activeLayerIndex = variant.layers.count - 1
        }
        
        print("[Brush] Mouse Down at \(point) in mode \(mode)")
        // Actual mask data mutation would happen here via ImageCore/DataCore
    }
    
    public func handleMouseDrag(at point: CGPoint, in image: ImageBase, mode: BrushMode) {
        // print("[Brush] Mouse Drag at \(point)")
    }
    
    public func handleMouseUp(to variant: VariantBase) {
        print("[Brush] Mouse Up")
        variant.isModified = true
        AdjustmentToolController.shared.refreshToolValues()
    }
    
    public enum BrushMode {
        case draw
        case erase
    }
}
