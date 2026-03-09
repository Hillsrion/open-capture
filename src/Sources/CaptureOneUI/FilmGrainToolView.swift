import SwiftUI
import AppCoreShared
import ImageCore

/// Reconstructed high-fidelity Film Grain tool (ENG-008).
/// Based on disassembly of POFilmGrainToolController.
public struct FilmGrainToolView: View {
    @ObservedObject var controller: AdjustmentToolController
    
    public init(controller: AdjustmentToolController) {
        self.controller = controller
    }
    
    public var body: some View {
        COToolSection("Film Grain") {
            VStack(spacing: 10) {
                // Film Type Picker
                Picker("", selection: $controller.filmGrainType) {
                    Text("Fine Grain").tag(IC_FilmGrainType.fine)
                    Text("Silver Rich").tag(IC_FilmGrainType.silverRich)
                    Text("Soft Grain").tag(IC_FilmGrainType.soft)
                    Text("Cubic").tag(IC_FilmGrainType.cubic)
                }
                .pickerStyle(MenuPickerStyle())
                .font(.system(size: 11))
                .padding(.bottom, 4)
                
                // Sliders
                COUISlider(label: "Amount", value: Binding(get: { Float(controller.filmGrainAmount) }, set: { controller.filmGrainAmount = Double($0) }), range: 0...100)
                COUISlider(label: "Granularity", value: Binding(get: { Float(controller.filmGrainGranularity) }, set: { controller.filmGrainGranularity = Double($0) }), range: 0...100)
                COUISlider(label: "Density", value: Binding(get: { Float(controller.filmGrainDensity) }, set: { controller.filmGrainDensity = Double($0) }), range: 0...100)
            }
        }
    }
}
