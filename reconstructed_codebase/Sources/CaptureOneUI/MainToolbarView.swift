import SwiftUI
import AppCoreShared
import ImageCore

/// Reconstructed high-fidelity Main Toolbar (UI-013/INT-001).
/// Based on version 16.5 layout and disassembly.
public struct MainToolbarView: View {
    @ObservedObject var workspaceManager = WorkspaceManager.shared
    @ObservedObject var adjustmentController = AdjustmentToolController.shared
    @ObservedObject var commands = AppCommandCenter.shared
    @State private var showingCustomization: Bool = false
    
    public init() {}
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(workspaceManager.activeWorkspace.toolbarConfiguration.itemIDs, id: \.self) { id in
                if id == "FLEXIBLE_SPACER" {
                    Spacer()
                } else if id == "FIXED_SPACER" {
                    Spacer().frame(width: 20)
                } else if let item = COToolbarItemRegistry.item(for: id) {
                    toolbarItemView(item)
                }
            }
        }
        .padding(.horizontal, 10)
        .frame(height: 40)
        .background(CaptureOneTheme.Colors.toolbarBackground)
        .contextMenu {
            Button("Customize Toolbar...") {
                showingCustomization = true
            }
        }
        .sheet(isPresented: $showingCustomization) {
            ToolbarCustomizationDialog()
        }
        .overlay(
            Rectangle()
                .fill(CaptureOneTheme.Colors.separator)
                .frame(height: 1),
            alignment: .bottom
        )
    }

    @ViewBuilder
    private func toolbarItemView(_ item: COToolbarItem) -> some View {
        switch item.id {
        case "UndoRedo":
            UndoRedoToolbarGroup()
        case "CursorTools":
            CursorToolsToolbarGroup()
        case "Activity":
            ActivityToolbarGroup()
        case "Proofing":
            ProofingToolbarGroup()
        default:
            COToolbarButton(
                item: item,
                isSelected: commands.selectedCursorToolID == item.id || toolbarToggleSelection(item.id)
            ) {
                commands.handleToolbarAction(item.id)
            }
        }
    }

    private func toolbarToggleSelection(_ itemID: String) -> Bool {
        switch itemID {
        case "BeforeAfter":
            return commands.beforeAfterEnabled
        case "Grid":
            return commands.showGridOverlay
        case "ExposureWarning":
            return commands.showExposureWarning
        case "FocusMask":
            return commands.showFocusMask
        case "Proofing":
            return adjustmentController.isSoftProofingEnabled
        case "EditSelected":
            return commands.editSelectedOnly
        default:
            return false
        }
    }
}

private struct UndoRedoToolbarGroup: View {
    @ObservedObject private var commands = AppCommandCenter.shared

    var body: some View {
        HStack(spacing: 4) {
            IconOnlyToolbarButton(systemName: "arrow.uturn.backward", action: commands.undo)
            IconOnlyToolbarButton(systemName: "arrow.uturn.forward", action: commands.redo)
        }
        .padding(.horizontal, 4)
    }
}

private struct CursorToolsToolbarGroup: View {
    @ObservedObject private var commands = AppCommandCenter.shared

    private let tools: [(String, String)] = [
        ("Select", "cursorarrow"),
        ("Pan", "hand.raised"),
        ("Loupe", "magnifyingglass"),
        ("Crop", "crop"),
        ("Rotate", "rotate.right"),
        ("Keystone", "rectangle.distorted")
    ]

    var body: some View {
        HStack(spacing: 2) {
            ForEach(tools, id: \.0) { toolID, iconName in
                IconOnlyToolbarButton(
                    systemName: iconName,
                    isSelected: commands.selectedCursorToolID == toolID
                ) {
                    commands.handleToolbarAction(toolID)
                }
            }
        }
        .padding(.horizontal, 4)
    }
}

private struct ActivityToolbarGroup: View {
    @ObservedObject private var commands = AppCommandCenter.shared

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 14))
                .foregroundColor(CaptureOneTheme.Colors.iconNormal)

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
                    .foregroundColor(CaptureOneTheme.Colors.textSecondary)
            }
        }
        .padding(.horizontal, 6)
    }
}

private struct ProofingToolbarGroup: View {
    @ObservedObject private var adjustmentController = AdjustmentToolController.shared
    @ObservedObject private var commands = AppCommandCenter.shared

    var body: some View {
        HStack(spacing: 6) {
            COToolbarButton(
                item: COToolbarItemRegistry.item(for: "Proofing")!,
                isSelected: adjustmentController.isSoftProofingEnabled
            ) {
                commands.handleToolbarAction("Proofing")
            }

            if adjustmentController.isSoftProofingEnabled {
                Menu {
                    ForEach(ICCManager.shared.availableProfiles(for: .output)) { profile in
                        Button(profile.name) {
                            adjustmentController.proofingProfileID = profile.id
                        }
                    }
                } label: {
                    Text(adjustmentController.proofingProfileID)
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(.gray)
                }
                .frame(width: 100)
            }
        }
    }
}

private struct IconOnlyToolbarButton: View {
    let systemName: String
    var isSelected: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 14))
                .frame(width: 28, height: 28)
                .background(isSelected ? CaptureOneTheme.Colors.activeHighlight : Color.white.opacity(0.05))
                .foregroundColor(isSelected ? .white : CaptureOneTheme.Colors.iconNormal)
                .cornerRadius(4)
        }
        .buttonStyle(.plain)
    }
}

struct COToolbarButton: View {
    let item: COToolbarItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                Image(systemName: item.iconName)
                    .font(.system(size: 18))
                    .frame(width: 32, height: 32)
                    .background(isSelected ? CaptureOneTheme.Colors.activeHighlight : Color.clear)
                    .foregroundColor(isSelected ? .white : CaptureOneTheme.Colors.iconNormal)
                    .cornerRadius(4)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .help(item.name)
    }
}
