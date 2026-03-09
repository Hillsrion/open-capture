import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Export Queue tool (TD-601).
public struct ExportQueueToolView: View {
    @ObservedObject var batchQueue: BatchQueue
    
    public init(batchQueue: BatchQueue) {
        self.batchQueue = batchQueue
    }
    
    public var body: some View {
        COToolSection("Export Queue", toolID: "ExportQueue") {
            VStack(alignment: .leading, spacing: 8) {
                if let active = batchQueue.activeJob {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Exporting...").font(.system(size: 11, weight: .bold))
                            Spacer()
                            Text("\(Int(active.progress * 100))%").font(.system(size: 10, design: .monospaced))
                        }
                        ProgressView(value: active.progress)
                            .accentColor(CaptureOneTheme.Colors.activeHighlight)
                        Text(active.destinationPath.lastPathComponent)
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                    }
                    .padding(8)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(4)
                } else {
                    Text("No active exports").font(.system(size: 11)).foregroundColor(.gray).frame(maxWidth: .infinity, alignment: .center).padding(.vertical, 12)
                }
                
                HStack {
                    Spacer()
                    Button("Stop All") { }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                        .disabled(batchQueue.activeJob == nil)
                }
            }
            .padding(.vertical, 4)
        }
    }
}
