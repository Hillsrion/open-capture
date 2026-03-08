import Cocoa
import SwiftUI
import AppCoreShared
import ImageCore

/// Native NSToolbar implementation for the main document window (UI-207).
/// Replaces the in-content SwiftUI MainToolbarView with a real macOS toolbar.
/// Based on decompiled POValidatingToolbarItem pattern.
public class CONativeToolbar: NSToolbar, NSToolbarDelegate {
    
    private var itemIDs: [NSToolbarItem.Identifier] = []
    private let commands: AppCommandCenter
    
    /// Creates a native toolbar driven by the workspace configuration.
    public init(configuration: ToolbarConfiguration, commands: AppCommandCenter) {
        self.commands = commands
        super.init(identifier: "com.phaseone.captureone.maintoolbar")
        self.delegate = self
        self.displayMode = .iconOnly
        self.allowsUserCustomization = true
        self.autosavesConfiguration = false
        
        // Map workspace config IDs to NSToolbarItem.Identifiers
        self.itemIDs = configuration.itemIDs.map { id in
            switch id {
            case "FLEXIBLE_SPACER": return .flexibleSpace
            case "FIXED_SPACER": return .space
            default: return NSToolbarItem.Identifier(id)
            }
        }
    }
    
    // MARK: - NSToolbarDelegate
    
    public func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return itemIDs
    }
    
    public func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        var all = COToolbarItemRegistry.availableItems.map { NSToolbarItem.Identifier($0.id) }
        all.append(.flexibleSpace)
        all.append(.space)
        return all
    }
    
    public func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        let id = itemIdentifier.rawValue
        
        // Standard spacers handled by AppKit
        if itemIdentifier == .flexibleSpace || itemIdentifier == .space {
            return nil
        }
        
        // Special grouped items get an NSToolbarItemGroup or custom view
        switch id {
        case "CursorTools":
            return makeCursorToolsGroup(identifier: itemIdentifier)
        case "UndoRedo":
            return makeUndoRedoGroup(identifier: itemIdentifier)
        case "Activity":
            return makeActivityItem(identifier: itemIdentifier)
        case "Proofing":
            return makeProofingItem(identifier: itemIdentifier)
        default:
            return makeStandardItem(identifier: itemIdentifier, id: id)
        }
    }
    
    // MARK: - Item Builders
    
    private func makeStandardItem(identifier: NSToolbarItem.Identifier, id: String) -> NSToolbarItem? {
        guard let model = COToolbarItemRegistry.item(for: id) else { return nil }
        
        let item = NSToolbarItem(itemIdentifier: identifier)
        item.label = model.name
        item.paletteLabel = model.name
        item.toolTip = model.name
        item.image = NSImage(systemSymbolName: model.iconName, accessibilityDescription: model.name)
        item.target = self
        item.action = #selector(toolbarItemClicked(_:))
        item.tag = id.hashValue
        item.isBordered = true
        return item
    }
    
    private func makeCursorToolsGroup(identifier: NSToolbarItem.Identifier) -> NSToolbarItem {
        let tools: [(String, String, String)] = [
            ("Select", "cursorarrow", "Select"),
            ("Pan", "hand.raised", "Pan"),
            ("Loupe", "magnifyingglass", "Loupe"),
            ("Crop", "crop", "Crop"),
            ("Rotate", "rotate.right", "Rotate"),
            ("Keystone", "rectangle.3.offgrid", "Keystone")
        ]
        
        let subitems = tools.map { id, icon, label -> NSToolbarItem in
            let sub = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier(id))
            sub.label = label
            sub.image = NSImage(systemSymbolName: icon, accessibilityDescription: label)
            sub.target = self
            sub.action = #selector(toolbarItemClicked(_:))
            sub.tag = id.hashValue
            return sub
        }
        
        let group = NSToolbarItemGroup(itemIdentifier: identifier)
        group.subitems = subitems
        group.selectionMode = .selectOne
        group.label = "Cursor Tools"
        group.paletteLabel = "Cursor Tools"
        
        // Select the first tool by default
        group.selectedIndex = 0
        
        return group
    }
    
    private func makeUndoRedoGroup(identifier: NSToolbarItem.Identifier) -> NSToolbarItem {
        let undoItem = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier("Undo"))
        undoItem.label = "Undo"
        undoItem.image = NSImage(systemSymbolName: "arrow.uturn.backward", accessibilityDescription: "Undo")
        undoItem.target = self
        undoItem.action = #selector(undoAction)

        let redoItem = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier("Redo"))
        redoItem.label = "Redo"
        redoItem.image = NSImage(systemSymbolName: "arrow.uturn.forward", accessibilityDescription: "Redo")
        redoItem.target = self
        redoItem.action = #selector(redoAction)

        let group = NSToolbarItemGroup(itemIdentifier: identifier)
        group.subitems = [undoItem, redoItem]
        group.label = "Undo / Redo"
        group.paletteLabel = "Undo / Redo"
        return group
    }
    
    private func makeActivityItem(identifier: NSToolbarItem.Identifier) -> NSToolbarItem {
        let item = NSToolbarItem(itemIdentifier: identifier)
        item.label = "Activity"
        item.paletteLabel = "Activity"
        
        let hostView = NSHostingView(rootView: ActivityToolbarGroupNative())
        hostView.frame = NSRect(x: 0, y: 0, width: 100, height: 28)
        item.view = hostView
        return item
    }
    
    private func makeProofingItem(identifier: NSToolbarItem.Identifier) -> NSToolbarItem {
        let item = NSToolbarItem(itemIdentifier: identifier)
        item.label = "Proofing"
        item.paletteLabel = "Proofing"
        item.image = NSImage(systemSymbolName: "eyeglasses", accessibilityDescription: "Proofing")
        item.target = self
        item.action = #selector(toolbarItemClicked(_:))
        item.tag = "Proofing".hashValue
        item.isBordered = true
        return item
    }
    
    // MARK: - Actions
    
    @objc private func toolbarItemClicked(_ sender: NSToolbarItem) {
        let id = sender.itemIdentifier.rawValue
        Task { @MainActor in
            self.commands.handleToolbarAction(id)
        }
    }
    
    @objc private func undoAction() {
        Task { @MainActor in self.commands.undo() }
    }
    
    @objc private func redoAction() {
        Task { @MainActor in self.commands.redo() }
    }
}

// MARK: - Embedded SwiftUI views for complex toolbar items

struct ActivityToolbarGroupNative: View {
    @ObservedObject private var commands = AppCommandCenter.shared

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 12))
                .foregroundColor(.gray)

            if let active = commands.batchQueue.activeJob {
                ProgressView(value: active.progress)
                    .frame(width: 50)
                    .tint(CaptureOneTheme.Colors.activeHighlight)
            } else if case .importing(let progress) = commands.importer.status {
                ProgressView(value: Double(progress))
                    .frame(width: 50)
                    .tint(CaptureOneTheme.Colors.activeHighlight)
            } else {
                Text("Idle")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
            }
        }
        .frame(width: 90, height: 24)
    }
}
