import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Main Toolbar (UI-013/INT-001).
/// Based on version 16.5 layout and disassembly.
public struct MainToolbarView: View {
    @ObservedObject var workspaceManager = WorkspaceManager.shared
    @State private var selectedToolID: String = "Select"
    
    public init() {}
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(workspaceManager.activeWorkspace.toolbarConfiguration.itemIDs, id: \.self) { id in
                if id == "FLEXIBLE_SPACER" {
                    Spacer()
                } else if id == "FIXED_SPACER" {
                    Spacer().frame(width: 20)
                } else if let item = ToolbarItemRegistry.item(for: id) {
                    ToolbarButton(item: item, isSelected: selectedToolID == item.id) {
                        if item.type == .tool {
                            selectedToolID = item.id
                        }
                        print("[Toolbar] Executed: \(item.name)")
                    }
                }
            }
        }
        .padding(.horizontal, 10)
        .frame(height: 40)
        .background(CaptureOneTheme.Colors.toolbarBackground)
        .overlay(
            Rectangle()
                .fill(CaptureOneTheme.Colors.separator)
                .frame(height: 1),
            alignment: .bottom
        )
    }
}

struct ToolbarButton: View {
    let item: ToolbarItem
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
