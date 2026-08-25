import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:native_calls_refresher/pages/camera_page.dart';
import 'package:native_calls_refresher/src/generated/camera_api.g.dart';

class MockFlashlightApi extends Mock implements FlashlightApi {}

void main() {
  late MockFlashlightApi mockApi;

  setUp(() {
    mockApi = MockFlashlightApi();
    when(() => mockApi.toggleFlashlight(any())).thenAnswer((_) async {});
  });

  testWidgets('Poprawnie osadza UiKitView dla kamery', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: CameraPage(api: mockApi)));

    final uiKitViewFinder = find.byWidgetPredicate((widget) => widget is UiKitView && widget.viewType == 'NativeCameraViewType');

    expect(uiKitViewFinder, findsOneWidget);
  });

  testWidgets('Przycisk latarki zmienia stan UI oraz wysyła poprawne polecenia do iOS', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: CameraPage(api: mockApi)));

    expect(find.text('Latarka OFF'), findsOneWidget);
    expect(find.byIcon(Icons.flashlight_off), findsOneWidget);

    verifyNever(() => mockApi.toggleFlashlight(any()));

    await tester.tap(find.byType(IconButton));
    await tester.pump();

    expect(find.text('Latarka ON'), findsOneWidget);
    expect(find.byIcon(Icons.flashlight_on), findsOneWidget);

    verify(() => mockApi.toggleFlashlight(true)).called(1);

    await tester.tap(find.byType(IconButton));
    await tester.pump();

    expect(find.text('Latarka OFF'), findsOneWidget);
    expect(find.byIcon(Icons.flashlight_off), findsOneWidget);

    verify(() => mockApi.toggleFlashlight(false)).called(1);
  });
}
