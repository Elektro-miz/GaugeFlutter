import 'package:flutter/material.dart';
import 'package:gauge/app.dart';
import 'package:gauge/app/controllers/api_file_controller.dart';
import 'package:gauge/app/controllers/bluetooth_controller.dart';
import 'package:gauge/app/controllers/config_send_controller.dart';
import 'package:gauge/app/modules/auth/controller/auth_controller.dart';
import 'package:gauge/app/modules/device/controller/device_controller.dart';
import 'package:gauge/app/modules/theme/controller/theme_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {

  Get.lazyPut<ApiFileController>(() => ApiFileController());
  Get.lazyPut<BleController>(() => BleController());
  Get.lazyPut<ConfigSendController>(() => ConfigSendController());
  Get.lazyPut<DeviceController>(() => DeviceController());
  Get.put<AuthController>(AuthController(), permanent: true);
  Get.put<ThemeController>(ThemeController());


  await _init();
  runApp(const MyApp());
}

Future<void> _init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
}

