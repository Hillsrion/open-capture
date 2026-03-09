import Foundation

/// Reconstructed Manager for Plugin Discovery and Loading (INT-003).
/// Based on COPluginManager from PluginCore.
public class COPluginManager: ObservableObject {
    public static let shared = COPluginManager()
    
    @Published public private(set) var installedPlugins: [COPlugin] = []
    
    /// Simulated paths where Capture One looks for plugins.
    private let pluginsPaths: [URL] = [
        FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!.appendingPathComponent("Capture One/Plug-ins"),
        URL(fileURLWithPath: "/Library/Application Support/Capture One/Plug-ins")
    ]
    
    public init() {
        // Initialize with empty state. `discoverPlugins` should be called explicitly or at launch.
    }
    
    /// Scans the plugin paths for .coplugin bundles and loads them.
    public func discoverPlugins() {
        var discovered: [COPlugin] = []
        
        let fm = FileManager.default
        for path in pluginsPaths {
            guard let contents = try? fm.contentsOfDirectory(at: path, includingPropertiesForKeys: [.isDirectoryKey], options: .skipsHiddenFiles) else {
                continue
            }
            
            for item in contents {
                if item.pathExtension.lowercased() == "coplugin" {
                    if let plugin = loadPlugin(from: item) {
                        discovered.append(plugin)
                    }
                }
            }
        }
        
        // Add a mock plugin for UI testing if none are found
        if discovered.isEmpty {
            discovered.append(COPlugin(
                id: "com.example.mockplugin",
                name: "Mock Frame.io Plugin",
                version: "1.0.0",
                path: URL(fileURLWithPath: "/Mock/Path/Frameio.coplugin"),
                type: .publish
            ))
            discovered.append(COPlugin(
                id: "com.captureone.openwith",
                name: "Open With",
                version: "2.1",
                path: URL(fileURLWithPath: "/Mock/Path/OpenWith.coplugin"),
                type: .system
            ))
        }
        
        DispatchQueue.main.async {
            self.installedPlugins = discovered
        }
    }
    
    /// Parses a .coplugin bundle's Info.plist to create a COPlugin model.
    private func loadPlugin(from bundleURL: URL) -> COPlugin? {
        let infoPlistURL = bundleURL.appendingPathComponent("Contents/Info.plist")
        
        guard let data = try? Data(contentsOf: infoPlistURL),
              let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] else {
            print("[PluginManager] Failed to read Info.plist for \(bundleURL.lastPathComponent)")
            return nil
        }
        
        let id = plist["CFBundleIdentifier"] as? String ?? UUID().uuidString
        let name = plist["CFBundleName"] as? String ?? bundleURL.deletingPathExtension().lastPathComponent
        let version = plist["CFBundleShortVersionString"] as? String ?? "1.0"
        
        // Infer type from a hypothetical specific key, defaulting to utility
        let typeString = plist["COPluginType"] as? String ?? "Utility"
        let type = COPlugin.PluginType(rawValue: typeString) ?? .utility
        
        print("[PluginManager] Loaded Plugin: \(name) v\(version)")
        return COPlugin(id: id, name: name, version: version, path: bundleURL, type: type)
    }
    
    /// Simulates installing a new plugin from a zip or bundle.
    public func installPlugin(from sourceURL: URL) throws {
        // In reality, this unzips to ~/Library/Application Support/Capture One/Plug-ins/
        print("[PluginManager] Simulating installation of \(sourceURL.lastPathComponent)")
        discoverPlugins() // Refresh list
    }
}
