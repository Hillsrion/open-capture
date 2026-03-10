import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Export Content Credentials tool (WF-204).
/// Allows attaching C2PA standard metadata indicating AI use and creator identity.
public struct ExportContentCredentialsToolView: View {
    @State private var enableCredentials: Bool = true
    @State private var includeEdits: Bool = true
    @State private var indicateAIUse: Bool = true
    
    public init() {}
    
    public var body: some View {
        COToolSection("Content Credentials", toolID: "OutputContentCredentials") {
            VStack(alignment: .leading, spacing: 8) {
                Toggle("Enable Content Credentials", isOn: $enableCredentials)
                    .toggleStyle(POCheckboxStyle())
                    .font(.system(size: 11))
                
                if enableCredentials {
                    VStack(alignment: .leading, spacing: 6) {
                        Toggle("Include Edits and Activity", isOn: $includeEdits)
                            .toggleStyle(POCheckboxStyle())
                            .font(.system(size: 11))
                        
                        Toggle("Indicate AI usage", isOn: $indicateAIUse)
                            .toggleStyle(POCheckboxStyle())
                            .font(.system(size: 11))
                        
                        Text("Attaches a digital signature (C2PA) to the exported file to certify its origin and any AI processing used.")
                            .font(.system(size: 9))
                            .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                            .padding(.top, 4)
                    }
                    .padding(.leading, 18)
                    .padding(.top, 4)
                }
            }
            .padding(.vertical, 4)
        }
    }
}
