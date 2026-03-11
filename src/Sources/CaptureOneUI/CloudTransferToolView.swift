import SwiftUI
import AppCoreShared

/// Reconstructed Cloud Sync & Transfer tool (ENG-012).
/// Displays available cloud sessions and transfer status.
public struct CloudTransferToolView: View {
    @ObservedObject var cloudManager = CloudTransferManager.shared
    
    public init() {}
    
    public var body: some View {
        COToolSection("Cloud Transfer", toolID: "CloudTransfer") {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("iPad & iPhone Sessions")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    Spacer()
                    Button(action: { cloudManager.fetchCloudSessions() }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 10))
                    }
                    .buttonStyle(.plain)
                    .disabled(cloudManager.isFetching)
                }
                
                if cloudManager.isFetching {
                    HStack {
                        ProgressView().controlSize(.small)
                        Text("Checking cloud...").font(.system(size: 10)).foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                } else if cloudManager.availableCloudSessions.isEmpty {
                    Text("No cloud sessions found.")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                        .padding(.vertical, 4)
                } else {
                    VStack(spacing: 1) {
                        ForEach(cloudManager.availableCloudSessions) { session in
                            cloudSessionRow(session)
                        }
                    }
                    .background(Color.black.opacity(0.2))
                    .cornerRadius(4)
                }
                
                if cloudManager.transferProgress > 0 {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Downloading...").font(.system(size: 9)).foregroundColor(.gray)
                        ProgressView(value: cloudManager.transferProgress)
                            .progressViewStyle(LinearProgressViewStyle(tint: CaptureOneTheme.Colors.activeHighlight))
                    }
                    .padding(.top, 4)
                }
            }
            .padding(.vertical, 4)
        }
    }
    
    private func cloudSessionRow(_ session: CloudTransferManager.CloudSession) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(session.name).font(.system(size: 11))
                Text("\(session.imageCount) images • \(session.lastModified, style: .date)")
                    .font(.system(size: 9))
                    .foregroundColor(.gray)
            }
            Spacer()
            Button(action: { cloudManager.downloadSession(session) }) {
                Image(systemName: "icloud.and.arrow.down")
                    .font(.system(size: 12))
                    .foregroundColor(CaptureOneTheme.Colors.activeHighlight)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 8)
        .frame(height: 36)
        .background(Color.white.opacity(0.02))
    }
}
