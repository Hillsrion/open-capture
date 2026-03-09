import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Export Format & Size tool (TD-601).
public struct ExportFormatToolView: View {
    @ObservedObject var recipeManager: OutputRecipeManager
    
    public init(recipeManager: OutputRecipeManager) {
        self.recipeManager = recipeManager
    }
    
    public var body: some View {
        COToolSection("Format & Size", toolID: "FormatAndSize") {
            VStack(alignment: .leading, spacing: 10) {
                if let activeRecipe = recipeManager.activeRecipes.first {
                    Group {
                        HStack {
                            Text("Format").font(.system(size: 11)).foregroundColor(.gray)
                            Spacer()
                            Text(activeRecipe.format.rawValue.uppercased())
                                .font(.system(size: 11, weight: .bold))
                        }
                        
                        if activeRecipe.format == .jpeg {
                            HStack {
                                Text("Quality").font(.system(size: 11)).foregroundColor(.gray)
                                Spacer()
                                Slider(value: .constant(80), in: 0...100)
                                    .accentColor(CaptureOneTheme.Colors.activeHighlight)
                                    .frame(width: 80)
                                Text("80")
                                    .font(.system(size: 11, design: .monospaced))
                                    .frame(width: 25, alignment: .trailing)
                            }
                        }
                        
                        HStack {
                            Text("ICC Profile").font(.system(size: 11)).foregroundColor(.gray)
                            Spacer()
                            Text(activeRecipe.iccProfile)
                                .font(.system(size: 11, weight: .medium))
                        }
                        
                        Divider().background(Color.white.opacity(0.05))
                        
                        HStack {
                            Text("Resolution").font(.system(size: 11)).foregroundColor(.gray)
                            Spacer()
                            TextField("300", text: .constant("300"))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 40)
                                .font(.system(size: 11, design: .monospaced))
                            Text("px/in").font(.system(size: 10)).foregroundColor(.gray)
                        }
                    }
                } else {
                    Text("Select a recipe to edit format settings.")
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 12)
                }
            }
            .padding(.vertical, 4)
        }
    }
}
