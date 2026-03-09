import SwiftUI
import AppCoreShared

/// Reconstructed Print Settings Sidebar (UI-012).
public struct PrintSettingsSidebar: View {
    @ObservedObject var manager: PrintManager
    
    public init(manager: PrintManager) {
        self.manager = manager
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 1) {
                // Templates
                COToolSection("Templates") {
                    Picker("", selection: $manager.currentTemplate.name) {
                        ForEach(manager.templates, id: \.name) { template in
                            Text(template.name).tag(template.name)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: manager.currentTemplate.name) { newName in
                        if let matched = manager.templates.first(where: { $0.name == newName }) {
                            manager.currentTemplate = matched
                        }
                    }
                }
                
                // Layout (Margins)
                COToolSection("Margins") {
                    VStack(spacing: 8) {
                        HStack {
                            Text("Top")
                            Spacer()
                            TextField("", value: $manager.currentTemplate.marginTop, formatter: NumberFormatter())
                                .frame(width: 50)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Text("mm")
                        }
                        HStack {
                            Text("Bottom")
                            Spacer()
                            TextField("", value: $manager.currentTemplate.marginBottom, formatter: NumberFormatter())
                                .frame(width: 50)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Text("mm")
                        }
                        HStack {
                            Text("Left")
                            Spacer()
                            TextField("", value: $manager.currentTemplate.marginLeft, formatter: NumberFormatter())
                                .frame(width: 50)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Text("mm")
                        }
                        HStack {
                            Text("Right")
                            Spacer()
                            TextField("", value: $manager.currentTemplate.marginRight, formatter: NumberFormatter())
                                .frame(width: 50)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Text("mm")
                        }
                    }
                    .font(.system(size: 11))
                }
                
                // Grid
                COToolSection("Grid") {
                    VStack(spacing: 8) {
                        HStack {
                            Text("Rows")
                            Spacer()
                            Stepper("", value: $manager.currentTemplate.rows, in: 1...10)
                            Text("\(manager.currentTemplate.rows)")
                                .frame(width: 20)
                        }
                        HStack {
                            Text("Columns")
                            Spacer()
                            Stepper("", value: $manager.currentTemplate.columns, in: 1...10)
                            Text("\(manager.currentTemplate.columns)")
                                .frame(width: 20)
                        }
                        HStack {
                            Text("Spacing")
                            Spacer()
                            TextField("", value: $manager.currentTemplate.cellSpacing, formatter: NumberFormatter())
                                .frame(width: 50)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Text("mm")
                        }
                    }
                    .font(.system(size: 11))
                }
                
                // Color Profile
                COToolSection("Color Profile") {
                    VStack(alignment: .leading, spacing: 8) {
                        Picker("Profile", selection: $manager.currentSettings.iccProfileID) {
                            Text("Printer Managed").tag("Printer Managed")
                            Text("sRGB").tag("sRGB")
                            Text("Adobe RGB").tag("AdobeRGB")
                            // Add more profiles from ICCManager if needed
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                        Picker("Intent", selection: $manager.currentSettings.renderingIntent) {
                            Text("Perceptual").tag(0)
                            Text("Relative Colorimetric").tag(1)
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    .font(.system(size: 11))
                }
            }
            .padding(10)
        }
        .frame(width: 300)
        .background(CaptureOneTheme.Colors.panelBackground)
    }
}
