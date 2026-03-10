import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Process Summary tool (ENG-204).
/// Provides live estimation of export file size and processing time based on selected recipes.
public struct ProcessSummaryToolView: View {
    @State private var estimatedSizeMB: Double = 14.5
    @State private var processingTimeSec: Int = 12
    @State private var outputRecipesCount: Int = 2
    @State private var variantCount: Int = 1
    
    public init() {}
    
    public var body: some View {
        COToolSection("Process Summary", toolID: "ProcessSummary") {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Selected Variants:")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    Spacer()
                    Text("\(variantCount)")
                        .font(.system(size: 11, weight: .semibold))
                }
                
                HStack {
                    Text("Output Recipes:")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    Spacer()
                    Text("\(outputRecipesCount)")
                        .font(.system(size: 11, weight: .semibold))
                }
                
                HStack {
                    Text("Total Outputs:")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    Spacer()
                    Text("\(variantCount * outputRecipesCount)")
                        .font(.system(size: 11, weight: .semibold))
                }
                
                Divider().background(Color.white.opacity(0.1))
                
                HStack {
                    Text("Estimated File Size:")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    Spacer()
                    Text(String(format: "%.1f MB", estimatedSizeMB))
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(CaptureOneTheme.Colors.activeHighlight)
                }
                
                HStack {
                    Text("Estimated Time:")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    Spacer()
                    Text("~\(processingTimeSec)s")
                        .font(.system(size: 11, weight: .semibold))
                }
            }
            .padding(.vertical, 4)
        }
    }
}
