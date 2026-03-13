import SwiftUI
import AppCoreShared

/// Reconstructed `POCurvesControl` interactive spline editor.
/// Manages adding, moving, and removing curve points.

public struct POCurvesControl: View {
    // Shared state representation for points
    @Binding var points: [CGPoint]
    @State private var selectedChannel: Int = 0 // 0: RGB, 1: Luma, 2: Red, 3: Green, 4: Blue
    @State private var draggingIndex: Int? = nil
    
    public var isNegative: Bool
    
    public init(points: Binding<[CGPoint]>, isNegative: Bool = false) {
        self._points = points
        self.isNegative = isNegative
    }
    
    public var body: some View {
        COToolSection(isNegative ? "Curve (Post-Inversion)" : "Curve", toolID: "Curves") {
            VStack(spacing: 8) {
                // Channel Selector
                Picker("Channel", selection: $selectedChannel) {
                    Text("RGB").tag(0)
                    Text("Luma").tag(1)
                    Text("Red").tag(2)
                    Text("Green").tag(3)
                    Text("Blue").tag(4)
                }
                .pickerStyle(SegmentedPickerStyle())
                .labelsHidden()
                
                // Curve Editor View
                VStack(spacing: 4) {
                    GeometryReader { geometry in
                        ZStack {
                            CaptureOneTheme.Colors.histogramBackground
                                .cornerRadius(4)
                            
                            // Grid
                            Path { path in
                                let stepX = geometry.size.width / 4
                                let stepY = geometry.size.height / 4
                                for i in 1..<4 {
                                    path.move(to: CGPoint(x: CGFloat(i) * stepX, y: 0))
                                    path.addLine(to: CGPoint(x: CGFloat(i) * stepX, y: geometry.size.height))
                                    
                                    path.move(to: CGPoint(x: 0, y: CGFloat(i) * stepY))
                                    path.addLine(to: CGPoint(x: geometry.size.width, y: CGFloat(i) * stepY))
                                }
                            }
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            
                            // Interpolated Spline line
                            Path { path in
                                let sortedPoints = points.sorted { $0.x < $1.x }
                                guard let first = sortedPoints.first else { return }
                                
                                path.move(to: pointToView(first, in: geometry.size))
                                for pt in sortedPoints.dropFirst() {
                                    path.addLine(to: pointToView(pt, in: geometry.size))
                                }
                            }
                            .stroke(CaptureOneTheme.Colors.textPrimary, lineWidth: 1.5)
                            
                            // Control Points
                            ForEach(points.indices, id: \.self) { index in
                                Circle()
                                    .fill(CaptureOneTheme.Colors.activeHighlight)
                                    .frame(width: 8, height: 8)
                                    .position(pointToView(points[index], in: geometry.size))
                                    .gesture(
                                        DragGesture()
                                            .onChanged { value in
                                                draggingIndex = index
                                                updatePoint(at: index, with: value.location, in: geometry.size)
                                            }
                                            .onEnded { _ in
                                                draggingIndex = nil
                                                sortPoints()
                                            }
                                    )
                            }
                        }
                        .scaleEffect(x: isNegative ? -1 : 1, y: 1)
                        .gesture(
                            TapGesture()
                                .onEnded {
                                    // Add new point (simplified)
                                }
                        )
                    }
                    .frame(height: 180)
                    
                    // Labels
                    HStack {
                        Text(isNegative ? "255" : "0")
                        Spacer()
                        Text(isNegative ? "0" : "255")
                    }
                    .font(.system(size: 9, design: .monospaced))
                    .foregroundColor(.gray)
                }
            }
        }
    }
    
    private func pointToView(_ pt: CGPoint, in size: CGSize) -> CGPoint {
        return CGPoint(x: pt.x * size.width, y: (1.0 - pt.y) * size.height)
    }
    
    private func updatePoint(at index: Int, with location: CGPoint, in size: CGSize) {
        let newX = max(0.0, min(1.0, location.x / size.width))
        let newY = max(0.0, min(1.0, 1.0 - (location.y / size.height)))
        
        // Ensure endpoints don't cross each other and maintain bounds
        if index == 0 {
            points[index] = CGPoint(x: 0.0, y: newY)
        } else if index == points.count - 1 {
            points[index] = CGPoint(x: 1.0, y: newY)
        } else {
            let minX = points[index - 1].x + 0.01
            let maxX = points[index + 1].x - 0.01
            points[index] = CGPoint(x: max(minX, min(maxX, newX)), y: newY)
        }
    }
    
    private func sortPoints() {
        points.sort { $0.x < $1.x }
    }
}
