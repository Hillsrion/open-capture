import AppCoreShared
import ImageCore
import DataCore
import SwiftUI
import AppKit

/// Reconstructed CullingWindowController for Capture One.
/// Manages the high-speed image culling interface.
/// Based on version 16.5.9.7 metadata.
public class CullingWindowController: NSWindowController {
    
    // MARK: - UI Outlets (Reconstructed from properties)
    public var doneButton: NSButton?
    public var browserWarningText: NSTextField?
    public var shortcutHelpLabel: NSTextField?
    
    // MARK: - Data Bindings
    public var cullingCollection: MOFolderCollection?
    public var browser = CImageBrowser()
    public var hasBrowser: Bool = true
    
    // MARK: - Initialization
    public override init(window: NSWindow?) {
        super.init(window: window)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    public override func windowDidLoad() {
        super.windowDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        window?.backgroundColor = NSColor.coApplicationBackground
        
        // Setup initial folder scan for testing (inferred logic)
        let context = ObjectContext()
        cullingCollection = MOFolderCollection(uuid: UUID().uuidString, context: context)
        
        // For demonstration, we'll point to the Pictures folder
        let picturesPath = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first?.path ?? "/"
        cullingCollection?.updateWithFolderPath(picturesPath, clear: true, synchronizeFS: true)
        
        if let images = cullingCollection?.images {
            browser.dataSource = images
        }
        
        let contentView = CullingView(browser: browser)
        window?.contentView = NSHostingView(rootView: contentView)
    }
    
    // MARK: - Actions
    @objc public func doneAction(_ sender: Any) {
        self.close()
    }
}

/// SwiftUI Wrapper for Culling interface
public struct CullingView: View {
    
    @ObservedObject var browserWrapper: BrowserWrapper
    
    public init(browser: CImageBrowser) {
        self.browserWrapper = BrowserWrapper(browser: browser)
    }
    
    public var body: some View {
        ZStack {
            CaptureOneTheme.Colors.applicationBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Culling View")
                        .foregroundColor(.white)
                        .font(.headline)
                    Spacer()
                    Text("\(browserWrapper.browser.dataSource.count) Images")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                    Button("Done") {
                        NSApp.terminate(nil)
                    }
                    .buttonStyle(COUButtonStyle())
                }
                .padding()
                .background(CaptureOneTheme.Colors.mainWindowTitleAndToolbar)
                
                // Browser Grid
                ImageBrowserView(images: browserWrapper.browser.dataSource)
                
                // Footer
                HistogramToolView()
                    .frame(height: 200)
            }
        }
    }
}

/// Observable wrapper for CImageBrowser to trigger SwiftUI updates
class BrowserWrapper: ObservableObject {
    @Published var browser: CImageBrowser
    init(browser: CImageBrowser) {
        self.browser = browser
    }
}
