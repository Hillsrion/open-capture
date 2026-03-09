import SwiftUI
import AppKit
import AppCoreShared
import DataCore

public enum AppSheetRoute: String, Identifiable {
    case preferences
    case keyboardShortcuts
    case sessionUpgrade

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
    @Published public private(set) var importer = POImporter()
    @Published public private(set) var copiedAdjustments: Style?

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
    }

    public func handleToolbarAction(_ itemID: String) {
        switch itemID {
        case "Select", "Pan", "Loupe", "Crop", "Straighten", "Rotate", "Keystone":
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
        let ctx = ObjectContext()
        documentContext = ctx
        let session = SessionBase(documentUUID: UUID().uuidString, type: 0, context: ctx)
        session.name = "Untitled Catalog"
        
        let recipeManager = OutputRecipeManager.shared
        if recipeManager.recipes.isEmpty {
            recipeManager.addRecipe(OutputRecipe(name: "JPEG 80%", recipe: MCRecipe(dictionary: [:]), context: ctx))
        }
        
        configure(session: session, recipeManager: recipeManager, batchQueue: BatchQueue())
        COWindowManager.shared.openDocumentWindow(for: session)
    }

    public func newSession() {
        let ctx = ObjectContext()
        documentContext = ctx
        let session = SessionBase(documentUUID: UUID().uuidString, type: 1, context: ctx)
        session.name = "Untitled Session"
        
        let recipeManager = OutputRecipeManager.shared
        if recipeManager.recipes.isEmpty {
            recipeManager.addRecipe(OutputRecipe(name: "JPEG 80%", recipe: MCRecipe(dictionary: [:]), context: ctx))
        }
        
        configure(session: session, recipeManager: recipeManager, batchQueue: BatchQueue())
        COWindowManager.shared.openDocumentWindow(for: session)
    }

    public func openDocument() {
        // Simulate finding an old session that needs upgrade
        let ctx = ObjectContext()
        self.documentContext = ctx
        let oldSession = SessionBase(documentUUID: "legacy-session", type: 1, context: ctx)
        oldSession.name = "Legacy Professional Catalog"
        self.session = oldSession
        
        // Show upgrade dialog (simulated trigger)
        presentedSheet = .sessionUpgrade
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

        let adjustments: [String: AnyCodable] = [
            "ZEXPOSURE": AnyCodable(Double(adjustmentController.exposure)),
            "ZCONTRAST": AnyCodable(Double(adjustmentController.contrast)),
            "ZBRIGHTNESS": AnyCodable(Double(adjustmentController.brightness)),
            "ZSATURATION": AnyCodable(Double(adjustmentController.saturation)),
            "ZKELVIN": AnyCodable(Double(adjustmentController.kelvin)),
            "ZTINT": AnyCodable(Double(adjustmentController.tint))
        ]
        return Style(name: name, adjustments: adjustments)
    }
}
