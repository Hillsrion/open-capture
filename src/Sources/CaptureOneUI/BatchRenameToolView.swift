import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Batch Rename tool (UI-204).
public struct BatchRenameToolView: View {
    @State private var method: Int = 0 // 0: Text and Tokens, 1: Find and Replace
    @State private var formatText: String = "[Image Name]_[Sequence ID]"
    @State private var findText: String = ""
    @State private var replaceText: String = ""
    @ObservedObject var batchQueue = BatchQueue() // Simplified
    
    public init() {}
    
    public var body: some View {
        COToolSection("Batch Rename", toolID: "BatchRename") {
            VStack(alignment: .leading, spacing: 10) {
                // Method Picker
                VStack(alignment: .leading, spacing: 4) {
                    Text("Method").font(.system(size: 11)).foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    Picker("", selection: $method) {
                        Text("Text and Tokens").tag(0)
                        Text("Find and Replace").tag(1)
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                }
                
                if method == 0 {
                    // Text and Tokens
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Format").font(.system(size: 11)).foregroundColor(CaptureOneTheme.Colors.textSecondary)
                        HStack {
                            TextField("", text: $formatText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .font(.system(size: 11, design: .monospaced))
                            Button(action: {
                                // Open Token Selector Modal
                            }) {
                                Image(systemName: "ellipsis")
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                } else {
                    // Find and Replace
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Find").font(.system(size: 11)).foregroundColor(CaptureOneTheme.Colors.textSecondary).frame(width: 50, alignment: .leading)
                            TextField("", text: $findText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .font(.system(size: 11))
                        }
                        HStack {
                            Text("Replace").font(.system(size: 11)).foregroundColor(CaptureOneTheme.Colors.textSecondary).frame(width: 50, alignment: .leading)
                            TextField("", text: $replaceText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .font(.system(size: 11))
                        }
                    }
                }
                
                Divider().background(Color.white.opacity(0.05))
                
                // Sample Preview
                VStack(alignment: .leading, spacing: 2) {
                    Text("Example:").font(.system(size: 10)).foregroundColor(.gray)
                    Text(generateSampleName())
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Button(action: {
                    // Execute rename logic
                    print("[BatchRename] Executing rename with method \(method)")
                }) {
                    Text("Rename")
                        .font(.system(size: 11, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 4)
                        .background(CaptureOneTheme.Colors.activeHighlight)
                        .foregroundColor(.black)
                        .cornerRadius(4)
                }
                .buttonStyle(.plain)
                .padding(.top, 4)
            }
            .padding(.vertical, 4)
        }
    }
    
    private func generateSampleName() -> String {
        if method == 0 {
            var sample = formatText
            sample = sample.replacingOccurrences(of: "[Image Name]", with: "DSC0042")
            sample = sample.replacingOccurrences(of: "[Sequence ID]", with: "001")
            return sample + ".ARW"
        } else {
            if findText.isEmpty { return "DSC0042.ARW" }
            return "DSC0042".replacingOccurrences(of: findText, with: replaceText) + ".ARW"
        }
    }
}
