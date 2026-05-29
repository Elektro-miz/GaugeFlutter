
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gauge/app/modules/controller/device_controller.dart';
import 'package:gauge/app/modules/device/widgets/device_tile.dart';
import 'package:get/get.dart';

class DeviceList extends StatelessWidget {
  DeviceList({super.key});

  final DeviceController deviceController = Get.find();

  @override
  Widget build(BuildContext context) {
    return deviceController.obx(
      (state) => (ListView.builder(
        // padding: EdgeInsets.all(20.0),
        itemBuilder: (context, index) {
          final device = state![index];
          return DeviceTile(
            key: ValueKey(device),
            device: device,
            title: device.name,
            longPressCallback: () {
              deviceController.openDevice(device);
            },
          );
        },
        itemCount: state!.length,
      )),
      onLoading: const Center(child: CircularProgressIndicator()),
      onEmpty: const Text('No data found'),
      onError: (error) => Text(error!),
    );
  }
}
