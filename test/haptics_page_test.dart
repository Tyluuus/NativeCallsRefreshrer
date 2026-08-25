import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:native_calls_refresher/pages/haptics_page.dart';
import 'package:native_calls_refresher/src/generated/haptics_api.g.dart';

class MockHapticsApi extends Mock implements HapticsApi {}

void main() {
  late MockHapticsApi mockApi;

  setUp(() {
    mockApi = MockHapticsApi();

    when(() => mockApi.triggerFeedback(HapticsFeedbackType.success)).thenAnswer((_) async {});

    when(() => mockApi.triggerFeedback(HapticsFeedbackType.warning)).thenAnswer((_) async {});

    when(() => mockApi.triggerFeedback(HapticsFeedbackType.error)).thenAnswer((_) async {});
  });

  testWidgets('Kliknięcie "Sukces" wywołuje Pigeon API z enumem success', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HapticsPage(api: mockApi)));

    await tester.tap(find.text('Sukces'));
    await tester.pump();

    verify(() => mockApi.triggerFeedback(HapticsFeedbackType.success)).called(1);
  });

  testWidgets('Kliknięcie "Błąd" wywołuje Pigeon API z enumem error', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HapticsPage(api: mockApi)));

    await tester.tap(find.text('Błąd'));
    await tester.pump();

    verify(() => mockApi.triggerFeedback(HapticsFeedbackType.error)).called(1);
  });
}
