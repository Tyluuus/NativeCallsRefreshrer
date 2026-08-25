import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:native_calls_refresher/pages/device_info_page.dart';
import 'package:native_calls_refresher/src/generated/device_info_api.g.dart';

class MockDeviceInfoApi extends Mock implements DeviceInfoApi {}

void main() {
  late MockDeviceInfoApi mockApi;

  setUp(() {
    mockApi = MockDeviceInfoApi();
  });

  testWidgets('Wyświetla dane o baterii po pobraniu z iOS', (WidgetTester tester) async {
    when(() => mockApi.getDeviceInfo()).thenAnswer((_) async => DeviceInfo(modelName: 'iPhone 17 Pro (Mock)', batteryLevel: 85));

    await tester.pumpWidget(MaterialApp(home: DeviceInfoPage(api: mockApi)));

    await tester.tap(find.text('Pobierz z iOS'));
    await tester.pumpAndSettle();

    expect(find.text('Model: iPhone 17 Pro (Mock)'), findsOneWidget);
    expect(find.text('Bateria: 85%'), findsOneWidget);
  });

  testWidgets('Wyświetla dane o baterii po pobraniu z iOS', (WidgetTester tester) async {
    when(() => mockApi.getDeviceInfo()).thenThrow(PlatformException(code: 'UNAVAILABLE', message: 'Bateria rozładowana'));

    await tester.pumpWidget(MaterialApp(home: DeviceInfoPage(api: mockApi)));

    await tester.tap(find.text('Pobierz z iOS'));
    await tester.pumpAndSettle();

    expect(find.text('Błąd platformy: Bateria rozładowana'), findsOneWidget);
  });
}
