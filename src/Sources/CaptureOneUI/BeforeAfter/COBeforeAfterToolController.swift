import SwiftUI
import Combine

/// Reconstructed controller for managing the Before/After comparison tool (UI-013).
/// Decouples comparison state from AppCommandCenter for high-fidelity tool parity.
public final class COBeforeAfterToolController: ObservableObject {
    public static let shared = COBeforeAfterToolController()
    
    public enum Mode: Int {
        case fullView = 0
        case splitScreen = 1
    }
    
    @Published public var isEnabled: Bool = false
    @Published public var mode: Mode = .fullView
    @Published public var splitPosition: Double = 0.5
    @Published public var isLongPressingBefore: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        // Sync with AppCommandCenter for legacy parity if needed
        // But the goal is to migrate to this specialized controller
    }
    
    public func toggle() {
        isEnabled.toggle()
    }
    
    public func setMode(_ mode: Mode) {
        self.mode = mode
        if !isEnabled { isEnabled = true }
    }
}
