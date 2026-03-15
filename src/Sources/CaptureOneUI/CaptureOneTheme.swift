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
    @ObservedObject private var workspaceManager = WorkspaceManager.shared
    @ObservedObject private var commands = AppCommandCenter.shared
    @ObservedObject private var styleManager = COStyleManager.shared
    let content: Content
    
    public init(_ title: String, toolID: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.toolID = toolID
        self.content = content()
    }
    
    private var isExpanded: Bool {
        !workspaceManager.isToolCollapsed(toolID)
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        workspaceManager.setToolCollapsed(isExpanded, for: toolID)
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 8, weight: .bold))
                            .rotationEffect(isExpanded ? .degrees(90) : .degrees(0))
                            .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                        
                        Text(title)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(CaptureOneTheme.Colors.textPrimary)
                    }
                    .padding(.leading, 8)
                    .frame(maxHeight: .infinity)
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())

                Spacer()

                // MARK: - Action Group (Aligned Right)
                HStack(spacing: 0) {
                    toolHeaderButton(systemName: "questionmark") {
                        commands.showHelp(for: toolID)
                    }

                    toolHeaderButton(systemName: "wand.and.rays") {
                        commands.autoAdjustTool(toolID)
                    }

                    toolHeaderButton(systemName: "arrow.up.left.and.arrow.down.right") {
                        if let session = commands.session {
                            COWindowManager.shared.openFloatingToolWindow(toolID: toolID, toolName: title, session: session)
                        }
                    }

                    toolHeaderButton(systemName: "arrow.up.doc") {
                        commands.copyAdjustmentsForTool(toolID)
                    }

                    toolHeaderButton(systemName: "arrow.down.doc") {
                        commands.pasteAdjustmentsForTool(toolID)
                    }

                    toolHeaderButton(systemName: "arrow.uturn.backward") {
                        commands.resetTool(toolID)
                    }

                    presetMenu

                    ellipsisMenu
                }
                .padding(.trailing, 4)
            }
            .frame(height: 24)
            .background(Color.white.opacity(0.04))
            
            if isExpanded {
                content
                    .padding(.horizontal, 8)
                    .padding(.vertical, 10)
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
                .font(.system(size: 10))
                .frame(width: 22, height: 22)
        }
        .buttonStyle(.plain)
        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
    }

    private var presetMenu: some View {
        Menu {
            Button("Save User Preset...") { /* logic */ }
            Button("Save as Style...") { /* logic */ }
            Divider()
            Button("Stack Presets") { /* logic */ }
            Divider()
            Button("Manage Presets...") { /* logic */ }
        } label: {
            Image(systemName: "line.3.horizontal")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                .frame(width: 22, height: 22)
        }
        .menuStyle(BorderlessButtonMenuStyle())
    }

    private var ellipsisMenu: some View {
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

            Button("Auto Size") { workspaceManager.setToolSizeOption(nil, for: toolID) }
            Button("Small Size") { workspaceManager.setToolSizeOption(1, for: toolID) }
            Button("Medium Size") { workspaceManager.setToolSizeOption(2, for: toolID) }
            Button("Large Size") { workspaceManager.setToolSizeOption(3, for: toolID) }

            Divider()

            Button("Remove Tool") {
                workspaceManager.removeTool(toolID)
            }
            
            if toolID == "ColorEditor" {
                Divider()
                Button("Create Mask from Selection") {
                    // Logic to turn color range into a layer mask
                }
            }
        } label: {
            Image(systemName: "ellipsis")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                .frame(width: 22, height: 22)
        }
        .menuStyle(BorderlessButtonMenuStyle())
    }
}

/// The high-fidelity C1 Slider with precise numeric input (UI-205)
/// Supports dragging, mouse scroll, and arrow keys.
public struct COToolValueSlider: View {
    let label: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let decimalPlaces: Int
    
    @State private var textValue: String = ""
    @FocusState private var isFocused: Bool
    @State private var isHovered: Bool = false
    
    public init(label: String, value: Binding<Double>, range: ClosedRange<Double>, decimalPlaces: Int = 1) {
        self.label = label
        self._value = value
        self.range = range
        self.decimalPlaces = decimalPlaces
    }
    
    public init(label: String, value: Binding<Float>, range: ClosedRange<Float>, decimalPlaces: Int = 1) {
        self.label = label
        self._value = Binding(
            get: { Double(value.wrappedValue) },
            set: { value.wrappedValue = Float($0) }
        )
        self.range = Double(range.lowerBound)...Double(range.upperBound)
        self.decimalPlaces = decimalPlaces
    }
    
    public var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(CaptureOneTheme.Colors.textPrimary)
                .frame(width: 85, alignment: .leading)
            
            sliderTrack
                .onContinuousHover { phase in
                    switch phase {
                    case .active(_): isHovered = true
                    case .ended: isHovered = false
                    }
                }
                .modifier(ScrollWheelModifier { event in
                    if isHovered || isFocused {
                        let step = (range.upperBound - range.lowerBound) / 100.0
                        let delta = Double(event.scrollingDeltaY) * step * 0.2
                        self.updateValue(value + delta)
                    }
                })
            
            TextField("", text: $textValue)
                .textFieldStyle(.plain)
                .font(.system(size: 11, design: .monospaced))
                .multilineTextAlignment(.trailing)
                .frame(width: 45, height: 18)
                .background(isFocused ? Color.black.opacity(0.3) : Color.black.opacity(0.15))
                .cornerRadius(2)
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(isFocused ? CaptureOneTheme.Colors.activeHighlight : Color.white.opacity(0.1), lineWidth: 0.5)
                )
                .focused($isFocused)
                .onSubmit {
                    updateValueFromText()
                }
                .onChange(of: isFocused) { focused in
                    if !focused { updateValueFromText() }
                }
                .background(
                    Group {
                        if isFocused {
                            KeyEventView(onArrowKey: { key, isLarge in
                                let stepCount = isLarge ? 10.0 : 1.0
                                let stepValue = (range.upperBound - range.lowerBound) / 100.0
                                let change = (key == .up ? 1.0 : -1.0) * stepValue * stepCount
                                self.updateValue(value + change)
                            })
                        }
                    }
                )
        }
        .onAppear { syncText() }
        .onChange(of: value) { _ in if !isFocused { syncText() } }
    }
    
    private var sliderTrack: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                // Track background
                Capsule()
                    .fill(Color.white.opacity(0.12))
                    .frame(height: 2)
                
                // Active track (Bipolar support)
                let currentPercent = CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound))
                
                if range.contains(0) {
                    let centerPercent = CGFloat(-range.lowerBound / (range.upperBound - range.lowerBound))
                    let width = abs(currentPercent - centerPercent) * geo.size.width
                    let startX = min(centerPercent, currentPercent) * geo.size.width
                    
                    Capsule()
                        .fill(CaptureOneTheme.Colors.activeHighlight)
                        .frame(width: width, height: 2)
                        .offset(x: startX)
                } else {
                    Capsule()
                        .fill(CaptureOneTheme.Colors.activeHighlight)
                        .frame(width: currentPercent * geo.size.width, height: 2)
                }
                
                // Knob
                Circle()
                    .fill(Color(white: 0.9))
                    .frame(width: 10, height: 10)
                    .shadow(color: .black.opacity(0.4), radius: 1, x: 0, y: 1)
                    .offset(x: currentPercent * geo.size.width - 5)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gesture in
                                let percent = min(max(0, Double(gesture.location.x / geo.size.width)), 1.0)
                                self.updateValue(range.lowerBound + percent * (range.upperBound - range.lowerBound))
                            }
                    )
            }
            .frame(maxHeight: .infinity)
        }
        .frame(height: 18)
    }
    
    private func updateValue(_ newValue: Double) {
        self.value = min(max(newValue, range.lowerBound), range.upperBound)
    }
    
    private func syncText() {
        textValue = String(format: "%.\(decimalPlaces)f", value)
    }
    
    private func updateValueFromText() {
        if let newValue = Double(textValue) {
            updateValue(newValue)
        }
        syncText()
    }
}

// MARK: - Event Handling Helpers

struct ScrollWheelModifier: ViewModifier {
    let action: (NSEvent) -> Void
    
    func body(content: Content) -> some View {
        content.overlay(
            ScrollWheelRepresentable(action: action)
        )
    }
}

struct ScrollWheelRepresentable: NSViewRepresentable {
    let action: (NSEvent) -> Void
    
    func makeNSView(context: Context) -> NSView {
        let view = ScrollWheelView()
        view.action = action
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {}
}

class ScrollWheelView: NSView {
    var action: ((NSEvent) -> Void)?
    
    override func scrollWheel(with event: NSEvent) {
        action?(event)
    }
    
    override var acceptsFirstResponder: Bool { false }
}

struct KeyEventView: NSViewRepresentable {
    enum ArrowKey { case up, down }
    let onArrowKey: (ArrowKey, Bool) -> Void
    
    func makeNSView(context: Context) -> NSView {
        let view = KeyCaptureView()
        view.onArrowKey = onArrowKey
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {}
}

class KeyCaptureView: NSView {
    var onArrowKey: ((KeyEventView.ArrowKey, Bool) -> Void)?
    
    override var acceptsFirstResponder: Bool { true }
    
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        if window != nil {
            window?.makeFirstResponder(self)
        }
    }
    
    override func keyDown(with event: NSEvent) {
        let isShift = event.modifierFlags.contains(.shift)
        switch event.keyCode {
        case 126: // Up
            onArrowKey?(.up, isShift)
        case 125: // Down
            onArrowKey?(.down, isShift)
        default:
            super.keyDown(with: event)
        }
    }
}

/// The high-fidelity C1 Slider (Old version, kept for compatibility if needed)
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
