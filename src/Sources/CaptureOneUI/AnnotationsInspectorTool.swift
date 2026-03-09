import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Annotations tool (UI-007).
/// Based on disassembly of AnnotationsInspectorTool.
public struct AnnotationsInspectorTool: View {
    @ObservedObject var variant: VariantBase
    @State private var includeInExport: Bool = true
    @State private var alwaysShow: Bool = false
    
    public init(variant: VariantBase) {
        self.variant = variant
    }
    
    public var body: some View {
        COToolSection("Annotations", toolID: "Annotations") {
            VStack(spacing: 10) {
                Toggle("Always Show Annotations", isOn: $alwaysShow)
                    .toggleStyle(POCheckboxStyle())
                    .font(.system(size: 11))
                
                Toggle("Include Annotations in Export", isOn: $includeInExport)
                    .toggleStyle(POCheckboxStyle())
                    .font(.system(size: 11))
                
                Divider().background(Color.white.opacity(0.1))
                
                Button(action: {
                    variant.annotations.lines = []
                    variant.annotations.notes = []
                    variant.isModified = true
                }) {
                    Text("Clear Annotations")
                        .font(.system(size: 11, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .padding(6)
                        .background(Color.red.opacity(0.3))
                        .cornerRadius(4)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}
