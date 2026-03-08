import SwiftUI
import AppCoreShared
import ImageCore

public enum ColorWheelLayoutMode: Int, CaseIterable {
    case master = 0
    case threeWay = 1
    case shadow = 2
    case midtone = 3
    case highlight = 4

    public var displayName: String {
        switch self {
        case .master: return "Master"
        case .threeWay: return "3-Way"
        case .shadow: return "Shadow"
        case .midtone: return "Midtone"
        case .highlight: return "Highlight"
        }
    }
}

public struct ColorBalanceToolView: View {
    @ObservedObject var controller: AdjustmentToolController
    @ObservedObject private var workspaceManager = WorkspaceManager.shared
    @State private var layoutMode: ColorWheelLayoutMode = .threeWay

    private let toolID = "ColorBalance"
    private let selectedTabKey = "ColorBalanceInspectorToolSelectedTab"

    public var body: some View {
        COToolSection("Color Balance") {
            VStack(spacing: 14) {
                tabStrip

                Group {
                    if layoutMode == .threeWay {
                        ThreeWayColorView(controller: controller)
                    } else {
                        SingleColorWheelView(mode: layoutMode, controller: controller)
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 230)
            }
            .onAppear(perform: restoreLayoutMode)
            .onChange(of: layoutMode) { newValue in
                workspaceManager.setToolStateValue(String(newValue.rawValue), toolID: toolID, key: selectedTabKey)
            }
        }
    }

    private var tabStrip: some View {
        HStack(spacing: 0) {
            ForEach(ColorWheelLayoutMode.allCases, id: \.self) { mode in
                Button(action: { layoutMode = mode }) {
                    Text(mode.displayName)
                        .font(.system(size: 11, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                        .foregroundColor(layoutMode == mode ? CaptureOneTheme.Colors.activeHighlight : CaptureOneTheme.Colors.textSecondary)
                        .background(layoutMode == mode ? Color.white.opacity(0.06) : Color.clear)
                }
                .buttonStyle(.plain)
            }
        }
        .background(Color.black.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }

    private func restoreLayoutMode() {
        guard
            let persisted = workspaceManager.toolStateValue(toolID: toolID, key: selectedTabKey),
            let raw = Int(persisted),
            let mode = ColorWheelLayoutMode(rawValue: raw)
        else {
            return
        }

        layoutMode = mode
    }
}

private struct ThreeWayColorView: View {
    @ObservedObject var controller: AdjustmentToolController

    var body: some View {
        VStack(spacing: 14) {
            POColorBalanceControl(
                value: $controller.cbMidtone,
                title: "Midtone",
                wheelDiameter: 112
            )

            HStack(alignment: .top, spacing: 30) {
                POColorBalanceControl(
                    value: $controller.cbShadow,
                    title: "Shadow",
                    wheelDiameter: 92
                )

                POColorBalanceControl(
                    value: $controller.cbHighlight,
                    title: "Highlight",
                    wheelDiameter: 92
                )
            }
        }
        .frame(maxWidth: .infinity)
    }
}

private struct SingleColorWheelView: View {
    let mode: ColorWheelLayoutMode
    @ObservedObject var controller: AdjustmentToolController

    var body: some View {
        VStack {
            switch mode {
            case .master:
                POColorBalanceControl(
                    value: $controller.cbMaster,
                    title: "Master",
                    wheelDiameter: 116,
                    lightnessControlDisabled: true
                )
            case .shadow:
                POColorBalanceControl(value: $controller.cbShadow, title: "Shadow", wheelDiameter: 116)
            case .midtone:
                POColorBalanceControl(value: $controller.cbMidtone, title: "Midtone", wheelDiameter: 116)
            case .highlight:
                POColorBalanceControl(value: $controller.cbHighlight, title: "Highlight", wheelDiameter: 116)
            case .threeWay:
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity)
    }
}
