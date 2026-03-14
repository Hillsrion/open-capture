import SwiftUI
import AppCoreShared
import ImageCore

/// Reconstructed Layers Inspector Tool.
/// Based on _TtC10CaptureOne18LayersInspectorView metadata.

public struct LayerInspectorView: View {
    @ObservedObject var variant: VariantBase
    @ObservedObject var controller = AdjustmentToolController.shared
    @State private var selectedLayerIndex: Int = 0
    @State private var isRefineExpanded: Bool = false
    @State private var isCombineMasksPresented: Bool = false
    
    public init(variant: VariantBase) {
        self.variant = variant
        self._selectedLayerIndex = State(initialValue: variant.activeLayerIndex)
    }
    
    public var body: some View {
        COToolSection("Layers", toolID: "LocalAdjustments") {
            VStack(spacing: 8) {
                // Mask Visibility Toolbar (16.7.4 style)
                HStack(spacing: 12) {
                    maskModeButton(mode: 0, icon: "eye.slash", tooltip: "Never Show Mask")
                    maskModeButton(mode: 1, icon: "eye.fill", tooltip: "Always Show Mask")
                    maskModeButton(mode: 2, icon: "paintbrush.fill", tooltip: "Only When Brushing")
                    maskModeButton(mode: 3, icon: "circle.lefthalf.filled", tooltip: "Grayscale Mask")
                    
                    Spacer()
                    
                    Picker("", selection: $controller.maskColorIndex) {
                        Image(systemName: "circle.fill").foregroundColor(.red).tag(0)
                        Image(systemName: "circle.fill").foregroundColor(.green).tag(1)
                        Image(systemName: "circle.fill").foregroundColor(.blue).tag(2)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 60)
                    .scaleEffect(0.8)
                }
                .padding(.horizontal, 4)
                
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
                        .contextMenu {
                            if variant.layers[index].type == .heal || variant.layers[index].type == .clone {
                                Button("Reset Retouching") { controller.resetRetouching() }
                                Divider()
                            }
                            Button("Invert Mask") { /* controller.invertMask(for: variant.layers[index]) */ }
                            Button("Fill Mask") { /* controller.fillMask(for: variant.layers[index]) */ }
                            Button("Clear Mask") { /* controller.clearMask(for: variant.layers[index]) */ }
                            Divider()
                            Menu("Combine Masks") {
                                Button("Add Mask from Layer...") { }
                                Button("Subtract Mask from Layer...") { }
                                Button("Intersect Mask from Layer...") { }
                            }
                            Button("Copy Mask from Layer...") { }
                            Divider()
                            Button("Refine Edge...") { isRefineExpanded = true }
                            Divider()
                            Button("Delete Layer", role: .destructive) { removeLayer() }
                        }
                    }
                }
                .background(Color.black.opacity(0.2))
                .cornerRadius(4)
                
                // Heal & Clone Tool Header Buttons
                if let activeLayer = variant.activeLayer, (activeLayer.type == .heal || activeLayer.type == .clone) {
                    Divider().background(Color.white.opacity(0.1))
                    HStack {
                        Button(action: {
                            print("[RetouchEngine] Auto-Pick Source triggered")
                            if let firstArrow = activeLayer.repairArrows.first {
                                // Simulate calling the engine
                                _ = RetouchEngine.shared.autoPickSource(for: firstArrow.destinationPoint, in: variant.image as Any)
                            }
                        }) {
                            Text("Auto-Pick Source")
                                .font(.system(size: 11, weight: .medium))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 4)
                                .background(CaptureOneTheme.Colors.buttonBackground)
                                .cornerRadius(4)
                        }
                        .buttonStyle(.plain)
                        
                        Button(action: {
                            controller.resetRetouching()
                        }) {
                            Image(systemName: "arrow.uturn.backward")
                                .font(.system(size: 11, weight: .medium))
                                .frame(height: 18)
                                .padding(.horizontal, 6)
                                .background(CaptureOneTheme.Colors.buttonBackground)
                                .cornerRadius(4)
                        }
                        .buttonStyle(.plain)
                        .help("Reset All Layers")
                    }
                    .padding(.horizontal, 4)
                }
                
                // Toolbar
                HStack {
                    Menu {
                        Button("New Empty Layer", action: addLayer)
                        Button("New Heal Layer") { addLayer(type: .heal) }
                        Button("New Clone Layer") { addLayer(type: .clone) }
                        Divider()
                        Button("Select Subject") { /* logic */ }
                        Button("Select Background") { /* logic */ }
                        Menu("Select People") {
                            Button("All People") { /* logic */ }
                            Divider()
                            Button("Skin") { /* logic */ }
                            Button("Hair") { /* logic */ }
                            Button("Eyes") { /* logic */ }
                        }
                        Button("Select Clothes") { /* logic */ }
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 12, weight: .bold))
                    }
                    .menuStyle(BorderlessButtonMenuStyle())
                    .frame(width: 24)
                    
                    Button(action: removeLayer) {
                        Image(systemName: "minus")
                            .font(.system(size: 12, weight: .bold))
                    }
                    .disabled(variant.layers.count <= 1 || selectedLayerIndex == 0) // Can't delete background
                    
                    Button(action: {
                        isCombineMasksPresented = true
                    }) {
                        Image(systemName: "plus.forwardslash.minus") // Represents combining
                            .font(.system(size: 11, weight: .medium))
                    }
                    .help("Combine Masks")
                    .disabled(variant.layers.count < 2) // Need at least background and one mask
                    .popover(isPresented: $isCombineMasksPresented) {
                        CombineMasksModal(variant: variant, isPresented: $isCombineMasksPresented)
                    }
                    
                    Spacer()
                    
                    if let activeLayer = variant.activeLayer {
                        HStack(spacing: 4) {
                            Text("\(Int(activeLayer.opacity * 100))")
                                .font(.system(size: 10, design: .monospaced))
                                .foregroundColor(.gray)
                                .frame(width: 20)
                            Slider(value: Binding(
                                get: { Double(activeLayer.opacity) },
                                set: { activeLayer.opacity = Float($0); variant.isModified = true }
                            ), in: 0...1)
                            .frame(width: 60)
                        }
                    }
                }
                .padding(.top, 4)
                
                // Refine Section (GAP-404)
                VStack(spacing: 4) {
                    Button(action: { withAnimation { isRefineExpanded.toggle() } }) {
                        HStack {
                            Image(systemName: isRefineExpanded ? "chevron.down" : "chevron.right")
                                .font(.system(size: 8, weight: .bold))
                            Text("Refine Mask")
                                .font(.system(size: 11, weight: .semibold))
                            Spacer()
                        }
                    }
                    .buttonStyle(.plain)
                    
                    if isRefineExpanded {
                        VStack(spacing: 8) {
                            HStack {
                                Text("Refine Edge").font(.system(size: 10)).foregroundColor(.gray).frame(width: 65, alignment: .leading)
                                Slider(value: $controller.maskRefineEdge, in: 0...100)
                                    .accentColor(CaptureOneTheme.Colors.activeHighlight)
                                Text("\(Int(controller.maskRefineEdge))").font(.system(size: 10, design: .monospaced)).frame(width: 25, alignment: .trailing)
                            }
                            
                            HStack {
                                Text("Feather").font(.system(size: 10)).foregroundColor(.gray).frame(width: 65, alignment: .leading)
                                Slider(value: $controller.maskFeather, in: 0...100)
                                    .accentColor(CaptureOneTheme.Colors.activeHighlight)
                                Text("\(Int(controller.maskFeather))").font(.system(size: 10, design: .monospaced)).frame(width: 25, alignment: .trailing)
                            }
                        }
                        .padding(.leading, 12)
                        .padding(.top, 4)
                    }
                }
                .padding(.top, 4)
            }
        }
    }
    
    private func maskModeButton(mode: Int, icon: String, tooltip: String) -> some View {
        Button(action: { controller.maskVisibilityMode = mode }) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(controller.maskVisibilityMode == mode ? CaptureOneTheme.Colors.activeHighlight : .gray)
        }
        .buttonStyle(.plain)
        .help(tooltip)
    }
    
    private func addLayer() {
        addLayer(withMask: nil, name: "Adjustment Layer \(variant.layers.count)")
    }
    
    private func addLayer(type: LayerBase.LayerType) {
        let name = type == .heal ? "Heal Layer" : "Clone Layer"
        let newLayer = LayerBase(
            uuid: UUID().uuidString,
            name: "\(name) \(variant.layers.count)",
            type: type,
            context: variant.managedObjectContext
        )
        variant.layers.append(newLayer)
        variant.isModified = true
    }
    
    private func addLayer(withMask mask: [Float]?, name: String) {
        let newLayer = LayerBase(
            uuid: UUID().uuidString,
            name: name,
            type: .adjustment,
            context: variant.managedObjectContext
        )
        // In original, the mask buffer is associated with the layer
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

// MARK: - Combine Masks Modal
struct CombineMasksModal: View {
    @ObservedObject var variant: VariantBase
    @Binding var isPresented: Bool
    
    @State private var selectedLayerIDs: Set<String> = []
    @State private var operationType: Int = 0 // 0: Union (Or), 1: Intersection (And), 2: Subtract
    @State private var createNewLayer: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Combine Masks")
                .font(.headline)
            
            // Layer Selection List
            VStack(alignment: .leading, spacing: 4) {
                Text("Select masks to combine:")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                ScrollView {
                    VStack(spacing: 2) {
                        ForEach(variant.layers.filter { $0.type != .background }, id: \.id) { layer in
                            HStack {
                                let isSelected = selectedLayerIDs.contains(layer.id)
                                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                                    .foregroundColor(isSelected ? CaptureOneTheme.Colors.activeHighlight : .gray)
                                    .onTapGesture {
                                        if isSelected {
                                            selectedLayerIDs.remove(layer.id)
                                        } else {
                                            selectedLayerIDs.insert(layer.id)
                                        }
                                    }
                                Text(layer.name)
                                    .font(.system(size: 11))
                                Spacer()
                            }
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(4)
                        }
                    }
                }
                .frame(maxHeight: 150)
            }
            
            // Logic Selection
            VStack(alignment: .leading, spacing: 4) {
                Text("Operation:")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Picker("", selection: $operationType) {
                    Text("Add (Or)").tag(0)
                    Text("Intersect (And)").tag(1)
                    Text("Subtract").tag(2)
                }
                .pickerStyle(.segmented)
                .labelsHidden()
            }
            
            // Options
            Toggle("Create new layer", isOn: $createNewLayer)
                .font(.system(size: 11))
                .toggleStyle(CheckboxToggleStyle())
            
            Divider().background(Color.white.opacity(0.1))
            
            // Action Buttons
            HStack {
                Button("Cancel") {
                    isPresented = false
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.1))
                .cornerRadius(4)
                
                Spacer()
                
                Button("Combine") {
                    performCombine()
                    isPresented = false
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(CaptureOneTheme.Colors.activeHighlight)
                .foregroundColor(.black)
                .cornerRadius(4)
                .disabled(selectedLayerIDs.isEmpty || (operationType != 0 && selectedLayerIDs.count < 2))
            }
        }
        .padding(16)
        .frame(width: 300)
    }
    
    private func performCombine() {
        print("[Masks] Combining \(selectedLayerIDs.count) masks with operation \(operationType)")
        
        let targetLayerName = "Combined Mask"
        
        if createNewLayer {
            let newLayer = LayerBase(uuid: UUID().uuidString, name: targetLayerName, type: .adjustment, context: nil)
            variant.layers.insert(newLayer, at: 0)
            variant.activeLayerIndex = 0
            // In a real implementation, the mask array/bitmap would be combined using the ImageCore blending engine.
            print("[Masks] Created new layer: \(targetLayerName)")
        } else {
            // Apply to first selected
            if let firstID = selectedLayerIDs.first, let layer = variant.layers.first(where: { $0.id == firstID }) {
                print("[Masks] Applied combination directly to layer: \(layer.name)")
            }
        }
    }
}
