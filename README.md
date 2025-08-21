# wifi_name_plugin

Recupera il nome della rete Wi-Fi corrente su Android e iOS.

## Installazione

Aggiungi al `pubspec.yaml`:

```yaml
dependencies:
  wifi_name_plugin: ^1.0.0
```

## Uso

```dart
import 'package:wifi_name_plugin/wifi_name_plugin.dart';

String? ssid = await WifiNamePlugin.getWifiName();
print(ssid);
```

### Note sui permessi

- **Android**: serve ACCESS_FINE_LOCATION per ottenere il SSID. Se il plugin restituisce "PERMISSION_REQUIRED", richiedi i permessi runtime.
- **iOS**: aggiungi NSLocationWhenInUseUsageDescription e abilita Wi-Fi Info capability.