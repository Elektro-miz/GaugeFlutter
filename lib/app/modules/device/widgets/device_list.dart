import 'package:flutter/material.dart';
import 'package:gauge/app/modules/device/controller/device_controller.dart';
import 'package:gauge/app/modules/device/widgets/device_tile.dart';
import 'package:get/get.dart';

class DeviceList extends StatelessWidget {
  DeviceList({super.key});

  final DeviceController deviceController = Get.find();

  @override
  Widget build(BuildContext context) {
    return deviceController.obx(
      (state) => ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        itemCount: state!.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final device = state[index];
          return DeviceTile(
            key: ValueKey(device),
            device: device,
            title: device.name,
            longPressCallback: () {
              deviceController.openDevice(device);
            },
          );
        },
      ),
      onLoading: const Center(child: CircularProgressIndicator()),
      onEmpty: const Text('No data found'),
      onError: (error) => Text(error!),
    );
  }
}