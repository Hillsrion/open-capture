import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Export Location tool (TD-601).
public struct ExportLocationToolView: View {
    @ObservedObject var recipeManager: OutputRecipeManager
    @State private var subFolder: String = ""
    
    public init(recipeManager: OutputRecipeManager) {
        self.recipeManager = recipeManager
    }
    
    public var body: some View {
        COToolSection("Export Location", toolID: "ExportLocation") {
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Destination").font(.system(size: 10)).foregroundColor(.gray)
                    HStack {
                        Text("Output Folder")
                            .font(.system(size: 11, weight: .bold))
                        Spacer()
                        Button("Choose...") { }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Sub Folder").font(.system(size: 10)).foregroundColor(.gray)
                    HStack {
                        TextField("Enter subfolder...", text: $subFolder)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.system(size: 11, design: .monospaced))
                        
                        Button(action: {}) {
                            Image(systemName: "ellipsis")
                        }
                        .buttonStyle(.bordered)
                    }
                }
                
                Text("Sample: /Users/Shared/Capture One/Output/")
                    .font(.system(size: 9))
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 4)
        }
    }
}
