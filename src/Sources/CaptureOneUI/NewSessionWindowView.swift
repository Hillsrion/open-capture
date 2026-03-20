import SwiftUI
import AppCoreShared

public struct NewSessionWindowView: View {
    @StateObject private var controller = COSessionBuilderController()
    @ObservedObject var commands = AppCommandCenter.shared
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("New Session")
                    .font(.headline)
                Spacer()
                
                Picker("Mode", selection: $controller.mode) {
                    Text("Manual").tag(COSessionBuilderController.CreationMode.manual)
                    Text("Automated").tag(COSessionBuilderController.CreationMode.automated)
                }
                .pickerStyle(.segmented)
                .frame(width: 200)
            }
            .padding()
            .background(Color(white: 0.15))
            
            ScrollView {
                Form {
                    Section(header: Text("Session Name & Location")) {
                        TextField("Name:", text: $controller.sessionName)
                        
                        HStack {
                            Text("Location:")
                            Text(controller.location.path)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                                .truncationMode(.middle)
                            Spacer()
                            Button("Choose...") {
                                selectLocation()
                            }
                        }
                    }
                    
                    if controller.mode == .manual {
                        Section(header: Text("Subfolders Matrix")) {
                            VStack(spacing: 8) {
                                TextField("Capture Folder:", text: $controller.captureFolder)
                                TextField("Selects Folder:", text: $controller.selectsFolder)
                                TextField("Output Folder:", text: $controller.outputFolder)
                                TextField("Trash Folder:", text: $controller.trashFolder)
                            }
                        }
                    } else {
                        Section(header: Text("Automated Configuration")) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Folder Names (delimited by comma, semicolon, or newline):")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                TextEditor(text: $controller.automatedList)
                                    .frame(height: 100)
                                    .font(.system(.body, design: .monospaced))
                                    .cornerRadius(4)
                                
                                Text("Hierarchy Support: Use '/' (e.g., Trash/JPG, Trash/TIF)")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                
                                Divider()
                                
                                Text("Preview Hierarchy:")
                                    .font(.subheadline)
                                
                                List(controller.previewPaths, id: \.self) { path in
                                    HStack {
                                        Image(systemName: "folder")
                                        Text(path)
                                    }
                                }
                                .frame(height: 150)
                            }
                        }
                    }
                }
                .padding()
            }
            
            Divider()
            
            HStack {
                Spacer()
                
                Button("Cancel") {
                    commands.presentedSheet = nil
                }
                .keyboardShortcut(.cancelAction)
                
                Button("Done") {
                    performCreation()
                }
                .buttonStyle(.borderedProminent)
                .tint(CaptureOneTheme.Colors.activeHighlight)
                .keyboardShortcut(.defaultAction)
            }
            .padding()
        }
        .frame(width: 550, height: 600)
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
                controller.location = url
            }
        }
    }
    
    private func performCreation() {
        do {
            let sessionFile = try controller.createSession()
            // In a real app, we'd open this session.
            // For this simulation, we'll notify the CommandCenter.
            commands.openDocument(at: sessionFile)
            commands.presentedSheet = nil
        } catch {
            print("[NewSession] Error: \(error.localizedDescription)")
        }
    }
}
