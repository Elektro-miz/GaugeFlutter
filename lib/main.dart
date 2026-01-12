import 'package:flutter/material.dart';
import 'package:gauge_test/app.dart';
import 'package:gauge_test/controllers/api_file_controller.dart';
import 'package:gauge_test/controllers/bluetooth_controller.dart';
import 'package:gauge_test/controllers/config_send_controller.dart';
import 'package:get/get.dart';

void main() {
  Get.lazyPut<BleController>(() => BleController());
  Get.lazyPut<ConfigSendController>(() => ConfigSendController());
  Get.lazyPut<ApiFileController>(() => ApiFileController());
  runApp(const MyApp());
}
