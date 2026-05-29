import 'package:flutter/material.dart';
import 'package:gauge/app.dart';
import 'package:gauge/app/controllers/api_file_controller.dart';
import 'package:gauge/app/controllers/bluetooth_controller.dart';
import 'package:gauge/app/controllers/config_send_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {

  await _init();
  runApp(const MyApp());
}

Future<void> _init() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.lazyPut<BleController>(() => BleController());
  Get.lazyPut<ConfigSendController>(() => ConfigSendController());
  Get.lazyPut<ApiFileController>(() => ApiFileController());

  await GetStorage.init();
  await GetStorage.init("devices");
  await GetStorage.init("themes");
}

