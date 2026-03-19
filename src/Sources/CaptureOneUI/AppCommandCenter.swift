import SwiftUI
import AppKit
import AppCoreShared
import DataCore

public enum AppSheetRoute: String, Identifiable {
    case preferences
    case keyboardShortcuts
    case sessionUpgrade
    case newCatalog
    case newSession
    case batchRename

    public var id: String { rawValue }
}

public struct AppNotice: Identifiable {
    public let id = UUID()
    public let title: String
    public let message: String

    public init(title: String, message: String) {
        self.title = title
        self.message = message
    }
}

@MainActor
public final class AppCommandCenter: ObservableObject {
    public static let shared = AppCommandCenter()

    @Published public var presentedSheet: AppSheetRoute?
    @Published public var notice: AppNotice?
    @Published public var selectedCursorToolID: String = "Select" {
        didSet {
            if oldValue != "Annotate" && oldValue != "EraseAnnotation" {
                lastCursorToolID = oldValue
            }
        }
    }
    @Published public var lastCursorToolID: String = "Select"
    @Published public var beforeAfterEnabled: Bool = false
    @Published public var beforeAfterMode: Int = 0 // 0: Full View, 1: Split Screen
    @Published public var beforeAfterSplitPosition: Double = 0.5
    @Published public var showGridOverlay: Bool = false
    @Published public var showExposureWarning: Bool = false
    @Published public var showFocusMask: Bool = false
    @Published public var editSelectedOnly: Bool = true
    
    // Auto Adjust Configuration (UI-204) - Managed by COAutoAdjustManager
    public var autoAdjustManager = COAutoAdjustManager.shared
    
    // Cull View State (WS-103)
    @Published public var isGroupingEnabled: Bool = false
    @Published public var groupSimilarity: Double = 0.5
    @Published public var showCullingFaceFocus: Bool = true
    
    // Adjustments Clipboard State
    @Published public var clipboardAutoSelectAdjusted: Bool = true
    @Published public var clipboardExposureSelected: Bool = true
    @Published public var clipboardColorSelected: Bool = true
    @Published public var clipboardDetailsSelected: Bool = true
    @Published public var clipboardLayersSelected: Bool = true
    
    @Published public private(set) var importer = POImporter()
    @Published public private(set) var copiedAdjustments: COStyle?
    @Published public var browser = CImageBrowser()
    @Published public var selectedVariantsForBatchRename: [VariantBase] = []

    public let batchRenameController = COBatchRenameController()
    public var recipeManager: OutputRecipeManager = OutputRecipeManager.shared
    public var batchQueue: BatchQueue = BatchQueue()
    public var session: SessionBase?
    /// Retained context for the current document — prevents premature deallocation
    private var documentContext: ObjectContext?

    private let adjustmentController = AdjustmentToolController.shared
    private let workspaceManager = WorkspaceManager.shared

    private init() {}

    public func configure(
        session: SessionBase,
        recipeManager: OutputRecipeManager,
        batchQueue: BatchQueue
    ) {
        self.session = session
        self.recipeManager = recipeManager
        self.batchQueue = batchQueue
        
        // Register shortcuts
        ShortcutManager.shared.registerAction(id: "com.captureone.tool.select") { [weak self] in
            self?.selectedCursorToolID = "Select"
        }
        ShortcutManager.shared.registerAction(id: "com.captureone.tool.pan") { [weak self] in
            self?.selectedCursorToolID = "Pan"
        }
        ShortcutManager.shared.registerAction(id: "com.captureone.tool.loupe") { [weak self] in
            self?.selectedCursorToolID = "Loupe"
        }
        ShortcutManager.shared.registerAction(id: "com.captureone.tool.crop") { [weak self] in
            self?.selectedCursorToolID = "Crop"
        }
        ShortcutManager.shared.registerAction(id: "com.captureone.tool.rotate") { [weak self] in
            self?.selectedCursorToolID = "Rotate"
        }
        ShortcutManager.shared.registerAction(id: "com.captureone.tool.keystone") { [weak self] in
            self?.selectedCursorToolID = "Keystone"
        }
        ShortcutManager.shared.registerAction(id: "com.captureone.tool.heal") { [weak self] in
            self?.selectedCursorToolID = "Heal"
        }
        ShortcutManager.shared.registerAction(id: "com.captureone.tool.clone") { [weak self] in
            self?.selectedCursorToolID = "Clone"
        }
        ShortcutManager.shared.registerAction(id: "com.captureone.tool.directColorEditor") { [weak self] in
            self?.selectedCursorToolID = "DirectColorEditor"
        }
        ShortcutManager.shared.registerAction(id: "com.captureone.tool.linearGradient") { [weak self] in
            self?.selectedCursorToolID = "DrawLinearGradient"
        }
        ShortcutManager.shared.registerAction(id: "com.captureone.tool.drawMask") { [weak self] in
            self?.selectedCursorToolID = "DrawMask"
        }
        ShortcutManager.shared.registerAction(id: "com.captureone.tool.eraseMask") { [weak self] in
            self?.selectedCursorToolID = "EraseMask"
        }
        ShortcutManager.shared.registerAction(id: "com.captureone.tool.annotate") { [weak self] in
            guard let self = self else { return }
            if self.selectedCursorToolID == "Annotate" || self.selectedCursorToolID == "EraseAnnotation" {
                self.selectedCursorToolID = self.lastCursorToolID
            } else {
                self.selectedCursorToolID = "Annotate"
            }
        }
        ShortcutManager.shared.registerAction(id: "com.captureone.tool.magicBrush") { [weak self] in
            self?.selectedCursorToolID = "DrawMagicBrush"
        }
        ShortcutManager.shared.registerAction(id: "com.captureone.cullView") { [weak self] in
            self?.openCullingWindow()
        }
        ShortcutManager.shared.registerAction(id: "com.captureone.tool.radialGradient") { [weak self] in
            self?.selectedCursorToolID = "DrawRadialGradient"
        }
        ShortcutManager.shared.registerAction(id: "com.captureone.autoAdjust") { [weak self] in
            self?.autoAdjust()
        }
        ShortcutManager.shared.registerAction(id: "com.captureone.mask.toggleVisibility") { [weak self] in
            self?.toggleMaskVisibility()
        }
        ShortcutManager.shared.registerAction(id: "com.captureone.applyAdjustments") { [weak self] in
            self?.pasteAdjustments()
        }
        ShortcutManager.shared.registerAction(id: "com.captureone.beforeAfter") { [weak self] in
            self?.beforeAfterEnabled.toggle()
        }
        
        // MARK: - Browser Mode Actions (WF-501)
        ShortcutManager.shared.registerAction(id: "com.captureone.browser.grid") { [weak self] in
            self?.workspaceManager.activeWorkspace.chromeState.browserMode = 0
            self?.workspaceManager.saveWorkspace()
        }
        ShortcutManager.shared.registerAction(id: "com.captureone.browser.filmstrip") { [weak self] in
            self?.workspaceManager.activeWorkspace.chromeState.browserMode = 1
            self?.workspaceManager.saveWorkspace()
        }
        ShortcutManager.shared.registerAction(id: "com.captureone.browser.list") { [weak self] in
            self?.workspaceManager.activeWorkspace.chromeState.browserMode = 2
            self?.workspaceManager.saveWorkspace()
        }
    }

    public func selectSessionFolder(type: SessionFolderType) {
        guard let session = session else { return }
        guard let url = SessionFolderManager.shared.resolvePath(for: type, in: session) else { return }
        
        print("[CommandCenter] Selecting folder: \(url.path)")
        
        let context = session.managedObjectContext ?? ObjectContext()
        let collection = MOFolderCollection(uuid: UUID().uuidString, context: context)
        collection.updateWithFolderPath(url.path, clear: true, synchronizeFS: true)
        
        self.browser.dataSource = collection.images
        
        // Auto-select first image if available
        if let firstImage = collection.images.first {
            adjustmentController.currentVariant = firstImage.primaryVariant
        }
    }

    public func handleToolbarAction(_ itemID: String) {
        switch itemID {
        case "Select", "Pan", "Loupe", "Crop", "Straighten", "Rotate", "Keystone", "KeystoneVertical", "KeystoneHorizontal", "Heal", "Clone", "DrawLinearGradient", "DrawRadialGradient", "DirectColorEditor", "PickColorEditor", "DrawMask", "EraseMask", "Annotate", "EraseAnnotation", "DrawMagicBrush", "EraseMagicBrush":
            self.selectedCursorToolID = itemID
        case "Import":
            presentImport()
        case "Export":
            presentExport()
        case "BatchRename":
            presentBatchRename()
        case "Capture":
            workspaceManager.setSelectedPaletteID("CaptureToolTab")
        case "Reset":
            resetAdjustments()
        case "AutoAdjust":
            autoAdjust()
        case "ConvertNegative":
            adjustmentController.negativeFilmEnabled.toggle()
        case "CopyAdjustments":
            copyAdjustments()
        case "ApplyAdjustments":
            applyCopiedAdjustments()
        case "Print":
            presentPrint()
        case "BeforeAfter":
            beforeAfterEnabled.toggle()
        case "Grid":
            showGridOverlay.toggle()
        case "ExposureWarning":
            showExposureWarning.toggle()
        case "FocusMask":
            showFocusMask.toggle()
        case "Proofing":
            adjustmentController.isSoftProofingEnabled.toggle()
        case "EditSelected":
            editSelectedOnly.toggle()
        case "Culling":
            workspaceManager.activeWorkspace.chromeState.browserDisplayState =
                workspaceManager.activeWorkspace.chromeState.browserDisplayState == .hidden ? .shown : .hidden
        case "Live":
            openLivePreview()
        case "SelfServe", "Tips":
            showTips()
        default:
            notice = AppNotice(
                title: "Unavailable Action",
                message: "\(itemID) is not wired yet."
            )
        }
    }

    public func undo() {
        if let undoManager = NSApp.keyWindow?.undoManager, undoManager.canUndo {
            undoManager.undo()
        } else {
            notice = AppNotice(
                title: "Undo",
                message: "No undo stack is available in the current reconstruction state."
            )
        }
    }

    public func redo() {
        if let undoManager = NSApp.keyWindow?.undoManager, undoManager.canRedo {
            undoManager.redo()
        } else {
            notice = AppNotice(
                title: "Redo",
                message: "No redo stack is available in the current reconstruction state."
            )
        }
    }
    
    // MARK: - Culling & Selection (WF-502)
    
    public func selectNextVariant() {
        let items = browser.dataSource
        guard !items.isEmpty, let current = adjustmentController.currentVariant?.image else { return }
        if let index = items.firstIndex(where: { $0.id == current.id }), index < items.count - 1 {
            adjustmentController.currentVariant = items[index + 1].primaryVariant
        }
    }
    
    public func selectPreviousVariant() {
        let items = browser.dataSource
        guard !items.isEmpty, let current = adjustmentController.currentVariant?.image else { return }
        if let index = items.firstIndex(where: { $0.id == current.id }), index > 0 {
            adjustmentController.currentVariant = items[index - 1].primaryVariant
        }
    }
    
    public func setRating(_ rating: Int) {
        guard let variant = adjustmentController.currentVariant else { return }
        variant.rating = rating
        
        // Auto-Advance logic (Parity with C1 default behavior)
        if UserDefaults.standard.bool(forKey: "COAutoAdvanceAfterVariantRating") {
            selectNextVariant()
        }
    }
    
    public func setColorTag(_ tag: VariantBase.ColorTag) {
        guard let variant = adjustmentController.currentVariant else { return }
        variant.colorTag = tag
        
        if UserDefaults.standard.bool(forKey: "COAutoAdvanceAfterVariantRating") {
            selectNextVariant()
        }
    }
    
    // MARK: - Image Transformations (UI-204)
    
    public func rotateLeft() {
        guard let variant = adjustmentController.currentVariant else { return }
        adjustmentController.rotationAngle -= 90
        print("[Command] Rotated Left: \(variant.image?.displayName ?? "")")
    }
    
    public func rotateRight() {
        guard let variant = adjustmentController.currentVariant else { return }
        adjustmentController.rotationAngle += 90
        print("[Command] Rotated Right: \(variant.image?.displayName ?? "")")
    }
    
    public func applyCrop() {
        self.selectedCursorToolID = "Select"
        print("[AppCommandCenter] Crop Applied")
    }
    
    public func flipHorizontal() {
        guard let variant = adjustmentController.currentVariant else { return }
        adjustmentController.flipHorizontal.toggle()
        print("[Command] Flip Horizontal: \(adjustmentController.flipHorizontal) for \(variant.image?.displayName ?? "")")
    }
    
    public func flipVertical() {
        guard let variant = adjustmentController.currentVariant else { return }
        adjustmentController.flipVertical.toggle()
        print("[Command] Flip Vertical: \(adjustmentController.flipVertical) for \(variant.image?.displayName ?? "")")
    }
    
    // MARK: - Specialized Tool Modes (WF-503)
    
    public func setKeystoneMode(_ mode: Int) {
        // 0: Vertical, 1: Horizontal, 2: 4-Point
        print("[Command] Keystone Mode set to: \(mode)")
        selectedCursorToolID = "Keystone"
    }
    
    public func setPickerTool(_ type: String) {
        // "WB", "Levels", "Curves", "ColorEditor"
        print("[Command] Picker Tool active: \(type)")
        selectedCursorToolID = "Picker_\(type)"
    }

    public func presentImport() {
        importer = POImporter()
        COWindowManager.shared.openImporterWindow(importer: importer)
    }

    public func presentExport() {
        COWindowManager.shared.openExporterWindow(
            recipeManager: recipeManager,
            batchQueue: batchQueue,
            selectedVariant: adjustmentController.currentVariant
        )
    }

    public func newCatalog() {
        presentedSheet = .newCatalog
    }

    public func newSession() {
        presentedSheet = .newSession
    }

    public func createCatalog(name: String, location: URL) {
        let catalogPath = location.appendingPathComponent("\(name).cocatalog").path
        print("[CommandCenter] Creating New Catalog: \(name) at \(catalogPath)")
        
        CORecentDocumentManager.shared.recordOpenedDocument(name: name, path: catalogPath, isCatalog: true)
        
        let ctx = ObjectContext()
        documentContext = ctx
        let session = SessionBase(documentUUID: UUID().uuidString, type: 0, context: ctx)
        session.name = name
        
        let recipeManager = OutputRecipeManager.shared
        if recipeManager.recipes.isEmpty {
            recipeManager.addRecipe(OutputRecipe(name: "JPEG 80%", recipe: MCRecipe(dictionary: [:]), context: ctx))
        }
        
        configure(session: session, recipeManager: recipeManager, batchQueue: BatchQueue())
        print("[CommandCenter] Catalog configured, opening window...")
        COWindowManager.shared.openDocumentWindow(for: session)
        presentedSheet = nil
    }

    public func createSession(name: String, location: URL, subfolders: [String: String], autoFavorite: Bool = false) {
        let sessionRoot = location.appendingPathComponent(name)
        let sessionPath = sessionRoot.appendingPathComponent("\(name).cosession").path
        print("[CommandCenter] Creating New Session: \(name) at \(sessionPath)")
        
        CORecentDocumentManager.shared.recordOpenedDocument(name: name, path: sessionPath, isCatalog: false)
        
        let evaluator = TokenEvaluator()
        let tokenContext = TokenEvaluator.Context(imageName: "Image", date: Date(), sequence: 1, jobName: name)
        
        // Evaluate the dynamic subfolder names
        var evaluatedSubfolders: [String: String] = [:]
        for (key, format) in subfolders {
            evaluatedSubfolders[key] = evaluator.evaluate(format: format, context: tokenContext)
        }
        
        // 1. Create directory scaffold
        let fm = FileManager.default
        do {
            try fm.createDirectory(at: sessionRoot, withIntermediateDirectories: true)
            for folderName in evaluatedSubfolders.values {
                try fm.createDirectory(at: sessionRoot.appendingPathComponent(folderName), withIntermediateDirectories: true)
            }
            // Create dummy .cosession file
            let sessionFile = sessionRoot.appendingPathComponent("\(name).cosession")
            try "Capture One Session".write(to: sessionFile, atomically: true, encoding: .utf8)
        } catch {
            notice = AppNotice(title: "Creation Error", message: "Failed to create session folder structure: \(error.localizedDescription)")
            return
        }

        let ctx = ObjectContext()
        documentContext = ctx
        let session = SessionBase(documentUUID: UUID().uuidString, type: 1, context: ctx)
        session.name = name
        session.rootFolder = sessionRoot.path
        
        // Assign the actual evaluated folder paths back to session
        if let cap = evaluatedSubfolders["Capture"] { session.captureFolder = sessionRoot.appendingPathComponent(cap).path }
        if let sel = evaluatedSubfolders["Selects"] { session.selectsFolder = sessionRoot.appendingPathComponent(sel).path }
        if let out = evaluatedSubfolders["Output"] { session.outputFolder = sessionRoot.appendingPathComponent(out).path }
        if let tra = evaluatedSubfolders["Trash"] { session.trashFolder = sessionRoot.appendingPathComponent(tra).path }
        
        if autoFavorite {
            for folderName in evaluatedSubfolders.values {
                let fav = CollectionBase(uuid: UUID().uuidString, context: ctx)
                fav.name = folderName
                fav.folderPath = sessionRoot.appendingPathComponent(folderName).path
                session.arrangedUserFavouriteCollections.append(fav)
            }
        }
        
        let recipeManager = OutputRecipeManager.shared
        if recipeManager.recipes.isEmpty {
            recipeManager.addRecipe(OutputRecipe(name: "JPEG 80%", recipe: MCRecipe(dictionary: [:]), context: ctx))
        }
        
        configure(session: session, recipeManager: recipeManager, batchQueue: BatchQueue())
        selectSessionFolder(type: .capture) // Auto-load Capture folder

        print("[CommandCenter] Session configured, opening window...")
        COWindowManager.shared.openDocumentWindow(for: session)
        presentedSheet = nil
    }

    public func saveSessionAsTemplate(name: String, subfolders: [String: String]) {
        print("[AppCommandCenter] Saving Session Template: \(name).cosessiontemplate")
        // In a real implementation, this would write a JSON/Plist to Application Support/Capture One/Templates
    }

    public func openDocument(at url: URL) {
        print("[CommandCenter] Opening document at: \(url.path)")
        
        let isCatalog = url.pathExtension == "cocatalog"
        let name = url.deletingPathExtension().lastPathComponent
        CORecentDocumentManager.shared.recordOpenedDocument(name: name, path: url.path, isCatalog: isCatalog)
        
        Task { @MainActor in
            // 1. Open SQLite Database (DataCore)
            let dbURL: URL
            if isCatalog {
                dbURL = url.appendingPathComponent("\(name).cocatalogdb") // Standard C1 package structure
            } else {
                dbURL = url.deletingPathExtension().appendingPathExtension("cosessiondb")
            }
            
            do {
                try DataCoreManager.shared.openDatabase(at: dbURL)
            } catch {
                print("[CommandCenter] Warning: Could not open database at \(dbURL.path): \(error.localizedDescription)")
                // We continue anyway as a fallback, but some features might fail with DataCore error 3
            }

            let ctx = ObjectContext()
            self.documentContext = ctx
            let session = SessionBase(documentUUID: UUID().uuidString, type: isCatalog ? 1 : 0, context: ctx)
            session.name = name
            
            if !isCatalog {
                let root = url.deletingLastPathComponent()
                session.rootFolder = root.path
                self.resolveStandardFolders(for: session, at: root)
            }
            
            self.configure(session: session, recipeManager: OutputRecipeManager.shared, batchQueue: BatchQueue())
            if !isCatalog {
                self.selectSessionFolder(type: .capture)
            }
            COWindowManager.shared.openDocumentWindow(for: session)
        }
    }

    private func resolveStandardFolders(for session: SessionBase, at root: URL) {
        session.captureFolder = root.appendingPathComponent("Capture").path
        session.selectsFolder = root.appendingPathComponent("Selects").path
        session.outputFolder = root.appendingPathComponent("Output").path
        session.trashFolder = root.appendingPathComponent("Trash").path
    }

    public func openDocument() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowedContentTypes = [.init(filenameExtension: "cocatalog")!, .init(filenameExtension: "cosession")!]
        
        panel.begin { response in
            if response == .OK, let url = panel.url {
                print("[CommandCenter] Opening document at: \(url.path)")
                
                let isCatalog = url.pathExtension == "cocatalog"
                let name = url.deletingPathExtension().lastPathComponent
                CORecentDocumentManager.shared.recordOpenedDocument(name: name, path: url.path, isCatalog: isCatalog)
                
                // Logic to load and open the document window
                Task { @MainActor in
                    // 1. Open SQLite Database (DataCore)
                    let dbURL: URL
                    if isCatalog {
                        dbURL = url.appendingPathComponent("\(name).cocatalogdb")
                    } else {
                        dbURL = url.deletingPathExtension().appendingPathExtension("cosessiondb")
                    }
                    
                    do {
                        try DataCoreManager.shared.openDatabase(at: dbURL)
                    } catch {
                        print("[CommandCenter] Warning: Could not open database at \(dbURL.path): \(error.localizedDescription)")
                    }

                    let ctx = ObjectContext()
                    self.documentContext = ctx
                    let session = SessionBase(documentUUID: UUID().uuidString, type: isCatalog ? 1 : 0, context: ctx)
                    session.name = name
                    
                    if !isCatalog {
                        let root = url.deletingLastPathComponent()
                        session.rootFolder = root.path
                        self.resolveStandardFolders(for: session, at: root)
                    }
                    
                    self.configure(session: session, recipeManager: OutputRecipeManager.shared, batchQueue: BatchQueue())
                    COWindowManager.shared.openDocumentWindow(for: session)
                }
            }
        }
    }
    
    public func performUpgrade() {
        print("[System] Performing session database upgrade...")
        // In Phase 3, this would trigger actual DataCore migration.
        notice = AppNotice(title: "Upgrade Successful", message: "The database has been upgraded to the current version.")
    }
    
    public func openLivePreview() {
        guard let session = session else {
            notice = AppNotice(title: "No Session", message: "A session must be open before launching Live View.")
            return
        }
        COWindowManager.shared.openLivePreview(for: session)
    }
    
    public func openViewerWindow() {
        guard let session = session else {
            notice = AppNotice(title: "No Session", message: "A session must be open before launching a Viewer window.")
            return
        }
        COWindowManager.shared.openViewerWindow(for: session)
    }
    
    public func presentBatchRename() {
        presentedSheet = .batchRename
    }
    
    public func updateSelectedVariantsForBatchRename(_ variants: [VariantBase]) {
        self.selectedVariantsForBatchRename = variants
    }
    
    public func openCullingWindow() {
        guard let session = session else {
            notice = AppNotice(title: "No Session", message: "A session must be open before launching a Culling window.")
            return
        }
        COWindowManager.shared.openCullingWindow(for: session)
        print("[AppCommandCenter] Opened Cull View")
    }

    public func presentPreferences() {
        presentedSheet = .preferences
    }

    public func presentKeyboardShortcuts() {
        presentedSheet = .keyboardShortcuts
    }

    public func presentPrint() {
        guard adjustmentController.currentVariant != nil else {
            notice = AppNotice(
                title: "Nothing to Print",
                message: "Select an image before opening the print dialog."
            )
            return
        }
        COWindowManager.shared.openPrintWindow()
    }

    public func resetAdjustments() {
        let isAltHeld = NSEvent.modifierFlags.contains(.option)
        
        // Safety Modal Logic (UI-806)
        if !editSelectedOnly {
            let alert = NSAlert()
            alert.messageText = "Reset Adjustments"
            alert.informativeText = "Are you sure you want to reset all adjustments on the selected images?"
            alert.addButton(withTitle: "Reset All")
            alert.addButton(withTitle: "Cancel")
            alert.alertStyle = .warning
            
            if alert.runModal() == .alertSecondButtonReturn {
                return // User cancelled
            }
        }
        
        adjustmentController.resetToNeutral(includeComposition: !isAltHeld)
        print("[AppCommandCenter] Global Reset (Include Composition: \(!isAltHeld))")
    }

    public func showTips() {
        notice = AppNotice(
            title: "Tips",
            message: "Menu tips and self-serve surfaces are still being restored."
        )
    }

    public func autoAdjust() {
        guard adjustmentController.currentVariant != nil else {
            notice = AppNotice(
                title: "No Selection",
                message: "Select an image before running Auto Adjust."
            )
            return
        }

        COAutoAdjustManager.shared.performAutoAdjust(controller: adjustmentController)
    }

    public func autoAdjustTool(_ toolID: String) {
        guard adjustmentController.currentVariant != nil else {
            notice = AppNotice(
                title: "No Selection",
                message: "Select an image before running Auto Adjust."
            )
            return
        }
        
        switch toolID {
        case "Exposure":
            COAutoAdjustManager.shared.autoAdjustExposure(controller: adjustmentController)
        case "White Balance":
            COAutoAdjustManager.shared.autoAdjustWhiteBalance(controller: adjustmentController)
        case "High Dynamic Range", "HDR":
            COAutoAdjustManager.shared.autoAdjustHDR(controller: adjustmentController)
        case "Levels":
            adjustmentController.autoLevels()
        case "Rotation":
            COAutoAdjustManager.shared.autoAdjustRotation(controller: adjustmentController)
        case "Keystone":
            adjustmentController.autoKeystone()
        default:
            autoAdjust()
        }
        
        adjustmentController.commitChanges(to: adjustmentController.currentVariant)
    }

    public func copyAdjustments() {
        copiedAdjustments = snapshotCurrentAdjustments(name: "Copied Adjustments")
        guard copiedAdjustments != nil else {
            notice = AppNotice(
                title: "Nothing to Copy",
                message: "Select an image before copying adjustments."
            )
            return
        }
    }

    public func applyCopiedAdjustments() {
        guard let copiedAdjustments else {
            notice = AppNotice(
                title: "Clipboard Empty",
                message: "Copy adjustments before trying to apply them."
            )
            return
        }

        guard adjustmentController.currentVariant != nil else {
            notice = AppNotice(
                title: "No Selection",
                message: "Select an image before applying copied adjustments."
            )
            return
        }

        adjustmentController.applyCOStyle(copiedAdjustments)
    }

    public func saveCurrentAdjustmentsAsCOStyle(toolID: String) {
        guard let style = snapshotCurrentAdjustments(name: "\(toolID) Snapshot") else {
            notice = AppNotice(
                title: "Nothing to Save",
                message: "Select an image before saving adjustments as a style."
            )
            return
        }

        COStyleManager.shared.objectWillChange.send()
        COStyleManager.shared.userCOStyles.styles.append(style)
        notice = AppNotice(
            title: "COStyle Saved",
            message: "\"\(style.name)\" was added to User COStyles."
        )
    }

    public func applyCOStyle(_ style: COStyle) {
        guard adjustmentController.currentVariant != nil else {
            notice = AppNotice(
                title: "No Selection",
                message: "Select an image before applying a style."
            )
            return
        }

        adjustmentController.applyCOStyle(style)
    }

    public func showHelp(for toolID: String) {
        notice = AppNotice(
            title: toolID,
            message: "Tool help popovers are still being restored. This placeholder keeps the header affordance functional."
        )
    }

    public struct ToolAdjustmentClip {
        public let toolID: String
        public let style: COStyle
    }
    public private(set) var copiedToolAdjustments: ToolAdjustmentClip?

    public func copyAdjustmentsForTool(_ toolID: String) {
        guard let style = snapshotCurrentAdjustments(name: "\(toolID) Copy") else {
            notice = AppNotice(
                title: "Nothing to Copy",
                message: "Select an image before copying \(toolID) adjustments."
            )
            return
        }
        copiedToolAdjustments = ToolAdjustmentClip(toolID: toolID, style: style)
    }

    public func pasteAdjustmentsForTool(_ toolID: String) {
        guard let copied = copiedToolAdjustments else {
            notice = AppNotice(
                title: "Clipboard Empty",
                message: "Copy \(toolID) adjustments first."
            )
            return
        }
        guard adjustmentController.currentVariant != nil else {
            notice = AppNotice(
                title: "No Selection",
                message: "Select an image before applying copied adjustments."
            )
            return
        }
        adjustmentController.applyCOStyle(copied.style)
    }

    public func toggleMaskVisibility() {
        // Cycle: Always (1) -> Never (0) -> Always (1)
        // (Simplified cycle for the 'M' shortcut)
        if adjustmentController.maskVisibilityMode == 1 {
            adjustmentController.maskVisibilityMode = 0
        } else {
            adjustmentController.maskVisibilityMode = 1
        }
        print("[AppCommandCenter] Mask Visibility: \(adjustmentController.maskVisibilityMode == 1 ? "Always" : "Never")")
    }

    public func pasteAdjustments() {
        // General paste: Apply from global clipboard
        // For now, reuse the most recently copied tool adjustments as a fallback
        if let clip = copiedToolAdjustments {
            adjustmentController.applyCOStyle(clip.style)
            print("[AppCommandCenter] Applied adjustments from \(clip.toolID)")
        } else {
            notice = AppNotice(
                title: "Clipboard Empty",
                message: "No adjustments found in clipboard to apply."
            )
        }
    }

    public func resetTool(_ toolID: String) {
        switch toolID {
        case "Exposure":
            adjustmentController.exposure = 0
            adjustmentController.contrast = 0
            adjustmentController.brightness = 0
            adjustmentController.saturation = 0
        case "White Balance":
            adjustmentController.kelvin = 5000
            adjustmentController.tint = 0
        case "High Dynamic Range", "ShadowHighlight":
            adjustmentController.highlights = 0
            adjustmentController.shadows = 0
            adjustmentController.whites = 0
            adjustmentController.blacks = 0
        case "Color Balance":
            adjustmentController.cbMaster = .neutral
            adjustmentController.cbShadow = .neutral
            adjustmentController.cbMidtone = .neutral
            adjustmentController.cbHighlight = .neutral
        case "Clarity":
            adjustmentController.clarityAmount = 0
            adjustmentController.structureAmount = 0
        case "Sharpening":
            adjustmentController.sharpAmount = 100
            adjustmentController.sharpRadius = 0.8
            adjustmentController.sharpThreshold = 1.0
            adjustmentController.sharpHalo = 0.0
        case "Noise Reduction", "Noise":
            adjustmentController.nrLuminance = 50
            adjustmentController.nrDetails = 50
            adjustmentController.nrColor = 50
            adjustmentController.nrSinglePixel = 0
        case "Vignetting":
            adjustmentController.vignettingAmount = 0
            adjustmentController.vignettingMethod = 0
        case "Dehaze":
            adjustmentController.dehazeAmount = 0
            adjustmentController.dehazeColor = .gray
        case "Crop":
            adjustmentController.cropRect = .zero
        default:
            adjustmentController.resetToNeutral()
        }
    }

    private func snapshotCurrentAdjustments(name: String) -> COStyle? {
        guard adjustmentController.currentVariant != nil else {
            return nil
        }

        var adjustments: [String: AnyCodable] = [:]
        
        // Simple mapping based on the Tool Categories
        if clipboardExposureSelected {
            adjustments["ZEXPOSURE"] = AnyCodable(Double(adjustmentController.exposure))
            adjustments["ZCONTRAST"] = AnyCodable(Double(adjustmentController.contrast))
            adjustments["ZBRIGHTNESS"] = AnyCodable(Double(adjustmentController.brightness))
        }
        
        if clipboardColorSelected {
            adjustments["ZSATURATION"] = AnyCodable(Double(adjustmentController.saturation))
            adjustments["ZKELVIN"] = AnyCodable(Double(adjustmentController.kelvin))
            adjustments["ZTINT"] = AnyCodable(Double(adjustmentController.tint))
        }
        
        // Return nil if nothing is selected
        guard !adjustments.isEmpty else { return nil }

        return COStyle(name: name, adjustments: adjustments)
    }
}
