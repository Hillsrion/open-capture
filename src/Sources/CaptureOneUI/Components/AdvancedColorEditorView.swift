import SwiftUI
import AppCoreShared
import ImageCore

/// Reconstructed high-fidelity Color Editor Tool (UI-004).
/// Matches Capture One 16.7.4 with Basic, Advanced, and Skin Tone tabs.

public struct AdvancedColorEditorView: View {
    @ObservedObject var controller: AdjustmentToolController
    @State private var selectedTab: Int = 0 // 0: Basic, 1: Advanced, 2: Skin Tone
    
    public init(controller: AdjustmentToolController) {
        self.controller = controller
    }
    
    public var body: some View {
        COToolSection("Color Editor", toolID: "SelectiveColorControl") {
            VStack(spacing: 10) {
                // Tab Picker
                Picker("", selection: $selectedTab) {
                    Text("Basic").tag(0)
                    Text("Advanced").tag(1)
                    Text("Skin Tone").tag(2)
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                .scaleEffect(0.9)
                
                tabContent
            }
            .padding(.vertical, 4)
        }
    }
    
    @ViewBuilder
    private var tabContent: some View {
        if selectedTab == 1 {
            advancedTab
        } else if selectedTab == 2 {
            skinToneTab
        } else {
            basicTab
        }
    }
    
    // MARK: - Basic Tab
    private var basicTab: some View {
        VStack(spacing: 8) {
            colorWheelView
            
            VStack(spacing: 6) {
                sliderRow(label: "Hue", value: .constant(0), range: -30...30)
                sliderRow(label: "Sat", value: .constant(0), range: -100...100)
                sliderRow(label: "Light", value: .constant(0), range: -100...100)
            }
        }
    }
    
    private var colorWheelView: some View {
        ZStack {
            Circle().fill(
                AngularGradient(gradient: Gradient(colors: [.red, .yellow, .green, .cyan, .blue, .purple, .red]), center: .center)
            )
            .frame(width: 120, height: 120)
            .opacity(0.8)
            .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1))
            
            // Color sector indicators
            ForEach(0..<8) { i in
                Circle()
                    .fill(Color.white)
                    .frame(width: 4, height: 4)
                    .offset(y: -50)
                    .rotationEffect(.degrees(Double(i) * 45))
            }
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - Advanced Tab
    private var advancedTab: some View {
        VStack(alignment: .leading, spacing: 10) {
            if controller.colorCorrections.isEmpty {
                Text("No color corrections added.")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                correctionList
            }
            
            HStack {
                Button(action: {}) { Image(systemName: "plus") }
                Button(action: {}) { Image(systemName: "minus") }
                Spacer()
                Button("Invert") {}.buttonStyle(.bordered).controlSize(.small)
            }
            .buttonStyle(.plain)
        }
    }
    
    private var correctionList: some View {
        ScrollView {
            VStack(spacing: 1) {
                ForEach(controller.colorCorrections, id: \.id) { correction in
                    correctionRow(for: correction)
                }
            }
        }
        .frame(height: 100)
        .background(Color.black.opacity(0.2))
        .cornerRadius(4)
    }
    
    private func correctionRow(for correction: IC_ColorCorrection) -> some View {
        HStack {
            Circle().fill(Color.red).frame(width: 10, height: 10)
            Text("Correction \(String(correction.id.uuidString.prefix(4)))").font(.system(size: 11))
            Spacer()
            Toggle("", isOn: .constant(true)).labelsHidden().controlSize(.small)
        }
        .padding(.horizontal, 8)
        .frame(height: 24)
        .background(Color.white.opacity(0.05))
    }
    
    // MARK: - Skin Tone Tab
    private var skinToneTab: some View {
        VStack(spacing: 8) {
            Text("Uniformity")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 6) {
                sliderRow(label: "Hue", value: .constant(0), range: 0...100)
                sliderRow(label: "Sat", value: .constant(0), range: 0...100)
                sliderRow(label: "Light", value: .constant(0), range: 0...100)
            }
        }
    }
    
    private func sliderRow(label: String, value: Binding<Float>, range: ClosedRange<Float>) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                .frame(width: 40, alignment: .leading)
            Slider(value: value, in: range)
                .accentColor(CaptureOneTheme.Colors.activeHighlight)
            Text("\(Int(value.wrappedValue))")
                .font(.system(size: 10, design: .monospaced))
                .frame(width: 30, alignment: .trailing)
        }
    }
}
