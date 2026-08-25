import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AirplaneModePage extends StatefulWidget {
  const AirplaneModePage({super.key});

  @override
  State<StatefulWidget> createState() => _AirplaneModePageState();
}

class _AirplaneModePageState extends State<AirplaneModePage> {
  static const platform = MethodChannel('com.sandbox.app/airplane');

  String _statusMessage = 'Naciśnij przycisk, aby sprawdzić dostępność sieci';
  bool _isLoading = false;

  Future<void> _checkNetwork() async {
    setState(() => _isLoading = true);

    try {
      final bool isOffline = await platform.invokeMethod('isAirplaneModeOn');
      setState(() {
        _statusMessage = isOffline ? 'Brak sieci (Tryb samolotowy/offline)' : 'Masz połączenie z siecią';
      });
    } on MissingPluginException {
      setState(() {
        _statusMessage = 'Błąd: MissingPluginException. \n Nie zaimplementowano części natywnej, lub użyto złej nazwy kanału';
      });
    } on PlatformException catch (e) {
      setState(() {
        _statusMessage = 'Błąd platformy: ${e.message}';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Nieznany błąd: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tryb Samolotowy / Sieć')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _statusMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              if (_isLoading) const CircularProgressIndicator() else ElevatedButton(onPressed: _checkNetwork, child: const Text('Sprawdź status sieci')),
            ],
          ),
        ),
      ),
    );
  }
}
