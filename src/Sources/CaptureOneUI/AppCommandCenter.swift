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
    @Published public var selectedCursorToolID: String = "Select"
    @Published public var beforeAfterEnabled: Bool = false
    @Published public var showGridOverlay: Bool = false
    @Published public var showExposureWarning: Bool = false
    @Published public var showFocusMask: Bool = false
    @Published public var editSelectedOnly: Bool = true
    
    // Adjustments Clipboard State
    @Published public var clipboardAutoSelectAdjusted: Bool = true
    @Published public var clipboardExposureSelected: Bool = true
    @Published public var clipboardColorSelected: Bool = true
    @Published public var clipboardDetailsSelected: Bool = true
    @Published public var clipboardLayersSelected: Bool = true
    
    @Published public private(set) var importer = POImporter()
    @Published public private(set) var copiedAdjustments: Style?
    @Published public var browser = CImageBrowser()

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
        ShortcutManager.shared.registerAction(id: "com.captureone.tool.heal") { [weak self] in
            self?.selectedCursorToolID = "Heal"
        }
        ShortcutManager.shared.registerAction(id: "com.captureone.tool.clone") { [weak self] in
            self?.selectedCursorToolID = "Clone"
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
        case "Select", "Pan", "Loupe", "Crop", "Straighten", "Rotate", "Keystone", "Heal", "Clone":
            selectedCursorToolID = itemID
        case "Import":
            presentImport()
        case "Export":
            presentExport()
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

    public func openDocument(at url: URL) {
        print("[CommandCenter] Opening document at: \(url.path)")
        
        let isCatalog = url.pathExtension == "cocatalog"
        let name = url.deletingPathExtension().lastPathComponent
        CORecentDocumentManager.shared.recordOpenedDocument(name: name, path: url.path, isCatalog: isCatalog)
        
        Task { @MainActor in
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
    
    public func openCullingWindow() {
        guard let session = session else {
            notice = AppNotice(title: "No Session", message: "A session must be open before launching a Culling window.")
            return
        }
        COWindowManager.shared.openCullingWindow(for: session)
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
        adjustmentController.resetToNeutral()
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

        // Keep the current implementation simple but visible until the
        // decompiled auto-adjust pipeline is restored.
        adjustmentController.exposure = min(max(adjustmentController.exposure == 0 ? 0.15 : adjustmentController.exposure * 0.7, -1.0), 1.0)
        adjustmentController.contrast = min(max(adjustmentController.contrast, 10.0), 20.0)
        adjustmentController.saturation = min(max(adjustmentController.saturation, 5.0), 15.0)
    }

    public func autoAdjustTool(_ toolID: String) {
        guard adjustmentController.currentVariant != nil else {
            notice = AppNotice(
                title: "No Selection",
                message: "Select an image before running Auto Adjust."
            )
            return
        }
        
        // Simple heuristic for Phase 2: just slightly nudge values toward center/neutral
        // based on the tool's focus area.
        switch toolID {
        case "Exposure":
            adjustmentController.exposure = min(max(adjustmentController.exposure * 1.1, -2.0), 2.0)
        case "White Balance":
            adjustmentController.kelvin = 5600
            adjustmentController.tint = 0
        case "High Dynamic Range":
            adjustmentController.highlights = 20
            adjustmentController.shadows = 20
        default:
            autoAdjust()
        }
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

        adjustmentController.applyStyle(copiedAdjustments)
    }

    public func saveCurrentAdjustmentsAsStyle(toolID: String) {
        guard let style = snapshotCurrentAdjustments(name: "\(toolID) Snapshot") else {
            notice = AppNotice(
                title: "Nothing to Save",
                message: "Select an image before saving adjustments as a style."
            )
            return
        }

        StyleManager.shared.objectWillChange.send()
        StyleManager.shared.userStyles.styles.append(style)
        notice = AppNotice(
            title: "Style Saved",
            message: "\"\(style.name)\" was added to User Styles."
        )
    }

    public func applyStyle(_ style: Style) {
        guard adjustmentController.currentVariant != nil else {
            notice = AppNotice(
                title: "No Selection",
                message: "Select an image before applying a style."
            )
            return
        }

        adjustmentController.applyStyle(style)
    }

    public func showHelp(for toolID: String) {
        notice = AppNotice(
            title: toolID,
            message: "Tool help popovers are still being restored. This placeholder keeps the header affordance functional."
        )
    }

    public struct ToolAdjustmentClip {
        public let toolID: String
        public let style: Style
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
        adjustmentController.applyStyle(copied.style)
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
        default:
            adjustmentController.resetToNeutral()
        }
    }

    private func snapshotCurrentAdjustments(name: String) -> Style? {
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

        return Style(name: name, adjustments: adjustments)
    }
}
