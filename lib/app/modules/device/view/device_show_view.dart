
import 'package:gauge/app/controllers/bluetooth_controller.dart';
import 'package:gauge/app/modules/auth/controller/auth_controller.dart';
import 'package:gauge/app/modules/device/controller/device_controller.dart';
import 'package:gauge/app/modules/device/model/device.dart';
import 'package:gauge/app/modules/device/widgets/device_info.dart';
import 'package:gauge/app/routes/app_pages.dart';
import 'package:gauge/common.dart';
import 'package:gauge/app/global_widgets/layouts/app/layout.dart';

class DeviceShowView extends StatelessWidget {
  DeviceShowView({super.key});
  String? title = 'Device list';
  late Device currentDevice;
  final DeviceController deviceController = Get.find();
  final AuthController authController = Get.find();
  final BleController bleController = Get.find();

  @override
  Widget build(BuildContext context) {
    currentDevice = deviceController.getCurrentDevice();
    title = currentDevice.name;
    return AppLayout(
      title: title,
      content: DeviceInfo(device: currentDevice),
      appbar: AppBar(
        title: Text(title!),
        actions: AppLayout.getAppBarActions(),
      ),
    );
  }
}
