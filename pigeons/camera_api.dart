import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    input: 'pigeons/haptics_api.dart',
    dartPackageName: 'native_calls_refresher',
    dartOut: 'lib/src/generated/camera_api.g.dart',
    dartOptions: DartOptions(),
    swiftOut: 'ios/Runner/CameraApi.g.swift',
    swiftOptions: SwiftOptions(includeErrorClass: false),
    // kotlinOut: 'android/app/src/main/kotlin/com/example/DeviceInfoApi.g.kt',
    // kotlinOptions: KotlinOptions(),
  ),
)
@HostApi()
abstract class FlashlightApi {
  void toggleFlashlight(bool isOn);
}
