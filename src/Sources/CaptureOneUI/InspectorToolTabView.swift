import SwiftUI
import AppCoreShared

public struct InspectorToolContext {
    public let adjustmentController: AdjustmentToolController
    public let session: SessionBase
    public let recipeManager: OutputRecipeManager
    public let batchQueue: BatchQueue
    public let keywordCache: DocumentKeywordCache

    public init(
        adjustmentController: AdjustmentToolController,
        session: SessionBase,
        recipeManager: OutputRecipeManager,
        batchQueue: BatchQueue,
        keywordCache: DocumentKeywordCache
    ) {
        self.adjustmentController = adjustmentController
        self.session = session
        self.recipeManager = recipeManager
        self.batchQueue = batchQueue
        self.keywordCache = keywordCache
    }
}

/// Reconstructed high-fidelity Tool Tab bar (UI-013).
public struct InspectorToolTabView: View {
    @ObservedObject var workspaceManager = WorkspaceManager.shared
    @Binding var selectedTabID: String
    let context: InspectorToolContext

    public init(selectedTabID: Binding<String>, context: InspectorToolContext) {
        self._selectedTabID = selectedTabID
        self.context = context
    }

    public var body: some View {
        let selectedID = workspaceManager.activeWorkspace.selectedPaletteID
        let _ = print("[UI] InspectorToolTabView rendering. Selected: \(selectedID)")
        
        HStack(spacing: 0) {
            ForEach(workspaceManager.activeWorkspace.palettes) { palette in
                let isSelected = (selectedID == palette.id)
                VStack(spacing: 3) {
                    Image(systemName: palette.iconName)
                        .font(.system(size: 14))
                    Text(palette.name)
                        .font(.system(size: 8, weight: .semibold))
                        .lineLimit(1)

                    Rectangle()
                        .fill(isSelected ? CaptureOneTheme.Colors.activeHighlight : Color.clear)
                        .frame(height: 2)
                }
                .frame(width: 54, height: 44)
                .background(Color.white.opacity(0.001)) // Essential for hit-testing transparent areas
                .onTapGesture {
                    print("[UI] InspectorToolTabView click: \(palette.id)")
                    workspaceManager.setSelectedPaletteID(palette.id)
                }
                .foregroundColor(isSelected ? .white : .gray)
                .contextMenu {
                    Button("Expand All Tools") {
                        workspaceManager.expandAllTools(in: palette.id)
                    }
                    Button("Collapse All Tools") {
                        workspaceManager.collapseAllTools(in: palette.id)
                    }
                    Divider()
                    Button("Float Palette") {
                        COWindowManager.shared.openFloatingPaletteWindow(palette: palette, context: context)
                    }
                }
            }
        }
        .frame(height: 44)
        .background(CaptureOneTheme.Colors.mainWindowTitleAndToolbar)
    }
}

/// Reconstructed inspector stack with fixed and scrollable tool zones.
public struct InspectorToolLayout: View {
    let palette: WorkspacePaletteDefinition
    let context: InspectorToolContext

    public init(palette: WorkspacePaletteDefinition, context: InspectorToolContext) {
        self.palette = palette
        self.context = context
    }

    public var body: some View {
        let _ = print("[UI] InspectorToolLayout rendering palette: \(palette.id) with \(palette.allTools.count) tools")
        VStack(spacing: 0) {
            if !palette.fixedTools.isEmpty {
                VStack(spacing: 1) {
                    ForEach(palette.fixedTools) { config in
                        ToolContainer(config: config, context: context)
                    }
                }
            }

            if !palette.fixedTools.isEmpty && !palette.scrolledTools.isEmpty {
                Divider().background(Color.black)
            }

            if !palette.scrolledTools.isEmpty {
                ScrollView {
                    VStack(spacing: 1) {
                        ForEach(palette.scrolledTools) { config in
                            ToolContainer(config: config, context: context)
                        }
                        Spacer(minLength: 12)
                    }
                }
            } else {
                Spacer(minLength: 0)
            }
        }
        .background(CaptureOneTheme.Colors.applicationBackground)
    }
}

struct ToolContainer: View {
    let config: ToolConfiguration
    let context: InspectorToolContext

    var body: some View {
        let registryContext = ToolRegistryContext(
            config: config,
            adjustmentController: context.adjustmentController,
            session: context.session,
            recipeManager: context.recipeManager,
            batchQueue: context.batchQueue,
            keywordCache: context.keywordCache
        )

        Group {
            ToolRegistry.view(for: config.id, context: registryContext)
        }
        .frame(maxWidth: .infinity)
        .frame(height: resolvedHeight)
        .contextMenu {
            let isPinned = WorkspaceManager.shared.activeWorkspace.activePalette()?.fixedTools.contains(where: { $0.id == config.id }) ?? false
            
            Button(isPinned ? "Move Tool to Scrollable Area" : "Move Tool to Pinned Area") {
                WorkspaceManager.shared.moveTool(config.id, toPinnedArea: !isPinned)
            }
            
            Button("Remove Tool") {
                WorkspaceManager.shared.removeTool(config.id)
            }
            
            Divider()
            
            Button("Auto Size") { WorkspaceManager.shared.setToolSizeOption(nil, for: config.id) }
            Button("Small Size") { WorkspaceManager.shared.setToolSizeOption(1, for: config.id) }
            Button("Medium Size") { WorkspaceManager.shared.setToolSizeOption(2, for: config.id) }
            Button("Large Size") { WorkspaceManager.shared.setToolSizeOption(3, for: config.id) }
        }
    }

    private var resolvedHeight: CGFloat? {
        if let height = config.height {
            return CGFloat(height)
        }

        switch config.sizeOption {
        case 1:
            return 140
        case 2:
            return 220
        case 3:
            return 320
        default:
            return nil
        }
    }
}
