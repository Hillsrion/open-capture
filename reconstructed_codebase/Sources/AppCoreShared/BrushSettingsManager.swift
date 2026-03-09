import Foundation

public enum CursorToolType {
    case drawMask
    case eraseMask
    case heal
    case clone
    case pan
    case select
}

/// Reconstructed manager for coordinating brush properties across cursor tools.
/// Based on decompiled AppCoreShared symbols (v16.5+).
public class BrushSettingsManager {
    public static let shared = BrushSettingsManager()
    
    private init() {}
    
    public func brushSettingsForCursorTool(_ tool: CursorToolType) -> Any? {
        return nil
    }
    
    public func appropriateLayerForCursorTool(_ tool: CursorToolType) -> LayerBase? {
        return nil
    }
    
    public func activeLocalAdjLayerIsAppropriateLayerForCursorTool(_ tool: CursorToolType) -> Bool {
        return false
    }
}
