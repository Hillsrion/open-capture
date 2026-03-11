import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Export Metadata tool (TD-601).
public struct ExportMetadataToolView: View {
    @ObservedObject var recipeManager = OutputRecipeManager.shared
    
    public init() {}
    
    public var body: some View {
        COToolSection("Metadata", toolID: "OutputMetadata") {
            VStack(alignment: .leading, spacing: 8) {
                if let recipe = recipeManager.primaryRecipe ?? recipeManager.recipes.first {
                    Toggle("Include Copyright", isOn: .constant(true))
                    Toggle("Include GPS", isOn: .constant(false))
                    Toggle("Include Camera Settings", isOn: .constant(true))
                    
                    Divider().background(Color.white.opacity(0.05))
                    
                    Toggle("Include Annotations", isOn: Binding(get: { recipe.includeAnnotations }, set: { recipe.includeAnnotations = $0 }))
                    
                    if recipe.includeAnnotations {
                        Toggle("Annotations as a Layer", isOn: Binding(get: { recipe.annotationsAsLayer }, set: { recipe.annotationsAsLayer = $0 }))
                            .padding(.leading, 12)
                            .disabled(recipe.format != .psd && recipe.format != .tiff)
                    }
                } else {
                    Text("No recipe selected").font(.system(size: 10)).foregroundColor(.gray)
                }
                
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
