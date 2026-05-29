// import 'package:mdrawer/app/modules/task/data/task_data.dart';
import 'dart:io';
import 'dart:nativewrappers/_internal/vm/lib/ffi_patch.dart';
import 'package:get_storage/get_storage.dart';

import 'package:gauge/app/modules/model/device.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';


class DeviceController extends GetxController with StateMixin<RxList<Device>> {
  GetStorage? devicesBox;
  // var uuid = Uuid();

  @override
  void onInit() async {
    super.onInit();


    try {
      devicesBox = GetStorage("devices");
      RxList<Device> projects = RxList<Device>();
      projects.addAll(devicesBox!.read("devices"));

      change(projects, status: RxStatus.success());
    } catch (error) {
      change(null, status: RxStatus.error(error.toString()));
    }
  }

  void openDevice(Device project) {
    // Get.lazyPut<TaskController>(() => TaskController());
    // final TaskController taskController = Get.find();
    // taskController.openProject(project);
    // Get.toNamed(Routes.theme);
  }
}
