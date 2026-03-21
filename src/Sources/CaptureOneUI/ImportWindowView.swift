import SwiftUI
import AppCoreShared

/// Reconstructed SwiftUI view for the AI-powered Import Window (AI-005).
/// Based on functional specs for the 4-pane layout.
public struct ImportWindowView: View {
    @StateObject var controller = COImportViewController()
    @Environment(\.dismiss) private var dismiss
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header: 4 Panes Tab Bar
            HStack(spacing: 0) {
                PaneButton(title: "Source", pane: .source, activePane: $controller.activePane)
                PaneButton(title: "Destination", pane: .destination, activePane: $controller.activePane)
                PaneButton(title: "Naming", pane: .naming, activePane: $controller.activePane)
                PaneButton(title: "Options", pane: .options, activePane: $controller.activePane)
                Spacer()
            }
            .background(CaptureOneTheme.Colors.panelBackground)
            
            Divider().background(Color.black)
            
            HStack(spacing: 0) {
                // Left Panel: Active Pane Content
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 15) {
                            switch controller.activePane {
                            case .source:
                                SourcePaneView(controller: controller)
                            case .destination:
                                DestinationPaneView(controller: controller)
                            case .naming:
                                NamingPaneView(controller: controller)
                            case .options:
                                OptionsPaneView(controller: controller)
                            }
                        }
                        .padding(15)
                    }
                    Spacer()
                }
                .frame(width: 300)
                .background(CaptureOneTheme.Colors.panelBackground)
                
                Divider().background(Color.black)
                
                // Main Content Area: Grouped Browser Grid
                GroupedImportGridView(controller: controller)
                    .background(CaptureOneTheme.Colors.browserBackground)
            }
            
            Divider().background(Color.black)
            
            // Bottom Bar: Progress and Action
            ImportBottomBar(importer: controller.importer)
        }
        .frame(minWidth: 1100, minHeight: 700)
        .foregroundColor(.white)
        .onAppear {
            // Auto-scan if a source URL is already set in importer (mock)
            if let url = controller.importer.sourceURL {
                controller.scanSource(url: url)
            }
        }
    }
}

// MARK: - Subviews

struct PaneButton: View {
    let title: String
    let pane: COImportViewController.ImportPane
    @Binding var activePane: COImportViewController.ImportPane
    
    var body: some View {
        Button(action: { activePane = pane }) {
            Text(title.uppercased())
                .font(.system(size: 10, weight: .bold))
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .foregroundColor(activePane == pane ? .white : .gray)
                .background(activePane == pane ? Color.white.opacity(0.1) : Color.clear)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SourcePaneView: View {
    @ObservedObject var controller: COImportViewController
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("IMPORT FROM").font(.system(size: 11, weight: .bold)).foregroundColor(.gray)
            
            Button(action: {
                let panel = NSOpenPanel()
                panel.canChooseDirectories = true
                panel.canChooseFiles = false
                if panel.runModal() == .OK, let url = panel.url {
                    controller.scanSource(url: url)
                }
            }) {
                HStack {
                    Image(systemName: "folder")
                    Text(controller.importer.sourceURL?.lastPathComponent ?? "Choose Folder...")
                    Spacer()
                }
                .font(.system(size: 11))
                .padding(8)
                .background(Color.white.opacity(0.05))
                .cornerRadius(4)
            }
            .buttonStyle(PlainButtonStyle())
            
            Toggle("Include Subfolders", isOn: $controller.importer.settings.includeSubfolders)
                .font(.system(size: 11))
            
            Divider().background(Color.gray.opacity(0.3))
            
            ImportSourceBrowser(importer: controller.importer)
        }
    }
}

struct DestinationPaneView: View {
    @ObservedObject var controller: COImportViewController
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("IMPORT TO").font(.system(size: 11, weight: .bold)).foregroundColor(.gray)
            
            Picker("", selection: $controller.importer.settings.destinationFolderType) {
                Text("Current Location").tag(ImportSettings.DestinationFolderType.currentLocation)
                Text("Inside Catalog").tag(ImportSettings.DestinationFolderType.insideCatalog)
                Text("Choose Folder...").tag(ImportSettings.DestinationFolderType.customFolder)
            }
            .pickerStyle(MenuPickerStyle())
            .font(.system(size: 11))
            
            if controller.importer.settings.destinationFolderType == .customFolder {
                HStack {
                    Text(controller.importer.settings.destinationCustomPath).font(.system(size: 10)).lineLimit(1)
                    Spacer()
                    Button("...") {
                        let panel = NSOpenPanel()
                        panel.canChooseDirectories = true
                        if panel.runModal() == .OK {
                            controller.importer.settings.destinationCustomPath = panel.url?.path ?? ""
                        }
                    }
                }
                .padding(4)
                .background(Color.black.opacity(0.2))
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("SUBFOLDER").font(.system(size: 10, weight: .bold)).foregroundColor(.gray)
                TextField("Tokens...", text: $controller.importer.settings.destinationSubfolderTokens)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 11))
            }
        }
    }
}

struct NamingPaneView: View {
    @ObservedObject var controller: COImportViewController
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("NAMING").font(.system(size: 11, weight: .bold)).foregroundColor(.gray)
            
            TextField("Format", text: $controller.importer.settings.namingFormat)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.system(size: 11))
            
            Text("Token examples: [Image Name], [Sequence], [Job Name]")
                .font(.system(size: 10))
                .foregroundColor(.gray)
        }
    }
}

struct OptionsPaneView: View {
    @ObservedObject var controller: COImportViewController
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("AI GROUPING").font(.system(size: 11, weight: .bold)).foregroundColor(.gray)
            
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text("Similarity").font(.system(size: 11))
                    Spacer()
                    Text("\(Int(controller.groupingAI.similarityThreshold * 100))%")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                }
                
                Slider(value: $controller.groupingAI.similarityThreshold, in: 0...1)
                    .accentColor(CaptureOneTheme.Colors.activeHighlight)
            }
            
            Divider().background(Color.gray.opacity(0.3))
            
            Text("PROCESSING").font(.system(size: 11, weight: .bold)).foregroundColor(.gray)
            
            Toggle("Pack as EIP", isOn: $controller.importer.settings.alwaysPackAsEIP)
            Toggle("Unpack EIP", isOn: $controller.importer.settings.alwaysUnpackEIP)
            
            Divider().background(Color.gray.opacity(0.3))
            
            Text("METADATA").font(.system(size: 11, weight: .bold)).foregroundColor(.gray)
            TextField("Job Name", text: $controller.importer.settings.metadata.jobName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.system(size: 11))
        }
        .font(.system(size: 11))
    }
}

struct GroupedImportGridView: View {
    @ObservedObject var controller: COImportViewController
    
    var body: some View {
        VStack(spacing: 0) {
            // Group Toolbar
            HStack {
                Text("\(controller.groupingAI.groups.count) Groups")
                    .font(.system(size: 11, weight: .bold))
                
                Spacer()
                
                Button("Pick All") { controller.pickAll() }
                    .buttonStyle(PlainButtonStyle()).font(.system(size: 11))
                
                Button("Unpick All") { controller.unpickAll() }
                    .buttonStyle(PlainButtonStyle()).font(.system(size: 11))
            }
            .padding(10)
            .background(CaptureOneTheme.Colors.panelBackground)
            
            Divider().background(Color.black)
            
            ScrollView {
                if controller.groupingAI.groups.isEmpty {
                    VStack {
                        Spacer()
                        Text("Scan a folder to discover and group images.").foregroundColor(.gray)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, minHeight: 400)
                } else {
                    LazyVStack(alignment: .leading, spacing: 20) {
                        ForEach(controller.groupingAI.groups) { group in
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text(group.name).font(.system(size: 12, weight: .bold))
                                    Text("(\(group.urls.count) items)").font(.system(size: 10)).foregroundColor(.gray)
                                    Spacer()
                                }
                                
                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 120, maximum: 120), spacing: 10)], spacing: 10) {
                                    ForEach(group.urls, id: \.self) { url in
                                        if #available(macOS 14.0, *) {
                                            ImportThumbnailCell(url: url, pickedState: controller.importer.pickedState)
                                                .focusable()
                                                .onKeyPress(.space) {
                                                    controller.togglePick(for: url)
                                                    return .handled
                                                }
                                        } else {
                                            ImportThumbnailCell(url: url, pickedState: controller.importer.pickedState)
                                                .onTapGesture {
                                                    controller.togglePick(for: url)
                                                }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 15)
                        }
                    }
                    .padding(.vertical, 15)
                }
            }
        }
    }
}
