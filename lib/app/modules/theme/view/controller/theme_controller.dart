// import 'package:mdrawer/app/modules/task/data/task_data.dart';
import 'dart:io';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:gauge/app/controllers/bluetooth_controller.dart';
import 'package:gauge/app/modules/theme/view/model/gauge_theme.dart';
import 'package:get_storage/get_storage.dart';

import 'package:gauge/app/modules/device/model/device.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';


class ThemeController extends GetxController with StateMixin<RxList<GaugeTheme>> {
  GetStorage? themesBox;

  @override
  void onInit() async {
    super.onInit();

    try {
      themesBox = GetStorage("themes");
      RxList<GaugeTheme> devices = RxList<GaugeTheme>();
      // devices.addAll(themesBox.read("themes"));
      change(devices, status: RxStatus.success());
    } catch (error) {
      change(null, status: RxStatus.error(error.toString()));
    }
  }

  void getThemes() async {
    RxList<GaugeTheme> devices = RxList<GaugeTheme>();
    // change(devices, status: RxStatus.loading());
    // for(final ScanResult elem in data)
    // {
    //   devices.add(Device(elem));
    // }
    // devicesBox?.write("devices", devices);
    change(devices, status: RxStatus.success());
  }

  void openTheme(GaugeTheme theme) {
    // Get.lazyPut<TaskController>(() => TaskController());
    // final TaskController taskController = Get.find();
    // taskController.openProject(project);
    // Get.toNamed(Routes.theme);
  }
}
