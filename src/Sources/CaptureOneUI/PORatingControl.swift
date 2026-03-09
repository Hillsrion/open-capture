import SwiftUI
import AppCoreShared

/// Reconstructed `PORatingControl` for star ratings (0-5).
public struct PORatingControl: View {
    @Binding var rating: Int
    public var size: CGFloat = 14
    
    public init(rating: Binding<Int>, size: CGFloat = 14) {
        self._rating = rating
        self.size = size
    }
    
    public var body: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .foregroundColor(index <= rating ? .yellow : .gray.opacity(0.4))
                    .onTapGesture {
                        if rating == 1 && index == 1 {
                            rating = 0
                        } else {
                            rating = index
                        }
                    }
            }
        }
    }
}
