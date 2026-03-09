import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Shortcut Editor (INT-002).
public struct ShortcutEditorView: View {
    @ObservedObject var manager = ShortcutManager.shared
    @State private var recordingActionID: String? = nil
    
    public var body: some View {
        VStack(spacing: 0) {
            COToolSection("Keyboard Shortcuts") {
                VStack(spacing: 8) {
                    // Set Picker
                    HStack {
                        Text("Current Set").font(.system(size: 11))
                        Spacer()
                        Menu(manager.activeSet.name) {
                            Button("Default") { manager.activeSet = ShortcutManager.createDefaultSet() }
                            Button("Lightroom Legacy") { manager.activeSet = ShortcutManager.createLightroomSet() }
                        }
                        .font(.system(size: 11))
                    }
                    
                    Divider().background(Color.white.opacity(0.1))
                    
                    // Shortcut List
                    ScrollView {
                        VStack(spacing: 4) {
                            ForEach(manager.activeSet.shortcuts, id: \.actionID) { shortcut in
                                HStack {
                                    Text(shortcut.actionID.replacingOccurrences(of: "com.captureone.", with: "").capitalized)
                                        .font(.system(size: 11))
                                    Spacer()
                                    
                                    Button(action: { recordingActionID = shortcut.actionID }) {
                                        Text(recordingActionID == shortcut.actionID ? "Record..." : shortcut.displayString)
                                            .font(.system(size: 10, design: .monospaced))
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(Color.white.opacity(0.1))
                                            .cornerRadius(3)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                .padding(.vertical, 2)
                            }
                        }
                    }
                    .frame(maxHeight: 200)
                }
            }
        }
    }
}
