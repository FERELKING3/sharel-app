import Foundation
import Flutter

class MdnsService: NSObject, NetServiceDelegate {
    static let channelName = "com.sharel.app/mdns"
    static let shared = MdnsService()
    
    private var netService: NetService?
    private var servicePublished = false
    private var methodChannel: FlutterMethodChannel?
    
    static func setup(with controller: FlutterViewController) {
        let channel = FlutterMethodChannel(
            name: channelName,
            binaryMessenger: controller.binaryMessenger
        )
        
        MdnsService.shared.methodChannel = channel
        channel.setMethodCallHandler { call, result in
            switch call.method {
            case "publishService":
                guard let args = call.arguments as? [String: Any],
                      let serviceName = args["serviceName"] as? String,
                      let serviceType = args["serviceType"] as? String,
                      let port = args["port"] as? Int else {
                    result(false)
                    return
                }
                
                let txtRecords = (args["txtRecords"] as? [String: String]) ?? [:]
                let success = mdnsService.publishService(
                    name: serviceName,
                    type: serviceType,
                    port: port,
                    txtRecords: txtRecords
                )
                result(success)
                
            case "unpublishService":
                mdnsService.unpublishService()
                result(nil)
                
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    private func publishService(
        name: String,
        type: String,
        port: Int,
        txtRecords: [String: String]
    ) -> Bool {
        // Stop existing service if any
        unpublishService()
        
        // Create NetService for Bonjour advertisement
        netService = NetService(
            domain: "local.",
            type: type,
            name: name,
            port: Int32(port)
        )
        
        // Set TXT records if available
        if !txtRecords.isEmpty {
            var txtDict = [String: Data]()
            for (key, value) in txtRecords {
                if let data = value.data(using: .utf8) {
                    txtDict[key] = data
                }
            }
            let txtData = NetService.data(fromTXTRecord: txtDict)
            netService?.setTXTRecord(txtData)
        }
        
        netService?.delegate = self
        netService?.publish(options: .listenForConnections)
        
        print("[MdnsService] Publishing service \(name) on port \(port)")
        return true
    }
    
    private func unpublishService() {
        if let service = netService, servicePublished {
            service.stop()
            print("[MdnsService] Service stopped")
        }
        netService = nil
        servicePublished = false
    }
    
    // MARK: - NetServiceDelegate
    
    func netServiceDidPublish(_ sender: NetService) {
        servicePublished = true
        print("[MdnsService] Service published: \(sender.name) on port \(sender.port)")
    }
    
    func netService(_ sender: NetService, didNotPublish errorDict: [String: NSNumber]) {
        print("[MdnsService] Failed to publish service: \(errorDict)")
        servicePublished = false
    }
    
    func netServiceDidStop(_ sender: NetService) {
        servicePublished = false
        print("[MdnsService] Service stopped")
    }
}
