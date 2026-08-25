import 'package:flutter/material.dart';
import 'package:native_calls_refresher/src/generated/haptics_api.g.dart';

class HapticsPage extends StatelessWidget {
  final HapticsApi? api;

  const HapticsPage({super.key, this.api});

  @override
  Widget build(BuildContext context) {
    final hapticsApi = api ?? HapticsApi();

    return Scaffold(
      appBar: AppBar(title: const Text('Native Vibrations')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16.0,
            children: [
              const Text('Pigeon przesyła enum-a do iOS, a iOS uruchamia silnik haptyczny', textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
              SizedBox(height: 32),
              _HapticButton(
                title: 'Sukces',
                color: Colors.green,
                icon: Icons.check_circle_outline,
                onPressed: () => hapticsApi.triggerFeedback(HapticsFeedbackType.success),
              ),
              _HapticButton(
                title: 'Ostrzeżenie',
                color: Colors.orange,
                icon: Icons.warning_outlined,
                onPressed: () => hapticsApi.triggerFeedback(HapticsFeedbackType.warning),
              ),
              _HapticButton(
                title: 'Błąd',
                color: Colors.red,
                icon: Icons.error_outline,
                onPressed: () => hapticsApi.triggerFeedback(HapticsFeedbackType.error),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HapticButton extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;
  final VoidCallback onPressed;

  const _HapticButton({required this.title, required this.color, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: Icon(icon),
        label: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        onPressed: onPressed,
      ),
    );
  }
}
