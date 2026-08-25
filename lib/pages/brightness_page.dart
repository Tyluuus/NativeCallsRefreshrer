import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BrightnessPage extends StatelessWidget {
  final Stream<double>? brightnessStreamOverride;

  const BrightnessPage({super.key, this.brightnessStreamOverride});

  static const EventChannel _brightnessChannel = EventChannel('com.sandbox.app/brightness');

  Stream<double> get brightnessStream {
    if (brightnessStreamOverride != null) {
      return brightnessStreamOverride!;
    }
    return _brightnessChannel.receiveBroadcastStream().map((dynamic event) => event as double);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Screen brightness (Stream)')),
      body: Center(
        child: StreamBuilder<double>(
          stream: brightnessStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Błąd: ${snapshot.error}', style: const TextStyle(color: Colors.red));
            }

            if (!snapshot.hasData) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 16,
                children: [CircularProgressIndicator(), Text('Oczekiwanie na dane z iOS...')],
              );
            }

            final brightness = snapshot.data!;
            final percentage = (brightness * 100).toInt();

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 30,
              children: [
                Icon(Icons.lightbulb, size: 150, color: Colors.amber.withValues(alpha: brightness.clamp(0.1, 1.0))),
                Text('Aktualna jasność: $percentage%', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const Text(
                  'Zmień jasność ekranu telefonu aby obserwować zmiany w aplikacji',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
