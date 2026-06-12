import 'package:flutter/material.dart';
import 'package:gauge/app/modules/device/controller/device_controller.dart';
import 'package:gauge/app/modules/device/widgets/device_tile.dart';
import 'package:get/get.dart';
import 'package:gauge/app/global_widgets/layouts/app/responsive_layout.dart';

class DeviceList extends StatelessWidget {
  DeviceList({super.key});

  final DeviceController deviceController = Get.find();

  @override
  Widget build(BuildContext context) {
    return deviceController.obx(
      (state) {
        if (state == null || state.isEmpty) return const Text('No data found');

        if (context.isDesktop || context.isDeviceLandscape) {
          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
            itemCount: state.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              mainAxisExtent: 72,
            ),
            itemBuilder: (context, index) => _buildTile(state[index]),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          itemCount: state.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) => _buildTile(state[index]),
        );
      },
      onLoading: const Center(child: CircularProgressIndicator()),
      onEmpty: const Text('No data found'),
      onError: (error) => Text(error!),
    );
  }

  Widget _buildTile(dynamic device) {
    return DeviceTile(
      key: ValueKey(device),
      device: device,
      title: device.name,
      longPressCallback: () {
        deviceController.openDevice(device);
      },
    );
  }
}