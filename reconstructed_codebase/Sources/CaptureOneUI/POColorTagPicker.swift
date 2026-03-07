import SwiftUI
import AppCoreShared

/// Reconstructed `POColorTagPicker` for color tags.
public struct POColorTagPicker: View {
    @Binding var selectedTag: VariantBase.ColorTag
    
    public init(selectedTag: Binding<VariantBase.ColorTag>) {
        self._selectedTag = selectedTag
    }
    
    private let tags: [VariantBase.ColorTag] = [.none, .red, .orange, .yellow, .green, .blue, .purple, .pink]
    
    public var body: some View {
        HStack(spacing: 4) {
            ForEach(tags, id: \.self) { tag in
                Circle()
                    .fill(colorForTag(tag))
                    .frame(width: 14, height: 14)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: selectedTag == tag ? 1.5 : 0)
                    )
                    .overlay(
                        tag == .none ? Image(systemName: "slash.circle").font(.system(size: 8)).foregroundColor(.gray) : nil
                    )
                    .onTapGesture {
                        selectedTag = tag
                    }
            }
        }
    }
    
    private func colorForTag(_ tag: VariantBase.ColorTag) -> Color {
        switch tag {
        case .none: return Color.black.opacity(0.1)
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
