import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gauge/app/controllers/config_send_controller.dart';
import 'package:gauge/app/modules/device/controller/device_controller.dart';
import 'package:gauge/app/modules/theme/model/gauge_theme.dart';
import 'package:gauge/common.dart';

class ThemeDownloadDialog extends StatefulWidget {
  final GaugeTheme gaugeTheme;

  const ThemeDownloadDialog({super.key, required this.gaugeTheme});

  @override
  State<ThemeDownloadDialog> createState() => _ThemeDownloadDialogState(gaugeTheme: gaugeTheme);
}

class _ThemeDownloadDialogState extends State<ThemeDownloadDialog> {
  bool _isUploading = false;
  final DeviceController deviceController = Get.find();
  final ConfigSendController configSendController = Get.find();
  final GaugeTheme gaugeTheme;

  _ThemeDownloadDialogState({required this.gaugeTheme});

  @override
  void initState() {
    super.initState();
    configSendController.sendingConfigProgress.addListener(_progressListener);
  }

  @override
  void dispose() {
    configSendController.sendingConfigProgress.removeListener(_progressListener);
    super.dispose();
  }

  void _progressListener() {
    if (configSendController.sendingConfigProgress.value >= 1.0 && mounted) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: theme.cardColor,
      title: Text(
        _isUploading ? 'Wgrywanie...' : 'Wgrać motyw?',
        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!_isUploading) ...[
            Text(
              'Czy na pewno chcesz wgrać motyw "${widget.gaugeTheme.name}" na urządzenie?',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Nie przerywaj połączenia z urządzeniem podczas wgrywania!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ] else ...[
            Text(
              'Wgrywanie motywu na urządzenie...',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder<double>(
              valueListenable: configSendController.sendingConfigProgress,
              builder: (context, progress, child) {
                return Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
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
                );
              },
            ),
          ],
        ],
      ),
      actions: _isUploading
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
                    _isUploading = true;
                  });
                  // Tu wywołujesz swoją metodę wgrywania, np.:
                  configSendController.sendConfig(gaugeTheme.id.toString());
                },
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Wgraj'),
              ),
            ],
    );
  }
}