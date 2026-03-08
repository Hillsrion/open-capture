import SwiftUI
import AppCoreShared

/// Reconstructed Print Window / Dialog (UI-012).
public struct PrintDialog: View {
    @StateObject private var printManager = PrintManager.shared
    @Binding var selectedVariants: [VariantBase]
    
    @Environment(\.dismiss) var dismiss
    
    public init(selectedVariants: Binding<[VariantBase]>) {
        self._selectedVariants = selectedVariants
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Main Content Area
            HStack(spacing: 0) {
                // Settings Sidebar
                PrintSettingsSidebar(manager: printManager)
                
                Divider().background(Color.black)
                
                // Layout Canvas
                PrintLayoutView(manager: printManager, selectedVariants: $selectedVariants)
            }
            
            Divider().background(Color.black)
            
            // Bottom Action Bar
            HStack {
                Button("Page Setup...") {
                    // System page setup dialog
                    let printInfo = NSPrintInfo.shared
                    let panel = NSPageLayout()
                    panel.beginSheet(with: printInfo, modalFor: NSApp.keyWindow!, delegate: nil, didEnd: nil, contextInfo: nil)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 10)
                
                Spacer()
                
                Button("Cancel") {
                    dismiss()
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 10)
                
                Button(action: {
                    print("[Print] Executing print job for \(selectedVariants.count) variants.")
                    dismiss()
                }) {
                    Text("Print...")
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(CaptureOneTheme.Colors.activeHighlight)
                        .cornerRadius(4)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(15)
            .background(CaptureOneTheme.Colors.panelBackground)
        }
        .frame(minWidth: 1000, minHeight: 700)
        .foregroundColor(.white)
    }
}
