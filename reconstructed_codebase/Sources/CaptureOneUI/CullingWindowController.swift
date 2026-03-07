import AppCoreShared
import ImageCore
import DataCore
import SwiftUI
import AppKit

/// Reconstructed CullingWindowController for Capture One.
/// Manages the high-speed image culling interface.
public class CullingWindowController: NSWindowController {
    
    public var cullingCollection: MOFolderCollection?
    public var browser = CImageBrowser()
    
    public override init(window: NSWindow?) {
        super.init(window: window)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func windowDidLoad() {
        super.windowDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        window?.backgroundColor = NSColor.coApplicationBackground
        
        let context = ObjectContext()
        cullingCollection = MOFolderCollection(uuid: UUID().uuidString, context: context)
        
        let picturesPath = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first?.path ?? "/"
        cullingCollection?.updateWithFolderPath(picturesPath, clear: true, synchronizeFS: true)
        
        if let images = cullingCollection?.images {
            browser.dataSource = images
        }
        
        let contentView = CullingView(browser: browser)
        window?.contentView = NSHostingView(rootView: contentView)
    }
}

/// SwiftUI Wrapper for Culling interface with selection support
public struct CullingView: View {
    
    @ObservedObject var browserWrapper: BrowserWrapper
    @State private var selectedImage: ImageBase?
    
    public init(browser: CImageBrowser) {
        self.browserWrapper = BrowserWrapper(browser: browser)
        self._selectedImage = State(initialValue: browser.dataSource.first)
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
                
                HStack(spacing: 1) {
                    // Left: COViewerView (High Fidelity)
                    COViewerView(image: selectedImage)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    // Right: COImageBrowserView (High Fidelity)
                    COImageBrowserView(images: browserWrapper.browser.dataSource, onSelect: { image in
                        self.selectedImage = image
                    })
                    .frame(width: 350)
                }
                
                // Footer
                HistogramToolView()
                    .frame(height: 150)
            }
        }
    }
}

class BrowserWrapper: ObservableObject {
    @Published var browser: CImageBrowser
    init(browser: CImageBrowser) {
        self.browser = browser
    }
}
