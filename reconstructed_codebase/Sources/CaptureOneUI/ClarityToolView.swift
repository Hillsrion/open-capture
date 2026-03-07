import SwiftUI
import AppCoreShared

/// Reconstructed Clarity & Structure Tool.
/// Manages Clarity amount, method (Classic, Punch, Neutral, Natural) and Structure.
public struct ClarityToolView: View {
    @Binding var amount: Float
    @Binding var structure: Float
    @Binding var method: Int // 0: Classic, 1: Punch, 2: Neutral, 3: Natural
    
    public init(amount: Binding<Float>, structure: Binding<Float>, method: Binding<Int>) {
        self._amount = amount
        self._structure = structure
        self._method = method
    }
    
    public var body: some View {
        COToolSection("Clarity") {
            VStack(spacing: 8) {
                // Method Selector
                Picker("Method", selection: $method) {
                    Text("Classic").tag(0)
                    Text("Punch").tag(1)
                    Text("Neutral").tag(2)
                    Text("Natural").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
                .labelsHidden()
                
                // Sliders
                POSliderControl(label: "Clarity", value: $amount, range: -100...100)
                POSliderControl(label: "Structure", value: $structure, range: -100...100)
            }
        }
    }
}
