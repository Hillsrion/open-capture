import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Cross Recipe Tokens tool (LOGIC-204).
/// Allows global definition of Subfolder and Job Name tokens across all export recipes.
public struct CrossRecipeTokensToolView: View {
    @State private var jobName: String = "Wedding_Shoot_01"
    @State private var subfolderName: String = "Selects"
    
    public init() {}
    
    public var body: some View {
        COToolSection("Cross Recipe Tokens", toolID: "OutputCrossRecipeTokens") {
            VStack(alignment: .leading, spacing: 10) {
                Text("Define values for tokens used across multiple recipes.")
                    .font(.system(size: 10))
                    .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                
                VStack(spacing: 8) {
                    HStack {
                        Text("Job Name")
                            .font(.system(size: 11))
                            .foregroundColor(.gray)
                            .frame(width: 70, alignment: .leading)
                        
                        TextField("", text: $jobName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.system(size: 11))
                    }
                    
                    HStack {
                        Text("Sub Name")
                            .font(.system(size: 11))
                            .foregroundColor(.gray)
                            .frame(width: 70, alignment: .leading)
                        
                        TextField("", text: $subfolderName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.system(size: 11))
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
}
