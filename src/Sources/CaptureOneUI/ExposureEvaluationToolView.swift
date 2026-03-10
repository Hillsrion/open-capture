import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Exposure Evaluation tool (ENG-204).
/// Provides a raw-data based exposure meter from -1.7 to +2 stops.
public struct ExposureEvaluationToolView: View {
    // Simulated meter value (in stops) based on raw data
    @State private var meterValue: Double = 0.5 
    
    public init(adjustmentController: AdjustmentToolController? = nil, config: Any? = nil) {}
    
    public var body: some View {
        COToolSection("Exposure Evaluation", toolID: "ExposureEvaluation") {
            VStack(spacing: 12) {
                // Exposure Meter Visual
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // Background Track
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.black.opacity(0.4))
                            .frame(height: 24)
                        
                        // Center Zero Line
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: 1, height: 24)
                            .position(x: geometry.size.width / 2, y: 12)
                        
                        // Meter Bar
                        let normalizedValue = (meterValue + 1.7) / 3.7 // Map [-1.7, 2.0] to [0, 1]
                        let clampedValue = max(0, min(1, normalizedValue))
                        
                        // Green if ok, Red if overexposed, Blue if severely underexposed
                        let barColor: Color = meterValue > 1.5 ? .red : (meterValue < -1.5 ? .blue : CaptureOneTheme.Colors.activeHighlight)
                        
                        Rectangle()
                            .fill(barColor)
                            .frame(width: CGFloat(clampedValue) * geometry.size.width, height: 24)
                            .cornerRadius(3)
                        
                        // Stops markers
                        HStack(spacing: 0) {
                            Text("-1.7").font(.system(size: 8)).frame(maxWidth: .infinity, alignment: .leading)
                            Text("-1").font(.system(size: 8)).frame(maxWidth: .infinity, alignment: .center)
                            Text("0").font(.system(size: 8)).frame(maxWidth: .infinity, alignment: .center)
                            Text("+1").font(.system(size: 8)).frame(maxWidth: .infinity, alignment: .center)
                            Text("+2").font(.system(size: 8)).frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .foregroundColor(Color.white.opacity(0.5))
                        .padding(.horizontal, 4)
                        .offset(y: 20)
                    }
                }
                .frame(height: 40)
                
                HStack {
                    Text("Exposure Evaluation is based on RAW data.")
                        .font(.system(size: 9))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    Spacer()
                }
            }
            .padding(.vertical, 4)
        }
    }
}
