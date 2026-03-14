import SwiftUI
import AppCoreShared

/// Reconstructed Capture One Live tool (ENG-012).
/// Manages remote sharing sessions and reviewer permissions.
public struct CaptureOneLiveToolView: View {
    @ObservedObject var liveManager = CaptureOneLiveManager.shared
    
    public init() {}
    
    public var body: some View {
        COToolSection("Capture One Live", toolID: "CaptureOneLive") {
            VStack(alignment: .leading, spacing: 12) {
                if !liveManager.isSessionActive {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Share your images with clients or collaborators in real-time.")
                            .font(.system(size: 10))
                            .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                        
                        VStack(spacing: 6) {
                            HStack {
                                Text("Duration").font(.system(size: 11)).foregroundColor(.gray)
                                Spacer()
                                Picker("", selection: $liveManager.sessionDurationIndex) {
                                    Text("24 Hours").tag(0)
                                    Text("1 Week").tag(1)
                                    Text("1 Month").tag(2)
                                }
                                .pickerStyle(.menu)
                                .labelsHidden()
                                .frame(width: 100)
                            }
                            
                            HStack {
                                Text("Password").font(.system(size: 11)).foregroundColor(.gray)
                                Spacer()
                                SecureField("Optional", text: $liveManager.sessionPassword)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .font(.system(size: 10))
                                    .frame(width: 100)
                            }
                        }
                        .padding(8)
                        .background(Color.white.opacity(0.02))
                        .cornerRadius(4)
                        
                        Button(action: { liveManager.startSession() }) {
                            Text("Start Sharing")
                                .font(.system(size: 11, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(CaptureOneTheme.Colors.activeHighlight)
                                .foregroundColor(.black)
                                .cornerRadius(4)
                        }
                        .buttonStyle(.plain)
                    }
                } else {
                    activeSessionView
                }
                
                Divider().background(Color.white.opacity(0.05))
                
                // Permissions Grid
                VStack(alignment: .leading, spacing: 8) {
                    Text("Reviewer Permissions")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    
                    Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 8) {
                        GridRow {
                            permissionToggle(label: "Rate", isOn: $liveManager.canRate)
                            permissionToggle(label: "Color Tag", isOn: $liveManager.canColorTag)
                        }
                        GridRow {
                            permissionToggle(label: "Download", isOn: $liveManager.canDownload)
                        }
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
    
    private var activeSessionView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle().fill(Color.green).frame(width: 8, height: 8)
                Text("Session Active").font(.system(size: 11, weight: .bold))
                Spacer()
                Button("Stop") { liveManager.stopSession() }
                    .font(.system(size: 10))
                    .foregroundColor(.red)
            }
            
            if let url = liveManager.sessionURL {
                HStack {
                    Text(url)
                        .font(.system(size: 10, design: .monospaced))
                        .lineLimit(1)
                        .padding(6)
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(4)
                    
                    Button(action: { NSPasteboard.general.clearContents(); NSPasteboard.general.setString(url, forType: .string) }) {
                        Image(systemName: "doc.on.doc")
                            .font(.system(size: 10))
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Text("Expires: \(liveManager.expiryDate, style: .date) \(liveManager.expiryDate, style: .time)")
                .font(.system(size: 9))
                .foregroundColor(.gray)
                
            Divider().background(Color.white.opacity(0.1))
            
            // User Count & Activity Log
            HStack {
                Image(systemName: "person.2.fill")
                    .font(.system(size: 10))
                    .foregroundColor(CaptureOneTheme.Colors.activeHighlight)
                Text("\(liveManager.connectedUsersCount) Connected")
                    .font(.system(size: 11, weight: .bold))
            }
            .padding(.top, 4)
            
            if !liveManager.activityLog.isEmpty {
                Text("Activity Log")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    .padding(.top, 4)
                    
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(liveManager.activityLog.prefix(3)) { log in
                        HStack(alignment: .top, spacing: 4) {
                            Text(log.timestamp, style: .time)
                                .font(.system(size: 9))
                                .foregroundColor(.gray)
                                .frame(width: 45, alignment: .leading)
                            VStack(alignment: .leading, spacing: 1) {
                                Text(log.user)
                                    .font(.system(size: 10, weight: .semibold))
                                Text(log.action)
                                    .font(.system(size: 10))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .padding(6)
                .background(Color.black.opacity(0.2))
                .cornerRadius(4)
            }
        }
    }
    
    private func permissionToggle(label: String, isOn: Binding<Bool>) -> some View {
        Toggle(label, isOn: isOn)
            .toggleStyle(POCheckboxStyle())
            .font(.system(size: 11))
    }
}
