import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Color Readouts tool (UI-204).
/// Provides up to 10 measurement points with multiple color space support.
public struct ColorReadoutsToolView: View {
    // Simulated readouts data
    struct ReadoutItem: Identifiable {
        let id = UUID()
        var name: String
        var value: String // Formatted string based on selected color space
    }
    
    @State private var readouts: [ReadoutItem] = [
        ReadoutItem(name: "Point 1", value: "245, 120, 80"),
        ReadoutItem(name: "Point 2", value: "12, 45, 200")
    ]
    @State private var colorSpaceMode: Int = 0 // 0: RGB, 1: Lab, 2: CMYK
    
    public init() {}
    
    public var body: some View {
        COToolSection("Readouts", toolID: "ColorReadouts") {
            VStack(spacing: 8) {
                HStack {
                    Text("Format")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    Spacer()
                    Picker("", selection: $colorSpaceMode) {
                        Text("RGB (0-255)").tag(0)
                        Text("Lab").tag(1)
                        Text("CMYK").tag(2)
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .frame(width: 120)
                }
                
                Divider().background(Color.white.opacity(0.1))
                
                ScrollView {
                    VStack(spacing: 2) {
                        if readouts.isEmpty {
                            Text("Click on image to add readouts (Max 10)")
                                .font(.system(size: 10))
                                .foregroundColor(.gray)
                                .padding(.top, 12)
                        } else {
                            ForEach($readouts) { $item in
                                HStack {
                                    TextField("", text: $item.name)
                                        .font(.system(size: 11))
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .frame(maxWidth: 80)
                                    
                                    Spacer()
                                    
                                    Text(item.value)
                                        .font(.system(size: 11, design: .monospaced))
                                    
                                    Button(action: {
                                        readouts.removeAll(where: { $0.id == item.id })
                                    }) {
                                        Image(systemName: "xmark")
                                            .font(.system(size: 8, weight: .bold))
                                            .foregroundColor(.gray)
                                    }
                                    .buttonStyle(.plain)
                                }
                                .padding(.horizontal, 6)
                                .padding(.vertical, 4)
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(4)
                            }
                        }
                    }
                }
                .frame(maxHeight: 120)
                
                HStack {
                    Spacer()
                    Button("Clear All") { readouts.removeAll() }
                        .font(.system(size: 10))
                        .buttonStyle(.plain)
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                }
            }
            .padding(.vertical, 4)
        }
    }
}
