import 'package:flutter/material.dart';
import 'package:native_calls_refresher/src/generated/camera_api.g.dart';

class CameraPage extends StatefulWidget {
  final FlashlightApi? api;

  const CameraPage({super.key, this.api});

  @override
  State<StatefulWidget> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late final FlashlightApi _api = widget.api ?? FlashlightApi();
  bool _isFlashlightOn = false;

  void _toggleFlashlight() {
    setState(() {
      _isFlashlightOn = !_isFlashlightOn;
    });
    _api.toggleFlashlight(_isFlashlightOn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kamera + Pigeon')),
      body: Column(
        children: [
          const Expanded(flex: 2, child: UiKitView(viewType: 'NativeCameraViewType')),
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              color: Colors.black87,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_isFlashlightOn ? 'Latarka ON' : 'Latarka OFF', style: const TextStyle(color: Colors.white, fontSize: 20)),
                  const SizedBox(height: 20),
                  IconButton(
                    onPressed: _toggleFlashlight,
                    icon: Icon(_isFlashlightOn ? Icons.flashlight_on : Icons.flashlight_off),
                    iconSize: 64,
                    color: _isFlashlightOn ? Colors.amber : Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
