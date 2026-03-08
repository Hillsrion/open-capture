import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Annotations overlay (UI-007).
public struct AnnotationsOverlayView: View {
    @ObservedObject var annotations: MCAnnotations
    @State private var currentLine: MCAnnotationsLine?
    @State private var activeTool: AnnotationTool = .pen
    
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
                        if activeTool == .pen {
                            if currentLine == nil {
                                currentLine = MCAnnotationsLine(points: [gesture.location])
                            } else {
                                currentLine?.points.append(gesture.location)
                            }
                        } else if activeTool == .eraser {
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
