import SwiftUI
import AppKit
import AppCoreShared

/// Reconstructed visual theme for Capture One (High Fidelity).
/// Based on version 16.5.9.7 and visual analysis of the reference UI.
public struct CaptureOneTheme {
    
    public struct Colors {
        // MARK: - Core Backgrounds
        public static let applicationBackground = Color(red: 0.11, green: 0.11, blue: 0.11) // Very dark gray
        public static let toolbarBackground = Color(red: 0.15, green: 0.15, blue: 0.15)
        public static let panelBackground = Color(red: 0.13, green: 0.13, blue: 0.13)
        public static let browserBackground = Color(red: 0.18, green: 0.18, blue: 0.18)
        public static let histogramBackground = Color(red: 0.08, green: 0.08, blue: 0.08)
        
        // Aliases for compatibility
        public static let mainWindowTitleAndToolbar = toolbarBackground
        public static let buttonBackground = Color(white: 0.2)
        
        // MARK: - Highlights & Selection
        public static let activeHighlight = Color(red: 0.95, green: 0.55, blue: 0.10) // Signature C1 Orange
        public static let selectionBorder = Color(red: 0.95, green: 0.55, blue: 0.10)
        
        // MARK: - Text & Icons
        public static let textPrimary = Color(white: 0.9)
        public static let textSecondary = Color(white: 0.6)
        public static let iconNormal = Color(white: 0.8)
        public static let iconDisabled = Color(white: 0.3)
        
        // MARK: - Dividers
        public static let separator = Color(white: 0.05)
    }
}

// MARK: - Reconstructed Reusable Components

/// A collapsible tool section like "White Balance" or "Exposure"
public struct COToolSection<Content: View>: View {
    let title: String
    let toolID: String
    @State var isExpanded: Bool = true
    @ObservedObject private var commands = AppCommandCenter.shared
    @ObservedObject private var workspaceManager = WorkspaceManager.shared
    @ObservedObject private var styleManager = StyleManager.shared
    let content: Content
    
    public init(_ title: String, toolID: String? = nil, isExpanded: Bool = true, @ViewBuilder content: () -> Content) {
        self.title = title
        self.toolID = toolID ?? title
        self._isExpanded = State(initialValue: isExpanded)
        self.content = content()
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 6) {
                Button(action: { withAnimation { isExpanded.toggle() } }) {
                    HStack(spacing: 6) {
                        Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                            .font(.system(size: 8, weight: .bold))
                        Text(title.uppercased())
                            .font(.system(size: 11, weight: .bold))
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
                .gesture(
                    DragGesture(minimumDistance: 30)
                        .onEnded { value in
                            if abs(value.translation.width) > 50 || abs(value.translation.height) > 50 {
                                if let session = commands.session {
                                    COWindowManager.shared.openFloatingToolWindow(toolID: toolID, toolName: title, session: session)
                                }
                            }
                        }
                )

                Spacer()

                toolHeaderButton(systemName: "questionmark.circle") {
                    commands.showHelp(for: toolID)
                }

                toolHeaderButton(systemName: "arrow.uturn.backward.circle") {
                    commands.resetTool(toolID)
                }

                toolHeaderButton(systemName: "pip.fill") {
                    if let session = commands.session {
                        COWindowManager.shared.openFloatingToolWindow(toolID: toolID, toolName: title, session: session)
                    }
                }

                Menu {
                    Button("Save Adjustments as Style...") {
                        commands.saveCurrentAdjustmentsAsStyle(toolID: toolID)
                    }

                    if !styleManager.allStyles().isEmpty {
                        Menu("Apply Adjustments From") {
                            ForEach(styleManager.allStyles()) { style in
                                Button(style.name) {
                                    commands.applyStyle(style)
                                }
                            }
                        }
                    }
                } label: {
                    Image(systemName: "square.and.arrow.down")
                        .font(.system(size: 11))
                        .frame(width: 18, height: 18)
                }
                .menuStyle(BorderlessButtonMenuStyle())
                .foregroundColor(CaptureOneTheme.Colors.textPrimary)

                Menu {
                    Button(isPinned ? "Move Tool to Scrollable Area" : "Move Tool to Pinned Area") {
                        workspaceManager.moveTool(toolID, toPinnedArea: !isPinned)
                    }

                    Button("Float Tool") {
                        if let session = commands.session {
                            COWindowManager.shared.openFloatingToolWindow(toolID: toolID, toolName: title, session: session)
                        }
                    }

                    Divider()

                    Button("Copy \(title) Adjustments") {
                        commands.copyAdjustmentsForTool(toolID)
                    }
                    Button("Apply \(title) Adjustments") {
                        commands.pasteAdjustmentsForTool(toolID)
                    }
                    Button("Reset \(title)") {
                        commands.resetTool(toolID)
                    }

                    Divider()

                    Button("Auto Size") {
                        workspaceManager.setToolSizeOption(nil, for: toolID)
                    }
                    Button("Small Size") {
                        workspaceManager.setToolSizeOption(1, for: toolID)
                    }
                    Button("Medium Size") {
                        workspaceManager.setToolSizeOption(2, for: toolID)
                    }
                    Button("Large Size") {
                        workspaceManager.setToolSizeOption(3, for: toolID)
                    }

                    Divider()

                    Button("Remove Tool") {
                        workspaceManager.removeTool(toolID)
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.system(size: 11))
                        .frame(width: 18, height: 18)
                }
                .menuStyle(BorderlessButtonMenuStyle())
                .foregroundColor(CaptureOneTheme.Colors.textPrimary)
            }
            .foregroundColor(CaptureOneTheme.Colors.textPrimary)
            .padding(.horizontal, 8)
            .frame(height: 28)
            .background(Color.white.opacity(0.05))
            
            if isExpanded {
                content
                    .padding(8)
                    .background(CaptureOneTheme.Colors.applicationBackground)
            }
            
            Divider().background(CaptureOneTheme.Colors.separator)
        }
    }

    private var isPinned: Bool {
        workspaceManager.activeWorkspace.activePalette()?.fixedTools.contains(where: { $0.id == toolID }) ?? false
    }

    @ViewBuilder
    private func toolHeaderButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 11))
                .frame(width: 18, height: 18)
        }
        .buttonStyle(.plain)
        .foregroundColor(CaptureOneTheme.Colors.textPrimary)
    }
}

/// The high-fidelity C1 Slider
public struct COUISlider: View {
    let label: String
    @Binding var value: Float
    let range: ClosedRange<Float>
    let showLabel: Bool
    var actionID: String? = nil
    
    public init(label: String, value: Binding<Float>, range: ClosedRange<Float>, showLabel: Bool = true, actionID: String? = nil) {
        self.label = label
        self._value = value
        self.range = range
        self.showLabel = showLabel
        self.actionID = actionID
    }
    
    public var body: some View {
        VStack(spacing: 2) {
            if showLabel {
                HStack(alignment: .firstTextBaseline) {
                    Text(label)
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textPrimary)
                    
                    if let actionID = actionID, let shortcut = ShortcutManager.shared.shortcutString(forActionID: actionID) {
                        Text("[\(shortcut)]")
                            .font(.system(size: 9, design: .monospaced))
                            .foregroundColor(.gray.opacity(0.6))
                    }
                    
                    Spacer()
                    Text("\(Int(value))")
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(CaptureOneTheme.Colors.textPrimary)
                }
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    // Track background
                    Capsule()
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 2)
                    
                    // Active track
                    let isBipolar = range.contains(0)
                    if isBipolar {
                        let centerPercent = CGFloat(-range.lowerBound / (range.upperBound - range.lowerBound))
                        let currentPercent = CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound))
                        let width = abs(currentPercent - centerPercent) * geo.size.width
                        let startX = min(centerPercent, currentPercent) * geo.size.width
                        
                        Capsule()
                            .fill(CaptureOneTheme.Colors.activeHighlight)
                            .frame(width: width, height: 2)
                            .offset(x: startX)
                    } else {
                        Capsule()
                            .fill(CaptureOneTheme.Colors.activeHighlight)
                            .frame(width: CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound)) * geo.size.width, height: 2)
                    }
                    
                    // Knob
                    Circle()
                        .fill(Color(white: 0.95))
                        .frame(width: 14, height: 14)
                        .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                        .offset(x: CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound)) * geo.size.width - 7)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { gesture in
                                    let percent = min(max(0, Float(gesture.location.x / geo.size.width)), 1.0)
                                    self.value = range.lowerBound + percent * (range.upperBound - range.lowerBound)
                                }
                        )
                }
                .frame(maxHeight: .infinity)
            }
            .frame(height: 14) // Total height of the slider interaction area
        }
    }
}

// MARK: - AppKit Compatibility
extension Color {
    public var nsColor: NSColor {
        switch self {
        case CaptureOneTheme.Colors.activeHighlight: return NSColor(red: 0.95, green: 0.55, blue: 0.10, alpha: 1.0)
        case CaptureOneTheme.Colors.applicationBackground: return NSColor(calibratedWhite: 0.11, alpha: 1.0)
        case CaptureOneTheme.Colors.buttonBackground: return NSColor(calibratedWhite: 0.2, alpha: 1.0)
        default: return NSColor.gray
        }
    }
}

extension NSColor {
    public static var coApplicationBackground: NSColor { NSColor(calibratedWhite: 0.11, alpha: 1.0) }
    public static var coActiveHighlight: NSColor { NSColor(red: 0.95, green: 0.55, blue: 0.10, alpha: 1.0) }
}
