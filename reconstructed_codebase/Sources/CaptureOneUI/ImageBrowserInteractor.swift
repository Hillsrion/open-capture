import Foundation
import SwiftUI
import AppCoreShared
import Combine

/// Reconstructed Interactor for managing browser selection and navigation (UI-005).
/// Based on disassembly of _TtC13AppCoreShared22ImageBrowserInteractor.
public class ImageBrowserInteractor: ObservableObject {
    
    @Published public var selectedVariants: Set<String> = [] // Set of Variant UUIDs
    @Published public var primaryVariantUUID: String?
    
    private var cancellables = Set<AnyCancellable>()
    private var allVariants: [VariantBase] = []
    
    public init() {}
    
    public func updateDataSource(with images: [ImageBase]) {
        self.allVariants = images.flatMap { $0.variants }
    }
    
    /// Handles a click on a variant cell.
    public func select(variant: VariantBase, isMultiSelect: Bool, isRangeSelect: Bool) {
        if isRangeSelect, let primary = primaryVariantUUID {
            // Range selection logic
            selectRange(from: primary, to: variant.variantUUID)
        } else if isMultiSelect {
            // Toggle selection
            if selectedVariants.contains(variant.variantUUID) {
                selectedVariants.remove(variant.variantUUID)
            } else {
                selectedVariants.insert(variant.variantUUID)
                primaryVariantUUID = variant.variantUUID
            }
        } else {
            // Single selection
            selectedVariants = [variant.variantUUID]
            primaryVariantUUID = variant.variantUUID
        }
    }
    
    private func selectRange(from startUUID: String, to endUUID: String) {
        let uuids = allVariants.map { $0.variantUUID }
        guard let startIndex = uuids.firstIndex(of: startUUID),
              let endIndex = uuids.firstIndex(of: endUUID) else { return }
        
        let rangeStart = min(startIndex, endIndex)
        let rangeEnd = max(startIndex, endIndex)
        
        let rangeUUIDs = uuids[rangeStart...rangeEnd]
        selectedVariants.formUnion(rangeUUIDs)
    }
    
    public func clearSelection() {
        selectedVariants.removeAll()
        primaryVariantUUID = nil
    }
}
