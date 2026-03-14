import Foundation

/// Reconstructed XMP Sidecar Manager (MET-002).
/// Responsible for reading and writing .xmp files next to images.
/// Mimics SidecarManager and MetadataSynchronizationManager from AppCoreShared.
public class XMPManager {
    public static let shared = XMPManager()
    
    private init() {}
    
    /// Locates the XMP sidecar for a given image path.
    /// Original C1 logic: image.arw -> image.arw.xmp or image.xmp
    public func xmpURL(for imagePath: String) -> URL {
        let imageURL = URL(fileURLWithPath: imagePath)
        // Capture One usually appends .xmp to the full filename
        return imageURL.appendingPathExtension("xmp")
    }
    
    /// Reads IPTC metadata from an XMP file.
    public func readMetadata(for imagePath: String) -> IPTCData? {
        let url = xmpURL(for: imagePath)
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        
        print("[Metadata] Reading sidecar: \(url.lastPathComponent)")
        
        // Simulation of pugixml/XML parsing logic
        // In a real reconstruction, we would parse <dc:description>, <dc:rights>, etc.
        return IPTCData() 
    }
    
    /// Writes IPTC metadata to an XMP sidecar file.
    public func writeMetadata(_ iptc: IPTCData, for imagePath: String) throws {
        let url = xmpURL(for: imagePath)
        
        print("[Metadata] Writing sidecar: \(url.lastPathComponent)")
        
        // Simple XML Template (standard XMP/IPTC)
        let xml = """
        <?xpacket begin="" id="W5M0MpCehiHzreSzNTczkc9d"?>
        <x:xmpmeta xmlns:x="adobe:ns:meta/">
         <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
          <rdf:Description rdf:about=""
            xmlns:dc="http://purl.org/dc/elements/1.1/"
            xmlns:Iptc4xmpCore="http://iptc.org/std/Iptc4xmpCore/1.0/xmlns/">
           <dc:description>
            <rdf:Alt><rdf:li xml:lang="x-default">\(iptc.caption ?? "")</rdf:li></rdf:Alt>
           </dc:description>
           <dc:rights>
            <rdf:Alt><rdf:li xml:lang="x-default">\(iptc.copyright ?? "")</rdf:li></rdf:Alt>
           </dc:rights>
           <dc:creator><rdf:Seq><rdf:li>\(iptc.creator ?? "")</rdf:li></rdf:Seq></dc:creator>
           <Iptc4xmpCore:Headline>\(iptc.headline ?? "")</Iptc4xmpCore:Headline>
          </rdf:Description>
         </rdf:RDF>
        </x:xmpmeta>
        <?xpacket end="w"?>
        """
        
        try xml.write(to: url, atomically: true, encoding: .utf8)
    }
    
    /// Checks if the XMP file on disk is newer than the database state.
    /// Mimics the "Metadata Status" indicator in C1 (synchronized, remote changes).
    public func checkSyncStatus(for metadata: ImageMetadata) -> MetadataSyncStatus {
        let url = xmpURL(for: metadata.imagePath)
        guard let attributes = try? FileManager.default.attributesOfItem(atPath: url.path),
              let modDate = attributes[.modificationDate] as? Date else {
            return .synchronized
        }
        
        if modDate > metadata.lastSyncDate {
            return .remoteChanges
        }
        
        return .synchronized
    }
}
