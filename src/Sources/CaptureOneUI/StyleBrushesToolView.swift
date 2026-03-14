import SwiftUI
import AppCoreShared

/// Reconstructed Style Brushes Tool View.
/// Provides a vertical list of brush presets organized by effect.
public struct StyleBrushesToolView: View {
    @ObservedObject var brushManager = BrushSettingsManager.shared
    @ObservedObject var commands = AppCommandCenter.shared
    
    // Mock list of style brushes based on C1 specification
    let brushCategories = [
        ("Color", ["Deep Sky", "Warm Sunshine", "Cool Shadow"]),
        ("Exposure", ["Dodge (Brighten)", "Burn (Darken)", "High Contrast"]),
        ("Enhancements", ["Teeth Whitening", "Iris Brighten", "Skin Smoothing"])
    ]
    
    public init() {}
    
    public var body: some View {
        COToolSection("Style Brushes", toolID: "StyleBrushes") {
            VStack(alignment: .leading, spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(brushCategories, id: \.0) { category in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(category.0)
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                                    .padding(.horizontal, 8)
                                    .padding(.top, 4)
                                
                                ForEach(category.1, id: \.self) { brushName in
                                    StyleBrushRow(name: brushName, isSelected: brushManager.activeStyleBrush == brushName) {
                                        brushManager.activeStyleBrush = brushName
                                        // Activating a style brush automatically selects the draw mask tool
                                        commands.selectedCursorToolID = "DrawMask" // Assuming DrawMask is the ID
                                        // Auto-layering logic would be handled at the command/controller level when drawing starts
                                    }
                                }
                            }
                        }
                    }
                    .padding(.bottom, 8)
                }
                .frame(maxHeight: 250) // Restrict height for the tool section
                
                Divider().background(Color.white.opacity(0.1))
                
                // Link Brush Settings checkbox
                Toggle(isOn: $brushManager.linkBrushSettings) {
                    Text("Link Brush Settings")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                }
                .toggleStyle(CheckboxToggleStyle())
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
            }
        }
    }
}

private struct StyleBrushRow: View {
    let name: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "paintbrush.fill")
                    .font(.system(size: 10))
                    .foregroundColor(isSelected ? CaptureOneTheme.Colors.activeHighlight : .gray)
                
                Text(name)
                    .font(.system(size: 11))
                    .foregroundColor(isSelected ? .white : CaptureOneTheme.Colors.textPrimary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(CaptureOneTheme.Colors.activeHighlight)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(isSelected ? Color.white.opacity(0.1) : Color.clear)
            .cornerRadius(4)
        }
        .buttonStyle(.plain)
    }
}
