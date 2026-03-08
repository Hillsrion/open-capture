import SwiftUI
import AppCoreShared

// MARK: - ExposureEvaluation (Capture palette)

/// Reconstructed stub for ExposureEvaluationInspectorTool.
/// Original ivars: exposureMeter (POExposureMeter), curvesControl (POCurvesControl),
///   _pendingHistogramJob, _pendingExposureMeterJob.
struct ExposureEvaluationToolView: View {
    @ObservedObject var adjustmentController: AdjustmentToolController
    let config: ToolConfiguration
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Histogram placeholder
            RoundedRectangle(cornerRadius: 4)
                .fill(CaptureOneTheme.Colors.histogramBackground)
                .frame(height: 90)
                .overlay(
                    Image(systemName: "chart.bar.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.gray.opacity(0.4))
                )
            
            // Exposure meter
            HStack {
                Text("Exposure").font(.system(size: 11)).foregroundColor(.gray)
                Spacer()
                Text("0.0 EV").font(.system(size: 11, design: .monospaced)).foregroundColor(.white)
            }
            
            // Shadow / Highlight clipping
            HStack(spacing: 16) {
                VStack(alignment: .leading) {
                    Text("Shadow").font(.system(size: 10)).foregroundColor(.gray)
                    Text("0.0%").font(.system(size: 10, design: .monospaced)).foregroundColor(.white)
                }
                VStack(alignment: .leading) {
                    Text("Highlight").font(.system(size: 10)).foregroundColor(.gray)
                    Text("0.0%").font(.system(size: 10, design: .monospaced)).foregroundColor(.white)
                }
                Spacer()
            }
        }
        .padding(10)
    }
}

// MARK: - CameraFocus (Capture palette)

struct CameraFocusToolView: View {
    let config: ToolConfiguration
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Focus Mode").font(.system(size: 11)).foregroundColor(.gray)
                Spacer()
                Picker("", selection: .constant("AF-S")) {
                    Text("AF-S").tag("AF-S")
                    Text("AF-C").tag("AF-C")
                    Text("MF").tag("MF")
                }
                .pickerStyle(.menu)
                .frame(width: 90)
            }
            
            HStack {
                Text("Focus Area").font(.system(size: 11)).foregroundColor(.gray)
                Spacer()
                Text("Center").font(.system(size: 11)).foregroundColor(.white)
            }
            
            Button("Focus") {}
                .buttonStyle(.bordered)
                .controlSize(.small)
        }
        .padding(10)
    }
}

// MARK: - NextCaptureLocation (Capture palette)

struct NextCaptureLocationToolView: View {
    let config: ToolConfiguration
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Picker("Location", selection: .constant("Session Folder")) {
                Text("Session Folder").tag("Session Folder")
                Text("Custom...").tag("Custom...")
            }
            .pickerStyle(.menu)
            
            HStack {
                Text("Subfolder").font(.system(size: 11)).foregroundColor(.gray)
                Spacer()
                TextField("", text: .constant(""))
                    .textFieldStyle(.squareBorder)
                    .frame(width: 120)
            }
        }
        .padding(10)
    }
}

// MARK: - Overlay (Capture palette)

struct OverlayToolView: View {
    @State private var overlayEnabled = false
    @State private var opacity: Double = 50
    let config: ToolConfiguration
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Toggle("Show Overlay", isOn: $overlayEnabled)
                .font(.system(size: 11))
            
            HStack {
                Text("Opacity").font(.system(size: 11)).foregroundColor(.gray)
                Slider(value: $opacity, in: 0...100)
                    .accentColor(CaptureOneTheme.Colors.activeHighlight)
                Text("\(Int(opacity))%").font(.system(size: 10, design: .monospaced)).foregroundColor(.white)
            }
            
            Button("Load Overlay Image...") {}
                .buttonStyle(.bordered)
                .controlSize(.small)
        }
        .padding(10)
    }
}

// MARK: - LiveForStudio (Capture palette)

struct LiveForStudioToolView: View {
    let config: ToolConfiguration
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "video.fill")
                    .foregroundColor(CaptureOneTheme.Colors.activeHighlight)
                Text("Live for Studio").font(.system(size: 12, weight: .medium)).foregroundColor(.white)
            }
            
            Text("Connect a camera to enable Live for Studio features.")
                .font(.system(size: 10))
                .foregroundColor(.gray)
                .lineLimit(3)
        }
        .padding(10)
    }
}

// MARK: - NextCaptureMetadata (Capture palette)

struct NextCaptureMetadataToolView: View {
    @State private var copyright = ""
    @State private var creator = ""
    let config: ToolConfiguration
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Copyright").font(.system(size: 11)).foregroundColor(.gray)
                TextField("", text: $copyright)
                    .textFieldStyle(.squareBorder)
            }
            HStack {
                Text("Creator").font(.system(size: 11)).foregroundColor(.gray)
                TextField("", text: $creator)
                    .textFieldStyle(.squareBorder)
            }
        }
        .padding(10)
    }
}

// MARK: - NextCaptureKeywords (Capture palette)

struct NextCaptureKeywordsToolView: View {
    @State private var keywords = ""
    let config: ToolConfiguration
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Keywords applied to next capture:")
                .font(.system(size: 10))
                .foregroundColor(.gray)
            
            TextField("Enter keywords...", text: $keywords)
                .textFieldStyle(.squareBorder)
        }
        .padding(10)
    }
}

// MARK: - NextCaptureBackup (Capture palette)

struct NextCaptureBackupToolView: View {
    @State private var backupEnabled = false
    let config: ToolConfiguration
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Toggle("Enable Backup", isOn: $backupEnabled)
                .font(.system(size: 11))
            
            HStack {
                Text("Folder").font(.system(size: 11)).foregroundColor(.gray)
                Spacer()
                Button("Choose...") {}
                    .buttonStyle(.bordered)
                    .controlSize(.small)
            }
            .disabled(!backupEnabled)
        }
        .padding(10)
    }
}
