import SwiftUI
import AppCoreShared

/// Reconstructed Keyword Library Tool (UI-405).
/// Matches Capture One 16.7 specifications for hierarchical keyword management.
public struct KeywordLibraryToolView: View {
    @ObservedObject var library = KeywordLibrary()
    @State private var searchText: String = ""
    @State private var showImportDialog = false
    
    public init() {
        // Sample data for visual testing
        library.addKeyword(at: "People > Family")
        library.addKeyword(at: "People > Friends")
        library.addKeyword(at: "Places > France > Paris")
        library.addKeyword(at: "Places > USA > New York")
        library.addKeyword(at: "Nature > Landscape")
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Search & Tools
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                    TextField("Search Keywords", text: $searchText)
                        .font(.system(size: 11))
                        .textFieldStyle(.plain)
                }
                .padding(4)
                .background(Color.white.opacity(0.05))
                .cornerRadius(4)
                
                Button(action: { showImportDialog = true }) {
                    Image(systemName: "square.and.arrow.down")
                        .font(.system(size: 12))
                }
                .buttonStyle(.plain)
            }
            .padding(10)
            .background(CaptureOneTheme.Colors.panelBackground)
            
            Divider().background(Color.black)
            
            // Hierarchical List
            List {
                OutlineGroup(library.rootKeywords, children: \.children) { keyword in
                    KeywordRow(keyword: keyword)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            .listStyle(.sidebar)
            .scrollContentBackground(.hidden)
            .background(CaptureOneTheme.Colors.panelBackground)
            
            // Bottom Action Bar
            HStack {
                Button(action: {}) {
                    Image(systemName: "plus")
                        .font(.system(size: 12))
                }
                Button(action: {}) {
                    Image(systemName: "minus")
                        .font(.system(size: 12))
                }
                Spacer()
                Text("\(totalKeywordsCount) Keywords")
                    .font(.system(size: 9))
                    .foregroundColor(.gray)
            }
            .padding(8)
            .background(CaptureOneTheme.Colors.panelBackground)
        }
    }
    
    private var totalKeywordsCount: Int {
        // Simple recursive count
        return library.rootKeywords.count // Placeholder
    }
}

private struct KeywordRow: View {
    @ObservedObject var keyword: KeywordEntry
    @State private var isChecked = false
    
    var body: some View {
        HStack(spacing: 6) {
            Toggle("", isOn: $isChecked)
                .toggleStyle(CheckboxToggleStyle())
            
            Text(keyword.name)
                .font(.system(size: 11))
                .foregroundColor(.white)
            
            Spacer()
            
            if !keyword.children.isEmpty {
                Text("\(keyword.children.count)")
                    .font(.system(size: 9))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 4)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(4)
            }
        }
        .padding(.vertical, 2)
    }
}

/// Custom C1-style checkbox
struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: { configuration.isOn.toggle() }) {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .font(.system(size: 12))
                .foregroundColor(configuration.isOn ? .orange : .gray)
        }
        .buttonStyle(.plain)
    }
}
