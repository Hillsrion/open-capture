import Foundation

/// Represents a single state in the history stack.
public struct COHistoryItem: Identifiable, Equatable {
    public let id = UUID()
    public let timestamp: Date
    public let name: String
    public let properties: [String: Any]
    
    public init(name: String, properties: [String: Any]) {
        self.name = name
        self.properties = properties
        self.timestamp = Date()
    }
    
    public static func == (lhs: COHistoryItem, rhs: COHistoryItem) -> Bool {
        lhs.id == rhs.id
    }
}

/// Reconstructed history stack for non-destructive adjustments (UI-013).
public class COHistoryStack {
    private var stack: [COHistoryItem] = []
    private var currentIndex: Int = -1
    private let maxDepth: Int = 100
    
    public var canUndo: Bool {
        currentIndex > 0
    }
    
    public var canRedo: Bool {
        currentIndex < stack.count - 1
    }
    
    public init() {}
    
    public func push(item: COHistoryItem) {
        // If we are not at the end of the stack, remove all items after currentIndex
        if currentIndex < stack.count - 1 {
            stack.removeSubrange((currentIndex + 1)..<stack.count)
        }
        
        stack.append(item)
        
        // Enforce max depth
        if stack.count > maxDepth {
            stack.removeFirst()
        }
        
        currentIndex = stack.count - 1
    }
    
    public func undo() -> COHistoryItem? {
        guard canUndo else { return nil }
        currentIndex -= 1
        return stack[currentIndex]
    }
    
    public func redo() -> COHistoryItem? {
        guard canRedo else { return nil }
        currentIndex += 1
        return stack[currentIndex]
    }
    
    public func clear() {
        stack.removeAll()
        currentIndex = -1
    }
}
