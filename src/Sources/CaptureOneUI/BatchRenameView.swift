import SwiftUI
import AppCoreShared

/// Reconstructed Batch Rename Modal/Sidebar View (UI-204).
/// Features "pill" token visualization and real-time preview.
public struct BatchRenameView: View {
    @ObservedObject var controller: COBatchRenameController
    
    // Selection from Browser (Reconstructed placeholder)
    var selectedVariants: [VariantBase] = []
    
    public init(controller: COBatchRenameController, selectedVariants: [VariantBase] = []) {
        self.controller = controller
        self.selectedVariants = selectedVariants
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Batch Rename")
                .font(.headline)
                .padding(.bottom, 4)
            
            // Format / Token Field
            VStack(alignment: .leading, spacing: 6) {
                Text("Format").font(.system(size: 11)).foregroundColor(.gray)
                
                // Token "Pill" Area
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        ForEach(controller.tokens) { token in
                            TokenPillView(token: token) {
                                // Action: remove token
                                controller.tokens.removeAll { $0.id == token.id }
                            }
                        }
                        
                        // Add Token Button
                        Button(action: {
                            // Show Token Picker (Simplified: add a default token)
                            controller.tokens.append(CaptureNamingToken(name: "Image Name", type: .imageName))
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(6)
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(4)
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.white.opacity(0.1), lineWidth: 1))
                }
                .frame(minHeight: 34)
            }
            
            // Job Name
            VStack(alignment: .leading, spacing: 6) {
                Text("Job Name").font(.system(size: 11)).foregroundColor(.gray)
                TextField("Enter Job Name", text: $controller.jobName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            // Counter Settings
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Counter Start").font(.system(size: 11)).foregroundColor(.gray)
                    Stepper("\(controller.startCounter)", value: $controller.startCounter, in: 1...100000)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Counter Step").font(.system(size: 11)).foregroundColor(.gray)
                    Stepper("\(controller.counterStep)", value: $controller.counterStep, in: 1...100)
                }
            }
            
            Divider()
            
            // Preview List
            VStack(alignment: .leading, spacing: 6) {
                Text("Preview").font(.system(size: 11)).foregroundColor(.gray)
                List {
                    ForEach(0..<min(selectedVariants.count, 5), id: \.self) { index in
                        HStack {
                            Text(selectedVariants[index].name ?? "Untitled")
                                .foregroundColor(.gray)
                            Image(systemName: "arrow.right")
                                .font(.system(size: 10))
                                .foregroundColor(.blue)
                            Text(controller.previewNames.indices.contains(index) ? controller.previewNames[index] : "---")
                                .bold()
                        }
                        .font(.system(size: 11))
                    }
                    if selectedVariants.count > 5 {
                        Text("... and \(selectedVariants.count - 5) more")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                    }
                }
                .frame(height: 120)
                .listStyle(PlainListStyle())
                .background(Color.black.opacity(0.1))
                .cornerRadius(4)
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Button("Cancel") {
                    // Dismiss logic
                }
                .buttonStyle(.plain)
                .padding(.trailing, 10)
                
                Button("Rename") {
                    controller.execute(on: selectedVariants)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(4)
            }
        }
        .padding()
        .frame(width: 400, height: 500)
        .onAppear {
            controller.updatePreview(for: selectedVariants)
        }
        .onChange(of: controller.tokens) { _ in controller.updatePreview(for: selectedVariants) }
        .onChange(of: controller.startCounter) { _ in controller.updatePreview(for: selectedVariants) }
        .onChange(of: controller.counterStep) { _ in controller.updatePreview(for: selectedVariants) }
        .onChange(of: controller.jobName) { _ in controller.updatePreview(for: selectedVariants) }
    }
}

/// Helper view for Token Pills
struct TokenPillView: View {
    let token: CaptureNamingToken
    var onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text(token.name)
                .font(.system(size: 11, weight: .medium))
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 10))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.blue.opacity(0.8))
        .foregroundColor(.white)
        .cornerRadius(12)
    }
}
