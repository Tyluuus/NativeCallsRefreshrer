import 'package:flutter/material.dart';
import 'package:native_calls_refresher/pages/airplane_mode_page.dart';
import 'package:native_calls_refresher/pages/brightness_page.dart';
import 'package:native_calls_refresher/pages/haptics_page.dart';

import 'pages/device_info_page.dart';

void main() {
  runApp(const NativeSandboxApp());
}

class NativeSandboxApp extends StatelessWidget {
  const NativeSandboxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iOS & Flutter Sandbox',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter & iOS Integrations'), backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 12.0,
        children: [
          _buildMenuButton(
            context,
            title: '1. Device Info (Pigeon)',
            icon: Icons.smartphone,
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DeviceInfoPage())),
          ),
          _buildMenuButton(
            context,
            title: '2. Tryb Samolotowy (MethodChannel)',
            icon: Icons.flight,
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AirplaneModePage())),
          ),
          _buildMenuButton(
            context,
            title: '3. Haptyka (Pigeon enum)',
            icon: Icons.vibration,
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HapticsPage())),
          ),
          _buildMenuButton(
            context,
            title: '4. Jasność (EventChannel Stream)',
            icon: Icons.brightness_6,
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BrightnessPage())),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, {required String title, required IconData icon, required VoidCallback? onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: Icon(icon),
          label: Text(title, style: const TextStyle(fontSize: 16)),
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16.0), alignment: Alignment.centerLeft),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
