# NativeCallsRefreshrer
Flutter project for refreshing approach for iOS native calls

Contains 5 small examples:
* Fetching Device Info using *Pigeon Api Interface*
* Checking for network connection using *MethodChannel*
* Invoking haptics on native side, utilizing *enums via Pigeon*
* Fetching screen brightness using *EventChannel Stream*
* Add UIKitView with camera preview directly to flutter code + toggle flashlight using *Pigeon + 
  UIKitView*

Small addition:
All examples are covered with tests

Pigeon code generated using below command:
```bash
dart run pigeon --input pigeons/haptics_api.dart   
```

