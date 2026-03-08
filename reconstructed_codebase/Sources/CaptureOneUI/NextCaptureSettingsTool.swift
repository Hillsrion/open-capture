import SwiftUI
import AppCoreShared

/// Reconstructed Next Capture Naming and Adjustments tool (TETH-003).
public struct NextCaptureSettingsTool: View {
    @ObservedObject var camera: P1CaptureCore_Camera
    
    public init(camera: P1CaptureCore_Camera) {
        self.camera = camera
    }
    
    public var body: some View {
        VStack(spacing: 12) {
            // MARK: - Next Capture Naming
            VStack(alignment: .leading, spacing: 8) {
                Text("NEXT CAPTURE NAMING")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.gray)
                
                VStack(spacing: 4) {
                    TextField("Format", text: $camera.namingFormat)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.system(size: 11, design: .monospaced))
                    
                    HStack {
                        Text("Counter:")
                            .font(.system(size: 11))
                        TextField("", value: $camera.namingCounter, formatter: NumberFormatter())
                            .frame(width: 50)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Spacer()
                        Text("Sample: \(camera.nextCaptureName)")
                            .font(.system(size: 10).italic())
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(8)
            .background(Color.black.opacity(0.2))
            .cornerRadius(4)
            
            // MARK: - Next Capture Adjustments
            VStack(alignment: .leading, spacing: 8) {
                Text("NEXT CAPTURE ADJUSTMENTS")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.gray)
                
                Picker("Adjustments", selection: $camera.nextCaptureAdjustments) {
                    Text("Copy from Last").tag(P1CaptureCore_Camera.NextCaptureAdjustments.copyFromLast)
                    Text("Copy from Primary").tag(P1CaptureCore_Camera.NextCaptureAdjustments.copyFromPrimary)
                    Text("Neutral").tag(P1CaptureCore_Camera.NextCaptureAdjustments.neutral)
                }
                .pickerStyle(MenuPickerStyle())
                .font(.system(size: 11))
            }
            .padding(8)
            .background(Color.black.opacity(0.2))
            .cornerRadius(4)
        }
    }
}
