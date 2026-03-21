import SwiftUI
import AppCoreShared

/// Reconstructed Save Custom Style Dialog (Reference: 0xolTuhFkBk).
/// Allows user to name a new style and select which modified tools to include.
public struct SaveStyleDialog: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var styleName: String = "Untitled Style"
    @State private var selectedTools: Set<String> = []
    
    // In a real app, this would be populated based on the variant's modified tools
    let availableTools = [
        "Exposure", "Contrast", "Brightness", "Saturation",
        "White Balance", "HDR", "Levels", "Curves", "Color Editor",
        "Dehaze", "Vignetting"
    ]
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Save Style")
                    .font(.system(size: 13, weight: .bold))
                Spacer()
            }
            .padding()
            .background(CaptureOneTheme.Colors.panelBackground)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 15) {
                // Name Input
                VStack(alignment: .leading, spacing: 5) {
                    Text("Name")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    TextField("Style Name", text: $styleName)
                        .textFieldStyle(.roundedBorder)
                        .font(.system(size: 11))
                }
                
                Text("Select adjustments to include:")
                    .font(.system(size: 11))
                    .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                
                // Tool Checklist
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(availableTools, id: \.self) { tool in
                            HStack {
                                Toggle("", isOn: Binding(
                                    get: { selectedTools.contains(tool) },
                                    set: { newValue in
                                        if newValue { selectedTools.insert(tool) }
                                        else { selectedTools.remove(tool) }
                                    }
                                ))
                                .toggleStyle(CheckboxToggleStyle())
                                
                                Text(tool)
                                    .font(.system(size: 11))
                                    .foregroundColor(CaptureOneTheme.Colors.textPrimary)
                                Spacer()
                            }
                        }
                    }
                }
                .frame(maxHeight: 200)
                .padding(8)
                .background(Color.black.opacity(0.1))
                .cornerRadius(4)
                
                HStack {
                    Spacer()
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Save") {
                        save()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(CaptureOneTheme.Colors.activeHighlight)
                }
                .font(.system(size: 11))
            }
            .padding()
        }
        .frame(width: 300)
        .background(CaptureOneTheme.Colors.panelBackground)
        .foregroundColor(.white)
        .onAppear {
            // Default to all modified tools selected
            selectedTools = Set(availableTools)
        }
    }
    
    private func save() {
        guard let variant = AdjustmentToolController.shared.currentVariant,
              let mc = variant.mcVariant else { return }
        
        var adjustments: [String: AnyCodable] = [:]
        
        let toolMapping: [String: [String]] = [
            "Exposure": ["ZEXPOSURE"],
            "Contrast": ["ZCONTRAST"],
            "Brightness": ["ZBRIGHTNESS"],
            "Saturation": ["ZSATURATION"],
            "White Balance": ["ZKELVIN", "ZTINT"],
            "HDR": ["ZHIGHLIGHTS", "ZSHADOWS", "ZWHITES", "ZBLACKS"],
            "Dehaze": ["ZDEHAZE_AMOUNT", "ZDEHAZE_SHADOW_HUE"],
            "Vignetting": ["ZVIGNETTING_AMOUNT", "ZVIGNETTING_METHOD"],
            "Levels": ["ZLEVELS_BLACK_RGB", "ZLEVELS_MIDTONE_RGB", "ZLEVELS_WHITE_RGB", "ZLEVELS_TBLACK_RGB", "ZLEVELS_TWHITE_RGB"],
            "Curves": ["ZCURVE_POINTS_RGB"],
            "Color Editor": ["ZBASIC_COLOR_ARRAY"]
        ]
        
        for tool in selectedTools {
            if let keys = toolMapping[tool] {
                for key in keys {
                    if let value = mc.objectForKey(key) {
                        adjustments[key] = AnyCodable(value)
                    }
                }
            }
        }
        
        if !adjustments.isEmpty {
            let newStyle = COStyle(name: styleName, adjustments: adjustments)
            COStyleManager.shared.userCOStyles.styles.append(newStyle)
            print("[SaveStyle] Created new Style '\(styleName)' with \(adjustments.count) adjustments.")
        }
    }
}
