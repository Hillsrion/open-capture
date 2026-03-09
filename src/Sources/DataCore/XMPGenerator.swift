import Foundation

/// Reconstructed logic for generating XMP sidecar files.
/// Based on standard Adobe XMP Specification and Capture One patterns.

public struct XMPGenerator {
    
    public static func generateXMP(rating: Int, colorTag: String, creator: String, copyright: String, description: String, keywords: [String]) -> String {
        let now = ISO8601DateFormatter().string(from: Date())
        
        var xmp = """
        <?xpacket begin="" id="W5M0MpCehiHzreSzNTczkc9d"?>
        <x:xmpmeta xmlns:x="adobe:ns:meta/" x:xmptk="XMP Core 5.6.0">
          <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
            <rdf:Description rdf:about=""
                xmlns:xmp="http://ns.adobe.com/xap/1.0/"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:photoshop="http://ns.adobe.com/photoshop/1.0/"
                xmp:Rating="\(rating)"
                xmp:Label="\(colorTag)"
                xmp:MetadataDate="\(now)"
                xmp:ModifyDate="\(now)"
                photoshop:DateCreated="\(now)">
              <dc:creator>
                <rdf:Seq>
                  <rdf:li>\(creator)</rdf:Seq>
                </rdf:Seq>
              </dc:creator>
              <dc:rights>
                <rdf:Alt>
                  <rdf:li xml:lang="x-default">\(copyright)</rdf:li>
                </rdf:Alt>
              </dc:rights>
              <dc:description>
                <rdf:Alt>
                  <rdf:li xml:lang="x-default">\(description)</rdf:li>
                </rdf:Alt>
              </dc:description>
              <dc:subject>
                <rdf:Bag>
        """
        
        for keyword in keywords {
            xmp += "          <rdf:li>\(keyword)</rdf:li>\n"
        }
        
        xmp += """
                </rdf:Bag>
              </dc:subject>
            </rdf:Description>
          </rdf:RDF>
        </x:xmpmeta>
        <?xpacket end="w"?>
        """
        
        return xmp
    }
}
