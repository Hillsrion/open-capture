import SwiftUI
import AppCoreShared

/// Reconstructed circular activity indicator (UI-501).
/// Typically located in the top toolbar.
public struct COActivityIndicator: View {
    @ObservedObject var manager = PreviewManager.shared
    @State private var showDetails = false
    
    public init() {}
    
    public var body: some View {
        Button(action: { showDetails.toggle() }) {
            ZStack {
                if manager.isGenerating {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                        .frame(width: 18, height: 18)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(manager.totalProgress))
                        .stroke(Color.orange, lineWidth: 2)
                        .frame(width: 18, height: 18)
                        .rotationEffect(.degrees(-90))
                } else {
                    Image(systemName: "checkmark.circle")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            }
        }
        .buttonStyle(.plain)
        .popover(isPresented: $showDetails) {
            COBatchProgressModal()
                .frame(width: 300, height: 400)
        }
    }
}

/// Reconstructed Activities / Batch Progress window (UI-502).
/// Detailed view of ongoing background tasks.
public struct COBatchProgressModal: View {
    @ObservedObject var manager = PreviewManager.shared
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Activities")
                .font(.headline)
                .padding()
            
            Divider()
            
            if manager.activeJobs.isEmpty {
                VStack {
                    Spacer()
                    Text("No background activities")
                        .foregroundColor(.gray)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(Array(manager.activeJobs.values)) { job in
                            JobRow(job: job)
                        }
                    }
                    .padding()
                }
            }
            
            Divider()
            
            HStack {
                Text("\(manager.activeJobs.count) tasks remaining")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Button("Clear Completed") {
                    // Action to clear finished jobs
                }
                .font(.caption)
            }
            .padding(10)
        }
        .background(Color(NSColor.windowBackgroundColor))
    }
}

private struct JobRow: View {
    let job: PreviewJob
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(URL(fileURLWithPath: job.id).lastPathComponent)
                    .font(.system(size: 12, weight: .medium))
                    .lineLimit(1)
                Spacer()
                Text(statusText)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            
            ProgressView(value: job.progress)
                .progressViewStyle(.linear)
                .tint(.orange)
        }
    }
    
    private var statusText: String {
        switch job.status {
        case .pending: return "Pending..."
        case .processing: return "Developing..."
        case .completed: return "Done"
        case .failed(let error): return "Error: \(error)"
        }
    }
}
