import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Export Recipes tool (TD-601).
public struct ExportRecipesToolView: View {
    @ObservedObject var recipeManager: OutputRecipeManager
    
    public init(recipeManager: OutputRecipeManager) {
        self.recipeManager = recipeManager
    }
    
    public var body: some View {
        COToolSection("Export Recipes", toolID: "ExportDialogRecipeList") {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 1) {
                        if recipeManager.recipes.isEmpty {
                            Text("No recipes defined").font(.system(size: 10)).foregroundColor(.gray).padding(12)
                        } else {
                            ForEach(recipeManager.recipes) { recipe in
                                recipeRow(recipe)
                            }
                        }
                    }
                }
                .frame(maxHeight: 160)
                .background(Color.black.opacity(0.2))
                .cornerRadius(4)
                
                HStack(spacing: 0) {
                    Button(action: { 
                        let newRecipe = OutputRecipe(name: "New Recipe", format: .jpeg)
                        recipeManager.recipes.append(newRecipe)
                    }) { Image(systemName: "plus").font(.system(size: 10, weight: .bold)).frame(width: 24, height: 20) }
                    Divider().frame(height: 20)
                    Button(action: {
                        if let last = recipeManager.recipes.last {
                            recipeManager.recipes.removeAll { $0.id == last.id }
                        }
                    }) { Image(systemName: "minus").font(.system(size: 10, weight: .bold)).frame(width: 24, height: 20) }
                    Spacer()
                }
                .buttonStyle(.plain)
                .background(Color.white.opacity(0.02))
            }
        }
    }
    
    private func recipeRow(_ recipe: OutputRecipe) -> some View {
        HStack(spacing: 8) {
            Toggle("", isOn: Binding(get: { recipe.isEnabled }, set: { recipe.isEnabled = $0 }))
                .toggleStyle(POCheckboxStyle())
            
            Text(recipe.name)
                .font(.system(size: 11))
                .foregroundColor(recipe.isEnabled ? .white : .gray)
            
            Spacer()
            
            Text(recipe.format.rawValue.uppercased())
                .font(.system(size: 9, weight: .bold))
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 8)
        .frame(height: 24)
        .background(Color.white.opacity(0.02))
    }
}
