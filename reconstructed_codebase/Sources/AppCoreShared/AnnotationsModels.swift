import Foundation
import CoreGraphics
import SwiftUI

/// Reconstructed model for a single annotation stroke (UI-007).
public class MCAnnotationsLine: Identifiable, Codable {
    public let id: String
    public var points: [CGPoint]
    public var colorHex: String // Use hex for Codable ease
    public var width: CGFloat
    
    public init(id: String = UUID().uuidString, points: [CGPoint], colorHex: String = "#FF0000", width: CGFloat = 2.0) {
        self.id = id
        self.points = points
        self.colorHex = colorHex
        self.width = width
    }
}

/// Reconstructed model for a text annotation note.
public class MCAnnotationsNote: Identifiable, Codable {
    public let id: String
    public var text: String
    public var position: CGPoint
    
    public init(id: String = UUID().uuidString, text: String, position: CGPoint) {
        self.id = id
        self.text = text
        self.position = position
    }
}

/// Reconstructed container for all annotations on a variant.
/// Based on disassembly of MCAnnotations.
public class MCAnnotations: Codable, ObservableObject {
    @Published public var lines: [MCAnnotationsLine] = []
    @Published public var notes: [MCAnnotationsNote] = []
    public var version: Int = 1
    
    public init() {}
    
    public var isEmpty: Bool {
        lines.isEmpty && notes.isEmpty
    }
    
    // Custom Codable implementation for @Published
    enum CodingKeys: String, CodingKey {
        case lines, notes, version
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        lines = try container.decode([MCAnnotationsLine].self, forKey: .lines)
        notes = try container.decode([MCAnnotationsNote].self, forKey: .notes)
        version = try container.decode(Int.self, forKey: .version)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(lines, forKey: .lines)
        try container.encode(notes, forKey: .notes)
        try container.encode(version, forKey: .version)
    }
}
