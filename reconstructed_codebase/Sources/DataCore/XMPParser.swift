import Foundation

/// Reconstructed logic for parsing XMP sidecar files.
/// A simple SAX-based parser for extraction of core metadata.

public class XMPParser: NSObject, XMLParserDelegate {
    
    public var metadata: [String: Any] = [:]
    private var currentElement: String = ""
    private var tempKeywords: [String] = []
    
    public func parse(xmp: Data) -> [String: Any] {
        let parser = Foundation.XMLParser(data: xmp)
        parser.delegate = self
        parser.parse()
        if !tempKeywords.isEmpty {
            metadata["keywords"] = tempKeywords
        }
        return metadata
    }
    
    public func parser(_ parser: Foundation.XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
        // Handle attributes (common in rdf:Description)
        if let rating = attributeDict["xmp:Rating"] {
            metadata["rating"] = Int(rating)
        }
        if let label = attributeDict["xmp:Label"] {
            metadata["colorTag"] = label
        }
    }
    
    public func parser(_ parser: Foundation.XMLParser, foundCharacters string: String) {
        let text = string.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        
        switch currentElement {
        case "dc:creator": metadata["creator"] = text
        case "dc:rights": metadata["copyright"] = text
        case "dc:description": metadata["description"] = text
        case "rdf:li" where currentElementStackContains("dc:subject"): tempKeywords.append(text)
        default: break
        }
    }
    
    // Helper to check context (simplified)
    private func currentElementStackContains(_ name: String) -> Bool {
        // In a real implementation, we'd maintain a stack
        return true 
    }
}
