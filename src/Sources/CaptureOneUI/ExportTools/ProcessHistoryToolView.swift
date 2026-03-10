import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Process History tool (ENG-204).
/// Tracks previously exported images and provides quick access/reprocessing.
public struct ProcessHistoryToolView: View {
    // Simulated history data
    struct HistoryItem: Identifiable {
        let id = UUID()
        let filename: String
        let recipeName: String
        let date: Date
        let status: String
    }
    
    @State private var history: [HistoryItem] = [
        HistoryItem(filename: "DSLR_0045_edit.jpg", recipeName: "JPEG sRGB 8-bit", date: Date().addingTimeInterval(-3600), status: "Completed"),
        HistoryItem(filename: "DSLR_0045_edit.tif", recipeName: "TIFF AdobeRGB 16-bit", date: Date().addingTimeInterval(-3600), status: "Completed")
    ]
    
    public init() {}
    
    public var body: some View {
        COToolSection("Process History", toolID: "ProcessHistory") {
            VStack(spacing: 4) {
                HStack {
                    Button(action: { history.removeAll() }) {
                        Text("Clear History")
                            .font(.system(size: 10))
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    
                    Spacer()
                    
                    Button(action: { /* Reprocess logic */ }) {
                        Text("Reprocess")
                            .font(.system(size: 10, weight: .bold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(CaptureOneTheme.Colors.buttonBackground)
                            .cornerRadius(3)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.bottom, 4)
                
                ScrollView {
                    VStack(spacing: 2) {
                        if history.isEmpty {
                            Text("No history available")
                                .font(.system(size: 11))
                                .foregroundColor(.gray)
                                .padding(.top, 12)
                        } else {
                            ForEach(history) { item in
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(item.filename)
                                            .font(.system(size: 11, weight: .medium))
                                            .lineLimit(1)
                                            .truncationMode(.middle)
                                        HStack {
                                            Text(item.recipeName)
                                            Text("•")
                                            Text(item.date, style: .time)
                                        }
                                        .font(.system(size: 9))
                                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                                    }
                                    Spacer()
                                    Button(action: { /* Show in Finder */ }) {
                                        Image(systemName: "magnifyingglass")
                                            .font(.system(size: 10))
                                            .foregroundColor(.gray)
                                    }
                                    .buttonStyle(.plain)
                                }
                                .padding(6)
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(4)
                            }
                        }
                    }
                }
                .frame(maxHeight: 150)
            }
            .padding(.vertical, 4)
        }
    }
}
