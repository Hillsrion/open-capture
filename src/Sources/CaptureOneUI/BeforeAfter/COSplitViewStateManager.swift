import SwiftUI
import ImageCore

/// Reconstructed split-view management for comparison tools (UI-013).
/// Mimics C1's high-performance interactive split-slider.
public struct COSplitViewStateManager: View {
    let beforeImage: NSImage
    let afterImage: NSImage
    let afterCIImage: CIImage?
    @Binding var splitPosition: Double
    let viewerSize: CGSize
    
    public var body: some View {
        ZStack {
            // "After" Image (Full Width Background)
            Group {
                if let afterCI = afterCIImage, COMTRView.supportsMetal {
                    COMTRView(image: afterCI)
                        .frame(width: viewerSize.width, height: viewerSize.height)
                } else {
                    Image(nsImage: afterImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: viewerSize.width, height: viewerSize.height)
                }
            }
            .clipped()

            // "Before" Image (Masked)
            Image(nsImage: beforeImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: viewerSize.width, height: viewerSize.height)
                .mask(
                    HStack(spacing: 0) {
                        Rectangle().frame(width: viewerSize.width * CGFloat(splitPosition))
                        Spacer(minLength: 0)
                    }
                )
                .clipped()

            // Split Line Handle
            Rectangle()
                .fill(Color.white)
                .frame(width: 1)
                .overlay(
                    Circle()
                        .fill(Color.white)
                        .frame(width: 24, height: 24)
                        .shadow(color: .black.opacity(0.3), radius: 4)
                        .overlay(
                            Image(systemName: "arrow.left.and.right")
                                .font(.system(size: 10))
                                .foregroundColor(.black)
                        )
                )
                .position(x: viewerSize.width * CGFloat(splitPosition), y: viewerSize.height / 2)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            self.splitPosition = Double(max(0, min(1, value.location.x / viewerSize.width)))
                        }
                )
        }
    }
}
