import 'package:flutter/material.dart';
import 'package:gauge/app/modules/device/controller/device_controller.dart';
import 'package:gauge/common.dart';

class DeviceUpdateDialog extends StatefulWidget {
  const DeviceUpdateDialog({super.key});

  @override
  State<DeviceUpdateDialog> createState() => _DeviceUpdateDialogState();
}

class _DeviceUpdateDialogState extends State<DeviceUpdateDialog> {
  bool _isUpdating = false;

  // MIEJSCE NA TWOJĄ WARTOŚĆ (np. wepnij tu RxDouble z kontrolera przez Obx)
  double progress = 0.5;
  final DeviceController deviceController = Get.find();

  void _checkProgress() {
    if (progress >= 1.0) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    _checkProgress();

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: theme.cardColor,
      title: Text(
        _isUpdating ? 'Aktualizacja...' : 'Aktualizacja oprogramowania',
        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!_isUpdating) ...[
            Text(
              'Aktualizacja może zająć parę minut, czy na pewno chcesz ją wykonać?',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Urządzenie musi pozostać podłączone do prądu!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ] else ...[
            Text(
              'Nie odłączaj urządzenia od zasilania.',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress, // Tu podajesz wartość od 0.0 do 1.0
                minHeight: 8,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${(progress * 100).toInt()}%',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
      actions: _isUpdating
          ? null
          : [
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'Anuluj',
                  style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                ),
              ),
              FilledButton(
                onPressed: () {
                  setState(() {
                    _isUpdating = true;
                  });
                  deviceController.updateVersion(deviceController.getCurrentDevice());
                },
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Aktualizuj'),
              ),
            ],
    );
  }
}