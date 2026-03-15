import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Shortcut Editor (INT-002).
public struct ShortcutEditorView: View {
    @ObservedObject var manager = ShortcutManager.shared
    @State private var recordingActionID: String? = nil
    @State private var searchText: String = ""
    
    var filteredShortcuts: [AppCoreShared.KeyboardShortcut] {
        if searchText.isEmpty {
            return manager.activeSet.shortcuts
        }
        return manager.activeSet.shortcuts.filter {
            $0.actionID.localizedCaseInsensitiveContains(searchText) ||
            $0.displayString.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            COToolSection("Keyboard Shortcuts", toolID: "KeyboardShortcuts") {
                VStack(spacing: 8) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                        TextField("Search Commands...", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                            .font(.system(size: 11))
                        
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 10))
                                    .foregroundColor(.gray)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(6)
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(4)
                    
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
                            ForEach(filteredShortcuts, id: \.actionID) { shortcut in
                                let hasConflict = manager.activeSet.shortcuts.filter { $0.key == shortcut.key && $0.modifiers == shortcut.modifiers }.count > 1
                                
                                HStack {
                                    Text(shortcut.actionID.replacingOccurrences(of: "com.captureone.", with: "").capitalized)
                                        .font(.system(size: 11))
                                        .foregroundColor(hasConflict ? .red : .primary)
                                    
                                    Spacer()
                                    
                                    Button(action: { recordingActionID = shortcut.actionID }) {
                                        Text(recordingActionID == shortcut.actionID ? "Record..." : shortcut.displayString)
                                            .font(.system(size: 10, design: .monospaced))
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(hasConflict ? Color.red.opacity(0.2) : Color.white.opacity(0.1))
                                            .cornerRadius(3)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                .padding(.vertical, 2)
                            }
                        }
                    }
                    .frame(maxHeight: 300)
                }
            }
        }
    }
}
