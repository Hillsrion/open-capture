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
    
    // For visual drop feedback
    @State private var dropActiveUUID: String? = nil
    
    public init(session: SessionBase) {
        self.session = session
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            headerView
            sessionSelector
            
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
    
    private var headerView: some View {
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
    }
    
    private var sessionSelector: some View {
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
    }
    
    // MARK: - Session Hierarchy
    private var sessionHierarchy: some View {
        VStack(spacing: 0) {
            sessionFoldersSection
            sessionAlbumsSection
            sessionFavoritesSection
            systemFoldersSection
        }
    }
    
    private var sessionFoldersSection: some View {
        COToolSection("Session Folders", toolID: "SessionFolders", showDefaultActions: false) {
            VStack(alignment: .leading, spacing: 0) {
                systemFolderRow(title: "Capture Folder", icon: "camera", type: .capture)
                systemFolderRow(title: "Selects Folder", icon: "star", type: .selects)
                systemFolderRow(title: "Output Folder", icon: "gearshape", type: .output)
                systemFolderRow(title: "Trash Folder", icon: "trash", type: .trash)
            }
        }
    }
    
    private var sessionAlbumsSection: some View {
        COToolSection("Session Albums", toolID: "SessionAlbums", showDefaultActions: false, actions: {
            HStack(spacing: 0) {
                albumAddMenu
                toolHeaderButton(systemName: "minus") {
                    if let uuid = selectedCollectionUUID { session.removeUserAlbum(uuid: uuid) }
                }
            }
        }) {
            VStack(alignment: .leading, spacing: 0) {
                if session.arrangedUserAlbumCollections.isEmpty {
                    Text("No albums").font(.system(size: 10)).foregroundColor(.gray).padding(.leading, 12).padding(.vertical, 4)
                } else {
                    ForEach(session.arrangedUserAlbumCollections, id: \.uuid) { album in
                        albumRow(album)
                    }
                }
            }
        }
    }
    
    private var albumAddMenu: some View {
        Menu {
            Button("New Album") { 
                session.addUserAlbum(name: "New Album") 
                if let new = session.arrangedUserAlbumCollections.last { startEditing(new.uuid, currentName: "New Album") }
            }
            Button("New Smart Album") { 
                session.addUserAlbum(name: "New Smart Album", isSmart: true) 
                if let new = session.arrangedUserAlbumCollections.last { startEditing(new.uuid, currentName: "New Smart Album") }
            }
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                .frame(width: 22, height: 22)
        }
        .menuStyle(BorderlessButtonMenuStyle())
    }
    
    @ViewBuilder
    private func albumRow(_ album: CollectionBase) -> some View {
        LibraryRow(
            title: album.name ?? "Untitled",
            icon: album.isSmartAlbum ? "gearshape" : "photo.on.rectangle",
            count: album.itemCount,
            isSelected: selectedCollectionUUID == album.uuid,
            isEditing: editingUUID == album.uuid,
            editedName: $editedName,
            isTargeted: dropActiveUUID == album.uuid,
            onCommitRename: { commitRename(for: album) }
        )
        .onTapGesture { selectedCollectionUUID = album.uuid }
        .onTapGesture(count: 2) { startEditing(album.uuid, currentName: album.name ?? "") }
        .onDrop(of: [.text], isTargeted: Binding(
            get: { dropActiveUUID == album.uuid },
            set: { targeted in dropActiveUUID = targeted ? album.uuid : nil }
        )) { providers in
            handleDrop(providers: providers, targetAlbum: album)
        }
        .contextMenu {
            if album.isSmartAlbum { Button("Edit Smart Album...") { } }
            Button("Rename...") { startEditing(album.uuid, currentName: album.name ?? "") }
            Button("Duplicate...") { }
            Divider()
            Button("Delete", role: .destructive) { session.removeUserAlbum(uuid: album.uuid) }
        }
    }
    
    private var sessionFavoritesSection: some View {
        COToolSection("Session Favorites", toolID: "SessionFavorites", showDefaultActions: false, actions: {
            HStack(spacing: 0) {
                toolHeaderButton(systemName: "plus") { addFavoriteFolder() }
                toolHeaderButton(systemName: "minus") {
                    if let uuid = selectedCollectionUUID { session.removeUserFavourite(uuid: uuid) }
                }
            }
        }) {
            VStack(alignment: .leading, spacing: 0) {
                if session.arrangedUserFavouriteCollections.isEmpty {
                    Text("No favorites").font(.system(size: 10)).foregroundColor(.gray).padding(.leading, 12).padding(.vertical, 4)
                } else {
                    ForEach(session.arrangedUserFavouriteCollections, id: \.uuid) { fav in
                        favoriteRow(fav)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func favoriteRow(_ fav: CollectionBase) -> some View {
        LibraryRow(
            title: fav.name ?? "Favorite", 
            icon: iconForFolder(path: fav.folderPath ?? ""), 
            count: 0, 
            isSelected: selectedCollectionUUID == fav.uuid,
            isEditing: editingUUID == fav.uuid,
            editedName: $editedName,
            isTargeted: dropActiveUUID == fav.uuid,
            onCommitRename: { commitRename(for: fav) }
        )
        .onTapGesture { selectedCollectionUUID = fav.uuid }
        .onTapGesture(count: 2) { startEditing(fav.uuid, currentName: fav.name ?? "") }
        .onDrop(of: [.text], isTargeted: Binding(
            get: { dropActiveUUID == fav.uuid },
            set: { targeted in dropActiveUUID = targeted ? fav.uuid : nil }
        )) { providers in
            handleDrop(providers: providers, targetFavorite: fav)
        }
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
    
    private var systemFoldersSection: some View {
        COToolSection("System Folders", toolID: "SystemFolders", showDefaultActions: false) {
            VStack(alignment: .leading, spacing: 0) {
                LibraryRow(title: "Macintosh HD", icon: "internaldrive", count: 0, isSelected: selectedCollectionUUID == "hdd")
                    .onTapGesture { selectedCollectionUUID = "hdd" }
                    .padding(.leading, 12)
                
                ForEach(session.arrangedUserCachedFolderCollections, id: \.self) { path in
                    systemFolderItemRow(path: path)
                }
            }
        }
    }
    
    @ViewBuilder
    private func systemFolderItemRow(path: String) -> some View {
        LibraryRow(
            title: (path as NSString).lastPathComponent, 
            icon: iconForFolder(path: path), 
            count: 0, 
            isSelected: selectedCollectionUUID == path,
            isTargeted: dropActiveUUID == path
        )
        .onTapGesture { selectedCollectionUUID = path }
        .padding(.leading, 24)
        .onDrop(of: [.text], isTargeted: Binding(
            get: { dropActiveUUID == path },
            set: { targeted in dropActiveUUID = targeted ? path : nil }
        )) { providers in
            handleDrop(providers: providers, targetPath: path)
        }
        .contextMenu {
            let url = URL(fileURLWithPath: path)
            Button("Set as Capture Folder") { SessionFolderManager.shared.setAsSystemFolder(url: url, type: .capture, in: session) }
            Button("Set as Selects Folder") { SessionFolderManager.shared.setAsSystemFolder(url: url, type: .selects, in: session) }
            Button("Set as Output Folder") { SessionFolderManager.shared.setAsSystemFolder(url: url, type: .output, in: session) }
            Button("Set as Session Trash Folder") { SessionFolderManager.shared.setAsSystemFolder(url: url, type: .trash, in: session) }
            Divider()
            Button("Show in Finder") { NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: path) }
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
                    Button("New Album") { }
                    Button("New Smart Album") { }
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
    
    @ViewBuilder
    private func systemFolderRow(title: String, icon: String, type: SessionFolderType) -> some View {
        let uuid = type.defaultName.lowercased()
        LibraryRow(
            title: title, 
            icon: icon, 
            count: selectedCollectionUUID == uuid ? commands.browser.dataSource.count : 0, 
            isSelected: selectedCollectionUUID == uuid,
            isTargeted: dropActiveUUID == uuid
        )
        .onTapGesture { 
            selectedCollectionUUID = uuid
            commands.selectSessionFolder(type: type)
        }
        .onDrop(of: [.text], isTargeted: Binding(
            get: { dropActiveUUID == uuid },
            set: { targeted in dropActiveUUID = targeted ? uuid : nil }
        )) { providers in
            handleDrop(providers: providers, targetFolderType: type)
        }
    }

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
    
    private func handleDrop(providers: [NSItemProvider], targetAlbum: CollectionBase? = nil, targetFavorite: CollectionBase? = nil, targetFolderType: SessionFolderType? = nil, targetPath: String? = nil) -> Bool {
        guard let provider = providers.first else { return false }
        
        provider.loadObject(ofClass: NSString.self) { (uuid, error) in
            guard let variantUUID = uuid as? String else { return }
            
            DispatchQueue.main.async {
                guard let image = commands.browser.dataSource.first(where: { $0.primaryVariant?.variantUUID == variantUUID }),
                      let variant = image.primaryVariant else { return }
                
                do {
                    if let album = targetAlbum {
                        try SessionFolderManager.shared.addToAlbum(variant: variant, album: album)
                    } else if let favorite = targetFavorite {
                        try SessionFolderManager.shared.moveToFavorite(variant: variant, favorite: favorite)
                    } else if let type = targetFolderType {
                        try SessionFolderManager.shared.move(variant: variant, to: type, in: session)
                    } else if let path = targetPath {
                        let favorite = CollectionBase(uuid: "temp", context: nil)
                        favorite.folderPath = path
                        try SessionFolderManager.shared.moveToFavorite(variant: variant, favorite: favorite)
                    }
                } catch {
                    print("[Library] Drop failed: \(error.localizedDescription)")
                }
            }
        }
        return true
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
    var isTargeted: Bool = false
    var onCommitRename: (() -> Void)?
    
    init(title: String, icon: String, count: Int, isSelected: Bool, isEditing: Bool = false, editedName: Binding<String> = .constant(""), isTargeted: Bool = false, onCommitRename: (() -> Void)? = nil) {
        self.title = title
        self.icon = icon
        self.count = count
        self.isSelected = isSelected
        self.isEditing = isEditing
        self._editedName = editedName
        self.isTargeted = isTargeted
        self.onCommitRename = onCommitRename
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 11))
                .foregroundColor(isSelected || isTargeted ? CaptureOneTheme.Colors.activeHighlight : .white.opacity(0.6))
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
                    .foregroundColor(isSelected || isTargeted ? .white : .white.opacity(0.9))
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
        .background(isTargeted ? CaptureOneTheme.Colors.activeHighlight.opacity(0.3) : (isSelected ? Color.white.opacity(0.1) : Color.clear))
        .contentShape(Rectangle())
    }
}
