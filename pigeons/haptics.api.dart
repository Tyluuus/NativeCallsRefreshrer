import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    input: 'pigeons/haptics_api.dart',
    dartPackageName: 'native_calls_refresher',
    dartOut: 'lib/src/generated/haptics_api.g.dart',
    dartOptions: DartOptions(),
    swiftOut: 'ios/Runner/HapticsApi.g.swift',
    swiftOptions: SwiftOptions(includeErrorClass: false),
    // kotlinOut: 'android/app/src/main/kotlin/com/example/DeviceInfoApi.g.kt',
    // kotlinOptions: KotlinOptions(),
  ),
)
enum HapticsFeedbackType { success, warning, error }

@HostApi()
abstract class HapticsApi {
  void triggerFeedback(HapticsFeedbackType type);
}
