import Foundation
import Combine
import ImageCore

public enum NextCaptureAdjustmentMode: String, CaseIterable, Identifiable {
    case copyFromLast = "Copy from Last"
    case copyFromPrimary = "Copy from Primary"
    case specificStyle = "Specific Style"
    case defaults = "Defaults"
    
    public var id: String { self.rawValue }
}

public enum NextCaptureSubAdjustmentMode: String, CaseIterable, Identifiable {
    case `default` = "Default"
    case copyFromLast = "Copy from Last"
    
    public var id: String { self.rawValue }
}

/// Service handling persistence and fetching of adjustments (TETH-003).
public class COAdjustmentPersistenceService {
    public static let shared = COAdjustmentPersistenceService()
    
    public func fetchAdjustments(from variant: VariantBase) -> [String: Any] {
        print("[AdjustmentPersistence] Fetching adjustments from variant \(variant.variantUUID)")
        // In a real implementation, this would extract the MCVariant dictionary
        return variant.mcVariant?.properties ?? [:]
    }
    
    public func applyAdjustments(_ adjustments: [String: Any], to variant: VariantBase) {
        print("[AdjustmentPersistence] Applying \(adjustments.count) adjustments to variant \(variant.variantUUID)")
        variant.mcVariant = MCVariant(dictionary: adjustments)
        variant.isModified = true
    }
}

/// Service handling style application (TETH-003).
public class COStyleApplicationService {
    public static let shared = COStyleApplicationService()
    
    public func applyStyle(_ styleName: String, to variant: VariantBase) {
        print("[StyleApplication] Applying style '\(styleName)' to variant \(variant.variantUUID)")
        // In a real app, this would look up the COStyle by name/UUID and merge it
    }
}

/// Controller for managing Next Capture Adjustments logic (TETH-003).
public class CONextCaptureAdjustmentsController: ObservableObject {
    public static let shared = CONextCaptureAdjustmentsController()
    
    @Published public var allOtherAdjustmentMode: NextCaptureAdjustmentMode = .copyFromLast
    @Published public var iccProfileMode: NextCaptureSubAdjustmentMode = .default
    @Published public var orientationMode: NextCaptureSubAdjustmentMode = .default
    @Published public var metadataMode: NextCaptureSubAdjustmentMode = .default
    @Published public var specificStyleName: String = "None"
    
    private init() {}
    
    public func applyAdjustmentsToNextCapture(newVariant: VariantBase, lastVariant: VariantBase?, primaryVariant: VariantBase?) {
        print("[NextCapture] Applying adjustments to next capture: \(newVariant.variantUUID)")
        
        switch allOtherAdjustmentMode {
        case .copyFromLast:
            if let last = lastVariant {
                let adjustments = COAdjustmentPersistenceService.shared.fetchAdjustments(from: last)
                COAdjustmentPersistenceService.shared.applyAdjustments(adjustments, to: newVariant)
            }
        case .copyFromPrimary:
            if let primary = primaryVariant {
                let adjustments = COAdjustmentPersistenceService.shared.fetchAdjustments(from: primary)
                COAdjustmentPersistenceService.shared.applyAdjustments(adjustments, to: newVariant)
            }
        case .specificStyle:
            COStyleApplicationService.shared.applyStyle(specificStyleName, to: newVariant)
        case .defaults:
            print("[NextCapture] Using default adjustments.")
        }
        
        // Handle sub-adjustments
        if iccProfileMode == .copyFromLast, let last = lastVariant {
             print("[NextCapture] Copying ICC Profile from last capture...")
             // Implementation details would go here
        }
        
        if orientationMode == .copyFromLast, let last = lastVariant {
             print("[NextCapture] Copying Orientation from last capture...")
             // Implementation details would go here
        }
        
        if metadataMode == .copyFromLast, let last = lastVariant {
             print("[NextCapture] Copying Metadata from last capture...")
             // Implementation details would go here
        }
    }
}
