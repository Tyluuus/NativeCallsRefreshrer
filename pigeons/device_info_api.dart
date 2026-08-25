import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    input: 'pigeons/device_info_api.dart',
    dartPackageName: 'native_calls_refresher',
    dartOut: 'lib/src/generated/device_info_api.g.dart',
    dartOptions: DartOptions(),
    swiftOut: 'ios/Runner/DeviceInfoApi.g.swift',
    swiftOptions: SwiftOptions(),
    // kotlinOut: 'android/app/src/main/kotlin/com/example/DeviceInfoApi.g.kt',
    // kotlinOptions: KotlinOptions(),
  ),
)
class DeviceInfo {
  DeviceInfo({required this.modelName, required this.batteryLevel});
  String modelName;
  int batteryLevel;
}

@HostApi()
abstract class DeviceInfoApi {
  DeviceInfo getDeviceInfo();
}
