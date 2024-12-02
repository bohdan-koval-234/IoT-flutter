import 'package:flashlight/iot_flashlight_plugin.dart';
import 'package:flutter/material.dart';

class SecretFlashlightButton extends StatelessWidget {
  final bool isVisible;

  const SecretFlashlightButton({super.key, this.isVisible = false});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isVisible ? 1.0 : 0.01,
      child: IconButton(
        icon: const Icon(Icons.flashlight_on),
        onPressed: () async {
          try {
            bool? isOn = await IotFlashlightPlugin.toggleFlashlight();

            isOn ??= false;

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      isOn ? 'Ліхтарик увімкнено!' : 'Ліхтарик вимкнено!',),
                ),
              );
            }
          } on UnsupportedError catch (e) {
            if (context.mounted) {
              _showUnsupportedDialog(context, e.message ?? 'Невідома помилка.');
            }
          } catch (e) {
            if (context.mounted) {
              _showErrorDialog(context, e.toString());
            }
          }
        },
      ),
    );
  }

  void _showUnsupportedDialog(BuildContext context, String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Непідтримувана платформа'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Помилка'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
