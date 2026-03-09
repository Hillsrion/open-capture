import SwiftUI
import AppCoreShared
import DataCore

/// Reconstructed high-fidelity Metadata Filter Tool (GAP-402).
/// Based on _TtC10CaptureOne18MetadataFilterTool metadata.

public struct FilterToolView: View {
    @Binding var predicate: COFilterPredicate
    @State private var isShowingFilterDialog = false
    
    public init(predicate: Binding<COFilterPredicate>) {
        self._predicate = predicate
    }
    
    public var body: some View {
        COToolSection("Filters", toolID: "MetadataFilters") {
            VStack(alignment: .leading, spacing: 8) {
                // Active Filters Summary
                if hasActiveFilters {
                    HStack {
                        Circle().fill(CaptureOneTheme.Colors.activeHighlight).frame(width: 6, height: 6)
                        Text("Filters Active").font(.system(size: 10, weight: .semibold))
                        Spacer()
                        Button("Clear All") {
                            predicate = COFilterPredicate()
                        }
                        .buttonStyle(.plain)
                        .font(.system(size: 10))
                        .foregroundColor(CaptureOneTheme.Colors.activeHighlight)
                    }
                    .padding(.bottom, 4)
                }
                
                // Ratings Filter Row
                VStack(alignment: .leading, spacing: 4) {
                    Text("RATING").font(.system(size: 9, weight: .bold)).foregroundColor(.gray)
                    ForEach((0...5).reversed(), id: \.self) { rating in
                        filterRow(
                            label: rating == 0 ? "No Rating" : "\(rating) Stars",
                            count: 0, // Stub for numeric indicator
                            isActive: predicate.minRating == rating && (predicate.maxRating == rating || predicate.maxRating == nil),
                            onTap: {
                                if predicate.minRating == rating {
                                    predicate.minRating = nil
                                    predicate.maxRating = nil
                                } else {
                                    predicate.minRating = Int16(rating)
                                    predicate.maxRating = Int16(rating)
                                }
                            }
                        )
                    }
                }
                
                // Color Tags Filter Row
                VStack(alignment: .leading, spacing: 4) {
                    Text("COLOR TAG").font(.system(size: 9, weight: .bold)).foregroundColor(.gray)
                    ForEach(VariantBase.ColorTag.allCases.filter { $0 != .none }, id: \.self) { tag in
                        filterRow(
                            label: tag.displayName,
                            count: 0, // Stub
                            isActive: predicate.colorTags?.contains(tag.rawValue) ?? false,
                            onTap: {
                                var tags = predicate.colorTags ?? []
                                if let idx = tags.firstIndex(of: tag.rawValue) {
                                    tags.remove(at: idx)
                                } else {
                                    tags.append(tag.rawValue)
                                }
                                predicate.colorTags = tags.isEmpty ? nil : tags
                            },
                            tagColor: colorForTag(tag)
                        )
                    }
                }
                
                Divider().background(Color.white.opacity(0.05))
                
                Button(action: { isShowingFilterDialog = true }) {
                    HStack {
                        Spacer()
                        Text("Show/Hide Filters...")
                            .font(.system(size: 10))
                        Spacer()
                    }
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }
            .padding(.vertical, 4)
        }
    }
    
    private var hasActiveFilters: Bool {
        predicate.minRating != nil || (predicate.colorTags?.isEmpty == false) || predicate.searchText != nil
    }
    
    private func filterRow(label: String, count: Int, isActive: Bool, onTap: @escaping () -> Void, tagColor: Color? = nil) -> some View {
        HStack(spacing: 8) {
            if let color = tagColor {
                RoundedRectangle(cornerRadius: 2).fill(color).frame(width: 12, height: 12)
            } else {
                Image(systemName: isActive ? "checkmark.square.fill" : "square")
                    .font(.system(size: 10))
                    .foregroundColor(isActive ? CaptureOneTheme.Colors.activeHighlight : .gray)
            }
            
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(isActive ? .white : .white.opacity(0.7))
            
            Spacer()
            
            Text("\(count)")
                .font(.system(size: 10, design: .monospaced))
                .foregroundColor(.gray)
        }
        .padding(.vertical, 2)
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
    
    private func colorForTag(_ tag: VariantBase.ColorTag) -> Color {
        switch tag {
        case .none: return .clear
        case .red: return .red
        case .orange: return .orange
        case .yellow: return .yellow
        case .green: return .green
        case .blue: return .blue
        case .purple: return .purple
        case .pink: return .pink
        }
    }
}

extension VariantBase.ColorTag {
    var displayName: String {
        switch self {
        case .none: return "None"
        case .red: return "Red"
        case .orange: return "Orange"
        case .yellow: return "Yellow"
        case .green: return "Green"
        case .blue: return "Blue"
        case .purple: return "Purple"
        case .pink: return "Pink"
        }
    }
}
