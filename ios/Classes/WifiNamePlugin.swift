import Flutter
import UIKit
import SystemConfiguration.CaptiveNetwork

public class WifiNamePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "wifi_name_plugin", binaryMessenger: registrar.messenger())
        let instance = WifiNamePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        print("WifiNamePlugin: Plugin registrato")
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        print("WifiNamePlugin: Metodo chiamato - \(call.method)")

        if call.method == "getWifiName" {
            if let ssid = getWiFiName() {
                print("WifiNamePlugin: SSID trovato - \(ssid)")
                result(ssid)
            } else {
                print("WifiNamePlugin: SSID non disponibile")
                result("SSID_NOT_AVAILABLE")
            }
        } else {
            print("WifiNamePlugin: Metodo non implementato")
            result(FlutterMethodNotImplemented)
        }
    }

    private func getWiFiName() -> String? {
        guard let interfaces = CNCopySupportedInterfaces() as NSArray? else { return nil }
        for interface in interfaces {
            if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                return interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
            }
        }
        return nil
    }
}