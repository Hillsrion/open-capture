import Foundation

/// Reconstructed model for tracking a multi-image merge task (ENG-010).
public class MergeResult: ObservableObject, Identifiable {
    public let id: String = UUID().uuidString
    @Published public var progress: Double = 0.0
    @Published public var status: MergeStatus = .pending
    @Published public var resultDNGPath: String? = nil
    
    public enum MergeStatus {
        case pending, aligning, merging, saving, completed, failed
    }
    
    public init() {}
}
