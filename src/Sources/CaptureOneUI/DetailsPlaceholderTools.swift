import SwiftUI
import AppCoreShared
import DataCore

// MARK: - Navigator (UI-203)
public struct NavigatorToolView: View {
    public init() {}
    
    public var body: some View {
        COToolSection("Navigator") {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.black.opacity(0.3))
                        .aspectRatio(1.5, contentMode: .fit)
                    
                    VStack {
                        Image(systemName: "photo")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                        Text("No Image")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                    }
                }
                .cornerRadius(4)
                
                HStack {
                    Text("Fit")
                        .font(.system(size: 10))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    Spacer()
                    Text("100%")
                        .font(.system(size: 10))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                }
                .padding(.horizontal, 4)
                .padding(.top, 4)
            }
            .padding(.vertical, 4)
        }
    }
}

// MARK: - Focus (UI-203)
public struct FocusToolView: View {
    public init() {}
    
    public var body: some View {
        COToolSection("Focus") {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.black.opacity(0.3))
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(maxWidth: .infinity)
                    
                    VStack {
                        Image(systemName: "viewfinder")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                        Text("100% Focus")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                    }
                }
                .cornerRadius(4)
            }
            .padding(.vertical, 4)
        }
    }
}

// MARK: - Spot Removal (UI-203)
public struct SpotRemovalToolView: View {
    public init() {}
    
    public var body: some View {
        COToolSection("Spot Removal") {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Type")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    Spacer()
                    Picker("", selection: .constant(0)) {
                        Text("Dust").tag(0)
                        Text("Spot").tag(1)
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .frame(width: 80)
                }
                
                List {
                    Text("No spots added")
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 8)
                }
                .frame(height: 60)
                .listStyle(.plain)
                .background(Color.black.opacity(0.2))
                .cornerRadius(4)
                
                HStack {
                    Button(action: {}) { Image(systemName: "plus") }
                    Button(action: {}) { Image(systemName: "minus") }
                }
                .buttonStyle(.plain)
            }
            .padding(.vertical, 4)
        }
    }
}

// MARK: - Lens Color Corrections (UI-203)
public struct LensColorCorrectionsToolView: View {
    public init() {}
    
    public var body: some View {
        COToolSection("Lens Correction") {
            VStack(spacing: 8) {
                HStack {
                    Text("Purple Fringing")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                        .frame(width: 100, alignment: .leading)
                    Slider(value: .constant(0), in: 0...100)
                    Text("0")
                        .font(.system(size: 11, design: .monospaced))
                        .frame(width: 24, alignment: .trailing)
                }
            }
            .padding(.vertical, 4)
        }
    }
}

// MARK: - Moire (UI-203)
public struct MoireToolView: View {
    @ObservedObject var controller: AdjustmentToolController
    
    public init(controller: AdjustmentToolController) {
        self.controller = controller
    }
    
    public var body: some View {
        COToolSection("Moiré") {
            VStack(spacing: 8) {
                HStack {
                    Text("Amount")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                        .frame(width: 60, alignment: .leading)
                    Slider(value: Binding(
                        get: { controller.moireAmount },
                        set: { controller.moireAmount = $0 }
                    ), in: 0...100)
                    Text("\(Int(controller.moireAmount))")
                        .font(.system(size: 11, design: .monospaced))
                        .frame(width: 30, alignment: .trailing)
                }
                
                HStack {
                    Text("Pattern")
                        .font(.system(size: 11))
                        .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                        .frame(width: 60, alignment: .leading)
                    Slider(value: Binding(
                        get: { controller.moirePattern },
                        set: { controller.moirePattern = $0 }
                    ), in: 0...100)
                    Text("\(Int(controller.moirePattern))")
                        .font(.system(size: 11, design: .monospaced))
                        .frame(width: 30, alignment: .trailing)
                }
            }
            .padding(.vertical, 4)
        }
    }
}
