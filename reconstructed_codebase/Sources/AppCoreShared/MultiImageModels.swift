import Foundation

/// Reconstructed Data Model for HDR Merge settings (ENG-010).
public struct IC_HDRMergeSettings: Codable {
    public var autoAlign: Bool = true
    public var deghosting: Double = 0.0 // 0.0 to 100.0
    
    public init() {}
}

/// Reconstructed Data Model for Panorama Stitch settings.
public struct IC_PanoramaMergeSettings: Codable {
    public enum ProjectionType: Int, Codable {
        case spherical = 0
        case cylindrical = 1
        case perspective = 2
        case panini = 3
    }
    
    public var projection: ProjectionType = .cylindrical
    public var autoCrop: Bool = true
    
    public init() {}
}

/// Reconstructed model for tracking a multi-image merge task.
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
