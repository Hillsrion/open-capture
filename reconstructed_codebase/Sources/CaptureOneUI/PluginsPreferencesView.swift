import SwiftUI
import AppCoreShared

/// Reconstructed Plugins Preferences Tab (INT-003).
/// Displays installed plugins and allows loading new ones.
public struct PluginsPreferencesView: View {
    @ObservedObject var pluginManager = COPluginManager.shared
    
    public init() {}
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Installed Plugins")
                .font(.headline)
            
            List {
                ForEach(pluginManager.installedPlugins) { plugin in
                    PluginRowView(plugin: plugin)
                }
                
                if pluginManager.installedPlugins.isEmpty {
                    Text("No plugins installed.")
                        .foregroundColor(.gray)
                        .italic()
                        .padding()
                }
            }
            .listStyle(PlainListStyle())
            .frame(height: 300)
            .border(Color.gray.opacity(0.3), width: 1)
            
            HStack {
                Button("Get More Plugins...") {
                    if let url = URL(string: "https://www.captureone.com/plugins") {
                        NSWorkspace.shared.open(url)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.white.opacity(0.1))
                .cornerRadius(4)
                
                Spacer()
                
                Button("Load Plugin...") {
                    let panel = NSOpenPanel()
                    panel.allowedContentTypes = [.bundle] // Mocking .coplugin support
                    panel.canChooseDirectories = false
                    panel.canChooseFiles = true
                    panel.title = "Select a Capture One Plugin"
                    
                    if panel.runModal() == .OK, let url = panel.url {
                        do {
                            try pluginManager.installPlugin(from: url)
                        } catch {
                            print("[UI] Failed to install plugin: \(error)")
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(CaptureOneTheme.Colors.activeHighlight)
                .cornerRadius(4)
            }
        }
        .padding(20)
        .frame(width: 500)
        .background(CaptureOneTheme.Colors.panelBackground)
        .foregroundColor(.white)
        .onAppear {
            pluginManager.discoverPlugins()
        }
    }
}

struct PluginRowView: View {
    let plugin: COPlugin
    
    var body: some View {
        HStack(spacing: 12) {
            // Mock Icon
            Image(systemName: iconForType(plugin.type))
                .font(.system(size: 24))
                .frame(width: 40, height: 40)
                .background(Color.white.opacity(0.05))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(plugin.name)
                    .font(.system(size: 14, weight: .semibold))
                
                HStack(spacing: 8) {
                    Text("Version \(plugin.version)")
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                    
                    Text(plugin.type.rawValue)
                        .font(.system(size: 10))
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(4)
                }
            }
            
            Spacer()
            
            // Mock Status
            Circle()
                .fill(Color.green)
                .frame(width: 8, height: 8)
            Text("Enabled")
                .font(.system(size: 11))
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
    
    private func iconForType(_ type: COPlugin.PluginType) -> String {
        switch type {
        case .export: return "square.and.arrow.up"
        case .publish: return "network"
        case .utility: return "wrench.and.screwdriver"
        case .system: return "gearshape"
        }
    }
}
