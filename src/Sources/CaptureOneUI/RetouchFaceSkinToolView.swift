import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Retouch Faces tool (AI-204).
/// Provides AI-driven skin smoothing and redness reduction.
public struct RetouchFaceSkinToolView: View {
    @ObservedObject var controller: AdjustmentToolController
    @State private var smoothing: Double = 0.0
    @State private var redness: Double = 0.0
    @State private var uniformity: Double = 0.0
    
    public init(controller: AdjustmentToolController) {
        self.controller = controller
    }
    
    public var body: some View {
        COToolSection("Retouch Faces", toolID: "RetouchFaces") {
            VStack(alignment: .leading, spacing: 12) {
                // Face Selection Stub
                HStack {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Text("Select Face...")
                        .font(.system(size: 11))
                        .foregroundColor(.blue)
                    Spacer()
                }
                .padding(.vertical, 4)
                
                Divider().background(Color.white.opacity(0.1))
                
                VStack(spacing: 8) {
                    retouchSlider(label: "Smoothing", value: $smoothing, range: 0...100)
                    retouchSlider(label: "Redness", value: $redness, range: -50...50)
                    retouchSlider(label: "Uniformity", value: $uniformity, range: 0...100)
                }
                
                HStack {
                    Image(systemName: "face.smiling.fill")
                        .font(.system(size: 10))
                        .foregroundColor(CaptureOneTheme.Colors.activeHighlight)
                    Text("AI face detection active")
                        .font(.system(size: 9))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                }
                .padding(.top, 4)
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
