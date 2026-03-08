import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity HDR Merge Dialog (ENG-010).
public struct HDRMergeDialog: View {
    @ObservedObject var result: MergeResult
    @State var settings = IC_HDRMergeSettings()
    
    public var body: some View {
        VStack(spacing: 20) {
            Text("HDR Merge").font(.headline)
            
            VStack(alignment: .leading, spacing: 10) {
                Toggle("Auto Align", isOn: $settings.autoAlign)
                    .toggleStyle(POCheckboxStyle())
                
                COUISlider(label: "Deghosting", value: Binding(get: { Float(settings.deghosting) }, set: { settings.deghosting = Double($0) }), range: 0...100)
            }
            .padding()
            .background(Color.black.opacity(0.2))
            .cornerRadius(8)
            
            if result.status != .pending {
                ProgressView(value: result.progress, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle())
                Text("Status: \(String(describing: result.status))").font(.caption)
            }
            
            HStack {
                Button("Cancel") { /* Close logic */ }.buttonStyle(COUButtonStyle())
                Spacer()
                Button("Merge") { /* Trigger engine */ }.buttonStyle(COUButtonStyle())
            }
        }
        .padding()
        .frame(width: 400)
    }
}

/// Reconstructed high-fidelity Panorama Stitch Dialog.
public struct PanoramaMergeDialog: View {
    @ObservedObject var result: MergeResult
    @State var settings = IC_PanoramaMergeSettings()
    
    public var body: some View {
        VStack(spacing: 20) {
            Text("Panorama Stitch").font(.headline)
            
            VStack(alignment: .leading, spacing: 10) {
                Picker("Projection", selection: $settings.projection) {
                    Text("Spherical").tag(IC_PanoramaMergeSettings.ProjectionType.spherical)
                    Text("Cylindrical").tag(IC_PanoramaMergeSettings.ProjectionType.cylindrical)
                    Text("Perspective").tag(IC_PanoramaMergeSettings.ProjectionType.perspective)
                    Text("Panini").tag(IC_PanoramaMergeSettings.ProjectionType.panini)
                }
                
                Toggle("Auto Crop", isOn: $settings.autoCrop)
                    .toggleStyle(POCheckboxStyle())
            }
            .padding()
            .background(Color.black.opacity(0.2))
            .cornerRadius(8)
            
            if result.status != .pending {
                ProgressView(value: result.progress, total: 1.0)
                Text("Status: \(String(describing: result.status))").font(.caption)
            }
            
            HStack {
                Button("Cancel") { /* Close logic */ }.buttonStyle(COUButtonStyle())
                Spacer()
                Button("Stitch") { /* Trigger engine */ }.buttonStyle(COUButtonStyle())
            }
        }
        .padding()
        .frame(width: 400)
    }
}
