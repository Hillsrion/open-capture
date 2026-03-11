import SwiftUI
import Cocoa
import AppCoreShared

/// Reconstructed composite view for the Export Window (TD-601).
/// Wraps the discrete export tools into a scrollable stack.
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
        ScrollView {
            VStack(spacing: 1) {
                ExportRecipesToolView(recipeManager: recipeManager)
                ExportLocationToolView(recipeManager: recipeManager)
                ExportNamingToolView()
                ExportFormatToolView(recipeManager: recipeManager)
                ExportMetadataToolView()
                ExportWatermarkToolView()
                ExportContentCredentialsToolView()
                ExportQueueToolView(batchQueue: batchQueue)
                
                Spacer(minLength: 20)
                
                ProcessSummaryToolView()
                
                HStack(spacing: 8) {
                    Button(action: {
                        let path = recipeManager.activeRecipes.first?.outputFolder ?? "/Users/Shared/Capture One/Output"
                        NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: path)
                    }) {
                        Image(systemName: "folder")
                            .font(.system(size: 16))
                            .frame(height: 32)
                    }
                    .buttonStyle(.bordered)
                    .help("Instant Preview")

                    Button(action: {
                        guard let variant = selectedVariant else { return }
                        for recipe in recipeManager.activeRecipes {
                            let folder = URL(fileURLWithPath: recipe.outputFolder ?? "/Users/Shared/Capture One/Output")
                            batchQueue.addJob(variant: variant, recipe: recipe, outputFolder: folder)
                        }
                    }) {
                        Text("Export \(recipeManager.activeRecipes.count) Variants")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(CaptureOneTheme.Colors.activeHighlight)
                    .disabled(recipeManager.activeRecipes.isEmpty)
                }
                .padding(16)
            }
        }
        .background(CaptureOneTheme.Colors.panelBackground)
    }
}
