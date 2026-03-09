import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Smart Adjustments tool (UI-014/AI-002).
public struct SmartAdjustmentsToolView: View {
    @ObservedObject var controller: AdjustmentToolController
    
    public init(controller: AdjustmentToolController) {
        self.controller = controller
    }
    
    public var body: some View {
        COToolSection("Smart Adjustments") {
            VStack(spacing: 12) {
                // 1. Reference Status
                HStack {
                    if let _ = controller.smartReference {
                        Label("Reference Set", systemImage: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    } else {
                        Label("No Reference", systemImage: "info.circle")
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Button("Set Reference") {
                        controller.setSmartReference()
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(4)
                }
                .font(.system(size: 11))
                
                // 2. Options
                VStack(alignment: .leading, spacing: 8) {
                    Toggle("Exposure", isOn: $controller.smartExposureEnabled)
                        .toggleStyle(POCheckboxStyle())
                    Toggle("White Balance", isOn: $controller.smartWhiteBalanceEnabled)
                        .toggleStyle(POCheckboxStyle())
                }
                .font(.system(size: 11))
                
                // 3. Apply Button
                Button(action: {
                    // Simulation: Apply to all selected variants
                    // For now, we apply to current if available
                    if let current = controller.currentVariant {
                        controller.applySmartAdjustments(to: [current])
                    }
                }) {
                    Text("APPLY")
                        .font(.system(size: 12, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(controller.smartReference != nil ? CaptureOneTheme.Colors.activeHighlight : Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(4)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(controller.smartReference == nil)
                
                Text("Match the look of your reference image based on faces or other features.")
                    .font(.system(size: 9))
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
