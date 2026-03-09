import Cocoa
import SwiftUI
import AppCoreShared

/// Standalone Window Controller for the Print workflow (WS-104).
/// Reconstructs the dedicated window shell instead of using a sheet.
public class PrintWindowController: NSWindowController {
    
    private var workspace: Workspace
    
    public init() {
        // Request the specific print window workspace preset
        self.workspace = WorkspaceManager.createWorkspace(windowKind: .print, name: "Print")
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1100, height: 800),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.title = "Print"
        window.center()
        window.titlebarAppearsTransparent = true
        window.backgroundColor = NSColor(calibratedWhite: 0.12, alpha: 1.0)
        
        super.init(window: window)
        
        let contentView = PrintRootView(workspace: workspace)
        window.contentView = NSHostingView(rootView: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate struct PrintRootView: View {
    @ObservedObject private var adjustmentController = AdjustmentToolController.shared
    @State private var selectedVariants: [VariantBase] = []
    let workspace: Workspace
    
    var body: some View {
        PrintDialog(selectedVariants: $selectedVariants)
            .background(CaptureOneTheme.Colors.applicationBackground)
            .preferredColorScheme(.dark)
            .edgesIgnoringSafeArea(.top)
            .onAppear {
                selectedVariants = adjustmentController.currentVariant.map { [$0] } ?? []
            }
    }
}

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
                    // If hosted in a window, we should close the window.
                    // If hosted in a sheet, dismiss works.
                    if let window = NSApp.keyWindow, window.title == "Print" {
                        window.close()
                    } else {
                        dismiss()
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 10)
                
                Button(action: {
                    print("[Print] Executing print job for \(selectedVariants.count) variants.")
                    if let window = NSApp.keyWindow, window.title == "Print" {
                        window.close()
                    } else {
                        dismiss()
                    }
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
