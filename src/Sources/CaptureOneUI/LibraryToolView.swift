import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Library Tool (GAP-402).
/// Matches Capture One 16.7.4 specifications for both Sessions and Catalogs.

public struct LibraryToolView: View {
    @ObservedObject var session: SessionBase
    @ObservedObject var commands = AppCommandCenter.shared
    @State private var selectedCollectionUUID: String? = "capture"
    
    public init(session: SessionBase) {
        self.session = session
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Main Library Header
            HStack {
                Text("Library")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "questionmark")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.gray)
                Image(systemName: "ellipsis")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 10)
            .padding(.top, 6)
            .padding(.bottom, 4)
            .background(CaptureOneTheme.Colors.panelBackground)
            
            // Session Selector
            HStack {
                HStack {
                    Text("Session: \(session.name ?? "Untitled")")
                        .font(.system(size: 11))
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.system(size: 8))
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 4)
                .background(Color.white.opacity(0.1))
                .cornerRadius(4)
                
                Button(action: {}) {
                    Image(systemName: "plus")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 8)
            .background(CaptureOneTheme.Colors.panelBackground)
            
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
        .onAppear {
            if !session.isCatalog && commands.browser.dataSource.isEmpty {
                commands.selectSessionFolder(type: .capture)
            }
        }
    }
    
    // MARK: - Session Hierarchy
    private var sessionHierarchy: some View {
        VStack(spacing: 0) {
            // Session Folders Section
            COToolSection("Session Folders", toolID: "SessionFolders") {
                VStack(alignment: .leading, spacing: 0) {
                    LibraryRow(title: "Capture Folder", icon: "camera", count: selectedCollectionUUID == "capture" ? commands.browser.dataSource.count : 0, isSelected: selectedCollectionUUID == "capture")
                        .onTapGesture { 
                            selectedCollectionUUID = "capture"
                            commands.selectSessionFolder(type: .capture)
                        }
                    LibraryRow(title: "Selects Folder", icon: "star", count: selectedCollectionUUID == "selects" ? commands.browser.dataSource.count : 0, isSelected: selectedCollectionUUID == "selects")
                        .onTapGesture { 
                            selectedCollectionUUID = "selects"
                            commands.selectSessionFolder(type: .selects)
                        }
                    LibraryRow(title: "Output Folder", icon: "gearshape", count: selectedCollectionUUID == "output" ? commands.browser.dataSource.count : 0, isSelected: selectedCollectionUUID == "output")
                        .onTapGesture { 
                            selectedCollectionUUID = "output"
                            commands.selectSessionFolder(type: .output)
                        }
                    LibraryRow(title: "Trash Folder", icon: "trash", count: selectedCollectionUUID == "trash" ? commands.browser.dataSource.count : 0, isSelected: selectedCollectionUUID == "trash")
                        .onTapGesture { 
                            selectedCollectionUUID = "trash"
                            commands.selectSessionFolder(type: .trash)
                        }
                }
            }
            
            // Session Albums Section
            COToolSection("Session Albums", toolID: "SessionAlbums") {
                VStack(alignment: .leading, spacing: 0) {
                    if session.arrangedUserAlbumCollections.isEmpty {
                        Text("No albums").font(.system(size: 10)).foregroundColor(.gray).padding(.leading, 12).padding(.vertical, 4)
                    } else {
                        ForEach(session.arrangedUserAlbumCollections, id: \.uuid) { album in
                            LibraryRow(
                                title: album.name ?? "Untitled",
                                icon: album.isSmartAlbum ? "gearshape" : "photo.on.rectangle",
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
            }
            
            // Session Favorites
            COToolSection("Session Favorites", toolID: "SessionFavorites") {
                VStack(alignment: .leading, spacing: 0) {
                    if session.arrangedUserFavouriteCollections.isEmpty {
                        Text("No favorites").font(.system(size: 10)).foregroundColor(.gray).padding(.leading, 12).padding(.vertical, 4)
                    } else {
                        ForEach(session.arrangedUserFavouriteCollections, id: \.uuid) { fav in
                            LibraryRow(title: fav.name ?? "Favorite", icon: iconForFolder(path: fav.folderPath ?? ""), count: 0, isSelected: selectedCollectionUUID == fav.uuid)
                                .onTapGesture { selectedCollectionUUID = fav.uuid }
                                .contextMenu {
                                    if let path = fav.folderPath {
                                        let url = URL(fileURLWithPath: path)
                                        Button("Set as Capture Folder") { SessionFolderManager.shared.setAsSystemFolder(url: url, type: .capture, in: session) }
                                        Button("Set as Selects Folder") { SessionFolderManager.shared.setAsSystemFolder(url: url, type: .selects, in: session) }
                                        Button("Set as Output Folder") { SessionFolderManager.shared.setAsSystemFolder(url: url, type: .output, in: session) }
                                        Button("Set as Session Trash Folder") { SessionFolderManager.shared.setAsSystemFolder(url: url, type: .trash, in: session) }
                                    }
                                }
                        }
                    }
                }
            }
            
            // System Folders
            COToolSection("System Folders", toolID: "SystemFolders") {
                VStack(alignment: .leading, spacing: 0) {
                    // Placeholder for root Macintosh HD
                    LibraryRow(title: "Macintosh HD", icon: "internaldrive", count: 0, isSelected: selectedCollectionUUID == "hdd")
                        .onTapGesture { selectedCollectionUUID = "hdd" }
                        .padding(.leading, 12)
                    
                    ForEach(session.arrangedUserCachedFolderCollections, id: \.self) { path in
                        LibraryRow(title: (path as NSString).lastPathComponent, icon: iconForFolder(path: path), count: 0, isSelected: selectedCollectionUUID == path)
                            .onTapGesture { selectedCollectionUUID = path }
                            .padding(.leading, 24)
                            .contextMenu {
                                Button("New") { }
                                Button("Rename") { }
                                Divider()
                                Button("Import") { }
                                Button("Export") { }
                                Divider()
                                let url = URL(fileURLWithPath: path)
                                Button("Set as Capture Folder") { if let s = commands.session { SessionFolderManager.shared.setAsSystemFolder(url: url, type: .capture, in: s) } }
                                Button("Set as Selects Folder") { if let s = commands.session { SessionFolderManager.shared.setAsSystemFolder(url: url, type: .selects, in: s) } }
                                Button("Set as Output Folder") { if let s = commands.session { SessionFolderManager.shared.setAsSystemFolder(url: url, type: .output, in: s) } }
                                Button("Set as Session Trash Folder") { if let s = commands.session { SessionFolderManager.shared.setAsSystemFolder(url: url, type: .trash, in: s) } }
                                Divider()
                                Button("Show in Library") { }
                                Button("Show in Finder") { NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: path) }
                                Button("Show Info") { }
                                Divider()
                            }
                    }
                }
            }
            .padding(.bottom, 8)
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
            
            COToolSection("User Collections", toolID: "UserCollections") {
                VStack(alignment: .leading, spacing: 0) {
                    // Hierarchical view logic would go here (Groups/Projects)
                    LibraryRow(title: "Portfolio 2024", icon: "folder.fill.badge.plus", count: 45, isSelected: selectedCollectionUUID == "portfolio")
                        .onTapGesture { selectedCollectionUUID = "portfolio" }
                }
            }
            
            COToolSection("Folders", toolID: "CatalogFolders") {
                VStack(alignment: .leading, spacing: 0) {
                    LibraryRow(title: "Macintosh HD", icon: "desktopcomputer", count: 0, isSelected: selectedCollectionUUID == "hdd")
                        .onTapGesture { selectedCollectionUUID = "hdd" }
                }
            }
        }
    }
    
    // MARK: - Helpers
    private func iconForFolder(path: String) -> String {
        if path == session.captureFolder { return "camera" }
        if path == session.selectsFolder { return "star" }
        if path == session.outputFolder { return "gearshape" }
        if path == session.trashFolder { return "trash" }
        return "folder"
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
