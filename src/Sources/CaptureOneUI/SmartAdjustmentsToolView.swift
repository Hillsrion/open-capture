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
                
                // Reference Section
                HStack(alignment: .top, spacing: 8) {
                    if let refID = controller.smartReferenceVariantID {
                        ReferenceThumbnailView(variantID: refID)
                            .frame(width: 60, height: 60)
                            .cornerRadius(4)
                            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.white.opacity(0.1), lineWidth: 0.5))
                    } else {
                        Rectangle()
                            .fill(Color.black.opacity(0.2))
                            .frame(width: 60, height: 60)
                            .cornerRadius(4)
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Reference Image")
                            .font(.system(size: 11, weight: .bold))
                        
                        Button(action: {
                            controller.setSmartReference()
                        }) {
                            Text(controller.smartReferenceVariantID == nil ? "Set as Reference" : "Update Reference")
                                .font(.system(size: 10))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(4)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 4)

                VStack(spacing: 8) {
                    Toggle("Exposure", isOn: $controller.smartExposureEnabled)
                    Toggle("White Balance", isOn: $controller.smartWhiteBalanceEnabled)
                }
                .font(.system(size: 11))
                
                Divider().background(Color.white.opacity(0.05))
                
                Button(action: {
                    // For prototype, apply to current selection or active variant
                    if let variant = controller.currentVariant {
                        controller.applySmartAdjustments(to: [variant])
                    }
                }) {
                    HStack {
                        Image(systemName: "sparkles")
                        Text("Apply")
                    }
                    .font(.system(size: 11, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 32)
                    .background(controller.smartReference != nil ? CaptureOneTheme.Colors.activeHighlight : Color.white.opacity(0.05))
                    .foregroundColor(controller.smartReference != nil ? .black : .gray)
                    .cornerRadius(4)
                }
                .buttonStyle(.plain)
                .disabled(controller.smartReference == nil)
                
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

private struct ReferenceThumbnailView: View {
    let variantID: String
    @State private var thumbnail: NSImage? = nil
    
    var body: some View {
        ZStack {
            if let thumbnail = thumbnail {
                Image(nsImage: thumbnail)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Color.black.opacity(0.3)
            }
        }
        .onAppear(perform: loadThumbnail)
        .onChange(of: variantID) { _ in loadThumbnail() }
    }
    
    private func loadThumbnail() {
        // Simple mock: in a real app we'd find the VariantBase by ID
        // For the lab, we'll try to get the current variant's path if it matches the ID
        if let current = AdjustmentToolController.shared.currentVariant, current.id == variantID {
            if let path = current.image?.path {
                ThumbnailManager.shared.requestThumbnail(for: path, size: CGSize(width: 120, height: 120)) { img in
                    self.thumbnail = img
                }
            }
        }
    }
}
