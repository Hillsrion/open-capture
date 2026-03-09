import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Session Upgrade Dialog (UI-216).
/// Matches Capture One 16.5 aesthetics and phrasing found in disassembly.
public struct SessionUpgradeDialog: View {
    let session: SessionBase
    let onUpgrade: () -> Void
    let onCancel: () -> Void
    
    public init(session: SessionBase, onUpgrade: @escaping () -> Void, onCancel: @escaping () -> Void) {
        self.session = session
        self.onUpgrade = onUpgrade
        self.onCancel = onCancel
    }
    
    private var documentTypeName: String {
        session.documentType == 0 ? "Session" : "Catalog"
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            HStack(alignment: .top, spacing: 16) {
                // Warning Triangle Icon
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 44))
                    .foregroundColor(CaptureOneTheme.Colors.activeHighlight)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Database upgrade")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(CaptureOneTheme.Colors.textPrimary)
                    
                    Text("Do you want to upgrade \(documentTypeName.lowercased()) \"\(session.name ?? "Untitled")\"?")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(CaptureOneTheme.Colors.textPrimary)
                    
                    Text("This document was created in an older version of Capture One. Upgrading is required to open it.\n\nIt is recommended to create a backup before upgrading.")
                        .font(.system(size: 12))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                        .lineSpacing(2)
                }
            }
            .padding(.top, 10)
            
            Spacer()
            
            HStack {
                Spacer()
                
                Button("Cancel") {
                    onCancel()
                }
                .buttonStyle(CaptureOneButtonStyle(isPrimary: false))
                
                Button("Upgrade") {
                    onUpgrade()
                }
                .buttonStyle(CaptureOneButtonStyle(isPrimary: true))
            }
        }
        .padding(24)
        .frame(width: 440, height: 260)
        .background(CaptureOneTheme.Colors.panelBackground)
        .preferredColorScheme(.dark)
    }
}

/// Helper button style for C1 buttons
struct CaptureOneButtonStyle: ButtonStyle {
    let isPrimary: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 13))
            .padding(.horizontal, 16)
            .padding(.vertical, 6)
            .background(isPrimary ? CaptureOneTheme.Colors.activeHighlight : CaptureOneTheme.Colors.buttonBackground)
            .foregroundColor(isPrimary ? .black : CaptureOneTheme.Colors.textPrimary)
            .cornerRadius(4)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}

struct SessionUpgradeDialog_Previews: PreviewProvider {
    static var previews: some View {
        let ctx = ObjectContext()
        let session = SessionBase(documentUUID: "preview", type: 1, context: ctx)
        session.name = "Travel Photos 2023"
        
        return SessionUpgradeDialog(session: session, onUpgrade: {}, onCancel: {})
            .previewLayout(.sizeThatFits)
    }
}
