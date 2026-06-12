import 'package:flutter/material.dart';
import 'package:gauge/app/controllers/bluetooth_controller.dart';
import 'package:gauge/app/modules/device/controller/device_controller.dart';
import 'package:gauge/app/modules/device/model/device.dart';
import 'package:gauge/app/modules/device/widgets/device_update_dialog.dart';
import 'package:gauge/app/routes/app_pages.dart';
import 'package:gauge/common.dart';
import 'package:gauge/app/global_widgets/layouts/app/responsive_layout.dart';

class DeviceInfo extends StatelessWidget {
  final Device device;

  DeviceInfo({
    super.key,
    required this.device,
  });

  final DeviceController deviceController = Get.find();
  final BleController bleController = Get.find();

  bool _isVersionLow(String? versionStr) {
    String currentVersion = deviceController.getCurrentVersion();
    try {
      List<int> server = currentVersion.split('.').map(int.parse).toList();
      List<int> device = versionStr!.split('.').map(int.parse).toList();

      for (int i = 0; i < server.length; i++) {
        if (i >= device.length) return true;
        if (device[i] < server[i]) return true;
      }
      return false;
    } catch (e) {
      debugPrint("Błąd parsowania wersji: $e");
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLow = _isVersionLow(device.version);
    final theme = Theme.of(context);
    final isWide = context.isDesktop || context.isDeviceLandscape;

    Widget content = isWide
      ? IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _buildMainInfoCard(context, theme, isLow)),
              const SizedBox(width: 16),
              Expanded(child: _buildLiveDataCard(context, theme)),
            ],
          ),
        )
      : Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMainInfoCard(context, theme, isLow),
            const SizedBox(height: 16),
            _buildLiveDataCard(context, theme),
          ],
        );

    return SingleChildScrollView(
      padding: EdgeInsets.all(context.isDesktop ? 24.0 : 16.0),
      child: context.isDesktop
          ? Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1024),
                child: content,
              ),
            )
          : content,
    );
  }

  Widget _buildMainInfoCard(BuildContext context, ThemeData theme, bool isLow) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('URZĄDZENIE', style: theme.textTheme.labelSmall),
                          const SizedBox(height: 4),
                          Text('ID: ${device.id ?? "Nieznany"}', style: theme.textTheme.titleMedium, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isLow ? Palette.red[900] : Palette.green[900],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Version: ${device.version ?? "0.0"}',
                        style: TextStyle(
                          color: isLow ? Palette.red[500] : Palette.green[500],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: FilledButton.icon(
                    onPressed: () {
                      Get.dialog(
                        DeviceUpdateDialog(),
                        barrierDismissible: false,
                      );
                    },
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
          ],
        ),
      ),
    );
  }

  Widget _buildLiveDataCard(BuildContext context, ThemeData theme) {
    return ValueListenableBuilder(
      valueListenable: bleController.readValue,
      builder: (context, data, child) {
        return Card(
          margin: EdgeInsets.zero,
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
                        data.usedValue.toStringAsFixed(2),
                        LucideIcons.gauge,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildLiveMetric(
                        context,
                        'Bateria',
                        '${data.batteryVoltage.toStringAsFixed(2)} V',
                        LucideIcons.batteryFull,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.bodySmall, overflow: TextOverflow.ellipsis),
                Text(value, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}