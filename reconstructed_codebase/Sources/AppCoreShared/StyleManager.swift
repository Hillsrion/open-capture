import Foundation

/// Reconstructed hierarchical item for the Styles Browser (UI-010).
public struct StyleTreeItem: Identifiable {
    public let id: String
    public let name: String
    public let isFolder: Bool
    public var children: [StyleTreeItem]?
    public let style: Style?
    
    public init(name: String, isFolder: Bool, children: [StyleTreeItem]? = nil, style: Style? = nil) {
        self.id = style?.id.uuidString ?? UUID().uuidString
        self.name = name
        self.isFolder = isFolder
        self.children = children
        self.style = style
    }
}

/// Reconstructed central manager for Styles & Presets (AppCoreShared).
public class StyleManager: ObservableObject {
    public static let shared = StyleManager()
    
    @Published public var builtInStyles: StylePack
    @Published public var userStyles: StylePack
    
    public init() {
        // Mocking some default styles based on v16.5 built-ins
        let bwPack = StylePack(name: "Black & White", styles: [
            Style(name: "B&W High Contrast", adjustments: ["ZCONTRAST": AnyCodable(50.0), "ZSATURATION": AnyCodable(-100.0)]),
            Style(name: "B&W Soft", adjustments: ["ZCONTRAST": AnyCodable(-20.0), "ZSATURATION": AnyCodable(-100.0)])
        ])
        
        let cinematicPack = StylePack(name: "Cinematic", styles: [
            Style(name: "Teal & Orange", adjustments: ["ZKELVIN": AnyCodable(6500.0), "ZTINT": AnyCodable(10.0)])
        ])
        
        self.builtInStyles = StylePack(name: "Built-in Styles", childPacks: [bwPack, cinematicPack])
        self.userStyles = StylePack(name: "User Styles")
    }
    
    /// Returns the full tree for the browser.
    public func getStyleTree() -> [StyleTreeItem] {
        return [
            mapPackToTree(builtInStyles),
            mapPackToTree(userStyles)
        ]
    }
    
    private func mapPackToTree(_ pack: StylePack) -> StyleTreeItem {
        var children: [StyleTreeItem] = []
        
        // Add sub-packs
        for childPack in pack.childPacks {
            children.append(mapPackToTree(childPack))
        }
        
        // Add styles
        for style in pack.styles {
            children.append(StyleTreeItem(name: style.name, isFolder: false, style: style))
        }
        
        return StyleTreeItem(name: pack.name, isFolder: true, children: children)
    }
}
