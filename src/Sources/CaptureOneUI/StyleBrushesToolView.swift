import SwiftUI
import AppCoreShared

/// Reconstructed Style Brushes Tool View (Reference: C1-034).
/// Provides a vertical list of brush presets organized by category.
/// Selecting a brush automatically configures the tool and manages layers.
public struct StyleBrushesToolView: View {
    @ObservedObject var controller = COStyleBrushBrowserController.shared
    @ObservedObject var brushManager = BrushSettingsManager.shared
    @ObservedObject var commands = AppCommandCenter.shared
    @ObservedObject var adjustmentController = AdjustmentToolController.shared
    
    public init() {}
    
    // Group brushes by category for the accordion list
    private var groupedBrushes: [String: [COStyleBrushModel]] {
        Dictionary(grouping: controller.availableBrushes, by: { $0.category })
    }
    
    private var categories: [String] {
        ["Exposure", "Color", "Enhancements"] // Fixed order per C1 spec
    }
    
    public var body: some View {
        COToolSection("Style Brushes", toolID: "StyleBrushes") {
            VStack(alignment: .leading, spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(categories, id: \.self) { category in
                            if let brushes = groupedBrushes[category] {
                                CategorySection(
                                    title: category,
                                    brushes: brushes,
                                    activeStyleBrush: brushManager.activeStyleBrush,
                                    onSelect: { brush in
                                        if let variant = adjustmentController.currentVariant {
                                            controller.selectBrush(brush, for: variant)
                                            // Activating a style brush automatically selects the draw mask tool
                                            commands.selectedCursorToolID = "DrawMask"
                                        }
                                    }
                                )
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                .frame(maxHeight: 300)
                
                Divider().background(Color.white.opacity(0.1))
                
                // Cumulative behavior indicator/settings
                HStack {
                    Toggle(isOn: $brushManager.linkBrushSettings) {
                        Text("Link Brush Settings")
                            .font(.system(size: 11))
                            .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    }
                    .toggleStyle(CheckboxToggleStyle())
                    
                    Spacer()
                    
                    if let active = brushManager.activeStyleBrush {
                        Text("Active: \(active)")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(CaptureOneTheme.Colors.activeHighlight)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
            }
        }
    }
}

private struct CategorySection: View {
    let title: String
    let brushes: [COStyleBrushModel]
    let activeStyleBrush: String?
    let onSelect: (COStyleBrushModel) -> Void
    
    @State private var isExpanded: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Button(action: { withAnimation { isExpanded.toggle() } }) {
                HStack {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .font(.system(size: 8, weight: .bold))
                    Text(title.uppercased())
                        .font(.system(size: 10, weight: .bold))
                    Spacer()
                }
                .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                .padding(.horizontal, 8)
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 1) {
                    ForEach(brushes) { brush in
                        StyleBrushRow(
                            brush: brush,
                            isSelected: activeStyleBrush == brush.name,
                            action: { onSelect(brush) }
                        )
                    }
                }
                .padding(.leading, 4)
            }
        }
    }
}

private struct StyleBrushRow: View {
    let brush: COStyleBrushModel
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "paintbrush.fill")
                    .font(.system(size: 10))
                    .foregroundColor(isSelected ? CaptureOneTheme.Colors.activeHighlight : .gray.opacity(0.6))
                
                Text(brush.name)
                    .font(.system(size: 11))
                    .foregroundColor(isSelected ? .white : CaptureOneTheme.Colors.textPrimary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(CaptureOneTheme.Colors.activeHighlight)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(isSelected ? Color.white.opacity(0.1) : (isHovered ? Color.white.opacity(0.05) : Color.clear))
            .cornerRadius(4)
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}
