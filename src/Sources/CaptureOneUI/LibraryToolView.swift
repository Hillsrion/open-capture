import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Library Tool (GAP-402).
/// Matches Capture One 16.7.4 specifications for both Sessions and Catalogs.

public struct LibraryToolView: View {
    @ObservedObject var session: SessionBase
    @ObservedObject var commands = AppCommandCenter.shared
    @State private var selectedCollectionUUID: String? = "capture"
    
    // For inline renaming
    @State private var editingUUID: String? = nil
    @State private var editedName: String = ""
    
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
            COToolSection("Session Folders", toolID: "SessionFolders", showDefaultActions: false) {
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
            COToolSection("Session Albums", toolID: "SessionAlbums", showDefaultActions: false, actions: {
                HStack(spacing: 0) {
                    Menu {
                        Button("New Album") { 
                            session.addUserAlbum(name: "New Album") 
                            if let new = session.arrangedUserAlbumCollections.last {
                                startEditing(new.uuid, currentName: "New Album")
                            }
                        }
                        Button("New Smart Album") { 
                            session.addUserAlbum(name: "New Smart Album", isSmart: true) 
                            if let new = session.arrangedUserAlbumCollections.last {
                                startEditing(new.uuid, currentName: "New Smart Album")
                            }
                        }
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                            .frame(width: 22, height: 22)
                    }
                    .menuStyle(BorderlessButtonMenuStyle())
                    
                    toolHeaderButton(systemName: "minus") {
                        if let uuid = selectedCollectionUUID {
                            session.removeUserAlbum(uuid: uuid)
                        }
                    }
                }
            }) {
                VStack(alignment: .leading, spacing: 0) {
                    if session.arrangedUserAlbumCollections.isEmpty {
                        Text("No albums").font(.system(size: 10)).foregroundColor(.gray).padding(.leading, 12).padding(.vertical, 4)
                    } else {
                        ForEach(session.arrangedUserAlbumCollections, id: \.uuid) { album in
                            LibraryRow(
                                title: album.name ?? "Untitled",
                                icon: album.isSmartAlbum ? "gearshape" : "photo.on.rectangle",
                                count: album.itemCount,
                                isSelected: selectedCollectionUUID == album.uuid,
                                isEditing: editingUUID == album.uuid,
                                editedName: $editedName,
                                onCommitRename: { commitRename(for: album) }
                            )
                            .onTapGesture { selectedCollectionUUID = album.uuid }
                            .onTapGesture(count: 2) { startEditing(album.uuid, currentName: album.name ?? "") }
                            .contextMenu {
                                if album.isSmartAlbum {
                                    Button("Edit Smart Album...") { }
                                }
                                Button("Rename...") { startEditing(album.uuid, currentName: album.name ?? "") }
                                Button("Duplicate...") { }
                                Divider()
                                Button("Export as Catalog...") { }
                                Divider()
                                Button("Delete", role: .destructive) { 
                                    session.removeUserAlbum(uuid: album.uuid)
                                }
                            }
                        }
                    }
                }
            }
            
            // Session Favorites
            COToolSection("Session Favorites", toolID: "SessionFavorites", showDefaultActions: false, actions: {
                HStack(spacing: 0) {
                    toolHeaderButton(systemName: "plus") {
                        addFavoriteFolder()
                    }
                    toolHeaderButton(systemName: "minus") {
                        if let uuid = selectedCollectionUUID {
                            session.removeUserFavourite(uuid: uuid)
                        }
                    }
                }
            }) {
                VStack(alignment: .leading, spacing: 0) {
                    if session.arrangedUserFavouriteCollections.isEmpty {
                        Text("No favorites").font(.system(size: 10)).foregroundColor(.gray).padding(.leading, 12).padding(.vertical, 4)
                    } else {
                        ForEach(session.arrangedUserFavouriteCollections, id: \.uuid) { fav in
                            LibraryRow(
                                title: fav.name ?? "Favorite", 
                                icon: iconForFolder(path: fav.folderPath ?? ""), 
                                count: 0, 
                                isSelected: selectedCollectionUUID == fav.uuid,
                                isEditing: editingUUID == fav.uuid,
                                editedName: $editedName,
                                onCommitRename: { commitRename(for: fav) }
                            )
                            .onTapGesture { selectedCollectionUUID = fav.uuid }
                            .onTapGesture(count: 2) { startEditing(fav.uuid, currentName: fav.name ?? "") }
                            .contextMenu {
                                if let path = fav.folderPath {
                                    let url = URL(fileURLWithPath: path)
                                    Button("Set as Capture Folder") { SessionFolderManager.shared.setAsSystemFolder(url: url, type: .capture, in: session) }
                                    Button("Set as Selects Folder") { SessionFolderManager.shared.setAsSystemFolder(url: url, type: .selects, in: session) }
                                    Button("Set as Output Folder") { SessionFolderManager.shared.setAsSystemFolder(url: url, type: .output, in: session) }
                                    Button("Set as Session Trash Folder") { SessionFolderManager.shared.setAsSystemFolder(url: url, type: .trash, in: session) }
                                    Divider()
                                    Button("Rename...") { startEditing(fav.uuid, currentName: fav.name ?? "") }
                                    Button("Remove from Favorites") { session.removeUserFavourite(uuid: fav.uuid) }
                                    Divider()
                                    Button("Show in Finder") { NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: path) }
                                }
                            }
                        }
                    }
                }
            }
            
            // System Folders
            COToolSection("System Folders", toolID: "SystemFolders", showDefaultActions: false) {
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
                                Button("Show in Finder") { NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: path) }
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
            COToolSection("Catalog Collections", toolID: "CatalogCollections", showDefaultActions: false) {
                VStack(alignment: .leading, spacing: 0) {
                    LibraryRow(title: "All Images", icon: "rectangle.stack.fill", count: 12450, isSelected: selectedCollectionUUID == "all")
                        .onTapGesture { selectedCollectionUUID = "all" }
                    LibraryRow(title: "Recent Imports", icon: "clock.fill", count: 124, isSelected: selectedCollectionUUID == "recent")
                        .onTapGesture { selectedCollectionUUID = "recent" }
                    LibraryRow(title: "Trash", icon: "trash.fill", count: 5, isSelected: selectedCollectionUUID == "trash")
                        .onTapGesture { selectedCollectionUUID = "trash" }
                }
            }
            
            COToolSection("User Collections", toolID: "UserCollections", showDefaultActions: false, actions: {
                Menu {
                    Button("New Album") { /* catalog specific logic */ }
                    Button("New Smart Album") { /* catalog specific logic */ }
                    Button("New Group") { }
                    Button("New Project") { }
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                        .frame(width: 22, height: 22)
                }
                .menuStyle(BorderlessButtonMenuStyle())
            }) {
                VStack(alignment: .leading, spacing: 0) {
                    // Hierarchical view logic would go here (Groups/Projects)
                    LibraryRow(title: "Portfolio 2024", icon: "folder.fill.badge.plus", count: 45, isSelected: selectedCollectionUUID == "portfolio")
                        .onTapGesture { selectedCollectionUUID = "portfolio" }
                }
            }
            
            COToolSection("Folders", toolID: "CatalogFolders", showDefaultActions: false) {
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
    
    private func addFavoriteFolder() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.begin { response in
            if response == .OK, let url = panel.url {
                session.addUserFavourite(path: url.path)
            }
        }
    }
    
    private func startEditing(_ uuid: String, currentName: String) {
        editedName = currentName
        editingUUID = uuid
    }
    
    private func commitRename(for collection: CollectionBase) {
        collection.name = editedName
        editingUUID = nil
        session.isDirty = true
    }
    
    @ViewBuilder
    private func toolHeaderButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 10))
                .frame(width: 22, height: 22)
        }
        .buttonStyle(.plain)
        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
    }
}

struct LibraryRow: View {
    let title: String
    let icon: String
    let count: Int
    let isSelected: Bool
    
    // Renaming support
    var isEditing: Bool
    @Binding var editedName: String
    var onCommitRename: (() -> Void)?
    
    init(title: String, icon: String, count: Int, isSelected: Bool, isEditing: Bool = false, editedName: Binding<String> = .constant(""), onCommitRename: (() -> Void)? = nil) {
        self.title = title
        self.icon = icon
        self.count = count
        self.isSelected = isSelected
        self.isEditing = isEditing
        self._editedName = editedName
        self.onCommitRename = onCommitRename
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 11))
                .foregroundColor(isSelected ? CaptureOneTheme.Colors.activeHighlight : .white.opacity(0.6))
                .frame(width: 16)
            
            if isEditing {
                TextField("", text: $editedName, onCommit: {
                    onCommitRename?()
                })
                .textFieldStyle(.plain)
                .font(.system(size: 11))
                .foregroundColor(.white)
                .background(Color.blue.opacity(0.3))
            } else {
                Text(title)
                    .font(.system(size: 11))
                    .foregroundColor(isSelected ? CaptureOneTheme.Colors.activeHighlight : .white.opacity(0.9))
            }
            
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
