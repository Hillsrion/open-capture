import SwiftUI
import AppCoreShared

/// Reconstructed Base Characteristics tool (UI-204).
/// Manages ICC Profiles, Tone Curves, and Process Engines.
public struct BaseCharacteristicsToolView: View {
    @ObservedObject var controller: AdjustmentToolController
    
    public init(controller: AdjustmentToolController) {
        self.controller = controller
    }
    
    public var body: some View {
        COToolSection("Base Characteristics", toolID: "BaseCharacteristics") {
            VStack(alignment: .leading, spacing: 10) {
                // ICC Profile Row
                VStack(alignment: .leading, spacing: 4) {
                    Text("ICC Profile")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    
                    HStack {
                        Menu {
                            Section("Camera") {
                                Button("Fujifilm X-T5 Generic") { controller.iccProfile = "Fujifilm X-T5 Generic" }
                                Button("Fujifilm X-T5 ProStandard") { 
                                    controller.iccProfile = "Fujifilm X-T5 ProStandard"
                                    controller.isProStandard = true
                                }
                            }
                            Section("Standard") {
                                Button("Generic RGB Profile") { controller.iccProfile = "Generic RGB" }
                                Button("Adobe RGB (1998)") { controller.iccProfile = "Adobe RGB" }
                                Button("sRGB Color Space Profile") { controller.iccProfile = "sRGB" }
                            }
                            Divider()
                            Button("Show All Profiles...") { }
                        } label: {
                            HStack {
                                Text(controller.iccProfile)
                                    .font(.system(size: 11))
                                Spacer()
                                Image(systemName: "chevron.up.vertical")
                                    .font(.system(size: 8))
                            }
                            .padding(.horizontal, 8)
                            .frame(height: 22)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(4)
                        }
                        .menuStyle(.plain)
                        
                        if controller.isProStandard {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 10))
                                .foregroundColor(CaptureOneTheme.Colors.activeHighlight)
                                .help("ProStandard Profile")
                        }
                    }
                }
                
                // Curve Row
                VStack(alignment: .leading, spacing: 4) {
                    Text("Curve")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    
                    Menu {
                        Button("Auto") { controller.toneCurve = "Auto" }
                        Divider()
                        Button("Film Extra Shadow") { controller.toneCurve = "Film Extra Shadow" }
                        Button("Film High Contrast") { controller.toneCurve = "Film High Contrast" }
                        Button("Film Standard") { controller.toneCurve = "Film Standard" }
                        Button("Linear Response") { controller.toneCurve = "Linear Response" }
                    } label: {
                        HStack {
                            Text(controller.toneCurve)
                                .font(.system(size: 11))
                            Spacer()
                            Image(systemName: "chevron.up.vertical")
                                .font(.system(size: 8))
                        }
                        .padding(.horizontal, 8)
                        .frame(height: 22)
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(4)
                    }
                    .menuStyle(.plain)
                }
                
                Divider().background(Color.white.opacity(0.05))
                
                // Engine Row
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Engine")
                            .font(.system(size: 11))
                            .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                        Text(controller.engineVersion)
                            .font(.system(size: 10, weight: .bold))
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Upgrade engine logic
                    }) {
                        Text("Upgrade")
                            .font(.system(size: 10, weight: .bold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(CaptureOneTheme.Colors.activeHighlight.opacity(0.2))
                            .foregroundColor(CaptureOneTheme.Colors.activeHighlight)
                            .cornerRadius(4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(CaptureOneTheme.Colors.activeHighlight.opacity(0.5), lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 4)
        }
    }
}
