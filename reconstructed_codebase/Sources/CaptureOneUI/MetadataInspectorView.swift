import SwiftUI
import AppCoreShared

/// Reconstructed Metadata Inspector Tool.
/// Shows EXIF (Read-only) and IPTC (Editable) metadata.
/// Based on _TtC10CaptureOne21MetadataInspectorTool metadata.

public struct MetadataInspectorView: View {
    let image: ImageBase?
    
    public init(image: ImageBase?) {
        self.image = image
    }
    
    public var body: some View {
        COToolSection("Metadata") {
            VStack(alignment: .leading, spacing: 12) {
                // EXIF Section
                VStack(alignment: .leading, spacing: 4) {
                    Text("EXIF").font(.system(size: 9, weight: .bold)).foregroundColor(.gray)
                    
                    if let image = image {
                        MetadataRow(label: "ISO", value: "\(image.iso)")
                        MetadataRow(label: "Aperture", value: "f/\(String(format: "%.1f", image.aperture))")
                        MetadataRow(label: "Shutter", value: formatShutter(image.shutter))
                        MetadataRow(label: "Focal Length", value: "\(image.focalLength)mm")
                    } else {
                        Text("No selection").font(.system(size: 11)).foregroundColor(.gray)
                    }
                }
                
                Divider().background(Color.white.opacity(0.1))
                
                // IPTC Section (Editable placeholders)
                VStack(alignment: .leading, spacing: 4) {
                    Text("IPTC - CONTACT").font(.system(size: 9, weight: .bold)).foregroundColor(.gray)
                    
                    MetadataEditRow(label: "Creator", value: .constant("Unknown"))
                    MetadataEditRow(label: "Copyright", value: .constant("© 2026"))
                    MetadataEditRow(label: "Description", value: .constant(""))
                }
            }
            .padding(.vertical, 4)
        }
    }
    
    private func formatShutter(_ val: Double) -> String {
        if val >= 1.0 {
            return "\(Int(val))s"
        } else if val > 0 {
            return "1/\(Int(1.0/val))s"
        }
        return "-"
    }
}

struct MetadataRow: View {
    let label: String
    let value: String
    var body: some View {
        HStack {
            Text(label).font(.system(size: 11)).foregroundColor(.gray)
            Spacer()
            Text(value).font(.system(size: 11)).foregroundColor(.white)
        }
    }
}

struct MetadataEditRow: View {
    let label: String
    @Binding var value: String
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label).font(.system(size: 10)).foregroundColor(.gray)
            TextField("", text: $value)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.system(size: 11))
                .padding(4)
                .background(Color.black.opacity(0.2))
                .cornerRadius(3)
        }
    }
}
