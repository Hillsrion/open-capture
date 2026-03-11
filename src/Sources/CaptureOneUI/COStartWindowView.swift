import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Start Window (Select Document) for Capture One 16.7.
/// Matches the "Classic Recents" layout described:
/// - Header: "Recents"
/// - List: Recent Catalogs and Sessions
/// - Bottom Left: [New Catalog...] [New Session...] [Browse...]
/// - Bottom Right: [Cancel] [Open]
public struct COStartWindowView: View {
    @ObservedObject var commands = AppCommandCenter.shared
    @ObservedObject var recentManager = CORecentDocumentManager.shared
    @State private var selectedDocumentID: String? = nil
    
    public init() {}
    
    private var recentDocuments: [RecentDocument] {
        recentManager.recentDocuments.map { record in
            RecentDocument(
                id: record.path,
                name: record.name,
                path: record.path,
                type: record.type.rawValue,
                lastOpened: record.lastOpened
            )
        }
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header
            HStack {
                Text("Recents")
                    .font(.system(size: 24, weight: .regular))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .padding(.bottom, 16)
            
            Divider().background(Color.black.opacity(0.5))
            
            // MARK: - Recents List
            ScrollView {
                if recentDocuments.isEmpty {
                    VStack(spacing: 20) {
                        Spacer().frame(height: 60)
                        Image(systemName: "doc.on.doc")
                            .font(.system(size: 48))
                            .foregroundColor(.gray.opacity(0.3))
                        Text("No Recent Documents")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    VStack(spacing: 1) {
                        ForEach(recentDocuments) { doc in
                            RecentDocumentRow(doc: doc, isSelected: selectedDocumentID == doc.id)
                                .onTapGesture {
                                    selectedDocumentID = doc.id
                                }
                                .simultaneousGesture(TapGesture(count: 2).onEnded {
                                    selectedDocumentID = doc.id // Ensure selected
                                    openSelected()
                                })
                        }
                    }
                }
            }
            .background(Color(white: 0.10))
            
            Divider().background(Color.black)
            
            // MARK: - Bottom Action Bar
            HStack(spacing: 12) {
                // Left Actions
                HStack(spacing: 8) {
                    Button("New Catalog...") {
                        AppCommandCenter.shared.newCatalog()
                    }
                    .buttonStyle(StartButtonStyle())
                    
                    Button("New Session...") {
                        AppCommandCenter.shared.newSession()
                    }
                    .buttonStyle(StartButtonStyle())
                    
                    Button("Browse...") {
                        AppCommandCenter.shared.openDocument()
                    }
                    .buttonStyle(StartButtonStyle())
                }
                
                Spacer()
                
                // Right Actions
                HStack(spacing: 12) {
                    Button("Cancel") {
                        NSApp.terminate(nil)
                    }
                    .buttonStyle(StartButtonStyle())
                    
                    Button("Open") {
                        openSelected()
                    }
                    .buttonStyle(PrimaryStartButtonStyle())
                    .disabled(selectedDocumentID == nil)
                }
            }
            .padding(.horizontal, 20)
            .frame(height: 60)
            .background(CaptureOneTheme.Colors.panelBackground)
        }
        .frame(width: 700, height: 450)
        .background(CaptureOneTheme.Colors.applicationBackground)
        .preferredColorScheme(.dark)
        .sheet(item: $commands.presentedSheet) { route in
            sheetView(for: route)
        }
    }
    
    @ViewBuilder
    private func sheetView(for route: AppSheetRoute) -> some View {
        switch route {
        case .newCatalog:
            CONewCatalogView()
        case .newSession:
            CONewSessionView()
        default:
            EmptyView()
        }
    }
    
    private func openSelected() {
        guard let id = selectedDocumentID,
              let doc = recentDocuments.first(where: { $0.id == id }) else { return }
        print("[StartWindow] Opening: \(doc.name)")
        AppCommandCenter.shared.openDocument(at: URL(fileURLWithPath: doc.path))
    }
}

// MARK: - Supporting Types

struct RecentDocument: Identifiable {
    let id: String
    let name: String
    let path: String
    let type: String // "Catalog" or "Session"
    let lastOpened: Date
}

struct RecentDocumentRow: View {
    let doc: RecentDocument
    let isSelected: Bool
    
    private var displayName: String {
        URL(fileURLWithPath: doc.path).deletingPathExtension().lastPathComponent
    }
    
    private var displayPath: String {
        URL(fileURLWithPath: doc.path).deletingLastPathComponent().path
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: doc.type == "Catalog" ? "archivebox.fill" : "folder.fill")
                .foregroundColor(isSelected ? .white : .gray)
                .font(.system(size: 18))
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(displayName)
                    .font(.system(size: 13, weight: isSelected ? .semibold : .medium))
                    .foregroundColor(isSelected ? .white : .white.opacity(0.9))
                Text(displayPath)
                    .font(.system(size: 11))
                    .foregroundColor(isSelected ? .white.opacity(0.8) : .gray)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
            
            Spacer()
            
            Text(doc.type.uppercased())
                .font(.system(size: 9, weight: .bold))
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(isSelected ? Color.white.opacity(0.2) : Color.white.opacity(0.1))
                .cornerRadius(4)
                .foregroundColor(isSelected ? .white : .gray)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(isSelected ? CaptureOneTheme.Colors.activeHighlight : Color.clear)
        .contentShape(Rectangle())
    }
}

struct StartButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 12))
            .padding(.horizontal, 16)
            .padding(.vertical, 6)
            .background(Color.white.opacity(configuration.isPressed ? 0.05 : 0.1))
            .foregroundColor(.white)
            .cornerRadius(4)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
            )
    }
}

struct PrimaryStartButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 12, weight: .semibold))
            .padding(.horizontal, 24)
            .padding(.vertical, 6)
            .background(isEnabled ? CaptureOneTheme.Colors.activeHighlight : Color.gray.opacity(0.3))
            .foregroundColor(isEnabled ? .white : .white.opacity(0.5))
            .cornerRadius(4)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}
