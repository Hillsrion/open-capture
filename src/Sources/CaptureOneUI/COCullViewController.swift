import Foundation
import SwiftUI
import ImageCore
import DataCore
import AppCoreShared

public class COFaceDetectionService {
    public static let shared = COFaceDetectionService()
    
    public func detectFace(in image: CGImage) -> CGRect? {
        // Mock face detection returning a normalized rect
        return CGRect(x: 0.4, y: 0.4, width: 0.2, height: 0.2)
    }
}

public struct CullGroup: Identifiable {
    public let id = UUID()
    public let name: String
    public var variants: [VariantBase]
}

public class COSimilarityGroupingEngine {
    public static let shared = COSimilarityGroupingEngine()
    
    public func group(variants: [VariantBase], similarity: Double) -> [CullGroup] {
        // Mock implementation
        // For demonstration, let's just group them into random groups based on the threshold
        guard !variants.isEmpty else { return [] }
        
        let numberOfGroups = max(1, Int(Double(variants.count) * (1.0 - similarity)))
        var groups: [CullGroup] = (0..<numberOfGroups).map { CullGroup(name: "Group \($0 + 1)", variants: []) }
        
        for (index, variant) in variants.enumerated() {
            let groupIndex = index % numberOfGroups
            groups[groupIndex].variants.append(variant)
        }
        
        return groups
    }
}

public class COCullViewController: ObservableObject {
    @Published public var isGroupingEnabled: Bool = false {
        didSet { updateGroups() }
    }
    @Published public var similarityThreshold: Double = 0.5 {
        didSet { updateGroups() }
    }
    @Published public var showFaceFocus: Bool = true
    @Published public var groups: [CullGroup] = []
    @Published public var selectedGroup: CullGroup?
    @Published public var allVariants: [VariantBase] = []
    
    public let groupingEngine = COSimilarityGroupingEngine.shared
    
    public init() {}
    
    public func loadVariants(_ variants: [VariantBase]) {
        self.allVariants = variants
        updateGroups()
    }
    
    private func updateGroups() {
        if isGroupingEnabled {
            groups = groupingEngine.group(variants: allVariants, similarity: similarityThreshold)
            if !groups.contains(where: { $0.id == selectedGroup?.id }) {
                selectedGroup = groups.first
            }
        } else {
            groups = []
            selectedGroup = nil
        }
    }
}
