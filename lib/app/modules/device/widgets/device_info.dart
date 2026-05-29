import 'package:flutter/material.dart';
import 'package:gauge/app/controllers/bluetooth_controller.dart';
import 'package:gauge/app/modules/device/controller/device_controller.dart';
import 'package:gauge/app/modules/device/model/device.dart';
import 'package:gauge/app/routes/app_pages.dart';
import 'package:gauge/common.dart';

class DeviceInfo extends StatelessWidget {
  final Device device;

  DeviceInfo({
    super.key,
    required this.device,
  });

  final DeviceController deviceController = Get.find();
  final BleController bleController = Get.find();

  bool _isVersionLow(String? versionStr) {
    if (versionStr == null) return true;
    final clean = versionStr.replaceAll(RegExp(r'[^\d.]'), '');
    final major = int.tryParse(clean.split('.').first);
    return major == null || major < 1;
  }

  @override
  Widget build(BuildContext context) {
    final isLow = _isVersionLow(device.version);
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('URZĄDZENIE', style: theme.textTheme.labelSmall),
                        const SizedBox(height: 4),
                        Text('Nr: ${device.id ?? "Nieznany"}', style: theme.textTheme.titleMedium),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isLow ? theme.colorScheme.errorContainer : theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Soft: ${device.version ?? "0.0"}',
                        style: TextStyle(
                          color: isLow ? theme.colorScheme.error : theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.system_update_alt_rounded),
                    label: const Text('Aktualizuj'),
                    style: FilledButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: OutlinedButton.icon(
                    onPressed: () => Get.toNamed(Routes.themes),
                    icon: const Icon(Icons.palette_outlined),
                    label: const Text('Motyw'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ValueListenableBuilder(
          valueListenable: bleController.readValue,
          builder: (context, data, child) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('DANE POBIERANE NA ŻYWO', style: theme.textTheme.labelSmall),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildLiveMetric(
                            context,
                            'Wartość',
                            '${data.usedValue.toStringAsFixed(2)}',
                            Icons.speed,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildLiveMetric(
                            context,
                            'Bateria',
                            '${data.batteryVoltage.toStringAsFixed(2)} V',
                            Icons.waves,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLiveMetric(BuildContext context, String label, String value, IconData icon) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.bodySmall),
              Text(value, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}