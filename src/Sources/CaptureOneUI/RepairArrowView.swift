import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity visual overlay for Heal/Clone arrows (UI-006).
public struct RepairArrowView: View {
    @ObservedObject var arrow: RepairArrow
    
    public var body: some View {
        ZStack {
            // 1. Connection Line
            Path { path in
                path.move(to: arrow.sourcePoint)
                path.addLine(to: arrow.destinationPoint)
            }
            .stroke(arrow.type == .heal ? Color.orange : Color.blue, style: StrokeStyle(lineWidth: 1, dash: [2]))
            
            // 2. Source Point (Crosshair)
            Circle()
                .stroke(Color.white, lineWidth: 1)
                .frame(width: 8, height: 8)
                .position(arrow.sourcePoint)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            arrow.sourcePoint = gesture.location
                        }
                )
            
            // 3. Destination Point (Circle)
            Circle()
                .stroke(Color.white, lineWidth: 2)
                .background(Circle().fill(arrow.type == .heal ? Color.orange : Color.blue).opacity(0.3))
                .frame(width: 12, height: 12)
                .position(arrow.destinationPoint)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            arrow.destinationPoint = gesture.location
                        }
                )
        }
    }
}
