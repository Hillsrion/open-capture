import SwiftUI
import AppCoreShared

/// Reconstructed Negative Film tool (UI-202).
/// Supports inversion and base-tint correction for B&W and Color negatives.
public struct NegativeFilmToolView: View {
    @ObservedObject var controller: AdjustmentToolController
    
    public init(controller: AdjustmentToolController) {
        self.controller = controller
    }
    
    public var body: some View {
        COToolSection("Negative Film", toolID: "NegativeFilm") {
            VStack(spacing: 8) {
                Toggle("Enable", isOn: $controller.negativeFilmEnabled)
                    .font(.system(size: 11))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if controller.negativeFilmEnabled {
                    Divider().background(Color.white.opacity(0.05))
                    
                    HStack {
                        Text("Film Type")
                            .font(.system(size: 11))
                            .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                        Spacer()
                        Picker("", selection: $controller.negativeFilmType) {
                            Text("B&W").tag(0)
                            Text("Color Negative").tag(1)
                        }
                        .labelsHidden()
                        .controlSize(.small)
                        .frame(width: 120)
                    }
                    
                    Button(action: { /* Logic to enter film-edge picking mode */ }) {
                        HStack {
                            Image(systemName: "eyedropper")
                            Text("Pick White Balance (Film Edge)")
                        }
                        .font(.system(size: 11, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(4)
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 4)
                }
            }
            .padding(.vertical, 4)
        }
    }
}
