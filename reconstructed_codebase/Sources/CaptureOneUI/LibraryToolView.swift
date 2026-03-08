import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Library Tool for the sidebar (CORE-008).
/// Based on disassembly of LibraryInspectorTool.
public struct LibraryToolView: View {
    @ObservedObject var session: SessionBase
    
    public init(session: SessionBase) {
        self.session = session
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Session Folders Section
            COToolSection("Session Folders") {
                VStack(alignment: .leading, spacing: 4) {
                    SessionFolderRow(type: .capture, path: session.captureFolder, session: session)
                    SessionFolderRow(type: .selects, path: session.selectsFolder, session: session)
                    SessionFolderRow(type: .output, path: session.outputFolder, session: session)
                    SessionFolderRow(type: .trash, path: session.trashFolder, session: session)
                }
                .padding(.vertical, 4)
            }
            
            // Session Favorites Section
            COToolSection("Session Favorites") {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "star.fill").foregroundColor(.yellow).font(.system(size: 10))
                        Text("Pictures").font(.system(size: 11))
                        Spacer()
                    }
                    .padding(.vertical, 2)
                }
            }
        }
    }
}

struct SessionFolderRow: View {
    let type: SessionFolderType
    let path: String?
    let session: SessionBase
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: iconName)
                .foregroundColor(CaptureOneTheme.Colors.activeHighlight)
                .frame(width: 16)
            
            Text(type.defaultName)
                .font(.system(size: 11))
            
            Spacer()
            
            if let p = path {
                Text((p as NSString).lastPathComponent)
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 2)
        .contentShape(Rectangle())
        .contextMenu {
            Button(action: {
                // Logic to select folder from dialog
            }) {
                Text("Select Folder...")
            }
            
            Divider()
            
            Button(action: {
                if let p = path {
                    SessionFolderManager.shared.setAsSystemFolder(url: URL(fileURLWithPath: p), type: .capture, in: session)
                }
            }) {
                Text("Set as Capture Folder")
            }
            
            Button(action: {
                if let p = path {
                    SessionFolderManager.shared.setAsSystemFolder(url: URL(fileURLWithPath: p), type: .selects, in: session)
                }
            }) {
                Text("Set as Selects Folder")
            }
        }
    }
    
    private var iconName: String {
        switch type {
        case .capture: return "camera.fill"
        case .selects: return "app.badge.checkmark.fill"
        case .output: return "arrow.up.doc.fill"
        case .trash: return "trash.fill"
        }
    }
}
