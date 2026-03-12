import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Batch Rename tool (UI-204).
/// Aligned with Capture One 16.7 visual standards.
public struct BatchRenameToolView: View {
    @State private var method: Int = 0 // 0: Text and Tokens, 1: Find and Replace
    @State private var formatText: String = "[Image Name]_[Sequence ID]"
    @State private var findText: String = ""
    @State private var replaceText: String = ""
    @State private var sequenceID: Int = 1
    @State private var sequenceIncrement: Int = 1
    @State private var showSequenceSettings: Bool = false
    
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
                        HStack {
                            Text("Format").font(.system(size: 11)).foregroundColor(CaptureOneTheme.Colors.textSecondary)
                            Spacer()
                            // Sequence Settings Gear (Fidelity FIX)
                            Button(action: { showSequenceSettings.toggle() }) {
                                Image(systemName: "gearshape.fill")
                                    .font(.system(size: 10))
                                    .foregroundColor(showSequenceSettings ? CaptureOneTheme.Colors.activeHighlight : .gray)
                            }
                            .buttonStyle(.plain)
                            .popover(isPresented: $showSequenceSettings) {
                                sequenceSettingsPopover
                            }
                        }
                        
                        HStack(spacing: 0) {
                            TextField("", text: $formatText)
                                .textFieldStyle(PlainTextFieldStyle())
                                .font(.system(size: 11, design: .monospaced))
                                .padding(4)
                                .background(Color.black.opacity(0.2))
                                .overlay(Rectangle().stroke(Color.white.opacity(0.1), lineWidth: 0.5))
                            
                            // Compact Token Button (Fidelity FIX)
                            Button(action: {
                                // Open Token Selector Modal
                            }) {
                                Text("...")
                                    .font(.system(size: 12, weight: .bold))
                                    .frame(width: 24, height: 21)
                                    .background(Color.white.opacity(0.1))
                                    .overlay(Rectangle().stroke(Color.white.opacity(0.1), lineWidth: 0.5))
                            }
                            .buttonStyle(.plain)
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
                    let tokens = CaptureNamingFormatter.parse(formatString: formatText)
                    let browser = AppCommandCenter.shared.browser
                    
                    var currentCounter = sequenceID
                    for image in browser.dataSource {
                        if let variant = image.primaryVariant {
                            CaptureNamingFormatter.renameVariant(variant, tokens: tokens, counter: currentCounter)
                            currentCounter += sequenceIncrement
                        }
                    }
                    print("[BatchRename] Executed rename with method \(method) on \(browser.dataSource.count) items")
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
    
    private var sequenceSettingsPopover: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Sequence Settings").font(.headline)
            Stepper("Start at: \(sequenceID)", value: $sequenceID, in: 0...99999)
            Stepper("Increment: \(sequenceIncrement)", value: $sequenceIncrement, in: 1...100)
            Button("Reset Counter") { sequenceID = 1 }
                .buttonStyle(.bordered)
        }
        .padding()
        .frame(width: 200)
    }
    
    private func generateSampleName() -> String {
        if method == 0 {
            var sample = formatText
            sample = sample.replacingOccurrences(of: "[Image Name]", with: "DSC0042")
            // Use current sequenceID for preview
            let sequenceStr = String(format: "%03d", sequenceID)
            sample = sample.replacingOccurrences(of: "[Sequence ID]", with: sequenceStr)
            return sample + ".ARW"
        } else {
            if findText.isEmpty { return "DSC0042.ARW" }
            return "DSC0042".replacingOccurrences(of: findText, with: replaceText) + ".ARW"
        }
    }
}
