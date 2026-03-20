import Foundation

/// Reconstructed Bonjour/ZeroConf discovery service for Capture One Live for Studio.
/// Enables local iPads to find the Mac session without internet (ENG-012).
public class COLiveLocalDiscoveryService: NSObject, NetServiceDelegate {
    public static let shared = COLiveLocalDiscoveryService()
    
    private var netService: NetService?
    private let serviceType = "_c1live._tcp."
    private let serviceDomain = "local."
    
    @Published public private(set) var isBroadcasting: Bool = false
    
    public override init() {
        super.init()
    }
    
    /// Starts broadcasting the session on the local network.
    public func startBroadcasting(sessionName: String, port: Int32 = 8080) {
        stopBroadcasting()
        
        netService = NetService(domain: serviceDomain, type: serviceType, name: sessionName, port: port)
        netService?.delegate = self
        netService?.publish()
        
        print("[Discovery] Starting local broadcast: \(sessionName) on port \(port)")
    }
    
    /// Stops broadcasting the session.
    public func stopBroadcasting() {
        netService?.stop()
        netService = nil
        isBroadcasting = false
        print("[Discovery] Stopped local broadcast.")
    }
    
    // MARK: - NetServiceDelegate
    
    public func netServiceDidPublish(_ sender: NetService) {
        isBroadcasting = true
        print("[Discovery] Successfully published service: \(sender.name)")
    }
    
    public func netService(_ sender: NetService, didNotPublish errorDict: [String : NSNumber]) {
        isBroadcasting = false
        print("[Discovery] Failed to publish service: \(errorDict)")
    }
}
