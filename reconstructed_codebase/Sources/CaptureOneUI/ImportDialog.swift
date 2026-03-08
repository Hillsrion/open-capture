import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Import Dialog (CORE-007 / UI-008).
/// Based on disassembly of ImporterWindowController.
public struct ImportDialog: View {
    @ObservedObject var importer: POImporter
    @Environment(\.dismiss) private var dismiss
    
    public init(importer: POImporter) {
        self.importer = importer
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Main Content Area
            HStack(spacing: 0) {
                // Sidebar: Settings
                ImportSettingsSidebar(importer: importer)
                    .frame(width: 300)
                    .background(CaptureOneTheme.Colors.panelBackground)
                
                Divider().background(Color.black)
                
                // Main: Browser Grid
                ImportGridView(importer: importer)
                    .background(CaptureOneTheme.Colors.browserBackground)
            }
            
            Divider().background(Color.black)
            
            // Bottom Bar: Actions
            ImportBottomBar(importer: importer)
        }
        .frame(minWidth: 900, minHeight: 600)
        .foregroundColor(.white)
    }
}

/// Sidebar for Import settings.
struct ImportSettingsSidebar: View {
    @ObservedObject var importer: POImporter
    
    var body: some View {
        ScrollView {
            VStack(spacing: 1) {
                // Import From (Source)
                COToolSection("Import From") {
                    VStack(alignment: .leading, spacing: 10) {
                        Button(action: {
                            let panel = NSOpenPanel()
                            panel.canChooseDirectories = true
                            panel.canChooseFiles = false
                            panel.allowsMultipleSelection = false
                            panel.prompt = "Choose"
                            if panel.runModal() == .OK, let url = panel.url {
                                importer.scanSource(url: url)
                            }
                        }) {
                            HStack {
                                Image(systemName: "folder")
                                Text("Select Folder...")
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .font(.system(size: 11))
                            .padding(8)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(4)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Toggle("Include Subfolders", isOn: $importer.settings.includeSubfolders)
                            .font(.system(size: 11))
                    }
                }
                
                // Destination
                COToolSection("Import To") {
                    VStack(alignment: .leading, spacing: 8) {
                        Picker("", selection: $importer.settings.destinationFolderType) {
                            Text("Current Location").tag(ImportSettings.DestinationFolderType.currentLocation)
                            Text("Inside Catalog").tag(ImportSettings.DestinationFolderType.insideCatalog)
                            Text("Choose Folder...").tag(ImportSettings.DestinationFolderType.customFolder)
                        }
                        .pickerStyle(MenuPickerStyle())
                        .font(.system(size: 11))
                    }
                }
                
                // Naming
                COToolSection("Naming") {
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("Format", text: $importer.settings.namingFormat)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.system(size: 11))
                        
                        Text("Example: \(importer.settings.namingFormat)")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                    }
                }
                
                // Metadata
                COToolSection("Metadata") {
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("Job Name", text: $importer.settings.metadata.jobName)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(4)
                            .background(Color.black.opacity(0.2))
                        
                        TextField("Copyright", text: $importer.settings.metadata.copyright)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(4)
                            .background(Color.black.opacity(0.2))
                    }
                    .font(.system(size: 11))
                }
                
                // EIP Handling (CORE-006)
                COToolSection("Options") {
                    VStack(alignment: .leading, spacing: 8) {
                        Toggle("Pack as EIP", isOn: $importer.settings.alwaysPackAsEIP)
                            .font(.system(size: 11))
                        Toggle("Unpack EIP", isOn: $importer.settings.alwaysUnpackEIP)
                            .font(.system(size: 11))
                    }
                }
                
                Spacer()
            }
            .padding(10)
        }
    }
}

/// Grid view for discovered items.
struct ImportGridView: View {
    @ObservedObject var importer: POImporter
    
    let columns = [
        GridItem(.adaptive(minimum: 120, maximum: 120), spacing: 10)
    ]
    
    var body: some View {
        ScrollView {
            if importer.discoveredURLs.isEmpty {
                VStack {
                    Spacer()
                    Text("No images found in source.")
                        .foregroundColor(.gray)
                    Spacer()
                }
                .frame(maxWidth: .infinity, minHeight: 400)
            } else {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(importer.discoveredURLs, id: \.self) { url in
                        ImportThumbnailCell(url: url, pickedState: importer.pickedState)
                    }
                }
                .padding(15)
            }
        }
    }
}

/// Individual thumbnail cell in the import grid.
struct ImportThumbnailCell: View {
    let url: URL
    @ObservedObject var pickedState: ImporterPickedState
    
    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .aspectRatio(1.0, contentMode: .fit)
                
                // Pick checkbox
                Image(systemName: pickedState.isPicked(url) ? "checkmark.square.fill" : "square")
                    .foregroundColor(pickedState.isPicked(url) ? CaptureOneTheme.Colors.activeHighlight : .white)
                    .padding(4)
                    .onTapGesture {
                        pickedState.togglePicked(for: url)
                    }
            }
            
            Text(url.lastPathComponent)
                .font(.system(size: 9))
                .lineLimit(1)
                .padding(.top, 2)
        }
        .frame(width: 120)
    }
}

/// Bottom bar actions.
struct ImportBottomBar: View {
    @ObservedObject var importer: POImporter
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack {
            if case .importing(let progress) = importer.status {
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle())
                    .frame(width: 200)
                Text("Importing...")
                    .font(.system(size: 11))
            } else if case .completed(let count) = importer.status {
                Text("Imported \(count) images.")
                    .font(.system(size: 11))
                    .foregroundColor(.green)
            }
            
            Spacer()
            
            Button("Cancel") {
                dismiss()
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal, 10)
            
            Button(action: {
                importer.startImport()
            }) {
                Text("Import \(importer.pickedState.count) Images")
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(CaptureOneTheme.Colors.activeHighlight)
                    .cornerRadius(4)
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(importer.pickedState.count == 0)
        }
        .padding(15)
        .background(CaptureOneTheme.Colors.panelBackground)
    }
}
