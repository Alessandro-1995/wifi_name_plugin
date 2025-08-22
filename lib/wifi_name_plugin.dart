import 'dart:async';
import 'package:flutter/services.dart';

class WifiNamePlugin {
  static const MethodChannel _channel = MethodChannel('wifi_name_plugin');

  static Future<String?> getWifiName() async {
    try {
      final String? wifiName = await _channel.invokeMethod('getWifiName');
      return wifiName;
    } on PlatformException catch (e) {
      return null;
    }
  }

  static Future<String?> getWifiBSSID() async {
    try {
      final String? bssid = await _channel.invokeMethod('getWifiBSSid');
      return bssid;
    } on PlatformException catch (e) {
      return null;
    }
  }

  static Future<String?> getIPAddress() async {
    try {
      final String? ip = await _channel.invokeMethod('getIPAddress');
      return ip;
    } on PlatformException catch (e) {
      return null;
    }
  }

  static Future<String?> getWifiMask() async {
    try {
      final String? mask = await _channel.invokeMethod('getMaskAddress');
      return mask;
    } on PlatformException catch (e) {
      return null;
    }
  }

  static Future<bool> requestPermission() async {
    try {
      return await _channel.invokeMethod('requestPermission');
    } on PlatformException catch (e) {
      return false;
    }
  }
}
