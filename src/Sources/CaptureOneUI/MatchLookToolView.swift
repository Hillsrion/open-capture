import SwiftUI
import AppCoreShared

/// Reconstructed Match Look tool (AI-204).
/// Transfers stylistic "DNA" from reference images using AI.
public struct MatchLookToolView: View {
    @ObservedObject var controller: COMatchLookController = .shared
    @ObservedObject var appCommands = AppCommandCenter.shared
    
    public init(controller: AdjustmentToolController) {
        // Keeping the init signature for ToolRegistry compatibility
    }
    
    public var body: some View {
        COToolSection("Match Look", toolID: "MatchLook") {
            VStack(alignment: .leading, spacing: 12) {
                Text("Transfer the look of a reference image to your selection.")
                    .font(.system(size: 10))
                    .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                
                // Reference Zone
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.white.opacity(0.1), style: StrokeStyle(lineWidth: 1, dash: [4]))
                        .background(Color.black.opacity(0.2))
                    
                    if let ref = controller.referenceVariant {
                        VStack(spacing: 4) {
                            Image(systemName: "photo.fill")
                                .font(.system(size: 20))
                                .foregroundColor(CaptureOneTheme.Colors.activeHighlight)
                            Text(ref.name ?? "Reference Set")
                                .font(.system(size: 10, weight: .bold))
                        }
                    } else {
                        VStack(spacing: 8) {
                            Image(systemName: "plus.viewfinder")
                                .font(.system(size: 24))
                                .foregroundColor(.gray)
                            
                            Button("Use Selected Variant") {
                                controller.setSelectionAsReference()
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                        }
                    }
                }
                .frame(height: 100)
                
                if controller.referenceVariant != nil {
                    VStack(spacing: 10) {
                        HStack {
                            Text("Impact")
                                .font(.system(size: 11))
                            Slider(value: $controller.impact, in: 0...100)
                                .accentColor(CaptureOneTheme.Colors.activeHighlight)
                            Text("\(Int(controller.impact))%")
                                .font(.system(size: 10, design: .monospaced))
                                .frame(width: 35, alignment: .trailing)
                        }
                        
                        HStack(spacing: 8) {
                            Button(action: { 
                                // Apply to current browser selection
                                // Note: In a full implementation, we'd access the interactor's selection
                                print("[MatchLook] Applying to selection...")
                                controller.isProcessing = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    controller.isProcessing = false
                                }
                            }) {
                                if controller.isProcessing {
                                    ProgressView().controlSize(.small)
                                } else {
                                    Text("Apply")
                                        .frame(maxWidth: .infinity)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 4)
                            .background(CaptureOneTheme.Colors.activeHighlight)
                            .foregroundColor(.black)
                            .cornerRadius(4)
                            .buttonStyle(.plain)
                            .disabled(controller.isProcessing)
                            
                            Button(action: { 
                                controller.clearReference()
                            }) {
                                Image(systemName: "trash")
                                    .padding(4)
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(4)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
}
