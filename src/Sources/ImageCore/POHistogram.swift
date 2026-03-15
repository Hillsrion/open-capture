import Foundation

/// Reconstructed `POHistogram` data container.
/// Holds normalized histogram data for all channels.
public class POHistogram: Codable, NSCopying {
    public let luminance: [Float]
    public let red: [Float]
    public let green: [Float]
    public let blue: [Float]
    public let binCount: Int
    
    public init(luminance: [Float], red: [Float], green: [Float], blue: [Float]) {
        self.luminance = luminance
        self.red = red
        self.green = green
        self.blue = blue
        self.binCount = luminance.count
    }
    
    public static func empty(binCount: Int = 256) -> POHistogram {
        let empty = [Float](repeating: 0, count: binCount)
        return POHistogram(luminance: empty, red: empty, green: empty, blue: empty)
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        return POHistogram(luminance: luminance, red: red, green: green, blue: blue)
    }
}
