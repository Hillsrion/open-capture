import Foundation
import ImageCore

public enum COBooleanMaskOperator: Int {
    case add = 0
    case intersect = 1
    case subtract = 2
}

public class COMaskCompositionEngine {
    
    public static func combine(mask1: [Float]?, mask2: [Float]?, operation: COBooleanMaskOperator) -> [Float]? {
        guard let m1 = mask1 else {
            if operation == .intersect {
                return mask2 != nil ? [Float](repeating: 0.0, count: mask2!.count) : nil
            }
            if operation == .subtract {
                return mask2 != nil ? [Float](repeating: 0.0, count: mask2!.count) : nil
            }
            return mask2
        }
        guard let m2 = mask2 else {
            if operation == .intersect {
                return [Float](repeating: 0.0, count: m1.count)
            }
            return m1
        }
        
        let count = min(m1.count, m2.count)
        guard count > 0 else { return nil }
        var result = [Float](repeating: 0.0, count: count)
        
        for i in 0..<count {
            switch operation {
            case .add:
                result[i] = min(1.0, m1[i] + m2[i])
            case .intersect:
                result[i] = min(m1[i], m2[i]) // using min for intersection of masks (0..1)
            case .subtract:
                result[i] = max(0.0, m1[i] - m2[i])
            }
        }
        return result
    }
}
