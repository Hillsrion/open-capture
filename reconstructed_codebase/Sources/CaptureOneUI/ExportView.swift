import SwiftUI
import AppCoreShared

/// View for managing and triggering export recipes.
/// Based on _TtC12CaptureOneUI10ExportView metadata.
public struct ExportView: View {
    @ObservedObject var recipeManager: OutputRecipeManager
    @ObservedObject var batchQueue: BatchQueue
    var selectedVariant: VariantBase?
    
    public init(recipeManager: OutputRecipeManager, batchQueue: BatchQueue, selectedVariant: VariantBase?) {
        self.recipeManager = recipeManager
        self.batchQueue = batchQueue
        self.selectedVariant = selectedVariant
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            Text("EXPORT RECIPES")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(8)
                .background(Color.black.opacity(0.2))
            
            List {
                ForEach(recipeManager.recipes) { recipe in
                    RecipeRow(recipe: recipe)
                }
            }
            .listStyle(.plain)
            .frame(height: 200)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                if let variant = selectedVariant {
                    Text("Selected: \(variant.image?.imageFileName ?? "None")")
                        .font(.caption)
                }
                
                Button(action: exportSelected) {
                    Text("Export")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(selectedVariant == nil || recipeManager.activeRecipes.isEmpty)
            }
            .padding(12)
            
            if let active = batchQueue.activeJob {
                VStack(alignment: .leading) {
                    Text("Exporting: \(active.destinationPath.lastPathComponent)")
                        .font(.caption2)
                    ProgressView(value: active.progress)
                }
                .padding(8)
                .background(Color.accentColor.opacity(0.1))
            }
        }
        .background(CaptureOneTheme.Colors.panelBackground)
    }
    
    private func exportSelected() {
        guard let variant = selectedVariant else { return }
        let recipes = recipeManager.activeRecipes
        
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        
        if panel.runModal() == .OK, let url = panel.url {
            for recipe in recipes {
                batchQueue.addJob(variant: variant, recipe: recipe, outputFolder: url)
            }
        }
    }
}

struct RecipeRow: View {
    @ObservedObject var recipe: OutputRecipe
    
    var body: some View {
        HStack {
            Toggle("", isOn: Binding(
                get: { recipe.isEnabled },
                set: { recipe.isEnabled = $0 }
            ))
            .toggleStyle(.checkbox)
            
            VStack(alignment: .leading) {
                Text(recipe.name)
                    .font(.system(size: 12))
                Text("\(recipe.format.rawValue) - \(recipe.iccProfile)")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

extension OutputRecipe: Identifiable {
    public var id: String { name }
}

extension String {
    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
}
