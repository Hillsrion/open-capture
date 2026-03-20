import SwiftUI

/// Renderer for the red mask overlay (Reference: 2-HZ7HSYXUQ).
public struct COMaskOverlayRenderer: View {
    let maskImage: NSImage?
    let zoomLevel: Double
    
    public var body: some View {
        if let mask = maskImage {
            Image(nsImage: mask)
                .resizable()
                .scaleEffect(zoomLevel)
                .aspectRatio(contentMode: .fit)
                .opacity(0.5)
                .colorMultiply(.red)
                .allowsHitTesting(false)
        }
    }
}
