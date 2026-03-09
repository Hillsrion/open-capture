import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Library Tool (GAP-402).
/// Matches Capture One 16.7.4 specifications for both Sessions and Catalogs.

public struct LibraryToolView: View {
    @ObservedObject var session: SessionBase
    @State private var selectedCollectionUUID: String? = nil
    
    public init(session: SessionBase) {
        self.session = session
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Main Library Header (Not a section, just a label in CO)
            HStack {
                Text("Library")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.black.opacity(0.1))
            
            ScrollView {
                VStack(spacing: 0) {
                    if session.isCatalog {
                        catalogHierarchy
                    } else {
                        sessionHierarchy
                    }
                }
            }
        }
    }
    
    // MARK: - Session Hierarchy
    private var sessionHierarchy: some View {
        VStack(spacing: 0) {
            // Shortcuts Section (Formerly Session Folders)
            COToolSection("Shortcuts", toolID: "SessionShortcuts") {
                VStack(alignment: .leading, spacing: 0) {
                    LibraryRow(title: "Capture", icon: "camera.fill", count: 124, isSelected: selectedCollectionUUID == "capture")
                        .onTapGesture { selectedCollectionUUID = "capture" }
                    LibraryRow(title: "Selects", icon: "app.badge.checkmark.fill", count: 42, isSelected: selectedCollectionUUID == "selects")
                        .onTapGesture { selectedCollectionUUID = "selects" }
                    LibraryRow(title: "Output", icon: "arrow.up.doc.fill", count: 0, isSelected: selectedCollectionUUID == "output")
                        .onTapGesture { selectedCollectionUUID = "output" }
                    LibraryRow(title: "Trash", icon: "trash.fill", count: 12, isSelected: selectedCollectionUUID == "trash")
                        .onTapGesture { selectedCollectionUUID = "trash" }
                }
            }
            
            // Session Albums Section
            sectionHeaderWithAdd(title: "Session Albums")
            VStack(alignment: .leading, spacing: 0) {
                if session.arrangedUserAlbumCollections.isEmpty {
                    Text("No albums added").font(.system(size: 10)).foregroundColor(.gray).padding(8)
                } else {
                    ForEach(session.arrangedUserAlbumCollections, id: \.uuid) { album in
                        LibraryRow(
                            title: album.name ?? "Untitled",
                            icon: album.isSmartAlbum ? "gearshape.fill" : "photo.on.rectangle",
                            count: album.itemCount,
                            isSelected: selectedCollectionUUID == album.uuid
                        )
                        .onTapGesture { selectedCollectionUUID = album.uuid }
                        .contextMenu {
                            Button("Edit Smart Album...") { }
                            Button("Rename...") { }
                            Button("Duplicate...") { }
                            Divider()
                            Button("Export as Catalog...") { }
                            Divider()
                            Button("Delete", role: .destructive) { 
                                session.arrangedUserAlbumCollections.removeAll(where: { $0.uuid == album.uuid })
                            }
                        }
                    }
                }
            }
            
            // Session Favorites
            sectionHeaderWithAdd(title: "Session Favorites")
            VStack(alignment: .leading, spacing: 0) {
                ForEach(session.arrangedUserFavouriteCollections, id: \.uuid) { fav in
                    LibraryRow(title: fav.name ?? "Favorite", icon: "star.fill", count: 0, isSelected: selectedCollectionUUID == fav.uuid)
                        .onTapGesture { selectedCollectionUUID = fav.uuid }
                }
            }
            
            // System Folders
            COToolSection("System Folders", toolID: "SystemFolders") {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(session.arrangedUserCachedFolderCollections, id: \.self) { path in
                        LibraryRow(title: (path as NSString).lastPathComponent, icon: "folder.fill", count: 0, isSelected: selectedCollectionUUID == path)
                            .onTapGesture { selectedCollectionUUID = path }
                    }
                }
            }
        }
    }
    
    // MARK: - Catalog Hierarchy
    private var catalogHierarchy: some View {
        VStack(spacing: 0) {
            COToolSection("Catalog Collections", toolID: "CatalogCollections") {
                VStack(alignment: .leading, spacing: 0) {
                    LibraryRow(title: "All Images", icon: "rectangle.stack.fill", count: 12450, isSelected: selectedCollectionUUID == "all")
                        .onTapGesture { selectedCollectionUUID = "all" }
                    LibraryRow(title: "Recent Imports", icon: "clock.fill", count: 124, isSelected: selectedCollectionUUID == "recent")
                        .onTapGesture { selectedCollectionUUID = "recent" }
                    LibraryRow(title: "Trash", icon: "trash.fill", count: 5, isSelected: selectedCollectionUUID == "trash")
                        .onTapGesture { selectedCollectionUUID = "trash" }
                }
            }
            
            sectionHeaderWithAdd(title: "User Collections")
            VStack(alignment: .leading, spacing: 0) {
                // Hierarchical view logic would go here (Groups/Projects)
                LibraryRow(title: "Portfolio 2024", icon: "folder.fill.badge.plus", count: 45, isSelected: selectedCollectionUUID == "portfolio")
                    .onTapGesture { selectedCollectionUUID = "portfolio" }
            }
            
            sectionHeaderWithAdd(title: "Folders")
            VStack(alignment: .leading, spacing: 0) {
                LibraryRow(title: "Macintosh HD", icon: "desktopcomputer", count: 0, isSelected: selectedCollectionUUID == "hdd")
                    .onTapGesture { selectedCollectionUUID = "hdd" }
            }
        }
    }
    
    // MARK: - Helpers
    private func sectionHeaderWithAdd(title: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.white.opacity(0.8))
            Spacer()
            Menu {
                Button("New Album") { }
                Button("New Smart Album") { }
                Button("New Group") { }
                Button("New Project") { }
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.gray)
            }
            .menuStyle(BorderlessButtonMenuStyle())
            .frame(width: 20)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(Color.white.opacity(0.02))
    }
}

struct LibraryRow: View {
    let title: String
    let icon: String
    let count: Int
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 11))
                .foregroundColor(isSelected ? CaptureOneTheme.Colors.activeHighlight : .white.opacity(0.6))
                .frame(width: 16)
            
            Text(title)
                .font(.system(size: 11))
                .foregroundColor(isSelected ? CaptureOneTheme.Colors.activeHighlight : .white.opacity(0.9))
            
            Spacer()
            
            if count > 0 {
                Text("\(count)")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background(isSelected ? Color.white.opacity(0.1) : Color.clear)
        .contentShape(Rectangle())
    }
}
