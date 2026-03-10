import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Style row view (UI-010).
/// Based on disassembly of _TtC10CaptureOne30StyleWithShortcutTableCellView.
public struct StyleWithShortcutTableCellView: View {
    let item: StyleTreeItem
    
    public var body: some View {
        HStack {
            Image(systemName: item.isFolder ? "folder.fill" : "slider.horizontal.3")
                .font(.system(size: 10))
                .foregroundColor(item.isFolder ? .gray : CaptureOneTheme.Colors.activeHighlight)
            
            Text(item.name)
                .font(.system(size: 11))
            
            Spacer()
            
            // Shortcut placeholder if available (simulated)
            if !item.isFolder {
                Text("⌘1")
                    .font(.system(size: 9))
                    .foregroundColor(.gray.opacity(0.5))
            }
        }
        .padding(.vertical, 2)
    }
}
