import SwiftUI

public struct AppPreferencesView: View {
    @State private var selection: PreferencesSection = .general
    @Environment(\.dismiss) private var dismiss

    public init() {}

    public var body: some View {
        VStack(spacing: 0) {
            Picker("Preferences", selection: $selection) {
                ForEach(PreferencesSection.allCases, id: \.self) { section in
                    Text(section.title).tag(section)
                }
            }
            .pickerStyle(.segmented)
            .padding(16)

            Divider()

            Group {
                switch selection {
                case .general:
                    GeneralPreferencesPane()
                case .exposure:
                    ExposurePreferencesPane()
                        .padding(16)
                case .shortcuts:
                    ShortcutEditorView()
                        .padding(16)
                case .catalogAndSession:
                    CatalogAndSessionPreferencesView()
                        .padding(16)
                case .plugins:
                    PluginsPreferencesView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            Divider()

            HStack {
                Spacer()
                Button("Done") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(CaptureOneTheme.Colors.activeHighlight)
                .padding(16)
            }
        }
        .frame(minWidth: 760, minHeight: 520)
        .background(CaptureOneTheme.Colors.panelBackground)
        .foregroundColor(.white)
    }
}

private enum PreferencesSection: CaseIterable {
    case general
    case exposure
    case shortcuts
    case catalogAndSession
    case plugins

    var title: String {
        switch self {
        case .general:
            return "General"
        case .exposure:
            return "Exposure"
        case .shortcuts:
            return "Shortcuts"
        case .catalogAndSession:
            return "Catalog / Session"
        case .plugins:
            return "Plugins"
        }
    }
}

private struct GeneralPreferencesPane: View {
    @ObservedObject private var commands = AppCommandCenter.shared
    @ObservedObject private var beforeAfterController = COBeforeAfterToolController.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("General")
                .font(.title3.weight(.semibold))

            Toggle("Enable Before/After in Viewer", isOn: $beforeAfterController.isEnabled)
            Toggle("Show Grid Overlay", isOn: $commands.showGridOverlay)
            Toggle("Show Exposure Warning", isOn: $commands.showExposureWarning)
            Toggle("Show Focus Mask", isOn: $commands.showFocusMask)
            Toggle("Edit Selected Only", isOn: $commands.editSelectedOnly)

            Spacer()
        }
        .padding(20)
    }
}

private struct ExposurePreferencesPane: View {
    @ObservedObject private var controller = AdjustmentToolController.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Exposure Warnings")
                .font(.title3.weight(.semibold))
            
            VStack(alignment: .leading, spacing: 16) {
                // Highlights
                VStack(alignment: .leading, spacing: 8) {
                    Text("Highlight Warning").font(.headline)
                    HStack {
                        Slider(value: $controller.exposureHighlightThreshold, in: 155...255)
                            .accentColor(.red)
                        Text("\(Int(controller.exposureHighlightThreshold))")
                            .font(.system(size: 11, design: .monospaced))
                            .frame(width: 30)
                    }
                    ColorPicker("Highlight Color", selection: $controller.exposureHighlightColor)
                        .font(.system(size: 11))
                }
                
                Divider().background(Color.white.opacity(0.1))
                
                // Shadows
                VStack(alignment: .leading, spacing: 8) {
                    Text("Shadow Warning").font(.headline)
                    HStack {
                        Slider(value: $controller.exposureShadowThreshold, in: 0...100)
                            .accentColor(.blue)
                        Text("\(Int(controller.exposureShadowThreshold))")
                            .font(.system(size: 11, design: .monospaced))
                            .frame(width: 30)
                    }
                    ColorPicker("Shadow Color", selection: $controller.exposureShadowColor)
                        .font(.system(size: 11))
                }
            }
            .padding(16)
            .background(Color.white.opacity(0.03))
            .cornerRadius(8)
            
            Spacer()
        }
        .padding(20)
    }
}

private struct CatalogAndSessionPreferencesView: View {
    @AppStorage("COOpenInNewWindow") private var openInNewWindow: Bool = true
    @AppStorage("COEnableSessionFolders") private var enableSessionFolders: Bool = true
    @AppStorage("COIncludeOutputFolder") private var includeOutputFolder: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Catalog and Session")
                .font(.title3.weight(.semibold))
                
            VStack(alignment: .leading, spacing: 12) {
                Toggle("Open in new window", isOn: $openInNewWindow)
                Text("Changes to window behavior will take effect next time you open a document.")
                    .font(.caption)
                    .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    .padding(.leading, 24)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Session Defaults").font(.headline)
                Toggle("Enable Session Folders", isOn: $enableSessionFolders)
                Toggle("Include Output Folder", isOn: $includeOutputFolder)
            }
            
            Spacer()
        }
        .padding(20)
    }
}
