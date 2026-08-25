import 'package:flutter/material.dart';
import 'package:native_calls_refresher/pages/airplane_mode_page.dart';

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
        children: [
          _buildMenuButton(
            context,
            title: 'Device Info (Pigeon)',
            icon: Icons.smartphone,
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DeviceInfoPage())),
          ),
          _buildMenuButton(
            context,
            title: '2. Tryb Samolotowy (MethodChannel)',
            icon: Icons.flight,
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AirplaneModePage())),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, {required String title, required IconData icon, required VoidCallback? onPressed}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 12.0),
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
