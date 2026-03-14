import Foundation
import Combine

/// Reconstructed Search Criteria for filtering variants (ENG-011).
public struct SearchCriteria {
    public var minRating: Int = 0 // 0 to 5
    public var allowedColorTags: Set<VariantBase.ColorTag> = Set(VariantBase.ColorTag.allCases)
    public var searchText: String = ""
    public var showOnlyModified: Bool = false
    
    public init() {}
}

/// Reconstructed Search and Filtering Manager (ENG-012).
/// Responsible for applying criteria to a collection of variants.
/// Mimics _TtC13AppCoreShared13SearchManager.
public class SearchManager: ObservableObject {
    public static let shared = SearchManager()
    
    @Published public var criteria = SearchCriteria()
    @Published public var activeFilterCount: Int = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        // Observe criteria changes to update counter
        $criteria
            .sink { [weak self] c in
                self?.activeFilterCount = self?.calculateActiveFilters(c) ?? 0
            }
            .store(in: &cancellables)
    }
    
    /// Filters a list of variants based on the current criteria.
    public func filter(_ variants: [VariantBase]) -> [VariantBase] {
        return variants.filter { variant in
            // 1. Rating Filter
            guard variant.rating >= criteria.minRating else { return false }
            
            // 2. Color Tag Filter
            guard criteria.allowedColorTags.contains(variant.colorTag) else { return false }
            
            // 3. Text Search (Filename, Keywords)
            if !criteria.searchText.isEmpty {
                let lowerText = criteria.searchText.lowercased()
                let filenameMatch = variant.image?.displayName.lowercased().contains(lowerText) ?? false
                let keywordMatch = variant.keywords.contains { $0.name.lowercased().contains(lowerText) }
                guard filenameMatch || keywordMatch else { return false }
            }
            
            // 4. Modification Filter
            if criteria.showOnlyModified {
                guard variant.isModified else { return false }
            }
            
            return true
        }
    }
    
    /// Resets all filters to default state.
    public func resetFilters() {
        self.criteria = SearchCriteria()
    }
    
    private func calculateActiveFilters(_ c: SearchCriteria) -> Int {
        var count = 0
        if c.minRating > 0 { count += 1 }
        if c.allowedColorTags.count < VariantBase.ColorTag.allCases.count { count += 1 }
        if !c.searchText.isEmpty { count += 1 }
        if c.showOnlyModified { count += 1 }
        return count
    }
}
