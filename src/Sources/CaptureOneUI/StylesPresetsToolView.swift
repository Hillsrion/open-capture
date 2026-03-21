import SwiftUI
import AppCoreShared

/// Reconstructed Styles & Presets Tool View (Reference: 0xolTuhFkBk).
/// Provides a unified interface for global Styles and tool-specific Presets.
/// Features Hover Preview and a "Save Custom Style" dialog.
public struct StylesPresetsToolView: View {
    @ObservedObject var controller = AdjustmentToolController.shared
    @ObservedObject var styleManager = COStyleManager.shared
    @ObservedObject var presetManager = COPresetManager.shared
    @ObservedObject var hoverService = COStyleHoverPreviewService.shared
    
    @State private var showingSaveDialog = false
    @State private var expandedStyles = true
    @State private var expandedPresets = true
    
    public init() {}
    
    public var body: some View {
        COToolSection("Styles & Presets", toolID: "StylesPresets") {
            VStack(spacing: 0) {
                // Actions Header
                HStack {
                    Button(action: { showingSaveDialog = true }) {
                        Image(systemName: "plus")
                            .font(.system(size: 10, weight: .bold))
                        Text("Save Custom Style...")
                            .font(.system(size: 11))
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(CaptureOneTheme.Colors.activeHighlight)
                    
                    Spacer()
                    
                    Toggle("Stack Styles", isOn: $controller.stackCOStyles)
                        .toggleStyle(CheckboxToggleStyle())
                        .font(.system(size: 10))
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
                
                Divider().background(Color.white.opacity(0.1))
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 1) {
                        // Styles Section
                        DisclosureGroup(isExpanded: $expandedStyles) {
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(styleManager.stylePacks) { pack in
                                    StylePackSection(pack: pack)
                                }
                                StylePackSection(pack: styleManager.userCOStyles)
                            }
                            .padding(.leading, 8)
                        } label: {
                            Text("STYLES")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                                .padding(.vertical, 4)
                        }
                        .accentColor(CaptureOneTheme.Colors.textSecondary)
                        
                        // Presets Section
                        DisclosureGroup(isExpanded: $expandedPresets) {
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(presetManager.presetsByTool.keys.sorted(), id: \.self) { toolID in
                                    if let presets = presetManager.presetsByTool[toolID] {
                                        PresetToolSection(toolID: toolID, presets: presets)
                                    }
                                }
                            }
                            .padding(.leading, 8)
                        } label: {
                            Text("PRESETS")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                                .padding(.vertical, 4)
                        }
                        .accentColor(CaptureOneTheme.Colors.textSecondary)
                    }
                    .padding(.horizontal, 4)
                }
                .frame(minHeight: 300, maxHeight: 600)
                
                // Style Opacity (Global)
                VStack(spacing: 4) {
                    HStack {
                        Text("Style Opacity")
                            .font(.system(size: 10))
                            .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                        Spacer()
                        Text("\(Int(controller.styleOpacity))%")
                            .font(.system(size: 10, design: .monospaced))
                    }
                    Slider(value: $controller.styleOpacity, in: 0...100)
                        .accentColor(CaptureOneTheme.Colors.activeHighlight)
                }
                .padding(8)
                .background(Color.black.opacity(0.1))
            }
        }
        .sheet(isPresented: $showingSaveDialog) {
            SaveStyleDialog()
        }
    }
}

private struct StylePackSection: View {
    let pack: StylePack
    @State private var isExpanded = false
    
    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(pack.styles) { style in
                    StyleRow(style: style)
                }
            }
            .padding(.leading, 8)
        } label: {
            HStack {
                Image(systemName: "folder.fill")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                Text(pack.name)
                    .font(.system(size: 11))
                Spacer()
            }
            .padding(.vertical, 2)
        }
        .accentColor(.gray)
    }
}

private struct StyleRow: View {
    let style: COStyle
    @State private var isHovered = false
    @ObservedObject var controller = AdjustmentToolController.shared
    @ObservedObject var hoverService = COStyleHoverPreviewService.shared
    
    var body: some View {
        HStack {
            Text(style.name)
                .font(.system(size: 11))
                .foregroundColor(isHovered ? .white : CaptureOneTheme.Colors.textPrimary)
            Spacer()
        }
        .padding(.vertical, 3)
        .padding(.horizontal, 4)
        .background(isHovered ? CaptureOneTheme.Colors.activeHighlight.opacity(0.3) : Color.clear)
        .contentShape(Rectangle())
        .onTapGesture {
            controller.applyCOStyle(style)
        }
        .onHover { hovering in
            isHovered = hovering
            if hovering {
                hoverService.startPreviewing(style, variant: controller.currentVariant)
            } else {
                hoverService.stopPreviewing(variant: controller.currentVariant)
            }
        }
    }
}

private struct PresetToolSection: View {
    let toolID: String
    let presets: [COPresetManager.COPreset]
    @State private var isExpanded = false
    
    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(presets) { preset in
                    PresetRow(preset: preset)
                }
            }
            .padding(.leading, 8)
        } label: {
            Text(toolID)
                .font(.system(size: 11))
                .padding(.vertical, 2)
        }
        .accentColor(.gray)
    }
}

private struct PresetRow: View {
    let preset: COPresetManager.COPreset
    @State private var isHovered = false
    @ObservedObject var controller = AdjustmentToolController.shared
    
    var body: some View {
        HStack {
            Text(preset.name)
                .font(.system(size: 11))
                .foregroundColor(isHovered ? .white : CaptureOneTheme.Colors.textPrimary)
            Spacer()
        }
        .padding(.vertical, 3)
        .padding(.horizontal, 4)
        .background(isHovered ? Color.white.opacity(0.1) : Color.clear)
        .contentShape(Rectangle())
        .onTapGesture {
            presetManagerApply()
        }
    }
    
    private func presetManagerApply() {
        if let variant = controller.currentVariant {
            COPresetManager.shared.applyPreset(preset, to: variant)
            controller.refreshToolValues()
        }
    }
}
