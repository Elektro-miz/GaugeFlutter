import 'package:flutter/material.dart';
import 'package:gauge/app/modules/device/controller/device_controller.dart';
import 'package:gauge/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DeviceMiddleware extends GetMiddleware {
  final box = GetStorage();
  final DeviceController deviceController = Get.find();

  @override
  RouteSettings? redirect(String? route) {
    bool isDeviceConnected = box.hasData('device');

    if (!isDeviceConnected && route != Routes.deviceSelect) {
      deviceController.getDevices();
      return const RouteSettings(name: Routes.deviceSelect);
    }

    return null;
  }
}