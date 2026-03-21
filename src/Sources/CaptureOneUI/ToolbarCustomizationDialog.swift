import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Toolbar Customization Dialog (INT-001).
public struct ToolbarCustomizationDialog: View {
    @ObservedObject var workspaceManager = COWorkspaceManager.shared
    @Environment(\.dismiss) var dismiss
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 20) {
            Text("Customize Toolbar")
                .font(.headline)
            
            Text("Drag your favorite items into the toolbar...")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            // Grid of all available items
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 20) {
                    ForEach(COToolbarItemRegistry.availableItems) { item in
                        CustomizationItemView(item: item)
                            .onDrag {
                                NSItemProvider(object: item.id as NSString)
                            }
                    }
                }
                .padding()
            }
            .frame(height: 300)
            .background(Color.black.opacity(0.2))
            .cornerRadius(8)
            
            // Current Toolbar Preview / Drop Zone
            VStack(alignment: .leading) {
                Text("Current Toolbar")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                HStack(spacing: 4) {
                    ForEach(workspaceManager.activeWorkspace.toolbarConfiguration.itemIDs, id: \.self) { id in
                        if let item = COToolbarItemRegistry.item(for: id) {
                            COToolbarButton(item: item, isSelected: false) {}
                                .onDrag {
                                    NSItemProvider(object: id as NSString)
                                }
                        }
                    }
                }
                .padding(8)
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(CaptureOneTheme.Colors.toolbarBackground)
                .cornerRadius(4)
                .onDrop(of: ["public.text"], isTargeted: nil) { providers in
                    // Logic: Handle item dropping for reordering or adding
                    // This is a simplified mock of the drop logic
                    return true
                }
            }
            
            HStack {
                Button("Reset to Default") {
                    workspaceManager.activeWorkspace.toolbarConfiguration = .defaultConfiguration
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.1))
                .cornerRadius(4)
                
                Spacer()
                
                Button("Done") {
                    workspaceManager.saveWorkspace()
                    dismiss()
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(CaptureOneTheme.Colors.activeHighlight)
                .cornerRadius(4)
            }
        }
        .padding(20)
        .frame(width: 600)
        .background(CaptureOneTheme.Colors.panelBackground)
        .foregroundColor(.white)
    }
}

struct CustomizationItemView: View {
    let item: COToolbarItem
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: item.iconName)
                .font(.system(size: 24))
                .frame(width: 44, height: 44)
                .background(Color.white.opacity(0.05))
                .cornerRadius(8)
            
            Text(item.name)
                .font(.system(size: 9))
                .multilineTextAlignment(.center)
                .frame(width: 70)
        }
    }
}
