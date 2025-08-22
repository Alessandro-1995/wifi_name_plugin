# wifi_name_plugin

Recupera il nome della rete Wi-Fi corrente su Android e iOS.

## Installazione

Aggiungi al `pubspec.yaml`:

```yaml
dependencies:
  wifi_name_plugin: ^0.0.1
```

## Uso

```dart
import 'package:wifi_name_plugin/wifi_name_plugin.dart';

String? ssid = await WifiNamePlugin.getWifiName();
print(ssid);
```

### Note sui permessi

- **iOS**: aggiungi NSLocationWhenInUseUsageDescription e abilita Wi-Fi Info capability.
- **info.plist**:

```dart
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>Serve per ottenere il nome della rete Wi-Fi</string>
    <key>com.apple.developer.networking.wifi-info</key>
    <true/>
```
