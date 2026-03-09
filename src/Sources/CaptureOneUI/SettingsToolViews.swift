import SwiftUI
import AppCoreShared

// MARK: - BaseCharacteristics (Settings palette)

/// BaseCharacteristicsInspectorTool — Controls ICC profile and film curve selection.
struct BaseCharacteristicsToolView: View {
    let config: ToolConfiguration
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("ICC Profile").font(.system(size: 11)).foregroundColor(.gray)
                Spacer()
                Picker("", selection: .constant("Phase One")) {
                    Text("Generic").tag("Generic")
                    Text("Phase One").tag("Phase One")
                    Text("Camera Default").tag("Camera Default")
                }
                .pickerStyle(.menu)
                .frame(width: 140)
            }
            
            HStack {
                Text("Curve").font(.system(size: 11)).foregroundColor(.gray)
                Spacer()
                Picker("", selection: .constant("Film Standard")) {
                    Text("Linear Response").tag("Linear Response")
                    Text("Film Standard").tag("Film Standard")
                    Text("Film High Contrast").tag("Film High Contrast")
                    Text("Film Extra Shadow").tag("Film Extra Shadow")
                }
                .pickerStyle(.menu)
                .frame(width: 140)
            }
        }
        .padding(10)
    }
}

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
