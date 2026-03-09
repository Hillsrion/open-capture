import SwiftUI
import AppCoreShared

/// Reconstructed Core Print Layout View (UI-012).
/// Displays the paper bounds, margins, and image cells based on the PrintTemplate.
public struct PrintLayoutView: View {
    @ObservedObject var manager: PrintManager
    @Binding var selectedVariants: [VariantBase]
    
    // Scaling factor for rendering mm on screen
    private let scale: CGFloat = 3.0
    
    public init(manager: PrintManager, selectedVariants: Binding<[VariantBase]>) {
        self.manager = manager
        self._selectedVariants = selectedVariants
    }
    
    public var body: some View {
        ScrollView([.horizontal, .vertical], showsIndicators: true) {
            ZStack {
                // Background Desktop
                Color(NSColor.windowBackgroundColor)
                
                // Paper
                let paperWidth = CGFloat(manager.currentTemplate.paperWidth) * scale
                let paperHeight = CGFloat(manager.currentTemplate.paperHeight) * scale
                
                ZStack {
                    Rectangle()
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
                    
                    // Margins overlay (Optional visual guide)
                    let mt = CGFloat(manager.currentTemplate.marginTop) * scale
                    let mb = CGFloat(manager.currentTemplate.marginBottom) * scale
                    let ml = CGFloat(manager.currentTemplate.marginLeft) * scale
                    let mr = CGFloat(manager.currentTemplate.marginRight) * scale
                    
                    Rectangle()
                        .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 1, dash: [5]))
                        .padding(.top, mt)
                        .padding(.bottom, mb)
                        .padding(.leading, ml)
                        .padding(.trailing, mr)
                    
                    // Grid Cells
                    PrintGridView(template: manager.currentTemplate, scale: scale, variants: selectedVariants)
                        .padding(.top, mt)
                        .padding(.bottom, mb)
                        .padding(.leading, ml)
                        .padding(.trailing, mr)
                }
                .frame(width: paperWidth, height: paperHeight)
                .padding(50) // Space around the paper on the desktop
            }
        }
        .background(Color(NSColor.windowBackgroundColor))
    }
}

/// Helper view to draw the cells within the print margins.
struct PrintGridView: View {
    let template: PrintTemplate
    let scale: CGFloat
    let variants: [VariantBase]
    
    var body: some View {
        GeometryReader { geo in
            let availableWidth = geo.size.width
            let availableHeight = geo.size.height
            
            let totalSpacingX = CGFloat(max(0, template.columns - 1)) * CGFloat(template.cellSpacing) * scale
            let totalSpacingY = CGFloat(max(0, template.rows - 1)) * CGFloat(template.cellSpacing) * scale
            
            let cellWidth = (availableWidth - totalSpacingX) / CGFloat(max(1, template.columns))
            let cellHeight = (availableHeight - totalSpacingY) / CGFloat(max(1, template.rows))
            
            ZStack(alignment: .topLeading) {
                ForEach(0..<template.rows, id: \.self) { row in
                    ForEach(0..<template.columns, id: \.self) { col in
                        let index = row * template.columns + col
                        let x = CGFloat(col) * (cellWidth + CGFloat(template.cellSpacing) * scale)
                        let y = CGFloat(row) * (cellHeight + CGFloat(template.cellSpacing) * scale)
                        
                        // Cell Bounds
                        Rectangle()
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            .background(Color.gray.opacity(0.1))
                            .frame(width: cellWidth, height: cellHeight)
                            .offset(x: x, y: y)
                        
                        // Image Content (if available)
                        if index < variants.count {
                            // Simulation: Normally we'd load the full image or high-res preview
                            // and scale it to fit/fill the cell based on settings.
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.gray)
                                .padding(10)
                                .frame(width: cellWidth, height: cellHeight)
                                .offset(x: x, y: y)
                                .clipShape(Rectangle().size(width: cellWidth, height: cellHeight)) // Mock clipping
                        } else {
                            Text("Empty Cell")
                                .font(.system(size: 10))
                                .foregroundColor(.gray.opacity(0.5))
                                .frame(width: cellWidth, height: cellHeight)
                                .offset(x: x, y: y)
                        }
                    }
                }
            }
        }
    }
}
