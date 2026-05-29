import 'package:flutter/material.dart';
import 'package:gauge/app/modules/device/controller/device_controller.dart';
import 'package:gauge/app/modules/device/model/device.dart';
import 'package:gauge/common.dart';

class DeviceTile extends StatelessWidget {
  final Device device;
  final String? color;
  final String? title;
  final VoidCallback? longPressCallback;

  const DeviceTile({
    super.key,
    required this.device,
    this.title,
    this.color,
    this.longPressCallback,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deviceController = Get.find<DeviceController>();

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: longPressCallback,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                LucideIcons.clock,
                color: theme.colorScheme.onSurfaceVariant,
                size: 22,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title ?? 'Urządzenie',
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              FilledButton.icon(
                onPressed: () => deviceController.openDevice(device),
                icon: const Icon(LucideIcons.bluetoothSearching, size: 16),
                label: const Text('Połącz'),
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}