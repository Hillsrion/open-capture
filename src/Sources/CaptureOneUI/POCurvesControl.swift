import SwiftUI
import AppCoreShared
import ImageCore

/// Reconstructed `POCurvesControl` interactive spline editor.
/// Manages adding, moving, and removing curve points.

public struct POCurvesControl: View {
    // Shared state representation for points across all channels
    @Binding var pointsRGB: [CGPoint]
    @Binding var pointsLuma: [CGPoint]
    @Binding var pointsRed: [CGPoint]
    @Binding var pointsGreen: [CGPoint]
    @Binding var pointsBlue: [CGPoint]
    @Binding var selectedChannel: Int // 0: RGB, 1: Luma, 2: Red, 3: Green, 4: Blue
    
    @State private var draggingIndex: Int? = nil
    
    public var isNegative: Bool
    
    public init(
        pointsRGB: Binding<[CGPoint]>,
        pointsLuma: Binding<[CGPoint]>,
        pointsRed: Binding<[CGPoint]>,
        pointsGreen: Binding<[CGPoint]>,
        pointsBlue: Binding<[CGPoint]>,
        selectedChannel: Binding<Int>,
        isNegative: Bool = false
    ) {
        self._pointsRGB = pointsRGB
        self._pointsLuma = pointsLuma
        self._pointsRed = pointsRed
        self._pointsGreen = pointsGreen
        self._pointsBlue = pointsBlue
        self._selectedChannel = selectedChannel
        self.isNegative = isNegative
    }
    
    private var currentPoints: Binding<[CGPoint]> {
        switch selectedChannel {
        case 0: return _pointsRGB
        case 1: return _pointsLuma
        case 2: return _pointsRed
        case 3: return _pointsGreen
        case 4: return _pointsBlue
        default: return _pointsRGB
        }
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
                                .contentShape(Rectangle())
                                .onTapGesture { location in
                                    // Add point on tap if not clicking a handle
                                    // (Points are rendered on top, so they'll catch their own gestures first)
                                    addPoint(at: location, in: geometry.size)
                                }
                            
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
                            .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                            
                            // Spline Curve
                            Path { path in
                                let sortedPoints = currentPoints.wrappedValue.sorted { $0.x < $1.x }
                                guard sortedPoints.count >= 2 else {
                                    if let first = sortedPoints.first {
                                        path.move(to: pointToView(first, in: geometry.size))
                                        if let last = sortedPoints.last {
                                            path.addLine(to: pointToView(last, in: geometry.size))
                                        }
                                    }
                                    return
                                }
                                
                                let icPoints = sortedPoints.map { ICCurvePoint(x: Float($0.x), y: Float($0.y)) }
                                let lut = CurvesKernels.generateLUT(from: icPoints, count: icPoints.count, lutSize: Int(geometry.size.width))
                                
                                path.move(to: pointToView(CGPoint(x: 0, y: CGFloat(lut[0])), in: geometry.size))
                                for i in 1..<lut.count {
                                    let x = CGFloat(i) / CGFloat(lut.count - 1)
                                    path.addLine(to: pointToView(CGPoint(x: x, y: CGFloat(lut[i])), in: geometry.size))
                                }
                            }
                            .stroke(curveColor, lineWidth: 1.5)
                            .shadow(color: Color.black.opacity(0.3), radius: 1, x: 0, y: 1)
                            
                            // Control Points
                            ForEach(currentPoints.wrappedValue.indices, id: \.self) { index in
                                ControlPointView(
                                    index: index,
                                    point: currentPoints.wrappedValue[index],
                                    geometry: geometry,
                                    isDragging: draggingIndex == index,
                                    onDragChanged: { location in
                                        draggingIndex = index
                                        updatePoint(at: index, with: location, in: geometry.size)
                                    },
                                    onDragEnded: { location in
                                        if shouldDeletePoint(at: location, in: geometry.size, index: index) {
                                            currentPoints.wrappedValue.remove(at: index)
                                        }
                                        draggingIndex = nil
                                        sortPoints()
                                    },
                                    onDelete: {
                                        if index > 0 && index < currentPoints.wrappedValue.count - 1 {
                                            currentPoints.wrappedValue.remove(at: index)
                                        }
                                    }
                                )
                            }
                        }
                        .scaleEffect(x: isNegative ? -1 : 1, y: 1)
                    }
                    .frame(height: 180)
                    
                    // Labels
                    HStack {
                        Text(isNegative ? "255" : "0")
                        Spacer()
                        Text(isNegative ? "0" : "255")
                    }
                    .font(.system(size: 9, design: .monospaced))
                    .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                }
            }
        }
    }
    
    private var curveColor: Color {
        switch selectedChannel {
        case 2: return .red
        case 3: return .green
        case 4: return .blue
        default: return CaptureOneTheme.Colors.textPrimary
        }
    }
    
    private func pointToView(_ pt: CGPoint, in size: CGSize) -> CGPoint {
        return CGPoint(x: pt.x * size.width, y: (1.0 - pt.y) * size.height)
    }
    
    private func addPoint(at location: CGPoint, in size: CGSize) {
        if currentPoints.wrappedValue.count >= 16 { return }
        
        let newX = max(0.0, min(1.0, location.x / size.width))
        let newY = max(0.0, min(1.0, 1.0 - (location.y / size.height)))
        let newPoint = CGPoint(x: newX, y: newY)
        
        if currentPoints.wrappedValue.contains(where: { abs($0.x - newX) < 0.015 }) { return }
        
        currentPoints.wrappedValue.append(newPoint)
        sortPoints()
    }
    
    private func updatePoint(at index: Int, with location: CGPoint, in size: CGSize) {
        let newX = max(0.0, min(1.0, location.x / size.width))
        let newY = max(0.0, min(1.0, 1.0 - (location.y / size.height)))
        
        if index == 0 {
            currentPoints.wrappedValue[index] = CGPoint(x: 0.0, y: newY)
        } else if index == currentPoints.wrappedValue.count - 1 {
            currentPoints.wrappedValue[index] = CGPoint(x: 1.0, y: newY)
        } else {
            let minX = currentPoints.wrappedValue[index - 1].x + 0.002
            let maxX = currentPoints.wrappedValue[index + 1].x - 0.002
            currentPoints.wrappedValue[index] = CGPoint(x: max(minX, min(maxX, newX)), y: newY)
        }
    }
    
    private func shouldDeletePoint(at location: CGPoint, in size: CGSize, index: Int) -> Bool {
        if index == 0 || index == currentPoints.wrappedValue.count - 1 { return false }
        let thresholdX: CGFloat = 60
        let thresholdY: CGFloat = 80
        return location.y < -thresholdY || location.y > size.height + thresholdY ||
               location.x < -thresholdX || location.x > size.width + thresholdX
    }
    
    private func sortPoints() {
        currentPoints.wrappedValue.sort { $0.x < $1.x }
    }
}


private struct ControlPointView: View {
    let index: Int
    let point: CGPoint
    let geometry: GeometryProxy
    let isDragging: Bool
    let onDragChanged: (CGPoint) -> Void
    let onDragEnded: (CGPoint) -> Void
    let onDelete: () -> Void
    
    var body: some View {
        Circle()
            .fill(isDragging ? CaptureOneTheme.Colors.activeHighlight : Color.white)
            .overlay(Circle().stroke(CaptureOneTheme.Colors.activeHighlight, lineWidth: 1))
            .frame(width: isDragging ? 12 : 8, height: isDragging ? 12 : 8)
            .position(pointToView(point, in: geometry.size))
            .shadow(radius: isDragging ? 2 : 0)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        onDragChanged(value.location)
                    }
                    .onEnded { value in
                        onDragEnded(value.location)
                    }
            )
            .contextMenu {
                if index > 0 && index < 4 { // Simplified check for endpoints
                    Button("Delete Point", role: .destructive) {
                        onDelete()
                    }
                }
            }
    }
    
    private func pointToView(_ pt: CGPoint, in size: CGSize) -> CGPoint {
        return CGPoint(x: pt.x * size.width, y: (1.0 - pt.y) * size.height)
    }
}

