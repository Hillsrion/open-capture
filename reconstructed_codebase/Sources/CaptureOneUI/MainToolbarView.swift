import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Main Toolbar (UI-013/INT-001).
/// Based on version 16.5 layout and disassembly.
public struct MainToolbarView: View {
    @ObservedObject var workspaceManager = WorkspaceManager.shared
    @ObservedObject var adjustmentController = AdjustmentToolController.shared // Assuming shared instance or passed down
    @State private var selectedToolID: String = "Select"
    @State private var showingCustomization: Bool = false
    
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
            
            // Reconstructed Proofing Button (ENG-011)
            HStack(spacing: 8) {
                Divider().frame(height: 20).padding(.horizontal, 4)
                
                Button(action: { adjustmentController.isSoftProofingEnabled.toggle() }) {
                    Image(systemName: "eyeglasses")
                        .font(.system(size: 16))
                        .padding(6)
                        .background(adjustmentController.isSoftProofingEnabled ? CaptureOneTheme.Colors.activeHighlight : Color.clear)
                        .foregroundColor(adjustmentController.isSoftProofingEnabled ? .white : .gray)
                        .cornerRadius(4)
                }
                .buttonStyle(PlainButtonStyle())
                .help("Soft Proofing")
                
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
                    .menuStyle(PlainMenuStyle())
                    .frame(width: 100)
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
