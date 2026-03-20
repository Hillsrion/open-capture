import SwiftUI
import AppCoreShared

/// Reconstructed Clarity & Structure Tool.
/// Manages Clarity amount, method (Natural, Punch, Neutral, Classic) and Structure.
public struct ClarityToolView: View {
    @ObservedObject var controller: COClarityToolController
    
    public init(controller: COClarityToolController) {
        self.controller = controller
    }
    
    public var body: some View {
        COToolSection("Clarity", toolID: "Clarity") {
            VStack(spacing: 12) {
                // Method Selector
                HStack {
                    Text("Method")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    Spacer()
                    Picker("", selection: Binding(
                        get: { controller.method },
                        set: { controller.method = $0 }
                    )) {
                        Text("Natural").tag(3)
                        Text("Punch").tag(1)
                        Text("Neutral").tag(2)
                        Text("Classic").tag(0)
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .frame(width: 100)
                }
                
                Divider()
                    .background(Color.white.opacity(0.1))
                    .padding(.horizontal, -8)
                
                // Clarity Slider
                VStack(spacing: 4) {
                    COToolValueSlider(
                        label: "Clarity", 
                        value: Binding(
                            get: { controller.amount },
                            set: { controller.amount = $0 }
                        ), 
                        range: -100...100, 
                        decimalPlaces: 0
                    )
                }
                
                // Fine visual separation between Clarity and Structure
                Rectangle()
                    .fill(Color.white.opacity(0.05))
                    .frame(height: 1)
                    .padding(.horizontal, 4)
                
                // Structure Slider
                VStack(spacing: 4) {
                    COToolValueSlider(
                        label: "Structure", 
                        value: Binding(
                            get: { controller.structure },
                            set: { controller.structure = $0 }
                        ), 
                        range: -100...100, 
                        decimalPlaces: 0
                    )
                }
            }
            .padding(.vertical, 6)
        }
    }
}
