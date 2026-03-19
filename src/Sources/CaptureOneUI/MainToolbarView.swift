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
        case "BeforeAfter":
            BeforeAfterToolbarGroup()
        case "AutoAdjust":
            AutoAdjustToolbarGroup()
        default:
            COToolbarButton(
                item: item,
                isSelected: commands.selectedCursorToolID == item.id || toolbarToggleSelection(item.id),
                activeColor: item.id == "ExposureWarning" ? .orange : CaptureOneTheme.Colors.activeHighlight
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
        ("Loupe", "magnifyingglass")
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
            PickerToolbarGroup()
            CropToolbarGroup()
            RotateToolbarGroup()
            KeystoneToolbarGroup()
            
            HStack(spacing: 2) {
                IconOnlyToolbarButton(systemName: "pencil.tip", isSelected: commands.selectedCursorToolID == "Annotate") { commands.handleToolbarAction("Annotate") }
                IconOnlyToolbarButton(systemName: "eraser.fill", isSelected: commands.selectedCursorToolID == "EraseAnnotation") { commands.handleToolbarAction("EraseAnnotation") }
            }
        }
        .padding(.horizontal, 4)
    }
}

private struct PickerToolbarGroup: View {
    @ObservedObject private var commands = AppCommandCenter.shared

    var body: some View {
        IconOnlyToolbarButton(
            systemName: "eyedropper",
            isSelected: commands.selectedCursorToolID.contains("Picker")
        ) {
            commands.setPickerTool("WB")
        }
        .contextMenu {
            Button("Pick White Balance") { commands.setPickerTool("WB") }
            Button("Pick Levels") { commands.setPickerTool("Levels") }
            Button("Pick Curves") { commands.setPickerTool("Curves") }
            Button("Pick Color Correction") { commands.setPickerTool("ColorEditor") }
        }
    }
}

private struct KeystoneToolbarGroup: View {
    @ObservedObject private var commands = AppCommandCenter.shared

    var body: some View {
        IconOnlyToolbarButton(
            systemName: "rectangle.distorted",
            isSelected: commands.selectedCursorToolID == "Keystone"
        ) {
            commands.handleToolbarAction("Keystone")
        }
        .contextMenu {
            Button("Keystone Vertical") { commands.setKeystoneMode(0) }
            Button("Keystone Horizontal") { commands.setKeystoneMode(1) }
            Button("Keystone 4-Point") { commands.setKeystoneMode(2) }
        }
    }
}

private struct CropToolbarGroup: View {
    @ObservedObject private var commands = AppCommandCenter.shared
    @ObservedObject private var controller = AdjustmentToolController.shared

    var body: some View {
        IconOnlyToolbarButton(
            systemName: "crop",
            isSelected: commands.selectedCursorToolID == "Crop"
        ) {
            commands.handleToolbarAction("Crop")
        }
        .contextMenu {
            Section("Aspect Ratio") {
                Button("Unconstrained") { controller.cropRatioIndex = 0 }
                Button("Original") { controller.cropRatioIndex = 1 }
                Button("1:1 (Square)") { controller.cropRatioIndex = 2 }
                Button("4:5 (8x10)") { controller.cropRatioIndex = 3 }
                Button("2:3 (4x6)") { controller.cropRatioIndex = 4 }
                Button("16:9") { controller.cropRatioIndex = 5 }
            }
            Divider()
            Button("Reset Crop") { controller.cropRect = .zero }
        }
    }
}

private struct RotateToolbarGroup: View {
    @ObservedObject private var commands = AppCommandCenter.shared

    var body: some View {
        HStack(spacing: 2) {
            // Main Rotate Tool (Freehand/Straighten)
            IconOnlyToolbarButton(
                systemName: "rotate.right",
                isSelected: commands.selectedCursorToolID == "Rotate" || commands.selectedCursorToolID == "Straighten"
            ) {
                commands.handleToolbarAction("Rotate")
            }
            .contextMenu {
                Button("Rotate Freehand") { commands.handleToolbarAction("Rotate") }
                Button("Straighten") { commands.handleToolbarAction("Straighten") }
                Divider()
                Button("Flip Horizontal") { commands.flipHorizontal() }
                Button("Flip Vertical") { commands.flipVertical() }
            }
            
            // Quick 90 Degree Buttons (C1 Parity)
            HStack(spacing: 0) {
                Button(action: commands.rotateLeft) {
                    Image(systemName: "rotate.left")
                        .font(.system(size: 10))
                        .frame(width: 20, height: 28)
                        .background(Color.white.opacity(0.03))
                }
                .buttonStyle(.plain)
                
                Divider().frame(height: 14).background(Color.gray.opacity(0.2))
                
                Button(action: commands.rotateRight) {
                    Image(systemName: "rotate.right")
                        .font(.system(size: 10))
                        .frame(width: 20, height: 28)
                        .background(Color.white.opacity(0.03))
                }
                .buttonStyle(.plain)
            }
            .cornerRadius(4)
        }
    }
}

private struct AutoAdjustToolbarGroup: View {
    @ObservedObject private var commands = AppCommandCenter.shared
    @ObservedObject private var autoAdjustManager = COAutoAdjustManager.shared

    var body: some View {
        COToolbarButton(
            item: COToolbarItemRegistry.item(for: "AutoAdjust")!,
            isSelected: false
        ) {
            commands.handleToolbarAction("AutoAdjust")
        }
        .contextMenu {
            Toggle("White Balance", isOn: $autoAdjustManager.includeWhiteBalance)
            Toggle("Exposure", isOn: $autoAdjustManager.includeExposure)
            Toggle("High Dynamic Range", isOn: $autoAdjustManager.includeHDR)
            Toggle("Levels", isOn: $autoAdjustManager.includeLevels)
            Toggle("Rotation", isOn: $autoAdjustManager.includeRotation)
            Toggle("Keystone", isOn: $autoAdjustManager.includeKeystone)
        }
    }
}

private struct BeforeAfterToolbarGroup: View {
    @ObservedObject private var commands = AppCommandCenter.shared

    var body: some View {
        COToolbarButton(
            item: COToolbarItemRegistry.item(for: "BeforeAfter")!,
            isSelected: commands.beforeAfterEnabled
        ) {
            commands.handleToolbarAction("BeforeAfter")
        }
        .contextMenu {
            Button(action: {
                commands.beforeAfterMode = 0
                commands.beforeAfterEnabled = true
            }) {
                HStack {
                    Text("Full View")
                    if commands.beforeAfterMode == 0 { Image(systemName: "checkmark") }
                }
            }
            Button(action: {
                commands.beforeAfterMode = 1
                commands.beforeAfterEnabled = true
            }) {
                HStack {
                    Text("Split Screen")
                    if commands.beforeAfterMode == 1 { Image(systemName: "checkmark") }
                }
            }
        }
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
    var activeColor: Color = CaptureOneTheme.Colors.activeHighlight
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                Image(systemName: item.iconName)
                    .font(.system(size: 18))
                    .frame(width: 32, height: 32)
                    .background(isSelected ? activeColor : Color.clear)
                    .foregroundColor(isSelected ? .white : CaptureOneTheme.Colors.iconNormal)
                    .cornerRadius(4)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .help(item.name)
    }
}
