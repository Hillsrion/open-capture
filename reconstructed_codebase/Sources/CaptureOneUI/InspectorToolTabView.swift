import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Tool Tab bar (UI-013).
/// Based on disassembly of InspectorToolTabView.
public struct InspectorToolTabView: View {
    @ObservedObject var workspaceManager = WorkspaceManager.shared
    @Binding var selectedTabID: String
    
    public init(selectedTabID: Binding<String>) {
        self._selectedTabID = selectedTabID
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(workspaceManager.activeWorkspace.leftSidebarTabs) { tab in
                Button(action: { selectedTabID = tab.id }) {
                    VStack(spacing: 4) {
                        Image(systemName: tab.iconName)
                            .font(.system(size: 14))
                        
                        if selectedTabID == tab.id {
                            Rectangle()
                                .fill(CaptureOneTheme.Colors.activeHighlight)
                                .frame(height: 2)
                        } else {
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: 2)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(selectedTabID == tab.id ? .white : .gray)
            }
        }
        .frame(height: 40)
        .background(CaptureOneTheme.Colors.mainWindowTitleAndToolbar)
    }
}

/// Reconstructed high-fidelity vertical layout for tool inspectors.
/// Based on disassembly of InspectorToolLayout.
public struct InspectorToolLayout: View {
    let tab: WorkspaceTab
    @ObservedObject var adjustmentController: AdjustmentToolController
    
    public init(tab: WorkspaceTab, adjustmentController: AdjustmentToolController) {
        self.tab = tab
        self.adjustmentController = adjustmentController
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 1) {
                ForEach(tab.tools) { config in
                    ToolContainer(config: config, adjustmentController: adjustmentController)
                }
                Spacer()
            }
        }
        .background(CaptureOneTheme.Colors.applicationBackground)
    }
}

/// Helper to map Tool IDs to their actual View implementations.
struct ToolContainer: View {
    let config: ToolConfiguration
    @ObservedObject var adjustmentController: AdjustmentToolController
    
    var body: some View {
        Group {
            switch config.id {
            case "Histogram": HistogramToolView()
            case "Exposure": ExposureToolView(
                exposure: $adjustmentController.exposure,
                contrast: $adjustmentController.contrast,
                brightness: $adjustmentController.brightness,
                saturation: $adjustmentController.saturation
            )
            case "SmartAdjustments": SmartAdjustmentsToolView(controller: adjustmentController)
            case "HDR": HDRToolView(
                highlights: $adjustmentController.highlights,
                shadows: $adjustmentController.shadows,
                whites: $adjustmentController.whites,
                blacks: $adjustmentController.blacks
            )
            case "ColorBalance": ColorBalanceToolView(controller: adjustmentController)
            case "WhiteBalance": WhiteBalanceToolView(
                kelvin: $adjustmentController.kelvin,
                tint: $adjustmentController.tint
            )
            default: Text("Tool \(config.id) Not Implemented").foregroundColor(.gray).padding()
            }
        Group {}.onAppear { /* Simulation of collapsed state */ }
        }
    }
}
