import Foundation

/// Reconstructed Filter Predicate model for building dynamic queries.
/// Based on _TtC8DataCore15FilterPredicate metadata.

public struct COFilterPredicate: Codable {
    public var minRating: Int?
    public var maxRating: Int?
    public var colorTags: [Int]?
    public var searchText: String?
    
    public init(minRating: Int? = nil, maxRating: Int? = nil, colorTags: [Int]? = nil, searchText: String? = nil) {
        self.minRating = minRating
        self.maxRating = maxRating
        self.colorTags = colorTags
        self.searchText = searchText
    }
    
    /// Generates a SQL WHERE clause fragment.
    public func toSQL() -> String {
        var conditions: [String] = []
        
        if let min = minRating {
            conditions.append("ZVARIANTMETADATA.ZBASIC_RATING >= \(min)")
        }
        if let max = maxRating {
            conditions.append("ZVARIANTMETADATA.ZBASIC_RATING <= \(max)")
        }
        if let tags = colorTags, !tags.isEmpty {
            let tagList = tags.map { String($0) }.joined(separator: ", ")
            conditions.append("ZVARIANTMETADATA.ZCOLOR_TAG_INDEX IN (\(tagList))")
        }
        if let text = searchText, !text.isEmpty {
            conditions.append("ZIMAGE.ZDISPLAYNAME LIKE '%\(text)%'")
        }
        
        return conditions.isEmpty ? "1=1" : conditions.joined(separator: " AND ")
    }
}
