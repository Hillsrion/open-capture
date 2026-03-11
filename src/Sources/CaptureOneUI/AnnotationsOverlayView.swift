import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Annotations overlay (UI-007).
public struct AnnotationsOverlayView: View {
    @ObservedObject var annotations: MCAnnotations
    @ObservedObject var commands = AppCommandCenter.shared
    @State private var currentLine: MCAnnotationsLine?
    
    private var activeTool: AnnotationTool {
        if commands.selectedCursorToolID == "Annotate" { return .pen }
        if commands.selectedCursorToolID == "EraseAnnotation" { return .eraser }
        return .pen // Default
    }
    
    public enum AnnotationTool {
        case pen, eraser, note
    }
    
    public var body: some View {
        ZStack {
            // 1. Drawing Canvas
            Canvas { context, size in
                for line in annotations.lines {
                    var path = Path()
                    if let first = line.points.first {
                        path.move(to: first)
                        for point in line.points.dropFirst() {
                            path.addLine(to: point)
                        }
                    }
                    context.stroke(path, with: .color(Color(hex: line.colorHex)), lineWidth: line.width)
                }
                
                if let line = currentLine {
                    var path = Path()
                    if let first = line.points.first {
                        path.move(to: first)
                        for point in line.points.dropFirst() {
                            path.addLine(to: point)
                        }
                    }
                    context.stroke(path, with: .color(Color(hex: line.colorHex)), lineWidth: line.width)
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        let tool = commands.selectedCursorToolID
                        if tool == "Annotate" {
                            if currentLine == nil {
                                currentLine = MCAnnotationsLine(points: [gesture.location])
                            } else {
                                currentLine?.points.append(gesture.location)
                            }
                        } else if tool == "EraseAnnotation" {
                            // Logic: Remove line if point is near any stroke
                            annotations.lines.removeAll { line in
                                line.points.contains { pt in
                                    abs(pt.x - gesture.location.x) < 10 && abs(pt.y - gesture.location.y) < 10
                                }
                            }
                        }
                    }
                    .onEnded { _ in
                        if let line = currentLine {
                            annotations.lines.append(line)
                            currentLine = nil
                        }
                    }
            )
            
            // 2. Notes Layer
            ForEach($annotations.notes) { $note in
                TextField("Note...", text: $note.text)
                    .font(.system(size: 12))
                    .padding(4)
                    .background(Color.yellow.opacity(0.8))
                    .cornerRadius(4)
                    .foregroundColor(.black)
                    .position(note.position)
                    .frame(width: 150)
            }
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}
