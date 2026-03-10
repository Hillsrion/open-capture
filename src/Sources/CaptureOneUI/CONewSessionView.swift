import SwiftUI
import AppCoreShared

public struct CONewSessionView: View {
    @ObservedObject var commands = AppCommandCenter.shared
    
    @State private var name: String = "Untitled Session"
    @State private var location: URL = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first!
    @State private var template: String = "None"
    
    @State private var captureFolder: String = "Capture"
    @State private var selectsFolder: String = "Selects"
    @State private var outputFolder: String = "Output"
    @State private var trashFolder: String = "Trash"
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("New Session")
                    .font(.headline)
                Spacer()
            }
            .padding()
            .background(Color(white: 0.15))
            
            Form {
                Section(header: Text("Session Name & Location")) {
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
                    
                    Picker("Template:", selection: $template) {
                        Text("None").tag("None")
                        Text("Default").tag("Default")
                    }
                }
                
                Section(header: Text("Subfolders")) {
                    TextField("Capture Folder:", text: $captureFolder)
                    TextField("Selects Folder:", text: $selectsFolder)
                    TextField("Output Folder:", text: $outputFolder)
                    TextField("Trash Folder:", text: $trashFolder)
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
                    createSession()
                }
                .buttonStyle(.borderedProminent)
                .tint(CaptureOneTheme.Colors.activeHighlight)
                .keyboardShortcut(.defaultAction)
            }
            .padding()
        }
        .frame(width: 500, height: 500)
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
    
    private func createSession() {
        let subfolders = [
            "Capture": captureFolder,
            "Selects": selectsFolder,
            "Output": outputFolder,
            "Trash": trashFolder
        ]
        commands.createSession(name: name, location: location, subfolders: subfolders)
    }
}
