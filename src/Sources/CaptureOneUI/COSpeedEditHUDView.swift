import SwiftUI
import AppCoreShared

/// Reconstructed Speed Edit HUD (UI-202).
/// Displays at the bottom-center of the Viewer during interaction.
public struct COSpeedEditHUDView: View {
    @ObservedObject var controller = COSpeedEditController.shared
    
    public init() {}
    
    public var body: some View {
        if controller.isInteracting, let action = controller.activeAction {
            VStack(spacing: 4) {
                Text(action.rawValue.uppercased())
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.gray)
                
                HStack(spacing: 8) {
                    Text(valueString(for: action))
                        .font(.system(size: 18, weight: .semibold, design: .monospaced))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.black.opacity(0.75))
            )
            .transition(.opacity.combined(with: .scale(scale: 0.95)))
            .animation(.easeOut(duration: 0.15), value: controller.isInteracting)
        }
    }
    
    private func valueString(for action: COSpeedEditController.SpeedEditAction) -> String {
        switch action {
        case .exposure:
            return String(format: "%+.2f", controller.currentValue)
        default:
            return String(format: "%.0f", controller.currentValue)
        }
    }
}
