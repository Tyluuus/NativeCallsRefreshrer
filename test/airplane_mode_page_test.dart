import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_calls_refresher/pages/airplane_mode_page.dart';

void main() {
  const channel = MethodChannel('com.sandbox.app/airplane');

  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Wyświelta brak sieci, gdy kod natywny zwraca true', (WidgetTester tester) async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'isAirplaneModeOn') {
        return true;
      }
      return null;
    });

    await tester.pumpWidget(const MaterialApp(home: AirplaneModePage()));
    await tester.tap(find.text('Sprawdź status sieci'));
    await tester.pumpAndSettle();

    expect(find.text('Brak sieci (Tryb samolotowy/offline)'), findsOneWidget);
  });

  testWidgets('Wyświetla błąd MissingPluginException, gdy iOS nie daje odpowiedzi', (WidgetTester tester) async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      throw MissingPluginException('Symulowany berak implementacji');
    });

    await tester.pumpWidget(const MaterialApp(home: AirplaneModePage()));
    await tester.tap(find.text('Sprawdź status sieci'));
    await tester.pumpAndSettle();

    expect(find.textContaining('MissingPluginException'), findsOneWidget);
  });
}
