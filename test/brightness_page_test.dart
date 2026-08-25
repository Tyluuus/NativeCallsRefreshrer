import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_calls_refresher/pages/brightness_page.dart';

void main() {
  testWidgets('Wyświetla loader , gdy nie ma jeszcze danych', (WidgetTester tester) async {
    final streamController = StreamController<double>();

    await tester.pumpWidget(MaterialApp(home: BrightnessPage(brightnessStreamOverride: streamController.stream)));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Oczekiwanie na dane z iOS...'), findsOneWidget);
    await streamController.close();
  });

  testWidgets('Aktualizacje UI w czasie rzeczywistym po otrzymaniu nowych wartości', (WidgetTester tester) async {
    final streamController = StreamController<double>();

    await tester.pumpWidget(MaterialApp(home: BrightnessPage(brightnessStreamOverride: streamController.stream)));

    streamController.add(0.5);

    await tester.pump();

    expect(find.text('Aktualna jasność: 50%'), findsOneWidget);

    streamController.add(0.8);
    await tester.pump();
    expect(find.text('Aktualna jasność: 80%'), findsOneWidget);
    await streamController.close();
  });
}
