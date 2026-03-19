import SwiftUI
import AppCoreShared

public struct EvenSkinToolView: View {
    @ObservedObject var controller: AdjustmentToolController
    
    public init(controller: AdjustmentToolController) {
        self.controller = controller
    }
    
    public var body: some View {
        COToolSection("Even Skin", toolID: "EvenSkin") {
            VStack(spacing: 8) {
                retouchSlider(label: "Amount", value: $controller.evenSkinAmount, range: 0...100)
                retouchSlider(label: "Texture", value: $controller.evenSkinTexture, range: 0...100)
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
