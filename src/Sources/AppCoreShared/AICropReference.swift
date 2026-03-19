import Foundation
import CoreGraphics

/// Data model for the reference state of an AI Crop.
/// Used to maintain consistency across multiple images by mapping subject alignment and sizing.
public struct AICropReference: Codable, Equatable {
    /// The normalized X alignment of the subject within the crop (0.0 to 1.0).
    public var alignmentX: Double
    
    /// The normalized Y alignment of the subject within the crop (0.0 to 1.0).
    public var alignmentY: Double
    
    /// The normalized center of the subject in the original image.
    public var subjectCenter: CGPoint
    
    /// The normalized size of the subject in the original image.
    public var subjectSize: CGSize
    
    /// The sizing mode for the crop calculation.
    /// 0: Fit, 1: Fill, 2: Fixed
    public var sizingMode: Int
    
    /// The target aspect ratio for the crop.
    public var aspect: Double
    
    public init(alignmentX: Double = 0.5,
                alignmentY: Double = 0.5,
                subjectCenter: CGPoint = CGPoint(x: 0.5, y: 0.5),
                subjectSize: CGSize = CGSize(width: 0.2, height: 0.2),
                sizingMode: Int = 0,
                aspect: Double = 1.0) {
        self.alignmentX = alignmentX
        self.alignmentY = alignmentY
        self.subjectCenter = subjectCenter
        self.subjectSize = subjectSize
        self.sizingMode = sizingMode
        self.aspect = aspect
    }
}
