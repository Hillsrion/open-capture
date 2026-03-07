import SwiftUI
import AppCoreShared

/// Reconstructed Layers Inspector Tool.
/// Based on _TtC10CaptureOne18LayersInspectorView metadata.

public struct LayerInspectorView: View {
    @ObservedObject var variant: VariantBase
    @State private var selectedLayerIndex: Int = 0
    
    public init(variant: VariantBase) {
        self.variant = variant
        self._selectedLayerIndex = State(initialValue: variant.activeLayerIndex)
    }
    
    public var body: some View {
        COToolSection("Layers") {
            VStack(spacing: 8) {
                // Layer Stack
                VStack(spacing: 1) {
                    ForEach(variant.layers.indices.reversed(), id: \.self) { index in
                        LayerRow(
                            layer: variant.layers[index],
                            isSelected: selectedLayerIndex == index
                        )
                        .onTapGesture {
                            selectedLayerIndex = index
                            variant.activeLayerIndex = index
                        }
                    }
                }
                .background(Color.black.opacity(0.2))
                .cornerRadius(4)
                
                // Toolbar
                HStack {
                    Button(action: addLayer) {
                        Image(systemName: "plus")
                    }
                    Button(action: removeLayer) {
                        Image(systemName: "minus")
                    }
                    Spacer()
                    
                    if let activeLayer = variant.activeLayer {
                        HStack {
                            Text("Opacity").font(.system(size: 10)).foregroundColor(.gray)
                            Slider(value: Binding(
                                get: { Double(activeLayer.opacity) },
                                set: { activeLayer.opacity = Float($0); variant.isModified = true }
                            ), in: 0...1)
                            .frame(width: 80)
                        }
                    }
                }
                .padding(.top, 4)
            }
        }
    }
    
    private func addLayer() {
        let newLayer = LayerBase(
            uuid: UUID().uuidString,
            name: "Adjustment Layer \(variant.layers.count)",
            type: .adjustment,
            context: variant.managedObjectContext
        )
        variant.layers.append(newLayer)
        variant.isModified = true
    }
    
    private func removeLayer() {
        guard variant.layers.count > 1 else { return } // Don't remove background
        variant.layers.remove(at: selectedLayerIndex)
        selectedLayerIndex = max(0, selectedLayerIndex - 1)
        variant.activeLayerIndex = selectedLayerIndex
        variant.isModified = true
    }
}

struct LayerRow: View {
    let layer: LayerBase
    let isSelected: Bool
    
    var body: some View {
        HStack {
            Image(systemName: iconForType(layer.type))
                .foregroundColor(isSelected ? CaptureOneTheme.Colors.activeHighlight : .gray)
            
            Text(layer.name)
                .font(.system(size: 11))
                .foregroundColor(isSelected ? .white : .gray)
            
            Spacer()
            
            Button(action: { layer.isVisible.toggle() }) {
                Image(systemName: layer.isVisible ? "eye.fill" : "eye.slash")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(isSelected ? Color.white.opacity(0.1) : Color.clear)
    }
    
    private func iconForType(_ type: LayerBase.LayerType) -> String {
        switch type {
        case .background: return "square.fill"
        case .adjustment: return "paintpalette.fill"
        case .clone: return "c.circle.fill"
        case .heal: return "h.circle.fill"
        }
    }
}
