import SwiftUI
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
                
                Button(action: {
                    // Logic to trigger batch export
                }) {
                    Text("Export \(recipeManager.activeRecipes.count) Variants")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.borderedProminent)
                .tint(CaptureOneTheme.Colors.activeHighlight)
                .padding(16)
                .disabled(recipeManager.activeRecipes.isEmpty)
            }
        }
        .background(CaptureOneTheme.Colors.panelBackground)
    }
}
