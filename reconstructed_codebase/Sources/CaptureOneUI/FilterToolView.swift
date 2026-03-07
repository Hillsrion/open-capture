import SwiftUI
import AppCoreShared
import DataCore

/// Reconstructed Filter Tool for the sidebar.
/// Based on _TtC10CaptureOne14FilterToolView metadata.

public struct FilterToolView: View {
    @Binding var predicate: COFilterPredicate
    
    public init(predicate: Binding<COFilterPredicate>) {
        self._predicate = predicate
    }
    
    public var body: some View {
        COToolSection("Filters") {
            VStack(alignment: .leading, spacing: 12) {
                // Text Search
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search", text: Binding(
                        get: { predicate.searchText ?? "" },
                        set: { predicate.searchText = $0.isEmpty ? nil : $0 }
                    ))
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.system(size: 11))
                }
                .padding(4)
                .background(Color.black.opacity(0.2))
                .cornerRadius(4)
                
                // Rating Filter
                VStack(alignment: .leading, spacing: 4) {
                    Text("RATING").font(.system(size: 9, weight: .bold)).foregroundColor(.gray)
                    HStack(spacing: 8) {
                        ForEach(0...5, id: \.self) { rating in
                            Button(action: {
                                toggleRating(rating)
                            }) {
                                Text("\(rating)★")
                                    .font(.system(size: 10))
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(isRatingSelected(rating) ? CaptureOneTheme.Colors.activeHighlight : Color.white.opacity(0.1))
                                    .cornerRadius(3)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                
                // Color Tag Filter
                VStack(alignment: .leading, spacing: 4) {
                    Text("COLOR TAG").font(.system(size: 9, weight: .bold)).foregroundColor(.gray)
                    HStack(spacing: 6) {
                        ForEach(1...7, id: \.self) { tagID in
                            let tag = VariantBase.ColorTag(rawValue: tagID)!
                            Circle()
                                .fill(colorForTag(tag))
                                .frame(width: 14, height: 14)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: isTagSelected(tagID) ? 1.5 : 0)
                                )
                                .onTapGesture {
                                    toggleTag(tagID)
                                }
                        }
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
    
    private func isRatingSelected(_ rating: Int) -> Bool {
        return (predicate.minRating ?? 0) == rating && (predicate.maxRating ?? 5) == rating
    }
    
    private func toggleRating(_ rating: Int) {
        if isRatingSelected(rating) {
            predicate.minRating = nil
            predicate.maxRating = nil
        } else {
            predicate.minRating = rating
            predicate.maxRating = rating
        }
    }
    
    private func isTagSelected(_ tagID: Int) -> Bool {
        return predicate.colorTags?.contains(tagID) ?? false
    }
    
    private func toggleTag(_ tagID: Int) {
        var tags = predicate.colorTags ?? []
        if let index = tags.firstIndex(of: tagID) {
            tags.remove(at: index)
        } else {
            tags.append(tagID)
        }
        predicate.colorTags = tags.isEmpty ? nil : tags
    }
    
    private func colorForTag(_ tag: VariantBase.ColorTag) -> Color {
        switch tag {
        case .none: return Color.clear
        case .red: return Color.red
        case .orange: return Color.orange
        case .yellow: return Color.yellow
        case .green: return Color.green
        case .blue: return Color.blue
        case .purple: return Color.purple
        case .pink: return Color.pink
        }
    }
}
