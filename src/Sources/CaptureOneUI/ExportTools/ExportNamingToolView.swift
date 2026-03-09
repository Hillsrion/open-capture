import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Export Naming tool (TD-601).
public struct ExportNamingToolView: View {
    @State private var format: String = "[Image Name]"
    
    public init() {}
    
    public var body: some View {
        COToolSection("Export Naming", toolID: "ExportNaming") {
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Format").font(.system(size: 10)).foregroundColor(.gray)
                    HStack {
                        TextField("", text: $format)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.system(size: 11, design: .monospaced))
                        
                        Button(action: {}) {
                            Image(systemName: "ellipsis")
                        }
                        .buttonStyle(.bordered)
                    }
                }
                
                HStack {
                    Text("Sample:").font(.system(size: 10)).foregroundColor(.gray)
                    Text("DSC01234.jpg")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .padding(.vertical, 4)
        }
    }
}
