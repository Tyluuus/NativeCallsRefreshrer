import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_calls_refresher/src/generated/device_info_api.g.dart';

class DeviceInfoPage extends StatefulWidget {
  final DeviceInfoApi? api;

  const DeviceInfoPage({super.key, this.api});

  @override
  State<DeviceInfoPage> createState() => _DeviceInfoPageState();
}

class _DeviceInfoPageState extends State<DeviceInfoPage> {
  DeviceInfo? _deviceInfo;
  bool _isLoading = false;
  String? _errorMessage;

  late final DeviceInfoApi _api = widget.api ?? DeviceInfoApi();

  Future<void> _fetchDataFromIOS() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final info = await _api.getDeviceInfo();

      setState(() {
        _deviceInfo = info;
        _isLoading = false;
      });
    } on PlatformException catch (e) {
      setState(() {
        _errorMessage = 'Błąd platformy: ${e.message}';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Wystąpił błąd: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Info o Urządzeniu')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading)
                const CircularProgressIndicator()
              else if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                )
              else if (_deviceInfo != null)
                _buildInfoCard()
              else
                const Text('Kliknij przycisk poniżej, aby zapytać iOS o szczegóły.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),

              const SizedBox(height: 40),

              ElevatedButton.icon(
                icon: const Icon(Icons.downloading),
                label: const Text('Pobierz z iOS'),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                onPressed: _isLoading ? null : _fetchDataFromIOS,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.apple, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text('Model: ${_deviceInfo!.modelName}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Bateria: ${_deviceInfo!.batteryLevel}%', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
