import Foundation
import Combine

/// Reconstructed Data Model for Magic Brush settings (AI-001).
/// Based on disassembly of MagicBrushSettings.
public class MagicBrushSettings: ObservableObject {
    @Published public var size: Double = 50.0
    @Published public var tolerance: Double = 20.0
    @Published public var refineEdge: Double = 0.0
    @Published public var opacity: Double = 100.0
    @Published public var flow: Double = 100.0
    @Published public var sampleEntirePhoto: Bool = false
    
    // Sampled color from the initial click
    @Published public var sampledColor: [Float]? // RGB 0.0-1.0
    
    public init() {}
    
    public func sync(with other: MagicBrushSettings) {
        self.size = other.size
        self.tolerance = other.tolerance
        self.refineEdge = other.refineEdge
        self.opacity = other.opacity
        self.flow = other.flow
        self.sampleEntirePhoto = other.sampleEntirePhoto
    }
}
