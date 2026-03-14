import Cocoa
import SwiftUI
import AppCoreShared
import ImageCore
import DataCore

/// Standalone Window Controller for the Culling window (WS-103).
/// Features specialized AI-based grouping and face focus checking.
public class CullingShellController: NSWindowController {
    
    private var session: SessionBase
    
    public init(session: SessionBase) {
        self.session = session
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1200, height: 800),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.title = "Cull View"
        window.center()
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        window.backgroundColor = NSColor(calibratedWhite: 0.08, alpha: 1.0)
        
        super.init(window: window)
        
        let contentView = CullViewRootView(session: session)
        window.contentView = NSHostingView(rootView: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate struct CullViewRootView: View {
    let session: SessionBase
    @ObservedObject var commands = AppCommandCenter.shared
    @ObservedObject var controller = AdjustmentToolController.shared
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Toolbar
            cullToolbar
            
            HStack(spacing: 0) {
                // 1. Grouping Sidebar (Left)
                groupingSidebar
                    .frame(width: 240)
                
                Divider().background(Color.black)
                
                // 2. Main Center Area
                VStack(spacing: 0) {
                    ZStack {
                        // Central Viewer
                        if let variant = controller.currentVariant, let image = variant.image {
                            COViewerView(image: image, adjustmentController: controller)
                        } else {
                            Text("No Image Selected")
                                .foregroundColor(.gray)
                        }
                        
                        // Face Focus Overlay (Top Right)
                        if commands.showCullingFaceFocus {
                            VStack {
                                HStack {
                                    Spacer()
                                    FaceFocusPanel()
                                        .frame(width: 200, height: 200)
                                        .padding(16)
                                }
                                Spacer()
                            }
                        }
                        
                        // Shortcuts Hint (Bottom Right)
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Text("1-5: Rate  •  0: Clear  •  Arrows: Nav")
                                    .font(.system(size: 10))
                                    .padding(6)
                                    .background(Color.black.opacity(0.6))
                                    .cornerRadius(4)
                                    .padding(16)
                            }
                        }
                    }
                    
                    Divider().background(Color.black)
                    
                    // 3. Group Filmstrip (Bottom)
                    groupFilmstrip
                        .frame(height: 120)
                }
            }
        }
        .background(Color(white: 0.05))
        .preferredColorScheme(.dark)
    }
    
    private var cullToolbar: some View {
        HStack {
            Text("CULL VIEW")
                .font(.system(size: 11, weight: .black))
                .foregroundColor(.white.opacity(0.8))
                .padding(.leading, 16)
            
            Spacer()
            
            Button("Done") {
                NSApp.keyWindow?.close()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
            .tint(CaptureOneTheme.Colors.activeHighlight)
            .padding(.trailing, 12)
        }
        .frame(height: 40)
        .background(Color(white: 0.12))
    }
    
    private var groupingSidebar: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("GROUPING")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.gray)
            
            Toggle("Enable Groups", isOn: $commands.isGroupingEnabled)
                .font(.system(size: 12))
            
            if commands.isGroupingEnabled {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Similarity").font(.system(size: 11))
                    Slider(value: $commands.groupSimilarity, in: 0...1)
                        .accentColor(CaptureOneTheme.Colors.activeHighlight)
                }
                
                Divider().background(Color.white.opacity(0.1))
                
                // Group List (Mock)
                ScrollView {
                    VStack(spacing: 2) {
                        groupRow(name: "Group 1", count: 12, isSelected: true)
                        groupRow(name: "Group 2", count: 5, isSelected: false)
                        groupRow(name: "Group 3", count: 24, isSelected: false)
                    }
                }
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color(white: 0.1))
    }
    
    private var groupFilmstrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(0..<10, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.white.opacity(0.05))
                        .frame(width: 80, height: 100)
                        .cornerRadius(4)
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.gray.opacity(0.3))
                        )
                }
            }
            .padding(.horizontal, 12)
        }
        .background(Color(white: 0.08))
    }
    
    private func groupRow(name: String, count: Int, isSelected: Bool) -> some View {
        HStack {
            Text(name).font(.system(size: 12))
            Spacer()
            Text("\(count)").font(.system(size: 10)).foregroundColor(.gray)
        }
        .padding(8)
        .background(isSelected ? CaptureOneTheme.Colors.activeHighlight.opacity(0.2) : Color.clear)
        .cornerRadius(4)
    }
}

struct FaceFocusPanel: View {
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color.black
                // Simulated zoom to face
                Image(systemName: "person.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.gray.opacity(0.5))
                
                VStack {
                    Spacer()
                    HStack {
                        Text("100% FACE FOCUS").font(.system(size: 9, weight: .bold))
                        Spacer()
                    }
                    .padding(4)
                    .background(Color.black.opacity(0.6))
                }
            }
            .aspectRatio(1.0, contentMode: .fit)
            .cornerRadius(4)
            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.white.opacity(0.2), lineWidth: 1))
            
            HStack {
                Text("EYE").font(.system(size: 9, weight: .bold))
                Spacer()
                Image(systemName: "checkmark.circle.fill").font(.system(size: 10))
            }
            .padding(6)
            .background(Color.black.opacity(0.4))
        }
    }
}
