import SwiftUI
import AppCoreShared

public struct CONewCatalogView: View {
    @ObservedObject var commands = AppCommandCenter.shared
    
    @State private var name: String = "Untitled Catalog"
    @State private var location: URL = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first!
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("New Catalog")
                    .font(.headline)
                Spacer()
            }
            .padding()
            .background(Color(white: 0.15))
            
            Form {
                Section(header: Text("Catalog Name & Location")) {
                    TextField("Name:", text: $name)
                    
                    HStack {
                        Text("Location:")
                        Text(location.path)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                            .truncationMode(.middle)
                        Spacer()
                        Button("Choose...") {
                            selectLocation()
                        }
                    }
                }
            }
            .padding()
            
            Divider()
            
            HStack {
                Spacer()
                Button("Cancel") {
                    commands.presentedSheet = nil
                }
                .keyboardShortcut(.cancelAction)
                
                Button("Done") {
                    createCatalog()
                }
                .buttonStyle(.borderedProminent)
                .tint(CaptureOneTheme.Colors.activeHighlight)
                .keyboardShortcut(.defaultAction)
            }
            .padding()
        }
        .frame(width: 400, height: 300)
        .background(CaptureOneTheme.Colors.applicationBackground)
        .preferredColorScheme(.dark)
    }
    
    private func selectLocation() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        
        if panel.runModal() == .OK {
            if let url = panel.url {
                self.location = url
            }
        }
    }
    
    private func createCatalog() {
        commands.createCatalog(name: name, location: location)
    }
}
