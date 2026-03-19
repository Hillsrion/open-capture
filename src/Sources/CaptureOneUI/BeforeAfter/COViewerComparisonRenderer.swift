import SwiftUI
import ImageCore

/// Reconstructed rendering component for comparing original and adjusted images (UI-013).
/// Based on _TtC10CaptureOne25ViewerComparisonRenderer and related disassembly.
public struct COViewerComparisonRenderer: View {
    @ObservedObject var controller = COBeforeAfterToolController.shared
    
    let beforeImage: NSImage
    let afterImage: NSImage
    let afterCIImage: CIImage?
    let viewerSize: CGSize
    
    public var body: some View {
        Group {
            if controller.mode == .splitScreen {
                COSplitViewStateManager(
                    beforeImage: beforeImage,
                    afterImage: afterImage,
                    afterCIImage: afterCIImage,
                    splitPosition: $controller.splitPosition,
                    viewerSize: viewerSize
                )
            } else {
                HStack(spacing: 1) {
                    Image(nsImage: beforeImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: (viewerSize.width - 1) / 2)
                        .clipped()
                    
                    if let afterCI = afterCIImage, COMTRView.supportsMetal {
                        COMTRView(image: afterCI)
                            .frame(width: (viewerSize.width - 1) / 2)
                            .clipped()
                    } else {
                        Image(nsImage: afterImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: (viewerSize.width - 1) / 2)
                            .clipped()
                    }
                }
            }
        }
    }
}
