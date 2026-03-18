import SwiftUI
import AppCoreShared
import DataCore

public struct FilterToolView: View {
    @Binding var predicate: COFilterPredicate
    @State private var isShowingFilterDialog = false
    
    @ObservedObject var commands = AppCommandCenter.shared
    @State private var ratingCounts: [Int: Int] = [:]
    @State private var colorTagCounts: [VariantBase.ColorTag: Int] = [:]
    
    // For visual drop feedback
    @State private var targetedRating: Int? = nil
    @State private var targetedColorTag: VariantBase.ColorTag? = nil

    public init(predicate: Binding<COFilterPredicate>) {
        self._predicate = predicate
    }
    
    public var body: some View {
        COToolSection("Filters", toolID: "MetadataFilters") {
            VStack(alignment: .leading, spacing: 8) {
                activeFiltersHeader
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("RATING").font(.system(size: 9, weight: .bold)).foregroundColor(.gray)
                    ForEach((0...5).reversed(), id: \.self) { value in
                        ratingRow(value: value)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("COLOR TAG").font(.system(size: 9, weight: .bold)).foregroundColor(.gray)
                    colorTagRow(tag: .red, name: "Red")
                    colorTagRow(tag: .orange, name: "Orange")
                    colorTagRow(tag: .yellow, name: "Yellow")
                    colorTagRow(tag: .green, name: "Green")
                    colorTagRow(tag: .blue, name: "Blue")
                    colorTagRow(tag: .purple, name: "Purple")
                    colorTagRow(tag: .pink, name: "Pink")
                }
                
                Divider().background(Color.white.opacity(0.05))
                
                showHideButton
            }
            .padding(.vertical, 4)
            .onAppear { calculateCounts() }
            .onReceive(commands.browser.$dataSource) { _ in calculateCounts() }
            .onReceive(NotificationCenter.default.publisher(for: .DCVariantMetadataDidChange)) { _ in calculateCounts() }
        }
    }
    
    private func calculateCounts() {
        var newRatingCounts: [Int: Int] = [:]
        var newColorCounts: [VariantBase.ColorTag: Int] = [:]
        
        let variants = commands.browser.dataSource.compactMap { $0.primaryVariant }
        
        for variant in variants {
            let r = variant.rating
            newRatingCounts[r, default: 0] += 1
            
            let c = variant.colorTag
            if c != .none {
                newColorCounts[c, default: 0] += 1
            }
        }
        
        ratingCounts = newRatingCounts
        colorTagCounts = newColorCounts
    }
    
    private var activeFiltersHeader: some View {
        Group {
            if hasActiveFilters {
                HStack {
                    Circle().fill(CaptureOneTheme.Colors.activeHighlight).frame(width: 6, height: 6)
                    Text("Filters Active").font(.system(size: 10, weight: .semibold))
                    Spacer()
                    Button("Clear All") { predicate = COFilterPredicate() }
                        .buttonStyle(.plain)
                        .font(.system(size: 10))
                        .foregroundColor(CaptureOneTheme.Colors.activeHighlight)
                }
                .padding(.bottom, 4)
            }
        }
    }
    
    private func ratingRow(value: Int) -> some View {
        let isMatch = predicate.minRating == value
        return filterRow(
            label: value == 0 ? "No Rating" : (value == 1 ? "1 Star" : "\(value) Stars"),
            count: ratingCounts[value] ?? 0,
            isActive: isMatch,
            isTargeted: targetedRating == value,
            onTap: { toggleRating(value) }
        )
        .onDrop(of: [.text], isTargeted: Binding(
            get: { targetedRating == value },
            set: { targeted in targetedRating = targeted ? value : nil }
        )) { providers in
            handleDrop(providers: providers, targetRating: value)
        }
    }
    
    private func colorTagRow(tag: VariantBase.ColorTag, name: String) -> some View {
        let isActive = predicate.colorTags?.contains(tag.rawValue) ?? false
        return filterRow(
            label: name,
            count: colorTagCounts[tag] ?? 0,
            isActive: isActive,
            isTargeted: targetedColorTag == tag,
            onTap: { toggleColorTag(tag.rawValue) },
            tagColor: colorForTag(tag)
        )
        .onDrop(of: [.text], isTargeted: Binding(
            get: { targetedColorTag == tag },
            set: { targeted in targetedColorTag = targeted ? tag : nil }
        )) { providers in
            handleDrop(providers: providers, targetColorTag: tag)
        }
    }
    
    private var hasActiveFilters: Bool {
        predicate.minRating != nil || (predicate.colorTags?.isEmpty == false) || predicate.searchText != nil
    }
    
    private func toggleRating(_ r: Int) {
        if predicate.minRating == r {
            predicate.minRating = nil
            predicate.maxRating = nil
        } else {
            predicate.minRating = r
            predicate.maxRating = r
        }
    }
    
    private func toggleColorTag(_ tagValue: Int) {
        var tags = predicate.colorTags ?? []
        if let idx = tags.firstIndex(of: tagValue) {
            tags.remove(at: idx)
        } else {
            tags.append(tagValue)
        }
        predicate.colorTags = tags.isEmpty ? nil : tags
    }
    
    private var showHideButton: some View {
        Button(action: { isShowingFilterDialog = true }) {
            HStack {
                Spacer()
                Text("Show/Hide Filters...").font(.system(size: 10))
                Spacer()
            }
        }
        .buttonStyle(.bordered)
        .controlSize(.small)
    }
    
    private func filterRow(label: String, count: Int, isActive: Bool, isTargeted: Bool = false, onTap: @escaping () -> Void, tagColor: Color? = nil) -> some View {
        HStack(spacing: 8) {
            if let color = tagColor {
                RoundedRectangle(cornerRadius: 2).fill(color).frame(width: 12, height: 12)
            } else {
                Image(systemName: isActive ? "checkmark.square.fill" : "square")
                    .font(.system(size: 10))
                    .foregroundColor(isActive || isTargeted ? CaptureOneTheme.Colors.activeHighlight : .gray)
            }
            Text(label).font(.system(size: 11)).foregroundColor(isActive || isTargeted ? .white : .white.opacity(0.7))
            Spacer()
            Text("\(count)").font(.system(size: 10, design: .monospaced)).foregroundColor(.gray)
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(isTargeted ? CaptureOneTheme.Colors.activeHighlight.opacity(0.3) : Color.clear)
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
    
    private func handleDrop(providers: [NSItemProvider], targetRating: Int? = nil, targetColorTag: VariantBase.ColorTag? = nil) -> Bool {
        for provider in providers {
            provider.loadObject(ofClass: NSString.self) { (uuid, error) in
                guard let variantUUID = uuid as? String else { return }
                
                DispatchQueue.main.async {
                    if let image = commands.browser.dataSource.first(where: { $0.primaryVariant?.variantUUID == variantUUID }),
                       let variant = image.primaryVariant {
                        withAnimation {
                            if let rating = targetRating {
                                variant.rating = rating
                            }
                            if let tag = targetColorTag {
                                variant.colorTag = tag
                            }
                        }
                    }
                }
            }
        }
        return true
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
