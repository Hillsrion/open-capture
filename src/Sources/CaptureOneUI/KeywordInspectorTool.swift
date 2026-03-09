import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Keyword Library tool (CORE-005).
public struct KeywordInspectorTool: View {
    @ObservedObject var cache: DocumentKeywordCache
    @State private var searchText: String = ""
    
    public init(cache: DocumentKeywordCache) {
        self.cache = cache
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            COToolSection("Keywords") {
                VStack(spacing: 8) {
                    // Search / Add Field
                    HStack {
                        Image(systemName: "magnifyingglass").font(.system(size: 10))
                        TextField("Filter or add keyword...", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                            .font(.system(size: 11))
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                let _ = cache.library.addKeyword(name: searchText)
                                searchText = ""
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(CaptureOneTheme.Colors.activeHighlight)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(6)
                    .background(Color.black.opacity(0.2))
                    .cornerRadius(4)
                    
                    // Hierarchical List
                    let treeItems = cache.library.keywords.filter { $0.parentID == nil }.compactMap { root in
                        mapEntryToTree(root)
                    }
                    
                    let filteredItems = searchText.isEmpty ? treeItems : treeItems.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
                    
                    List(filteredItems, children: \.children) { item in
                        HStack {
                            Image(systemName: item.children != nil ? "folder.fill" : "tag.fill")
                                .font(.system(size: 10))
                                .foregroundColor(.gray)
                            
                            Text(item.name)
                                .font(.system(size: 11))
                            
                            Spacer()
                            
                            // Checkbox simulated for "assigned to current variant"
                            Image(systemName: "square")
                                .font(.system(size: 10))
                        }
                        .padding(.vertical, 2)
                    }
                    .listStyle(SidebarListStyle())
                    .frame(minHeight: 250)
                }
            }
        }
    }
    
    private func mapEntryToTree(_ entry: KeywordEntry) -> StyleTreeItem {
        let children = cache.library.children(of: entry)
        let childItems = children.isEmpty ? nil : children.map { mapEntryToTree($0) }
        return StyleTreeItem(name: entry.name, isFolder: !children.isEmpty, children: childItems)
    }
}
