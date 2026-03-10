import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Export Naming tool (LOGIC-204).
/// Supports dynamic token-based naming (pill UI).
public struct ExportNamingToolView: View {
    @State private var format: String = "[Image Name]"
    
    // Parsed representation for Token Pills
    private var parsedTokens: [CaptureNamingToken] {
        CaptureNamingFormatter.parse(formatString: format)
    }
    
    public init() {}
    
    public var body: some View {
        COToolSection("Export Naming", toolID: "ExportNaming") {
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Format").font(.system(size: 10)).foregroundColor(.gray)
                    
                    // Token Builder UI (Pill representation)
                    HStack {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 2) {
                                ForEach(parsedTokens, id: \.self) { token in
                                    if token.type == .customText {
                                        Text(token.name)
                                            .font(.system(size: 11))
                                            .foregroundColor(.white)
                                    } else {
                                        // Pill style for tokens
                                        Text(token.name)
                                            .font(.system(size: 11, weight: .medium))
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(CaptureOneTheme.Colors.activeHighlight.opacity(0.8))
                                            .foregroundColor(.black)
                                            .cornerRadius(10)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 6)
                        .padding(.vertical, 4)
                        .background(Color.black.opacity(0.2))
                        .cornerRadius(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                        )
                        
                        Button(action: {
                            // Show token library popover
                        }) {
                            Image(systemName: "ellipsis")
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                    }
                }
                
                HStack {
                    Text("Sample:").font(.system(size: 10)).foregroundColor(.gray)
                    Text(CaptureNamingFormatter.format(tokens: parsedTokens, cameraName: "A7RIV", counter: 1234))
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .truncationMode(.middle)
                }
            }
            .padding(.vertical, 4)
        }
    }
}
