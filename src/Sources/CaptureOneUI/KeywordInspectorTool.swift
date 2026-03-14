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
            COToolSection("Keyword Library", toolID: "KeywordLibrary") {
                VStack(spacing: 8) {
                    // Search / Add Field
                    HStack {
                        Image(systemName: "magnifyingglass").font(.system(size: 10))
                        TextField("Filter or add keyword...", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                            .font(.system(size: 11))
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                cache.library.addKeyword(at: searchText)
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
                    
                    // Hierarchical List using new KeywordLibrary structure
                    let rootKeywords = cache.library.rootKeywords
                    let filteredItems = searchText.isEmpty ? rootKeywords : rootKeywords.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
                    
                    List(filteredItems, children: \.children) { item in
                        HStack {
                            Image(systemName: (item.children != nil && !item.children!.isEmpty) ? "folder.fill" : "tag.fill")
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
}
