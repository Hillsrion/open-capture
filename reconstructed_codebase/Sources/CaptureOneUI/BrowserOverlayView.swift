import SwiftUI
import AppCoreShared

/// Reconstructed reusable Overlay for Browser cells (UI-005 / UI-009).
public struct BrowserOverlayView: View {
    let variant: VariantBase?
    let image: ImageBase
    
    public init(variant: VariantBase?, image: ImageBase) {
        self.variant = variant
        self.image = image
    }
    
    public var body: some View {
        VStack {
            HStack(alignment: .top) {
                // 1. Color Tag Bar
                if let v = variant, v.colorTag != .none {
                    Rectangle()
                        .fill(colorForTag(v.colorTag))
                        .frame(width: 5, height: 18)
                        .cornerRadius(1.5)
                        .shadow(radius: 1)
                }
                
                Spacer()
                
                // 2. Status Indicators
                VStack(alignment: .trailing, spacing: 4) {
                    if image.isOffline {
                        Image(systemName: "bolt.horizontal.circle.fill")
                            .foregroundColor(.orange)
                            .font(.system(size: 11))
                            .shadow(radius: 1)
                    }
                    if image.isMovie {
                        Image(systemName: "play.circle.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 11))
                            .shadow(radius: 1)
                    }
                    if let v = variant, v.isModified {
                        Image(systemName: "pencil.circle.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 10))
                            .shadow(radius: 1)
                    }
                }
            }
            
            Spacer()
            
            // 3. Rating Stars
            if let v = variant, v.rating > 0 {
                HStack(spacing: 1.5) {
                    ForEach(0..<v.rating, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .font(.system(size: 8))
                            .foregroundColor(.yellow)
                    }
                }
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
                .background(Color.black.opacity(0.7))
                .cornerRadius(3)
            }
        }
        .padding(6)
    }
    
    private func colorForTag(_ tag: VariantBase.ColorTag) -> Color {
        switch tag {
        case .none: return Color.clear
        case .red: return Color.red
        case .orange: return Color.orange
        case .yellow: return Color.yellow
        case .green: return Color.green
        case .blue: return Color.blue
        case .purple: return Color.purple
        case .pink: return Color.pink
        }
    }
}
