import SwiftUI
import AppCoreShared

/// Reconstructed Keystone interactive handle (UI-006).
/// Provides visual feedback and dragging logic for a single keystone guide point.
public struct COKeystoneHandleView: View {
    let index: Int
    @Binding var point: CGPoint
    let containerSize: CGSize
    
    @State private var isDragging: Bool = false
    
    public init(index: Int, point: Binding<CGPoint>, containerSize: CGSize) {
        self.index = index
        self._point = point
        self.containerSize = containerSize
    }
    
    private var screenPos: CGPoint {
        CGPoint(x: point.x * containerSize.width, y: point.y * containerSize.height)
    }
    
    public var body: some View {
        ZStack {
            // Invisible larger hit target
            Circle()
                .fill(Color.white.opacity(0.001))
                .frame(width: 24, height: 24)
            
            // Visual handle
            ZStack {
                Circle()
                    .stroke(Color.black.opacity(0.5), lineWidth: 1.5)
                    .background(Circle().fill(CaptureOneTheme.Colors.activeHighlight))
                    .frame(width: 10, height: 10)
                
                if isDragging {
                    Circle()
                        .stroke(CaptureOneTheme.Colors.activeHighlight, lineWidth: 1)
                        .frame(width: 20, height: 20)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .position(screenPos)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    isDragging = true
                    let newX = max(0, min(1, value.location.x / containerSize.width))
                    let newY = max(0, min(1, value.location.y / containerSize.height))
                    self.point = CGPoint(x: newX, y: newY)
                }
                .onEnded { _ in
                    isDragging = false
                    COKeystoneController.shared.apply()
                }
        )
    }
}
