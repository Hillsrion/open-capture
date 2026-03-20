import SwiftUI
import AppCoreShared
import UniformTypeIdentifiers

/// Reconstructed high-fidelity Overlay tool (Composition Aid) (VrYJW5-34t8).
public struct OverlayToolView: View {
    @ObservedObject var model: COOverlayModel = .shared
    @ObservedObject var commands = AppCommandCenter.shared
    @State private var isTargeted: Bool = false
    
    public init() {}
    
    public var body: some View {
        COToolSection("Overlay", toolID: "Overlay") {
            VStack(spacing: 12) {
                // 1. Show Overlay & Drop Area
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Toggle("Show Overlay", isOn: $model.showOverlay)
                            .font(.system(size: 11))
                        Spacer()
                        
                        Button(action: {
                            let panel = NSOpenPanel()
                            panel.allowsMultipleSelection = false
                            panel.canChooseDirectories = false
                            panel.allowedContentTypes = [.image, .pdf]
                            if panel.runModal() == .OK {
                                model.imagePath = panel.url?.path ?? ""
                                model.showOverlay = true
                            }
                        }) {
                            Text("Choose...")
                                .font(.system(size: 10))
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                    }
                    
                    // Drop Area
                    ZStack {
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(isTargeted ? CaptureOneTheme.Colors.activeHighlight : Color.white.opacity(0.1), style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
                            .background(Color.white.opacity(0.02))
                        
                        VStack(spacing: 4) {
                            if model.imagePath.isEmpty {
                                Image(systemName: "plus.square.dashed")
                                    .font(.system(size: 24))
                                    .foregroundColor(.gray)
                                Text("Drop JPEG/PNG/PDF here")
                                    .font(.system(size: 10))
                                    .foregroundColor(.gray)
                            } else {
                                if let img = model.overlayImage {
                                    Image(nsImage: img)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxHeight: 60)
                                        .cornerRadius(4)
                                }
                                Text(model.imagePath.split(separator: "/").last.map(String.init) ?? "")
                                    .font(.system(size: 10, design: .monospaced))
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                            }
                        }
                        .padding(8)
                    }
                    .frame(height: 80)
                    .onDrop(of: [.fileURL], isTargeted: $isTargeted) { providers in
                        guard let provider = providers.first else { return false }
                        provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { (urlData, error) in
                            if let data = urlData as? Data, let url = URL(dataRepresentation: data, relativeTo: nil) {
                                DispatchQueue.main.async {
                                    model.imagePath = url.path
                                    model.showOverlay = true
                                }
                            }
                        }
                        return true
                    }
                }
                
                // 2. Sliders
                VStack(spacing: 6) {
                    overlaySlider(label: "Opacity", value: $model.opacity, range: 0...100, unit: "%")
                    overlaySlider(label: "Scale", value: $model.scale, range: 1...200, unit: "%")
                    overlaySlider(label: "Horizontal", value: Binding(get: { Double(model.offset.x) }, set: { model.offset.x = CGFloat($0) }), range: -1000...1000, unit: "px")
                    overlaySlider(label: "Vertical", value: Binding(get: { Double(model.offset.y) }, set: { model.offset.y = CGFloat($0) }), range: -1000...1000, unit: "px")
                }
                
                // 3. Toolbar Tools
                HStack(spacing: 8) {
                    // Move Overlay Tool Toggle
                    Button(action: { 
                        commands.selectedCursorToolID = commands.selectedCursorToolID == "MoveOverlay" ? "Select" : "MoveOverlay"
                    }) {
                        Image(systemName: "arrow.up.and.down.and.arrow.left.and.right")
                            .frame(width: 24, height: 24)
                            .background(commands.selectedCursorToolID == "MoveOverlay" ? CaptureOneTheme.Colors.activeHighlight : Color.white.opacity(0.05))
                            .cornerRadius(4)
                            .foregroundColor(commands.selectedCursorToolID == "MoveOverlay" ? .black : .white)
                    }
                    .help("Move Overlay Tool (H)")
                    
                    // Center Overlay (Crosshair)
                    Button(action: { model.centerOverlay() }) {
                        Image(systemName: "scope")
                            .frame(width: 24, height: 24)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(4)
                    }
                    .help("Center Overlay")
                    
                    Toggle("Follow Crop", isOn: $model.followCrop)
                        .font(.system(size: 10))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    
                    Spacer()
                }
                .buttonStyle(.plain)
                .imageScale(.small)
            }
            .padding(.vertical, 4)
        }
    }
    
    private func overlaySlider(label: String, value: Binding<Double>, range: ClosedRange<Double>, unit: String) -> some View {
        HStack {
            Text(label).font(.system(size: 11)).foregroundColor(CaptureOneTheme.Colors.textSecondary).frame(width: 65, alignment: .leading)
            Slider(value: value, in: range).accentColor(CaptureOneTheme.Colors.activeHighlight)
            Text("\(Int(value.wrappedValue))\(unit)").font(.system(size: 10, design: .monospaced)).frame(width: 45, alignment: .trailing)
        }
    }
}
