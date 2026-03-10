import SwiftUI
import AppCoreShared

/// Reconstructed Match Look tool (AI-204).
/// Transfers stylistic "DNA" from reference images using AI.
public struct MatchLookToolView: View {
    @ObservedObject var controller: AdjustmentToolController
    @State private var impact: Float = 100.0
    @State private var isReferenceSet: Bool = false
    
    public init(controller: AdjustmentToolController) {
        self.controller = controller
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
                    
                    if controller.matchLookReferenceVariantID != nil, isReferenceSet {
                        VStack(spacing: 4) {
                            Image(systemName: "photo.fill")
                                .font(.system(size: 20))
                                .foregroundColor(CaptureOneTheme.Colors.activeHighlight)
                            Text("Reference Set")
                                .font(.system(size: 10, weight: .bold))
                        }
                    } else {
                        VStack(spacing: 8) {
                            Image(systemName: "plus.viewfinder")
                                .font(.system(size: 24))
                                .foregroundColor(.gray)
                            
                            Button("Use Selected Variant") {
                                // Logic to set reference
                                isReferenceSet = true
                                controller.matchLookReferenceVariantID = "ref_001" 
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                        }
                    }
                }
                .frame(height: 100)
                .onDrop(of: ["public.file-url"], isTargeted: nil) { providers in
                    // Drag & Drop logic from Finder/Explorer
                    return true
                }
                
                if isReferenceSet {
                    VStack(spacing: 10) {
                        HStack {
                            Text("Impact")
                                .font(.system(size: 11))
                            Slider(value: $controller.matchLookImpact, in: 0...100)
                                .accentColor(CaptureOneTheme.Colors.activeHighlight)
                            Text("\(Int(controller.matchLookImpact))%")
                                .font(.system(size: 10, design: .monospaced))
                                .frame(width: 35, alignment: .trailing)
                        }
                        
                        HStack(spacing: 8) {
                            Button(action: { /* Apply logic */ }) {
                                Text("Apply")
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 4)
                                    .background(CaptureOneTheme.Colors.activeHighlight)
                                    .foregroundColor(.black)
                                    .cornerRadius(4)
                            }
                            .buttonStyle(.plain)
                            
                            Button(action: { 
                                isReferenceSet = false
                                controller.matchLookReferenceVariantID = nil
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
