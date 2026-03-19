import SwiftUI
import AppCoreShared

public struct RetouchTeethToolView: View {
    @ObservedObject var controller: AdjustmentToolController
    
    public init(controller: AdjustmentToolController) {
        self.controller = controller
    }
    
    public var body: some View {
        COToolSection("Retouch Teeth", toolID: "RetouchTeeth") {
            VStack(spacing: 8) {
                retouchSlider(label: "Impact", value: $controller.retouchTeethImpact, range: 0...100)
            }
            .padding(.vertical, 4)
        }
    }
    
    private func retouchSlider(label: String, value: Binding<Double>, range: ClosedRange<Double>) -> some View {
        HStack {
            Text(label).font(.system(size: 11)).foregroundColor(.gray).frame(width: 65, alignment: .leading)
            Slider(value: value, in: range)
                .accentColor(CaptureOneTheme.Colors.activeHighlight)
            Text("\(Int(value.wrappedValue))").font(.system(size: 10, design: .monospaced)).frame(width: 30, alignment: .trailing)
        }
    }
}
