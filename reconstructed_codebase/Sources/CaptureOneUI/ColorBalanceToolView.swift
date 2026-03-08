import SwiftUI
import AppCoreShared

/// Reconstructed enum for Color Wheel layout modes.
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

/// Reconstructed high-fidelity Color Balance tool (UI-003).
public struct ColorBalanceToolView: View {
    @ObservedObject var controller: AdjustmentToolController
    @State private var layoutMode: ColorWheelLayoutMode = .threeWay
    
    public var body: some View {
        COToolSection("Color Balance") {
            VStack(spacing: 12) {
                // Layout Switcher (Tabs)
                HStack(spacing: 0) {
                    ForEach(ColorWheelLayoutMode.allCases, id: \.self) { mode in
                        Button(action: { layoutMode = mode }) {
                            Text(mode.displayName.uppercased())
                                .font(.system(size: 9, weight: .bold))
                                .padding(.vertical, 4)
                                .frame(maxWidth: .infinity)
                                .background(layoutMode == mode ? Color.white.opacity(0.1) : Color.clear)
                                .foregroundColor(layoutMode == mode ? CaptureOneTheme.Colors.activeHighlight : .gray)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .background(Color.black.opacity(0.2))
                .cornerRadius(4)
                
                // Active View based on LayoutMode
                Group {
                    if layoutMode == .threeWay {
                        ThreeWayColorView(controller: controller)
                    } else {
                        SingleColorWheelView(mode: layoutMode, controller: controller)
                    }
                }
                .frame(minHeight: 220)
            }
        }
    }
}

/// 3-Way layout implementation.
struct ThreeWayColorView: View {
    @ObservedObject var controller: AdjustmentToolController
    var body: some View {
        HStack(spacing: 15) {
            POColorBalanceControl(value: $controller.cbShadow, title: "Shadow")
            POColorBalanceControl(value: $controller.cbMidtone, title: "Midtone")
            POColorBalanceControl(value: $controller.cbHighlight, title: "Highlight")
        }
    }
}

/// Single wheel layout implementation.
struct SingleColorWheelView: View {
    let mode: ColorWheelLayoutMode
    @ObservedObject var controller: AdjustmentToolController
    
    var body: some View {
        VStack {
            switch mode {
            case .master: POColorBalanceControl(value: $controller.cbMaster, title: "Master")
            case .shadow: POColorBalanceControl(value: $controller.cbShadow, title: "Shadow")
            case .midtone: POColorBalanceControl(value: $controller.cbMidtone, title: "Midtone")
            case .highlight: POColorBalanceControl(value: $controller.cbHighlight, title: "Highlight")
            default: EmptyView()
            }
        }
        .frame(maxWidth: 200)
    }
}
