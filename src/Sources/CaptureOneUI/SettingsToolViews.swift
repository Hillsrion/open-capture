import SwiftUI
import AppCoreShared

// MARK: - Settings (Settings palette – generic)

/// Generic Settings tool view for the Settings palette.
struct SettingsToolView: View {
    let config: ToolConfiguration
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Sharpening").font(.system(size: 11)).foregroundColor(.gray)
                Spacer()
                Picker("", selection: .constant("Default")) {
                    Text("Off").tag("Off")
                    Text("Default").tag("Default")
                    Text("Camera Default").tag("Camera Default")
                }
                .pickerStyle(.menu)
                .frame(width: 140)
            }
            
            HStack {
                Text("Noise Reduction").font(.system(size: 11)).foregroundColor(.gray)
                Spacer()
                Picker("", selection: .constant("Default")) {
                    Text("Off").tag("Off")
                    Text("Default").tag("Default")
                }
                .pickerStyle(.menu)
                .frame(width: 140)
            }
        }
        .padding(10)
    }
}
