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
    
    @State private var autoFavorite: Bool = true
    
    let evaluator = TokenEvaluator()
    
    public init() {}
    
    private var tokenContext: TokenEvaluator.Context {
        TokenEvaluator.Context(imageName: "Image", date: Date(), sequence: 1, jobName: name.isEmpty ? "Untitled" : name)
    }
    
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
                
                Section(header: Text("Subfolders Matrix")) {
                    HStack(alignment: .top, spacing: 16) {
                        VStack(alignment: .trailing, spacing: 12) {
                            Text("Capture Folder:")
                            Text("Selects Folder:")
                            Text("Output Folder:")
                            Text("Trash Folder:")
                        }
                        .padding(.top, 4)
                        
                        VStack(spacing: 8) {
                            folderField($captureFolder)
                            folderField($selectsFolder)
                            folderField($outputFolder)
                            folderField($trashFolder)
                        }
                    }
                    
                    Toggle("Auto-add specific folders to Session Favorites", isOn: $autoFavorite)
                        .padding(.top, 8)
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
    
    @ViewBuilder
    private func folderField(_ binding: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            TextField("", text: binding)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if binding.wrappedValue.contains("[") {
                Text("Preview: " + evaluator.evaluate(format: binding.wrappedValue, context: tokenContext))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
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
        commands.createSession(name: name, location: location, subfolders: subfolders, autoFavorite: autoFavorite)
    }
}
