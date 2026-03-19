import SwiftUI
import AppCoreShared

public struct BlemishRemovalToolView: View {
    @ObservedObject var controller: AdjustmentToolController
    
    public init(controller: AdjustmentToolController) {
        self.controller = controller
    }
    
    public var body: some View {
        COToolSection("Blemish Removal", toolID: "BlemishRemoval") {
            VStack(alignment: .leading, spacing: 12) {
                retouchSlider(label: "Blemishes", value: $controller.blemishAmount, range: 0...100)
                
                Button(action: {
                    // Action for marking areas to protect
                }) {
                    HStack {
                        Image(systemName: "shield.fill")
                        Text("Mark areas to protect")
                    }
                    .font(.system(size: 11))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(4)
                }
                .buttonStyle(PlainButtonStyle())
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
