import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Export Metadata tool (TD-601).
public struct ExportMetadataToolView: View {
    @State private var includeCopyright: Bool = true
    @State private var includeGPS: Bool = false
    @State private var includeCameraSettings: Bool = true
    
    public init() {}
    
    public var body: some View {
        COToolSection("Metadata", toolID: "OutputMetadata") {
            VStack(alignment: .leading, spacing: 8) {
                Toggle("Include Copyright", isOn: $includeCopyright)
                Toggle("Include GPS", isOn: $includeGPS)
                Toggle("Include Camera Settings", isOn: $includeCameraSettings)
                
                Divider().background(Color.white.opacity(0.05))
                
                HStack {
                    Text("IPTC Selection").font(.system(size: 11)).foregroundColor(.gray)
                    Spacer()
                    Text("All").font(.system(size: 11, weight: .medium))
                }
            }
            .font(.system(size: 11))
            .toggleStyle(POCheckboxStyle())
            .padding(.vertical, 4)
        }
    }
}
