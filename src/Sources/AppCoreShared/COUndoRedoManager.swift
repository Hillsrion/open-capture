import Foundation
import Combine

/// Manager for Global and Local Adjustment History (UI-013).
public class COUndoRedoManager: ObservableObject {
    public static let shared = COUndoRedoManager()
    
    @Published public private(set) var canUndo: Bool = false
    @Published public private(set) var canRedo: Bool = false
    
    // Per-variant history stacks
    private var historyStacks: [String: COHistoryStack] = [:]
    
    private init() {}
    
    public func stack(for variant: VariantBase) -> COHistoryStack {
        if let stack = historyStacks[variant.variantUUID] {
            return stack
        }
        let stack = COHistoryStack()
        historyStacks[variant.variantUUID] = stack
        return stack
    }
    
    public func pushState(for variant: VariantBase, actionName: String) {
        guard let mc = variant.mcVariant else { return }
        
        let item = COHistoryItem(name: actionName, properties: mc.properties)
        let stack = self.stack(for: variant)
        stack.push(item: item)
        
        updateState()
    }
    
    public func undo(for variant: VariantBase) {
        let stack = self.stack(for: variant)
        if let item = stack.undo() {
            applyState(item, to: variant)
        }
        updateState()
    }
    
    public func redo(for variant: VariantBase) {
        let stack = self.stack(for: variant)
        if let item = stack.redo() {
            applyState(item, to: variant)
        }
        updateState()
    }
    
    private func applyState(_ item: COHistoryItem, to variant: VariantBase) {
        guard let mc = variant.mcVariant else { return }
        
        mc.properties = item.properties
        variant.isModified = true
        
        // Post notification for UI refresh
        NotificationCenter.default.post(name: .COUndoRedoDidUpdate, object: variant)
    }
    
    private func updateState() {
        // Global state based on whatever is active, or we could just use observers.
        // For simplicity, we trigger the Published properties change.
        objectWillChange.send()
    }
}

extension Notification.Name {
    public static let COUndoRedoDidUpdate = Notification.Name("COUndoRedoDidUpdate")
}
