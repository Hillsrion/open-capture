import Foundation
import AppCoreShared
import ImageCore
import Combine

/// High-fidelity Magic Brush Controller (UI-205).
/// Coordinates brush state, mouse interactions, and smart selection logic.
public class COMagicBrushController: ObservableObject {
    public static let shared = COMagicBrushController()
    
    @Published public var settings = MagicBrushSettings()
    @Published public var isInteracting: Bool = false
    @Published public var currentSelectionPreview: [Float]?
    
    private var selectionService = COSmartSelectionService.shared
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        // Observer for tolerance changes during interaction
        settings.$tolerance
            .sink { [weak self] _ in
                if self?.isInteracting == true {
                    self?.updatePreview()
                }
            }
            .store(in: &cancellables)
    }
    
    /// Handle the initial mouse click.
    public func handleMouseDown(at point: CGPoint, in image: ImageBase) {
        self.isInteracting = true
        self.updateSelection(at: point, in: image)
    }
    
    /// Handle mouse drag for real-time tolerance adjustment or position update.
    public func handleMouseDrag(at point: CGPoint, in image: ImageBase) {
        guard isInteracting else { return }
        // Logic: horizontal drag often adjusts tolerance in Capture One
        self.updateSelection(at: point, in: image)
    }
    
    /// Handle mouse up to finalize the mask.
    public func handleMouseUp(to variant: VariantBase) {
        guard isInteracting, let preview = currentSelectionPreview else { return }
        
        print("[MagicBrush] Finalizing mask for variant: \(variant.variantUUID)")
        
        // Finalize the mask and apply to the variant's active layer
        if let activeLayer = variant.activeLayer as? VariantMagicBrushLayer {
            // Apply the mask buffer to the layer (simulated)
            print("[MagicBrush] Applying mask buffer to layer \(activeLayer.name)")
        }
        
        self.isInteracting = false
        self.currentSelectionPreview = nil
    }
    
    private func updateSelection(at point: CGPoint, in image: ImageBase) {
        let tolerance = Float(settings.tolerance / 100.0)
        let mask = selectionService.selectRegion(at: point, 
                                                tolerance: tolerance, 
                                                in: image, 
                                                settings: settings)
        
        DispatchQueue.main.async {
            self.currentSelectionPreview = mask
        }
    }
    
    private func updatePreview() {
        // Triggered when tolerance changes during an interaction
        print("[MagicBrush] Updating preview for tolerance change.")
    }
}
