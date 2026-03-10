import SwiftUI
import AppCoreShared

/// Reconstructed High Dynamic Range tool (UI-204).
/// Optimizes highlights, shadows, whites, and blacks with intelligent tonal remapping.
public struct HDRToolView: View {
    @Binding var highlights: Float
    @Binding var shadows: Float
    @Binding var whites: Float
    @Binding var blacks: Float
    
    public init(highlights: Binding<Float>, shadows: Binding<Float>, whites: Binding<Float>, blacks: Binding<Float>) {
        self._highlights = highlights
        self._shadows = shadows
        self._whites = whites
        self._blacks = blacks
    }
    
    public var body: some View {
        COToolSection("High Dynamic Range", toolID: "ShadowHighlight") {
            VStack(spacing: 8) {
                hdrSlider(label: "Highlights", value: $highlights, range: -100...100)
                hdrSlider(label: "Shadows", value: $shadows, range: -100...100)
                hdrSlider(label: "Whites", value: $whites, range: -100...100)
                hdrSlider(label: "Blacks", value: $blacks, range: -100...100)
                
                HStack {
                    Spacer()
                    Button(action: {
                        // Auto HDR logic
                    }) {
                        Image(systemName: "a.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(CaptureOneTheme.Colors.activeHighlight)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, 4)
            }
            .padding(.vertical, 4)
        }
    }
    
    private func hdrSlider(label: String, value: Binding<Float>, range: ClosedRange<Float>) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                .frame(width: 65, alignment: .leading)
            Slider(value: value, in: range)
                .accentColor(CaptureOneTheme.Colors.activeHighlight)
            Text("\(Int(value.wrappedValue))")
                .font(.system(size: 10, design: .monospaced))
                .frame(width: 30, alignment: .trailing)
        }
    }
}
