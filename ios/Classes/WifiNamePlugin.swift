import Flutter
import UIKit
import SystemConfiguration.CaptiveNetwork
import CoreLocation

public class WifiNamePlugin: NSObject, FlutterPlugin {
    var locationManager: CLLocationManager?
    var pendingResult: FlutterResult?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "wifi_name_plugin", binaryMessenger: registrar.messenger())
        let instance = WifiNamePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        print("WifiNamePlugin: Plugin registrato")
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getWifiName":
            // recuperdo del nome wifi alla chiamata
            let ssid = getWiFiName()
            result(ssid)
        case "requestPermission":
            pendingResult = result
            // autorizzazione della localizazione
            requestLocationAuthorization()
        case "getWifiBSSid":
            let bssid = getBSSID()
            result(bssid)
        case "getIPAddress":
            let ip = getIPAddress()
            result(ip)
        case "getMaskAddress":
            let mask = getMaskAddress()
            result(mask)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func requestLocationAuthorization() {
        print("richiesta autorizzazione")
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
    }

    private func getWiFiName() -> String? {
        guard let interfaces = CNCopySupportedInterfaces() as NSArray? else {
            return nil
        }
        for interface in interfaces {
            if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                return interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
            }
        }
        return nil
    }

    private func getBSSID() -> String? {
        guard let interfaces = CNCopySupportedInterfaces() as NSArray? else {
            return nil
        }
        for interface in interfaces {
            if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                return interfaceInfo[kCNNetworkInfoKeyBSSID as String] as? String
            }
        }
        return nil
    }
    private func getIPAddress() -> String? {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }
                guard let interface = ptr?.pointee else { continue }
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) {
                    let name = String(cString: interface.ifa_name)
                    if name == "en0" { // Wi-Fi
                        var addr = interface.ifa_addr.pointee
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                    &hostname, socklen_t(hostname.count),
                                    nil, 0, NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address
    }

    private func getMaskAddress() -> String? {
        var mask: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }
                guard let interface = ptr?.pointee else { continue }
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) {
                    let name = String(cString: interface.ifa_name)
                    if name == "en0" {
                        // Subnet mask
                        if let netmask = interface.ifa_netmask {
                            var addr = netmask.pointee
                            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                            getnameinfo(&addr, socklen_t(netmask.pointee.sa_len),
                                        &hostname, socklen_t(hostname.count),
                                        nil, 0, NI_NUMERICHOST)
                            mask = String(cString: hostname)
                        }
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return mask
    }
}
// MARK: - CLLocationManagerDelegate
extension WifiNamePlugin: CLLocationManagerDelegate {
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard let result = pendingResult else { return }

        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("PERMISSION_GRANTED")
            result(true)
        case .denied, .restricted:
            print("PERMISSION_DENIED")
            result(false)
        default:
            break
        }

        pendingResult = nil
    }
}
