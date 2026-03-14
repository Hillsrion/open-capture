import SwiftUI
import AppCoreShared

/// Reconstructed Cloud Sync & Transfer tool (ENG-012).
/// Displays available cloud sessions and transfer status.
public struct CloudTransferToolView: View {
    @ObservedObject var cloudManager = CloudTransferManager.shared
    @State private var showManagementModal = false
    
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
                
                Button(action: { showManagementModal = true }) {
                    Text("Manage Cloud...")
                        .font(.system(size: 11))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                .padding(.top, 4)
                .popover(isPresented: $showManagementModal) {
                    CloudManagementModal(manager: cloudManager)
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

/// Reconstructed Cloud Management Modal.
struct CloudManagementModal: View {
    @ObservedObject var manager: CloudTransferManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Account Info
            HStack {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.gray)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Capture One Cloud").font(.system(size: 12, weight: .bold))
                    Text(manager.accountEmail).font(.system(size: 11)).foregroundColor(.gray)
                }
            }
            
            Divider().background(Color.white.opacity(0.1))
            
            // Storage Bar
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Storage").font(.system(size: 11, weight: .bold))
                    Spacer()
                    Text(String(format: "%.1f GB of %.1f GB Used", manager.storageUsedGB, manager.storageTotalGB))
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                }
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Rectangle().fill(Color.white.opacity(0.1)).frame(height: 8).cornerRadius(4)
                        Rectangle().fill(CaptureOneTheme.Colors.activeHighlight)
                            .frame(width: geo.size.width * CGFloat(manager.storageUsedGB / manager.storageTotalGB), height: 8)
                            .cornerRadius(4)
                    }
                }
                .frame(height: 8)
            }
            
            Divider().background(Color.white.opacity(0.1))
            
            // Active Transfers
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Active Transfers").font(.system(size: 11, weight: .bold))
                    Spacer()
                    Button(action: { manager.togglePauseSync() }) {
                        Image(systemName: manager.isSyncPaused ? "play.fill" : "pause.fill")
                            .font(.system(size: 10))
                    }
                    .buttonStyle(.plain)
                    .help(manager.isSyncPaused ? "Resume Sync" : "Pause Sync")
                }
                
                if manager.activeTransfers.isEmpty {
                    Text("No active transfers.")
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                        .padding(.vertical, 8)
                } else {
                    ScrollView {
                        VStack(spacing: 8) {
                            ForEach(manager.activeTransfers) { transfer in
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Image(systemName: transfer.isUploading ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                                            .font(.system(size: 10))
                                            .foregroundColor(manager.isSyncPaused ? .gray : CaptureOneTheme.Colors.activeHighlight)
                                        Text(transfer.name).font(.system(size: 11))
                                        Spacer()
                                        Text("\(Int(transfer.progress * 100))%").font(.system(size: 10, design: .monospaced)).foregroundColor(.gray)
                                    }
                                    ProgressView(value: transfer.progress)
                                        .progressViewStyle(LinearProgressViewStyle(tint: manager.isSyncPaused ? .gray : CaptureOneTheme.Colors.activeHighlight))
                                }
                            }
                        }
                    }
                    .frame(maxHeight: 120)
                }
            }
        }
        .padding(16)
        .frame(width: 300)
    }
}
