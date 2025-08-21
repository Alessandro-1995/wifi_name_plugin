import 'dart:async';
import 'package:flutter/services.dart';

class WifiNamePlugin {
  static const MethodChannel _channel =
      MethodChannel('wifi_name_plugin');

  static Future<String?> getWifiName() async {
    try {
      print("WifiNamePlugin: Invocazione getWifiName");
      final String? wifiName = await _channel.invokeMethod('getWifiName');
      print("WifiNamePlugin: Risultato ricevuto - $wifiName");
      return wifiName;
    } on PlatformException catch (e) {
      print("WifiNamePlugin: Errore PlatformException - ${e.message}");
      return null;
    }
  }
}