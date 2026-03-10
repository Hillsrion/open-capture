import SwiftUI
import AppCoreShared

/// Reconstructed high-fidelity Dashboard (Welcome Window) for Capture One 16.7.
/// Based on decompiled PODashboardViewController and visual analysis.
public struct CODashboardView: View {
    @State private var selectedTab: Int = 0
    @State private var showOnStartup: Bool = true
    
    public init() {}
    
    public var body: some View {
        HStack(spacing: 0) {
            // MARK: - Sidebar
            VStack(spacing: 12) {
                Spacer().frame(height: 20)
                
                DashboardSidebarItem(icon: "clock", label: "Recent", isSelected: selectedTab == 0) { selectedTab = 0 }
                DashboardSidebarItem(icon: "photo", label: "Sample Image", isSelected: selectedTab == 1) { selectedTab = 1 }
                DashboardSidebarItem(icon: "questionmark.circle", label: "Get Help", isSelected: selectedTab == 2) { selectedTab = 2 }
                DashboardSidebarItem(icon: "star", label: "What's New", isSelected: selectedTab == 3) { selectedTab = 3 }
                DashboardSidebarItem(icon: "play.circle", label: "Learn", isSelected: selectedTab == 4) { selectedTab = 4 }
                
                Spacer()
            }
            .frame(width: 140)
            .background(Color(white: 0.08))
            
            Divider().background(Color.black)
            
            // MARK: - Main Content Area
            VStack(spacing: 0) {
                mainAreaHeader
                
                Spacer()
                
                if selectedTab == 0 {
                    recentDocumentsArea
                } else {
                    placeholderArea
                }
                
                Spacer()
                
                bottomActionBar
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(CaptureOneTheme.Colors.applicationBackground)
        }
        .preferredColorScheme(.dark)
    }
    
    private var mainAreaHeader: some View {
        HStack {
            Text(selectedTab == 0 ? "Recent" : tabTitle)
                .font(.system(size: 28, weight: .light))
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.horizontal, 40)
        .padding(.top, 40)
    }
    
    private var recentDocumentsArea: some View {
        VStack(spacing: 20) {
            // Empty State (improvised as requested)
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("No Recent Documents")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
            
            Text("Your recently opened Catalogs and Sessions will appear here.")
                .font(.system(size: 13))
                .foregroundColor(.gray.opacity(0.7))
                .multilineTextAlignment(.center)
                .frame(maxWidth: 300)
        }
    }
    
    private var placeholderArea: some View {
        Text("Restoring Content for \(tabTitle)...")
            .foregroundColor(.gray)
    }
    
    private var bottomActionBar: some View {
        VStack(spacing: 0) {
            Divider().background(Color.black.opacity(0.3))
            
            HStack(spacing: 16) {
                Toggle("Show on startup", isOn: $showOnStartup)
                    .toggleStyle(DashboardCheckboxToggleStyle())
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                Spacer()
                
                Button("Open...") {
                    AppCommandCenter.shared.openDocument()
                }
                .buttonStyle(.bordered)
                
                Button("New Session...") {
                    AppCommandCenter.shared.newSession()
                }
                .buttonStyle(.bordered)
                
                Button("New Catalog...") {
                    AppCommandCenter.shared.newCatalog()
                }
                .buttonStyle(.borderedProminent)
                .tint(CaptureOneTheme.Colors.activeHighlight)
            }
            .padding(.horizontal, 24)
            .frame(height: 70)
            .background(Color(white: 0.09))
        }
    }
    
    private var tabTitle: String {
        switch selectedTab {
        case 1: return "Sample Image"
        case 2: return "Get Help"
        case 3: return "What's New"
        case 4: return "Learn"
        default: return "Recent"
        }
    }
}

private struct DashboardSidebarItem: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(label)
                    .font(.system(size: 10, weight: .medium))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 70)
            .foregroundColor(isSelected ? CaptureOneTheme.Colors.activeHighlight : .gray)
            .background(isSelected ? Color.white.opacity(0.05) : Color.clear)
            .overlay(
                Rectangle()
                    .fill(isSelected ? CaptureOneTheme.Colors.activeHighlight : Color.clear)
                    .frame(width: 3),
                alignment: .leading
            )
        }
        .buttonStyle(.plain)
    }
}

private struct DashboardCheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .foregroundColor(configuration.isOn ? CaptureOneTheme.Colors.activeHighlight : .gray)
                .onTapGesture { configuration.isOn.toggle() }
            configuration.label
        }
    }
}
