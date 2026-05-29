// import 'package:mdrawer/app/modules/task/data/task_data.dart';
import 'dart:io';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:gauge/app/controllers/bluetooth_controller.dart';
import 'package:gauge/app/controllers/config_send_controller.dart';
import 'package:gauge/app/routes/app_pages.dart';
import 'package:get_storage/get_storage.dart';

import 'package:gauge/app/modules/device/model/device.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';



class DeviceController extends GetxController with StateMixin<RxList<Device>> {
  GetStorage? devicesBox;
  late BleController bleController;
  late ConfigSendController configSendController;
  // var uuid = Uuid();

  @override
  void onInit() async {
    super.onInit();


    bleController = Get.find<BleController>();
    configSendController = Get.find<ConfigSendController>();
    try {
      devicesBox = GetStorage("devices");
      devicesBox?.write("device", null);
      // RxList<Device> devices = RxList<Device>();

      // change(devices, status: RxStatus.success());
      getDevices();
    } catch (error) {
      change(null, status: RxStatus.error(error.toString()));
    }
  }

  void getDevices() async {
    RxList<Device> devices = RxList<Device>();
    change(devices, status: RxStatus.loading());
    await bleController.scanDevices();
    var data = await bleController.scanResults.first;
    for(final ScanResult elem in data)
    {
      devices.add(Device(elem));
    }
    devicesBox?.write("devices", devices);
    change(devices, status: RxStatus.success());
  }

  void openDevice(Device device) {
    bleController.connectToDevice(device);
    devicesBox?.write('device', device);
    // Get.lazyPut<TaskController>(() => TaskController());
    // final TaskController taskController = Get.find();
    // taskController.openProject(project);
    Get.toNamed(Routes.device);
  }

  Device getCurrentDevice()
  {
    return devicesBox?.read("device");
  }

  void updateVersion(Device device)
  {
    configSendController.sendUpdate();
  }
}
