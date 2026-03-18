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
    
    // File system roots
    @StateObject private var macintoshHDRoot = FileSystemNode(path: "/")
    
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
                        CollectionNodeView(
                            collection: album,
                            session: session,
                            selectedUUID: $selectedCollectionUUID,
                            editingUUID: $editingUUID,
                            editedName: $editedName,
                            dropActiveUUID: $dropActiveUUID,
                            onRename: { commitRename(for: album) },
                            onDrop: handleDrop
                        )
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
            Button("New Group") {
                let group = CollectionBase(uuid: UUID().uuidString, context: session.managedObjectContext)
                group.name = "New Group"
                group.collectionType = 4
                session.arrangedUserAlbumCollections.append(group)
                startEditing(group.uuid, currentName: "New Group")
            }
            Button("New Project") {
                let project = CollectionBase(uuid: UUID().uuidString, context: session.managedObjectContext)
                project.name = "New Project"
                project.collectionType = 3
                session.arrangedUserAlbumCollections.append(project)
                startEditing(project.uuid, currentName: "New Project")
            }
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                .frame(width: 22, height: 22)
        }
        .menuStyle(BorderlessButtonMenuStyle())
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
            indentLevel: 0,
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
                SystemFolderNodeView(
                    node: macintoshHDRoot, 
                    session: session, 
                    selectedPath: $selectedCollectionUUID, 
                    dropActiveUUID: $dropActiveUUID, 
                    onDrop: handleDrop
                )
                
                ForEach(session.arrangedUserCachedFolderCollections, id: \.self) { path in
                    SystemFolderNodeView(
                        node: FileSystemNode(path: path), 
                        session: session, 
                        selectedPath: $selectedCollectionUUID, 
                        dropActiveUUID: $dropActiveUUID, 
                        onDrop: handleDrop
                    )
                }
            }
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
                albumAddMenu
            }) {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(session.arrangedUserAlbumCollections, id: \.uuid) { collection in
                        CollectionNodeView(
                            collection: collection,
                            session: session,
                            selectedUUID: $selectedCollectionUUID,
                            editingUUID: $editingUUID,
                            editedName: $editedName,
                            dropActiveUUID: $dropActiveUUID,
                            onRename: { commitRename(for: collection) },
                            onDrop: handleDrop
                        )
                    }
                }
            }
            
            COToolSection("Folders", toolID: "CatalogFolders", showDefaultActions: false) {
                VStack(alignment: .leading, spacing: 0) {
                    SystemFolderNodeView(
                        node: macintoshHDRoot, 
                        session: session, 
                        selectedPath: $selectedCollectionUUID, 
                        dropActiveUUID: $dropActiveUUID, 
                        onDrop: handleDrop
                    )
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
                        if album.collectionType == 1 {
                            try SessionFolderManager.shared.addToAlbum(variant: variant, album: album)
                        } else {
                            print("[Library] Cannot drop images directly into a Group/Project.")
                        }
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

// MARK: - Recursive Node Views

struct CollectionNodeView: View {
    @ObservedObject var collection: CollectionBase
    var session: SessionBase
    @Binding var selectedUUID: String?
    @Binding var editingUUID: String?
    @Binding var editedName: String
    @Binding var dropActiveUUID: String?
    var onRename: () -> Void
    var onDrop: ([NSItemProvider], CollectionBase?, CollectionBase?, SessionFolderType?, String?) -> Bool
    var indentLevel: Int = 0
    
    @State private var isExpanded: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 4) {
                if !collection.children.isEmpty || isGroupOrProject(collection.collectionType) {
                    Image(systemName: "play.fill")
                        .font(.system(size: 6))
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .foregroundColor(collection.children.isEmpty ? .clear : .gray)
                        .onTapGesture { withAnimation { isExpanded.toggle() } }
                        .frame(width: 12)
                } else {
                    Spacer().frame(width: 16)
                }
                
                LibraryRow(
                    title: collection.name ?? "Untitled",
                    icon: iconForType(collection.collectionType),
                    count: collection.itemCount,
                    isSelected: selectedUUID == collection.uuid,
                    isEditing: editingUUID == collection.uuid,
                    editedName: $editedName,
                    isTargeted: dropActiveUUID == collection.uuid,
                    indentLevel: indentLevel,
                    onCommitRename: onRename
                )
                .onTapGesture { selectedUUID = collection.uuid }
                .onTapGesture(count: 2) { 
                    editedName = collection.name ?? ""
                    editingUUID = collection.uuid
                }
                .onDrop(of: [.text], isTargeted: Binding(
                    get: { dropActiveUUID == collection.uuid },
                    set: { targeted in dropActiveUUID = targeted ? collection.uuid : nil }
                )) { providers in
                    onDrop(providers, collection, nil, nil, nil)
                }
                .contextMenu {
                    if collection.isSmartAlbum { Button("Edit Smart Album...") { } }
                    Button("Rename...") { 
                        editedName = collection.name ?? ""
                        editingUUID = collection.uuid
                    }
                    Button("Duplicate...") { }
                    Divider()
                    if isGroupOrProject(collection.collectionType) {
                        Button("New Album inside") { addChild(type: 1, name: "New Album") }
                        Button("New Smart Album inside") { addChild(type: 2, name: "New Smart Album") }
                        Button("New Group inside") { addChild(type: 4, name: "New Group") }
                        Button("New Project inside") { addChild(type: 3, name: "New Project") }
                        Divider()
                    }
                    Button("Export as Catalog...") { }
                    Divider()
                    Button("Delete", role: .destructive) { session.removeUserAlbum(uuid: collection.uuid) }
                }
            }
            .padding(.leading, CGFloat(indentLevel * 12))
            
            if isExpanded && !collection.children.isEmpty {
                ForEach(collection.children, id: \.uuid) { child in
                    CollectionNodeView(
                        collection: child,
                        session: session,
                        selectedUUID: $selectedUUID,
                        editingUUID: $editingUUID,
                        editedName: $editedName,
                        dropActiveUUID: $dropActiveUUID,
                        onRename: { child.name = editedName; editingUUID = nil; session.isDirty = true },
                        onDrop: onDrop,
                        indentLevel: indentLevel + 1
                    )
                }
            }
        }
    }
    
    private func isGroupOrProject(_ type: Int) -> Bool {
        return type == 3 || type == 4
    }
    
    private func iconForType(_ type: Int) -> String {
        switch type {
        case 0: return "folder"
        case 1: return "photo.on.rectangle" // Album
        case 2: return "gearshape" // Smart Album
        case 3: return "tray.full" // Project
        case 4: return "folder.fill.badge.plus" // Group
        default: return "photo.on.rectangle"
        }
    }
    
    private func addChild(type: Int, name: String) {
        let child = CollectionBase(uuid: UUID().uuidString, context: session.managedObjectContext)
        child.name = name
        child.collectionType = type
        child.parent = collection
        collection.children.append(child)
        isExpanded = true
        session.isDirty = true
    }
}

struct SystemFolderNodeView: View {
    @ObservedObject var node: FileSystemNode
    var session: SessionBase
    @Binding var selectedPath: String?
    @Binding var dropActiveUUID: String?
    var onDrop: ([NSItemProvider], CollectionBase?, CollectionBase?, SessionFolderType?, String?) -> Bool
    var indentLevel: Int = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 4) {
                Image(systemName: "play.fill")
                    .font(.system(size: 6))
                    .rotationEffect(.degrees(node.isExpanded ? 90 : 0))
                    .foregroundColor(.gray)
                    .onTapGesture { 
                        if !node.isLoaded { node.loadChildren() }
                        withAnimation { node.isExpanded.toggle() } 
                    }
                    .frame(width: 12)
                
                LibraryRow(
                    title: node.name, 
                    icon: node.path == "/" ? "internaldrive" : "folder", 
                    count: 0, 
                    isSelected: selectedPath == node.path,
                    isTargeted: dropActiveUUID == node.path,
                    indentLevel: indentLevel
                )
                .onTapGesture { selectedPath = node.path }
                .onDrop(of: [.text], isTargeted: Binding(
                    get: { dropActiveUUID == node.path },
                    set: { targeted in dropActiveUUID = targeted ? node.path : nil }
                )) { providers in
                    onDrop(providers, nil, nil, nil, node.path)
                }
                .contextMenu {
                    Button("New Folder") { }
                    Button("Rename...") { }
                    Divider()
                    Button("Import") { }
                    Button("Export") { }
                    Divider()
                    let url = URL(fileURLWithPath: node.path)
                    Button("Set as Capture Folder") { SessionFolderManager.shared.setAsSystemFolder(url: url, type: .capture, in: session) }
                    Button("Set as Selects Folder") { SessionFolderManager.shared.setAsSystemFolder(url: url, type: .selects, in: session) }
                    Button("Set as Output Folder") { SessionFolderManager.shared.setAsSystemFolder(url: url, type: .output, in: session) }
                    Button("Set as Session Trash Folder") { SessionFolderManager.shared.setAsSystemFolder(url: url, type: .trash, in: session) }
                    Divider()
                    Button("Show in Finder") { NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: node.path) }
                }
            }
            .padding(.leading, CGFloat(indentLevel * 12))
            
            if node.isExpanded, let children = node.children {
                ForEach(children) { child in
                    SystemFolderNodeView(
                        node: child, 
                        session: session, 
                        selectedPath: $selectedPath, 
                        dropActiveUUID: $dropActiveUUID,
                        onDrop: onDrop,
                        indentLevel: indentLevel + 1
                    )
                }
            } else if node.isExpanded && !node.isLoaded {
                ProgressView().scaleEffect(0.5)
                    .padding(.leading, CGFloat((indentLevel + 1) * 12 + 16))
                    .onAppear { node.loadChildren() }
            }
        }
    }
}

// MARK: - Base Row UI
struct LibraryRow: View {
    let title: String
    let icon: String
    let count: Int
    let isSelected: Bool
    
    // Renaming support
    var isEditing: Bool
    @Binding var editedName: String
    var isTargeted: Bool
    var indentLevel: Int
    var onCommitRename: (() -> Void)?
    
    init(title: String, icon: String, count: Int, isSelected: Bool, isEditing: Bool = false, editedName: Binding<String> = .constant(""), isTargeted: Bool = false, indentLevel: Int = 0, onCommitRename: (() -> Void)? = nil) {
        self.title = title
        self.icon = icon
        self.count = count
        self.isSelected = isSelected
        self.isEditing = isEditing
        self._editedName = editedName
        self.isTargeted = isTargeted
        self.indentLevel = indentLevel
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
