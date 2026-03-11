import SwiftUI
import AppCoreShared

/// Reconstructed Smart Adjustments tool (AI-204).
/// Achieves consistency across images by matching Exposure and White Balance.
public struct SmartAdjustmentsToolView: View {
    @ObservedObject var controller: AdjustmentToolController
    
    public init(controller: AdjustmentToolController) {
        self.controller = controller
    }
    
    public var body: some View {
        COToolSection("Smart Adjustments", toolID: "SmartAdjustments") {
            VStack(alignment: .leading, spacing: 12) {
                Text("Achieve consistency across your selection based on a reference.")
                    .font(.system(size: 10))
                    .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                
                VStack(spacing: 8) {
                    Toggle("Exposure", isOn: $controller.smartExposureEnabled)
                    Toggle("White Balance", isOn: $controller.smartWhiteBalanceEnabled)
                }
                .font(.system(size: 11))
                
                Divider().background(Color.white.opacity(0.05))
                
                HStack(spacing: 8) {
                    Button(action: {
                        controller.setSmartReference()
                    }) {
                        VStack(spacing: 2) {
                            Image(systemName: "pin.circle.fill")
                                .font(.system(size: 14))
                            Text("Set Reference")
                                .font(.system(size: 9))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(controller.smartReference != nil ? CaptureOneTheme.Colors.activeHighlight : Color.white.opacity(0.05))
                        .cornerRadius(4)
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: {
                        // For prototype, apply to current selection or active variant
                        if let variant = controller.currentVariant {
                            controller.applySmartAdjustments(to: [variant])
                        }
                    }) {
                        VStack(spacing: 2) {
                            Image(systemName: "wand.and.stars")
                                .font(.system(size: 14))
                            Text("Apply")
                                .font(.system(size: 9))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(CaptureOneTheme.Colors.activeHighlight)
                        .foregroundColor(.black)
                        .cornerRadius(4)
                    }
                    .buttonStyle(.plain)
                    .disabled(controller.smartReference == nil)
                }
                
                HStack {
                    Image(systemName: "face.smiling.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                    Text("AI face prioritization active")
                        .font(.system(size: 9))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                }
                .padding(.top, 4)
            }
            .padding(.vertical, 4)
        }
    }
}
