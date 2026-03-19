import SwiftUI
import AppCoreShared

public struct RetouchEyesToolView: View {
    @ObservedObject var controller: AdjustmentToolController
    @State private var selectedEye: Int = 0 // 0: Left, 1: Right
    
    public init(controller: AdjustmentToolController) {
        self.controller = controller
    }
    
    public var body: some View {
        COToolSection("Retouch Eyes", toolID: "RetouchEyes") {
            VStack(alignment: .leading, spacing: 12) {
                Picker("", selection: $selectedEye) {
                    Text("Left").tag(0)
                    Text("Right").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .labelsHidden()
                
                if selectedEye == 0 {
                    retouchSlider(label: "Impact", value: $controller.retouchEyesLeftImpact, range: 0...100)
                } else {
                    retouchSlider(label: "Impact", value: $controller.retouchEyesRightImpact, range: 0...100)
                }
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
