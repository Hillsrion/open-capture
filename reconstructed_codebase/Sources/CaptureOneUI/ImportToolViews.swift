import SwiftUI
import AppCoreShared

// MARK: - ImporterFilters (TOOL-306)

/// Reconstructed stub for ImporterFiltersInspectorTool.
/// Decompiled: _TtC10CaptureOne28ImporterFiltersInspectorTool
struct ImporterFiltersToolView: View {
    let config: ToolConfiguration

    @State private var includeRAW = true
    @State private var includeJPEG = true
    @State private var includeTIFF = false
    @State private var includeVideo = false
    @State private var duplicateHandling = "Skip"

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("File Type Filters")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.white)

            Toggle("RAW Files", isOn: $includeRAW)
                .font(.system(size: 11))
            Toggle("JPEG Files", isOn: $includeJPEG)
                .font(.system(size: 11))
            Toggle("TIFF Files", isOn: $includeTIFF)
                .font(.system(size: 11))
            Toggle("Video Files", isOn: $includeVideo)
                .font(.system(size: 11))

            Divider()

            HStack {
                Text("Duplicates").font(.system(size: 11)).foregroundColor(.gray)
                Spacer()
                Picker("", selection: $duplicateHandling) {
                    Text("Skip").tag("Skip")
                    Text("Import").tag("Import")
                    Text("Rename").tag("Rename")
                }
                .pickerStyle(.menu)
                .frame(width: 100)
            }
        }
        .padding(10)
    }
}

// MARK: - ImportFileInfo (TOOL-306)

/// Reconstructed stub for ImportFileInfoInspectorTool.
/// Decompiled: ImportFileInfoInspectorTool (ObjC class)
struct ImportFileInfoToolView: View {
    let config: ToolConfiguration

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("File Information")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.white)

            infoRow("File Name", "—")
            infoRow("File Size", "—")
            infoRow("Dimensions", "—")
            infoRow("Camera", "—")
            infoRow("Date Taken", "—")
            infoRow("Format", "—")
        }
        .padding(10)
    }

    private func infoRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(.gray)
                .frame(width: 70, alignment: .leading)
            Text(value)
                .font(.system(size: 10))
                .foregroundColor(.white)
            Spacer()
        }
    }
}

// MARK: - FaceFocus (TOOL-306)

/// Reconstructed stub for FaceFocusStatistics display.
/// Decompiled: _TtC10CaptureOne19FaceFocusStatistics
struct FaceFocusToolView: View {
    let config: ToolConfiguration

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "face.smiling")
                    .font(.system(size: 16))
                    .foregroundColor(CaptureOneTheme.Colors.activeHighlight)
                Text("Face Focus")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
            }

            Text("Face detection analyzes images to identify and rank faces by sharpness.")
                .font(.system(size: 10))
                .foregroundColor(.gray)
                .fixedSize(horizontal: false, vertical: true)

            HStack {
                Text("Faces Detected")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                Spacer()
                Text("0")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(.white)
            }
        }
        .padding(10)
    }
}

// MARK: - TimeBasedGrouping (TOOL-306)

/// Reconstructed stub for TimeBasedGroupingInspectorTool.
/// Decompiled: _TtC10CaptureOne30TimeBasedGroupingInspectorTool
/// Related: TimeBasedGroupingModel, TimeBasedGroupingAlgorithm,
///          TimeBasedGroupingInteractor, TimeBasedGroupingSimilarityComparison
struct TimeBasedGroupingToolView: View {
    let config: ToolConfiguration

    @State private var groupingInterval = "Auto"
    @State private var showTimeline = true

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "clock.arrow.2.circlepath")
                    .font(.system(size: 14))
                    .foregroundColor(CaptureOneTheme.Colors.activeHighlight)
                Text("Time-Based Grouping")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
            }

            HStack {
                Text("Interval")
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
                Spacer()
                Picker("", selection: $groupingInterval) {
                    Text("Auto").tag("Auto")
                    Text("1 Hour").tag("1 Hour")
                    Text("1 Day").tag("1 Day")
                    Text("1 Week").tag("1 Week")
                }
                .pickerStyle(.menu)
                .frame(width: 100)
            }

            Toggle("Show Timeline", isOn: $showTimeline)
                .font(.system(size: 11))

            // Placeholder timeline strip
            if showTimeline {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.white.opacity(0.05))
                    .frame(height: 40)
                    .overlay(
                        Text("Timeline")
                            .font(.system(size: 9))
                            .foregroundColor(.gray)
                    )
            }
        }
        .padding(10)
    }
}
